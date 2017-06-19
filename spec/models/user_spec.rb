require 'rails_helper'

RSpec.describe User, type: :model do
  it             { should validate_presence_of :email }
  let(:password) { 'example_password' }
  subject        { create(:user, password: password) }

  describe 'authentication' do
    it 'has no password method' do
      expect(User.find(subject.id).password).to be_nil
    end

    it 'saves obfuscated password' do
      expect(User.find(subject.id).password_digest).not_to eq password
    end

    it 'responds with user when #authenticate is ok' do
      expect(subject.authenticate(password)).to eq subject
    end

    it 'doesnot authenticate when password is wrong' do
      expect(subject.authenticate('wrong_password')).to be false
    end
  end
end
