# encoding: utf-8
# frozen_string_literal: true

RSpec::Matchers.define :have_scheduled do |*expected_args|
  chain :at do |timestamp|
    @time = timestamp
  end

  match do |job_class|
    scheduled_times = Resque.scheduled_at(job_class, *expected_args)
    job_matches     = scheduled_times.any?
    time_matches    = @time.blank? ? true : scheduled_times.include?(@time.to_i)

    job_matches && time_matches
  end

  failure_message do |job_class|
    msg = "expected that #{job_class} would have " \
          "[#{expected_args.join(', ')}] scheduled"
    msg += " at #{@time}" unless @time.blank?
    msg
  end

  failure_message_when_negated do |job_class|
    msg = "expected that #{job_class} would not have " \
          "[#{expected_args.join(', ')}] scheduled"
    msg += " at #{@time}" unless @time.blank?
    msg
  end
end
