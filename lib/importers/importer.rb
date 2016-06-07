# encoding: utf-8
# frozen_string_literal: true

# The base Importer class.
class Importer
  attr_reader :input

  def initialize(export_file)
    @input = JSON.parse(File.read(export_file))
    @data  = @input['data']
  end

  def import(verbose_output: false, truncate_existing_data: false)
    @verbose = verbose_output
    truncate_data! if truncate_existing_data
  end

  protected

  def notify(msg)
    Rails.logger.info msg if @verbose
  end

  private

  def truncate_data!
    tables = %w(lists tasks subtasks)
    tables.each do |table|
      ["DELETE FROM #{table}", 'VACUUM'].each do |query|
        ActiveRecord::Base.connection.execute(query)
      end
    end
    notify "The #{tables.to_sentence} tables have been truncated."
  end
end
