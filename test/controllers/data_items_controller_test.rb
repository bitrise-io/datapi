require 'test_helper'

class DataItemsControllerTest < ActionDispatch::IntegrationTest
  test 'GET without token' do
    get '/data/typeid-test'

    assert_equal 401, status
  end

  test 'GET with READONLY token' do
    get '/data/typeid-test', headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_readonly_api_token}" }

    assert_equal 200, status
  end

  test 'POST without token' do
    post '/data/typeid-test'

    assert_equal 401, status
  end

  test 'POST with READONLY token' do
    json_payload = '{"generated_at":"2016-04-29T12:44:54.129Z","data":{"sample":"data2"}}'
    post '/data/typeid-test',
         headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_readonly_api_token}" },
         env: { 'RAW_POST_DATA' => json_payload }

    assert_equal 401, status
  end

  test 'POST with Read-Write token' do
    json_payload = '{"generated_at":"2016-04-29T12:44:54.129Z","data":{"sample":"data2"}}'
    post '/data/typeid-test',
         headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_read_write_api_token}" },
         env: { 'RAW_POST_DATA' => json_payload }

    assert_equal 200, status
  end

  test 'GET with READONLY token - generated_after and generated_before filter params' do
    generated_after = Time.now.utc - 10.minutes
    generated_before = Time.now.utc - 5.minutes
    generated_at_ok_test = generated_after + 1.minute
    data_item_gen_before_range = DataItem.create(typeid: 'typeid-test', generated_at: generated_after - 1.minute, data: { 'sample' => 'after' })
    data_item_ok_test = DataItem.create(typeid: 'typeid-test', generated_at: generated_at_ok_test, data: { 'sample' => 'ok' })
    data_item_gen_after_range = DataItem.create(typeid: 'typeid-test', generated_at: generated_before + 1.minute, data: { 'sample' => 'before' })

    # no filter at all
    get '/data/typeid-test',
        headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_readonly_api_token}" }

    assert_equal 200, status
    expected_response_body = { items: [data_item_gen_before_range, data_item_ok_test, data_item_gen_after_range] }
    assert_equal expected_response_body.to_json, response.body

    # both after & before filters - full range filter
    get '/data/typeid-test',
        headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_readonly_api_token}" },
        params: { generated_after: generated_after.to_i, generated_before: generated_before.to_i }

    assert_equal 200, status
    expected_response_body = { items: [data_item_ok_test] }
    assert_equal expected_response_body.to_json, response.body

    # no `generated_after`
    get '/data/typeid-test',
        headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_readonly_api_token}" },
        params: { generated_before: generated_before.to_i }

    assert_equal 200, status
    expected_response_body = { items: [data_item_gen_before_range, data_item_ok_test] }
    assert_equal expected_response_body.to_json, response.body

    # no `generated_before`
    get '/data/typeid-test',
        headers: { 'Authorization' => "Token token=#{Rails.application.secrets.datapi_readonly_api_token}" },
        params: { generated_after: generated_after.to_i }

    assert_equal 200, status
    expected_response_body = { items: [data_item_ok_test, data_item_gen_after_range] }
    assert_equal expected_response_body.to_json, response.body
  end
end
