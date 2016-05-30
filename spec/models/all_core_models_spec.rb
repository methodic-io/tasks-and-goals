# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'All Core Models' do
  Rails.application.eager_load!

  required_attributes = [:created_at, :updated_at, :deleted_at]
  all_models          = ActiveRecord::Base.descendants
  non_core_models     = [ActiveRecord::SchemaMigration, Grouping, Listing]
  core_models         = all_models - non_core_models

  core_models.each do |model|
    describe model do
      it { should respond_to(*required_attributes) }
    end
  end
end
