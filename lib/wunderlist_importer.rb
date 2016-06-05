# encoding: utf-8
# frozen_string_literal: true

# A utility that takes the location of a Wunderlist export JSON file,
# parses its content, amnd imports the content into the DB.
class WunderlistImporter
  attr_reader :input

  def initialize(export_file)
    @input = JSON.parse(File.read(export_file))
  end

  def import
  end
end
