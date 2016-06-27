# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'All Core Models' do
  Rails.application.eager_load!

  required_attributes = [:created_at, :updated_at, :deleted_at,
                         :delete, :undelete, :deleted?, :active?]
  all_models          = ActiveRecord::Base.descendants
  non_core_models     = [ActiveRecord::SchemaMigration, Grouping, Listing]
  core_models         = all_models - non_core_models

  core_models.each do |model|
    describe model do
      let(:subject) { create(model.to_s.downcase.to_sym) }

      it { should respond_to(*required_attributes) }

      it { expect(subject.delete).to eq(subject) }

      it { expect(subject.undelete).to eq(subject) }

      it 'correctly handles deletion and undeletion' do
        expect(subject.deleted_at).to be_nil
        expect(subject.deleted?).to   be_falsey
        expect(subject.active?).to    be_truthy

        subject.delete

        expect(subject.deleted_at.to_s).to eq(Time.current.to_s)
        expect(subject.deleted?).to be_truthy
        expect(subject.active?).to  be_falsey

        subject.undelete

        expect(subject.deleted_at).to be_nil
        expect(subject.deleted?).to   be_falsey
        expect(subject.active?).to    be_truthy
      end
    end
  end
end
