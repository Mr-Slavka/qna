shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(request_method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(request_method, api_path, params: { access_token: '1234'}, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Success requestable' do
  it 'returns success status' do
    expect(response).to be_successful
  end
end

shared_examples 'Resource count returnable' do
  it 'returns list of resources' do
    expect(resource_response.size).to eq resource.size
  end
end

shared_examples_for 'Public fields returnable' do
  it 'returns all public fields' do
    attrs.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end
