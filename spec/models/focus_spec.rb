# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Focus do
  let(:subject) { build(:focus) }

  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:position) }

  describe '#label' do
    it { is_expected(subject.label).to be_a(String) }

    it 'should not support string longer than 255 characters' do
      expect { subject.update_column(:label, Faker::Lorem.characters(256)) }.
        to raise_error(StandardError)
    end
  end

  describe '#note' do
    it { is_expected(subject.note).to be_a(String) }

    it 'should support string longer than 255 characters' do
      expect { subject.update_column(:note, Faker::Lorem.characters(256)) }.
        to raise_error(StandardError)
    end
  end

  describe '#position' do
    it { is_expected(subject.position).to be_an(Integer) }
    it { is_expected { subject.position = -1 }.to raise_error }
  end
end
