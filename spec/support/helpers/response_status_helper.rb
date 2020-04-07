# frozen_string_literal: true

shared_examples 'expect 200' do
  it 'returns 200' do
    expect(response).to have_http_status :ok
  end
end
shared_examples 'expect 201' do
  it 'returns 201' do
    expect(response).to have_http_status :created
  end
end
shared_examples 'expect 400' do
  it 'returns 400' do
    expect(response).to have_http_status :bad_request
  end
end
shared_examples 'expect 401' do
  it 'returns 401' do
    expect(response).to have_http_status :unauthorized
  end
end
shared_examples 'expect 403' do
  it 'returns 403' do
    expect(response).to have_http_status :forbidden
  end
end
shared_examples 'expect 404' do
  it 'returns 404' do
    expect(response).to have_http_status :not_found
  end
end
