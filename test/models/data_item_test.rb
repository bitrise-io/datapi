# frozen_string_literal: true

require 'test_helper'

class DataItemTest < ActiveSupport::TestCase
  # called before every single test
  setup do
    @test_gen_at = DateTime.current
    @test_typeid = 'test-typeid'
    @test_data = { 'sample' => 'data' }
  end

  test 'create - OK' do
    data_item = nil
    assert_nothing_raised do
      data_item = DataItem.create(typeid: @test_typeid, generated_at: @test_gen_at, data: @test_data)
    end
    assert_equal @test_typeid, data_item.typeid
    assert_equal @test_gen_at, data_item.generated_at
    assert_equal @test_data, data_item.data
  end

  test 'create - missing typeid' do
    assert_raises(ActiveRecord::StatementInvalid) do
      DataItem.create(generated_at: @test_gen_at, data: @test_data)
    end
  end

  test 'create - missing generated_at' do
    assert_raises(ActiveRecord::StatementInvalid) do
      DataItem.create(typeid: @test_typeid, data: @test_data)
    end
  end

  test 'create - missing data' do
    assert_raises(ActiveRecord::StatementInvalid) do
      DataItem.create(typeid: @test_typeid, generated_at: @test_gen_at)
    end
  end
end
