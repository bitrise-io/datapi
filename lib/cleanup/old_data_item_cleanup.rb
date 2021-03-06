# frozen_string_literal: true

# Cleanup ...
module Cleanup
  # OldDataItemCleanup ...
  class OldDataItemCleanup
    def delete_items_generated_before(before_date)
      DataItem.where('generated_at < ?', before_date).destroy_all
    end
  end
end
