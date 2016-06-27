# encoding: utf-8
# frozen_string_literal: true

# Handles the deferral of multiple deferrable objects.
class Deferrer
  def self.batch_defer(deferrables, duration)
    deferrables.each do |deferrable|
      if deferrable.class.included_modules.include? Deferrable
        deferrable.defer(duration)
      else
        error_msg = "#{self.class} can only apply #{__method__} to "  \
                    "Deferrable objects. #{deferrable.class} is not " \
                    'Deferrable.'
        raise TypeError, error_msg
      end
    end
  end
end
