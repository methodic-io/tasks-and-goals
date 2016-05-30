# encoding: utf-8
# frozen_string_literal: true

# Represents the association between a Group and a List.
class Grouping < ActiveRecord::Base
  belongs_to :group
  belongs_to :list
end
