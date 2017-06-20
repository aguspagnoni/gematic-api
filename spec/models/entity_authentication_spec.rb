describe EntityAuthentication do
  let(:example_class)     { Class.new { include EntityAuthentication } }
  let(:example_instance)  { example_class.new }

  before do
    example_instance.instance_variable_set(:id, Faker::Number.number(3))
  end

  let(:payload)      { example_instance.to_token_payload }
  let(:from_payload) { example_instance.from_token_payload(payload) }

  it 'de-serializes payload according to serialization' do
     expect()
  end
end
