require 'test_helper'

class DataItemsControllerTest < ActionDispatch::IntegrationTest
  test "GET without token" do
    get '/data/typeid-test'

    assert_equal 401, status
  end

  test "GET with READONLY token" do
    get '/data/typeid-test', headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_readonly_api_token}" }

    assert_equal 200, status
  end

  test "POST without token" do
    post '/data/typeid-test'

    assert_equal 401, status
  end

  test "POST with READONLY token" do
    json_payload = '{"generated_at":"2016-04-29T12:44:54.129Z","data":{"sample":"data2"}}'
    post '/data/typeid-test',
      headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_readonly_api_token}" },
      env: {'RAW_POST_DATA' => json_payload}

    assert_equal 401, status
  end

  test "POST with Read-Write token" do
    json_payload = '{"generated_at":"2016-04-29T12:44:54.129Z","data":{"sample":"data2"}}'
    post '/data/typeid-test',
      headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_read_write_api_token}" },
      env: {'RAW_POST_DATA' => json_payload}

    assert_equal 200, status
  end
end
