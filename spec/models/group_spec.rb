# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group do
  let(:subject) { build(:group, :with_lists) }

  it { should respond_to(:label) }
  it { should respond_to(:open?) }
  it { should respond_to(:position) }
  it { should respond_to(:list_positions) }

  it { should validate_presence_of(:label) }
  it { should validate_numericality_of(:position).only_integer }

  it do
    should validate_numericality_of(:position)
      .is_greater_than_or_equal_to(0)
  end

  it { should have_many(:lists).through(:groupings) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#open?' do
    it { expect(subject.open?).to be_boolean }
  end

  describe '#position' do
    it { expect(subject.position).to be_an(Integer) }
  end

  describe '#list_positions' do
    it { expect(subject.list_positions).to be_an(Array) }
    it do
      expect(subject.list_positions.map(&:class).uniq)
        .to match_array([Fixnum])
    end
  end

  describe '#lists=' do
    context 'when set to an empty array' do
      it 'sets list_positions to an empty array' do
        expect(subject.list_positions).not_to be_empty
        subject.lists = []
        expect(subject.list_positions).to be_empty
      end
    end

    context 'when set to an array of lists' do
      it 'sets list_positions appropriately' do
        new_lists     = Array.new(5) { create(:list) }.shuffle!
        new_list_ids  = new_lists.map(&:id)
        subject.lists = new_lists
        expect(subject.list_positions).to eq(new_list_ids)
      end
    end

    context 'when set with anything other than an empty array or ' \
      'an array of lists' do
      it 'raises an error' do
        expect { subject.lists = [] }.not_to raise_error
        expect { subject.lists = [create(:list), create(:list)] }
          .not_to raise_error
        expect { subject.lists = [create(:list), create(:group)] }
          .to raise_error(ActiveRecord::AssociationTypeMismatch)
      end
    end
  end

  describe '#lists <<' do
    context 'when a list is assigned' do
      it "adds the list's id to the top of list_positions" do
        list = create(:list)
        subject.lists << list
        expect(subject.list_positions.first).to eq(list.id)
      end
    end

    context 'when an array of lists are assigned' do
      it "adds the lists' ids to the top of list_positions" do
        list_a = create(:list)
        list_b = create(:list)
        subject.lists << [list_a, list_b]
        expect(subject.list_positions.first(2))
          .to eq([list_a.id, list_b.id])
      end
    end

    context 'when anything other than a list is assigned' do
      it 'raises an error' do
        expect { subject.lists << build(:goal) }
          .to raise_error(ActiveRecord::AssociationTypeMismatch)
      end
    end
  end

  describe '#lists.delete' do
    context 'when a list is removed' do
      it "removes the list's id from list_positions" do
        list = create(:list)
        subject.lists << list
        expect(subject.list_positions).to include(list.id)
        subject.lists.delete(list)
        expect(subject.list_positions).not_to include(list.id)
      end
    end
  end

  describe '#position_list' do
    let(:list)        { subject.lists.third }
    let(:num_lists)   { subject.list_positions.count }

    context 'when given an associated list and an in bounds position' do
      context 'when increasing the list position' do
        it 'correctly sets list_positions' do
          orig_positions = subject.list_positions.dup
          subject.position_list(list, 0)
          expect(subject.list_positions[0]).to eq(list.id)
          expect(subject.list_positions[1]).to eq(orig_positions[0])
          expect(subject.list_positions[2]).to eq(orig_positions[1])
          (num_lists - 3).times do |i|
            id = i + 3
            expect(subject.list_positions[id]).to eq(orig_positions[id])
          end
        end
      end

      context 'when decreasing the list position' do
        it 'correctly sets list_positions' do
          orig_positions = subject.list_positions.dup
          subject.position_list(list, -1)
          expect(subject.list_positions[0]).to eq(orig_positions[0])
          expect(subject.list_positions[1]).to eq(orig_positions[1])
          (num_lists - 3).times do |i|
            id = i + 2
            expect(subject.list_positions[id]).to eq(orig_positions[id + 1])
          end
          expect(subject.list_positions.last).to eq(list.id)
        end
      end
    end

    context 'when given an out of bounds position' do
      it 'raises an error' do
        too_high_pos = num_lists
        too_low_pos  = -num_lists - 1
        expect { subject.position_list(list, too_high_pos) }
          .to raise_error(ArgumentError)
        expect { subject.position_list(list, too_low_pos) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when given an unassociated list' do
      it 'raises an error' do
        expect { subject.position_list(create(:list), 0) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when given anything other than a list' do
      it 'raises an error' do
        expect { subject.position_list(build(:goal), 0) }
          .to raise_error(TypeError)
      end
    end
  end

  describe '#exchange_positions' do
    context 'when given 2 groups' do
      context 'and neither group belongs to the list' do
        it 'raises an error' do
          list_a = create(:list)
          list_b = create(:list)
          expect { subject.exchange_positions(list_a, list_b) }
            .to raise_error(ArgumentError)
        end
      end

      context 'and one of the two groups belongs to the list' do
        it 'raises an error' do
          list_a = create(:list)
          list_b = create(:list)
          subject.lists << list_a
          expect { subject.exchange_positions(list_a, list_b) }
            .to raise_error(ArgumentError)
        end
      end

      context 'and both groups belongs to the list' do
        it "swaps the lists' ids in list_positions" do
          list_a = create(:list)
          list_b = create(:list)
          subject.lists << [list_a, list_b]

          expect(subject.list_positions.first(2))
            .to eq([list_a.id, list_b.id])
          subject.exchange_positions(list_a, list_b)
          expect(subject.list_positions.first(2))
            .to eq([list_b.id, list_a.id])
        end
      end
    end

    context 'when given anything other than two groups' do
      it 'raises an error' do
        expect { subject.exchange_positions(build(:group), build(:goal)) }
          .to raise_error(TypeError)
      end
    end
  end

  describe '#ordered_lists' do
    it 'returns the lists ordered by list_positions' do
      subject.list_positions.shuffle!
      expect(subject.ordered_lists.map(&:id))
        .to eq(subject.list_positions)
    end
  end
end
