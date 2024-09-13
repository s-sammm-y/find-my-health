import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Popup from './components/Popup/Popup';
import './App.css';

function App() {
  const [inventory, setInventory] = useState([]);
  const [error, setError] = useState(null);
  const [showPopup, setShowPopup] = useState(false);
  const [newItemName, setNewItemName] = useState('');
  const [newItemQuantity, setNewItemQuantity] = useState('');
  const [newQuantity, setNewQuantity] = useState({}); // to handle item quantity updates

  useEffect(() => {
    const fetchInventory = async () => {
      try {
        const response = await axios.get('http://localhost:3000/api/inventory');
        setInventory(response.data);
      } catch (err) {
        setError('Error fetching inventory data');
        console.error(err);
      }
    };

    fetchInventory();
  }, []);

  const handleAddItemClick = () => {
    setShowPopup(true);
  };

  const handleClosePopup = () => {
    setShowPopup(false);
    setNewItemName('');
    setNewItemQuantity('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post('http://localhost:3000/api/inventory', {
        item_name: newItemName,
        quantity: newItemQuantity
      });
      // Refresh the inventory list
      const response = await axios.get('http://localhost:3000/api/inventory');
      setInventory(response.data);
      handleClosePopup();
    } catch (err) {
      setError('Error adding item');
      console.error(err);
    }
  };

  const handleQuantityChange = (e, itemName) => {
    setNewQuantity({
      ...newQuantity,
      [itemName]: e.target.value,
    });
  };

  const handleUpdateSubmit = async (e, itemName) => {
    e.preventDefault();
    try {
      await axios.put(`http://localhost:3000/api/inventory/${itemName}`, {
        quantity: newQuantity[itemName],
      });

      // Fetch the updated inventory
      const response = await axios.get('http://localhost:3000/api/inventory');
      setInventory(prevInventory => {
        const updatedInventory = response.data;
        return prevInventory.map(item => {
          const updatedItem = updatedInventory.find(i => i.item_name === item.item_name);
          return updatedItem ? { ...item, quantity: updatedItem.quantity } : item;
        });
      });
    } catch (err) {
      setError('Error updating quantity');
      console.error(err);
    }
  };

  return (
    <div className="app-container">
      <h1>Inventory</h1>
      <button className="addItem" onClick={handleAddItemClick}>Add item</button>
      {error && <p className="error-message">{error}</p>}
      <div className="inventory-list">
        {inventory.map((item) => (
          <div className="item" key={item.item_name}>
            <div className="item-name">{item.item_name}</div>
            <div className="item-quantity">
              <h5>Qty.</h5>
              <p>{item.quantity}</p>
            </div>
            <div className="item-update">
              <form onSubmit={(e) => handleUpdateSubmit(e, item.item_name)}>
                <input
                  type="number"
                  value={newQuantity[item.item_name] || ''}
                  onChange={(e) => handleQuantityChange(e, item.item_name)}
                  placeholder="Add quantity"
                  required
                />
                <button type="submit">Add</button>
              </form>
              <button>Remove</button>
            </div>
          </div>
        ))}
      </div>
      <Popup show={showPopup} onClose={handleClosePopup}>
        <h2>Add New Item</h2>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="item-name">Item Name:</label>
            <input
              id="item-name"
              type="text"
              value={newItemName}
              onChange={(e) => setNewItemName(e.target.value)}
              required
            />
          </div>
          <div className="form-group">
            <label htmlFor="item-quantity">Quantity:</label>
            <input
              id="item-quantity"
              type="number"
              value={newItemQuantity}
              onChange={(e) => setNewItemQuantity(e.target.value)}
              required
            />
          </div>
          <button type="submit">Add Item</button>
        </form>
      </Popup>
    </div>
  );
}

export default App;