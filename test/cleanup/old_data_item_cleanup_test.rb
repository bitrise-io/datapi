# frozen_string_literal: true

require 'test_helper'
require 'cleanup/old_data_item_cleanup'

class OldDataItemCleanupTest < ActiveSupport::TestCase
  test 'delete_items_generated_before' do
    DataItem.delete_all
    assert_equal 0, DataItem.count

    di1 = DataItem.create(typeid: 'old-items', generated_at: Time.now.utc - 48.hours, data: { test: 'data 1' })
    assert_equal 1, DataItem.count
    di2 = DataItem.create(typeid: 'old-items', generated_at: Time.now.utc - 72.hours, data: { test: 'data 2' })
    assert_equal 2, DataItem.count
    DataItem.create(typeid: 'old-items', generated_at: Time.now.utc - 96.hours, data: { test: 'data 3' })
    assert_equal 3, DataItem.count

    Cleanup::OldDataItemCleanup.new.delete_items_generated_before(Time.now.utc - 90.hours)
    assert_equal 2, DataItem.count
    assert_equal [di1, di2], DataItem.all

    Cleanup::OldDataItemCleanup.new.delete_items_generated_before(Time.now.utc)
    assert_equal 0, DataItem.count
  end
end
