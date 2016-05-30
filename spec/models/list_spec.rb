# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List do
  let(:subject) { build(:list) }

  it { should respond_to(:label) }
  it { should respond_to(:position) }

  it { should validate_presence_of(:label) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#position' do
    it { expect(subject.position).to be_an(Integer) }
    it { expect(build(:list, position: -1)).to_not be_valid }
  end
end
