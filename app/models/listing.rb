# encoding: utf-8
# frozen_string_literal: true

# Represents the association between a List and a Task.
class Listing < ActiveRecord::Base
  belongs_to :list
  belongs_to :task
end
