module Admin
  class DashboardController < ApplicationController
    def index
      @low_inventories = InventoryItem.group_by_store_with_low_quantity
    end
  end
end
