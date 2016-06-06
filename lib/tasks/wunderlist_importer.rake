# encoding: utf-8
# frozen_string_literal: true

require_relative '../wunderlist_importer'

namespace :import_from do
  Rails.logger = Logger.new(STDOUT)

  def notify(msg)
    Rails.logger.info msg if verbose
  end

  desc 'Import data from the given Wunderlist Export JSON file'
  task :wunderlist, [:file, :verbose, :truncate] => :environment do |_, args|
    args.with_defaults(verbose: true, truncate: false)
    export_file = File.expand_path("../../#{args[:file]}", __FILE__)
    verbose     = args[:verbose]
    truncate    = args[:truncate]

    notify "Importing Wunderlist data from: #{export_file}"

    if truncate
      notify 'Establishing database connection.'
      config = ActiveRecord::Base.configurations[Rails.env] ||
               Rails.application.config.database_configuration[Rails.env]
      ActiveRecord::Base.establish_connection(config)
    end

    notify '.......'
    importer = WunderlistImporter.new(export_file)
    importer.import(verbose_output: verbose, truncate_existing_data: truncate)
    notify '.......'

    if truncate
      notify 'Closing database connection.'
      ActiveRecord::Base.connection.close
    end
    notify 'Import task complete.'
  end
end
