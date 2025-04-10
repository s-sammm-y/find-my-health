import React, { useState, useEffect } from "react";
import axios from "axios";
import Popup from "./components/Popup/Popup";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBoxOpen } from '@fortawesome/free-solid-svg-icons';
import { faPen } from '@fortawesome/free-solid-svg-icons';


import SearchBarDropdown from "./components/Searchbar/SearchBarDropdown";

import "./App.css";

function App() {
  const [inventory, setInventory] = useState([]);
  const [trackInventory,inventoryChange] = useState(false)
  const [error, setError] = useState(null);
  const [showPopup, setShowPopup] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [selectedItemId, setSelectedItemId] = useState(null);
  const [newItemName, setNewItemName] = useState("");
  const [newItemQuantity, setNewItemQuantity] = useState("");
  const [addQuantity, setAddQuantity] = useState({});
  const [removeQuantity, setRemoveQuantity] = useState({});
  useEffect(() => {
    const fetchInventory = async () => {
      try {
        const response = await axios.get("http://localhost:3003/api/inventory");
        setInventory(response.data);
      } catch (err) {
        setError("Error fetching inventory data");
        console.error(err);
      }
    };

    fetchInventory();
  }, [trackInventory]);
  const openModal = (id) => {
    setSelectedItemId(id);
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setSelectedItemId(null);
  };

  const handleAddItemClick = () => {
    setShowPopup(true);
  };

  const handleClosePopup = () => {
    setShowPopup(false);
    setNewItemName("");
    setNewItemQuantity("");
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post("http://localhost:3003/api/inventory", {
        item_name: newItemName,
        quantity: newItemQuantity,
      });
      // Refresh the inventory list
      const response = await axios.get("http://localhost:3003/api/inventory");
      setInventory(response.data);
      handleClosePopup();
    } catch (err) {
      setError("Error adding item");
      console.error(err);
    }
  };

 
  const handleAddQuantityChange = (e, itemId) => {
    setAddQuantity({
      ...addQuantity,
      [itemId]: e.target.value,
    });
  };

  const handleRemoveQuantityChange = (e, itemId) => {
    setRemoveQuantity({
      ...removeQuantity,
      [itemId]: e.target.value,
    });
  };
  
  

  const handleUpdateSubmit = async (e, itemId, action) => {
    e.preventDefault();
    try {
      const updateValue = action === "add" ? addQuantity[itemId] : -removeQuantity[itemId];
  
      await axios.put(`http://localhost:3003/api/inventory/${itemId}`, {
        quantity: updateValue,
      });
  
      inventoryChange(true);
  
      // Clear the input field after submission
      if (action === "add") {
        setAddQuantity({ ...addQuantity, [itemId]: "" });
      } else {
        setRemoveQuantity({ ...removeQuantity, [itemId]: "" });
      }
  
      closeModal();
    } catch (err) {
      setError("Error updating quantity");
      console.error(err);
    }
  };


  return (
    <div className="min-h-screen overflow-auto">
          <div className="head">
            <h2>All Inventory List</h2>
            <div>
            <input className="name-filter" placeholder="Search item"/>
            <button >Sort By</button>
            </div>
            <button onClick={handleAddItemClick}>+ Add item</button>
          </div>
          {error && <p className="error-message">{error}</p>}
          <div className="inventory-list">
            {inventory.map((item) => (
              <div className="item" key={item.item_name}>
                <div className="item-details">
                  <img className="itemimage"src={item.image_url}></img>
                  <div className="item-name">{item.item_name}</div>
                </div>
                <div className="item-category">
                  <div className="category-header">Category</div>
                  <div className="category-name data">{item.category}</div>
                </div>
                <div className="item-quantity">
                  <div>Stock</div>
                  <div className="data"style={{ color: item.quantity < 100 ? 'red' : 'black' }}>
                  <FontAwesomeIcon icon={faBoxOpen} /> {item.quantity}
                  </div>
                </div>
                <div className="item-update">
                  <button className="icon-button" onClick={()=>openModal(item.item_id)}><FontAwesomeIcon icon={faPen} className="view-icon"/></button>
                  {modalOpen && (
        <div className="modal">
          <div className="modal-content">
            <div><h3>Update Stock for Item </h3></div>
            <form onSubmit={(e) => handleUpdateSubmit(e, selectedItemId, "add")}>
              <input
                type="number"
                value={addQuantity[selectedItemId] || ""}
                onChange={(e) => handleAddQuantityChange(e, selectedItemId)}
                required
              />
              <button className="submitBtn" type="submit">ADD</button>
            </form>
            <form onSubmit={(e) => handleUpdateSubmit(e, selectedItemId, "remove")}>
              <input
                type="number"
                value={removeQuantity[selectedItemId] || ""}
                onChange={(e) => handleRemoveQuantityChange(e, selectedItemId)}
                required
              />
              <button className="removeBtn m-rounded-md" type="submit">REMOVE</button>
            </form>
            <div className="manufacturer-details">Manufacturer Details: </div>   
            <button className="modal-close" onClick={closeModal}>Close</button>
          </div>
        </div>
      )}
                  {/* <form onSubmit={(e) => handleUpdateSubmit(e, item.item_name)}>
                    <input
                      type="number"
                      value={newQuantity[item.item_name] || ""}
                      onChange={(e) => handleQuantityChange(e, item.item_name)}
                      required
                    />
                    <button className="submitBtn" type="submit">
                      ADD
                    </button>
                  </form> */}
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
