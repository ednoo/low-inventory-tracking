require 'eventmachine'

class SyncInventoryJob < ApplicationJob
  queue_as :default

  WS_SERVER_URL = 'ws://localhost:8080/'.freeze

  def perform
    EM.run do
      connect_ws
      EM::Timer.new(30) do
        EM.stop
        @ws_client.close
      end
    end
  end

  private

  def connect_ws
    @ws_client = Faye::WebSocket::Client.new(WS_SERVER_URL)
    @ws_client.on :message do |event|
      sync(JSON.parse(event.data))
    end
  end

  def sync(data)
    store = Store.find_or_create_by(name: data['store'])
    shoe = Shoe.find_or_create_by(name: data['model'])
    inventory = InventoryItem.find_or_create_by(store:, product: shoe)
    inventory.quantity = data['inventory']
    inventory.save
  end
end
