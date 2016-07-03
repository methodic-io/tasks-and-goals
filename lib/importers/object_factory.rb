# encoding: utf-8
# frozen_string_literal: true

# A utility that takes a class and a data hash. Creates an instance of the
# class and assigns relevant data from the hash to the instance.
class ObjectFactory
  attr_reader :instance

  def initialize(object)
    @instance = object.new
  end

  def build(data)
    @data = data
    manufacture
    self
  end

  private

  def manufacture
    @data.keys.each do |attribute|
      next if skip_attribue?(attribute) || @data[attribute].blank?
      assign_value_to_attribute(attribute, @data[attribute])
    end
  end

  def skip_attribue?(attribute)
    attribute.to_s.include? 'id'
  end

  def assign_value_to_attribute(attribute, value)
    message = "#{attribute}="
    if @instance.respond_to? message
      @instance.public_send(message, parse_value(attribute, value))
    end
  end

  def parse_value(attribute, value)
    return Time.zone.parse(value) if attribute.to_s.include? '_at'
    value
  end
end
