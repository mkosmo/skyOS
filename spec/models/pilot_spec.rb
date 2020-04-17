# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pilot, type: :model do
  it 'has a valid factory' do
    expect(build(:pilot)).to be_valid
  end

  let(:pilot) { build(:pilot) }

  describe 'ActiveRecord associations' do
    it do
      # stub the callback so that default group is not assigned (for this test)
      allow_any_instance_of(Pilot).to receive(:assign_group).and_return(nil)
      expect(pilot).to belong_to(:group).required
    end
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(pilot).to validate_presence_of(:first_name) }
    it { expect(pilot).to validate_presence_of(:last_name) }

    # Format validations
    it { expect(pilot).to validate_numericality_of(:pid).only_integer }

    # Inclusion/acceptance of values
  end

  describe 'group' do
    it 'should be assigned the pilot group' do
      group = Group.find_by(name: 'Pilot')
      pilot.valid?
      expect(pilot.group).to eq group
    end
  end

  describe 'ID' do
    it 'should be assigned starting value if no other pilots exist' do
      pilot.valid?
      expect(pilot.pid).to eq 100
    end

    it 'should be assigned starting value if pilots exist below the number' do
      create(:pilot, pid: 1)
      pilot.valid? # build a new pilot and test validity
      expect(pilot.pid).to eq 100
    end

    it 'should be assigned the next available value if pilots exist' do
      create(:pilot)
      pilot.valid?
      expect(pilot.pid).to eq 101
    end
  end
end
