require 'rails_helper'

describe 'Registration' do
  let(:klass) { Class.new { include Registration } }
  let(:user)  { create(:user) }
  let(:token) { klass.send(:token_for, user) }

  it 'is possible to find user from confirmation link' do
    expect(klass.send(:user_from, user.email, token)).to eq(user)
  end

  it 'returns gracefully when email is inexistent' do
    expect(klass.send(:user_from, 'not_a_valid_email', '')).to be_nil
  end

  it 'returns gracefully when token mismatches users one' do
    expect(klass.send(:user_from, user.email, 'not_a_valid_token')).to be_nil
  end
end
