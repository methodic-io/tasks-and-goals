# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'
require 'importers/object_factory'

RSpec.describe ObjectFactory do
  let(:subject) { described_class.new(Task) }

  describe '#build' do
    context 'when given a hash' do
      it 'returns appropriately assigns relevant data to the instance' do
        data = JSON.parse(File.read(WUNDERLIST_EXPORT))['data']['tasks'].sample
        instance = subject.instance

        data.keys.each do |attribute|
          next unless instance.respond_to? "#{attribute}="
          expect(instance.public_send(attribute)).not_to eq(data[attribute])
        end

        subject.build(data)

        data.keys.each do |attribute|
          next unless instance.respond_to? "#{attribute}="
          if attribute == 'id'
            expect(instance.public_send(attribute)).not_to eq(data[attribute])
          else
            expect(instance.public_send(attribute)).to eq(data[attribute])
          end
        end
      end

      it 'responds with the subject' do
        expect(subject.build(foo: :bar)).to eq(subject)
      end
    end
  end

  describe '#skip_attribue?' do
    context "when given an attribute that includes 'id'" do
      it 'returns true' do
        expect(subject.send(:skip_attribue?, :subtask_id)).to eq(true)
      end
    end

    context "when given an attribute that does not include 'id'" do
      it 'returns false' do
        expect(subject.send(:skip_attribue?, :note)).to eq(false)
      end
    end
  end

  describe '#assign_value_to_attribute' do
    context 'when the instance responds to the attribute' do
      it 'assigns the value to the instance attribute' do
        original_value = Faker::Lorem.paragraph
        new_value      = original_value.reverse
        subject.instance.note = original_value
        expect { subject.send(:assign_value_to_attribute, :note, new_value) }
          .to change { subject.instance.note }
          .from(original_value)
          .to(new_value)
      end
    end

    context 'when the instance does not respond to the attribute' do
      it 'does nothing to the instance' do
        expect { subject.send(:assign_value_to_attribute, :foo, :bar) }
          .not_to change { subject.instance }
      end
    end
  end

  describe '#parse_value' do
    context "when the attribute ends in '_at'" do
      it 'returns a parsed Time object' do
        value = Faker::Time.forward(10)
        expect(subject.send(:parse_value, :due_at, value.to_s)).to eq(value)
      end
    end

    context "when the attribute does not end in '_at'" do
      it 'returns the given value unchanged' do
        value = Faker::Lorem.paragraph
        expect(subject.send(:parse_value, :note, value)).to eq(value)
      end
    end
  end
end
