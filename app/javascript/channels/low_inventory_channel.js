import consumer from "channels/consumer"

consumer.subscriptions.create("LowInventoryChannel", {
  connected(connection) {
    console.log("connected to WebSocket server", connection);
  },

  disconnected(data) {
    console.log('disconnected from WebSocket server', data);
  },

  received(data) {
    updateInventory(data)
  }
});


function updateInventory(data) {
  const inventoryContainer = document.getElementById("inventory-container");
  inventoryContainer.innerHTML = "";

  const inventoryItems = JSON.parse(data);

  for (const storeId in inventoryItems) {
    if (inventoryItems.hasOwnProperty(storeId)) {
      const storeData = inventoryItems[storeId];

      const storeName = document.createElement("h2");
      storeName.textContent = storeData.store_name;
      inventoryContainer.appendChild(storeName);

      const viewInventoryLink = document.createElement("a");
      viewInventoryLink.href = '#pretend_link_to_store_inventory_level_history_metrics';
      viewInventoryLink.textContent = 'View Inventory Metrics';
      inventoryContainer.appendChild(viewInventoryLink);

      storeData.inventory_items.forEach(item => {
        const listItem = document.createElement("li");
        listItem.textContent = `Product: ${item.product_name} | Quantity: ${item.quantity}`;
        inventoryContainer.appendChild(listItem);
      });
    }
  }
}

