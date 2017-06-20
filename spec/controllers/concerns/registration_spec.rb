require 'rails_helper'

describe 'Registration' do
  let(:klass)   { Class.new { include Registration } }
  let(:_module) { klass.new }
  let(:user)    { create(:user) }
  let(:token)   { _module.send(:token_for, user) }

  it 'is possible to find user from confirmation link' do
    expect(_module.send(:user_from, user.email, token)).to eq(user)
  end

  it 'returns gracefully when email is inexistent' do
    expect(_module.send(:user_from, 'not_a_valid_email', '')).to be_nil
  end

  it 'returns gracefully when token mismatches users one' do
    expect(_module.send(:user_from, user.email, 'not_a_valid_token')).to be_nil
  end
end
