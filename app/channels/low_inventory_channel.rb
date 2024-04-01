class LowInventoryChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'low_inventory_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast('low_inventory_channel', data)
  end
end
