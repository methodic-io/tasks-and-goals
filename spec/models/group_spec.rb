# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group do
  let(:subject) { build(:group) }

  it { should respond_to(:label) }
  it { should respond_to(:open) }
  it { should respond_to(:position) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#open' do
    it { expect(subject.note).to be_a(Boolean) }
  end

  describe '#position' do
    it { expect(subject.position).to be_an(Integer) }
  end
end
