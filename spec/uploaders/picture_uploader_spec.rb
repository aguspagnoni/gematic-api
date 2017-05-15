require 'carrierwave/test/matchers'
require 'rails_helper'

describe PictureUploader do
  include CarrierWave::Test::Matchers

  let(:user)        { create(:user) }
  let(:uploader)    { PictureUploader.new(user, :image) }
  let(:image_path)  { 'tmp/image_test.jpg' }

  before do
    PictureUploader.enable_processing = true
    File.open(image_path) { |f| uploader.store!(f) }
  end

  after do
    PictureUploader.enable_processing = false
    uploader.remove!
  end

  context 'the small version' do
    it "scales down a landscape image to fit within 200 by 200 pixels" do
      expect(uploader.small).to be_no_larger_than(200, 200)
    end
  end
end
