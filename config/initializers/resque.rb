# encoding: utf-8
# frozen_string_literal: true

rails_root    = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis  = resque_config[:redis_host]
