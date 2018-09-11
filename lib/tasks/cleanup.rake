# frozen_string_literal: true

require 'cleanup/old_data_item_cleanup'

namespace :cleanup do
  desc 'cleanup old_data_items'
  task :data_items_older_than_days, [:days_num] => [:environment] do |_t, args|
    arg_before_date = Time.now.utc - args[:days_num].to_i.days
    puts "=> Deleting DataItems generate before: #{arg_before_date}"
    puts "   * DataItem count before: #{DataItem.count}"
    Cleanup::OldDataItemCleanup.new.delete_items_generated_before(arg_before_date)
    puts "   * [DONE] DataItem count after: #{DataItem.count}"
  end
end
