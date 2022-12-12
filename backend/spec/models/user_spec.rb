require 'rails_helper'
RSpec.describe User, type: :model do
  describe '#full_name' do
    it 'concatenates first and last name' do
      user = User.new(first_name: 'Abraham', last_name: 'Lincoln')
      expect(user.full_name).to eq('Abraham Lincoln')
    end
  end
end