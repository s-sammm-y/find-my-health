import React, { useState } from "react";
import "./Sidebar.css"; // optional for styling

const Sidebar = () => {
  const [isInventoryOpen, setIsInventoryOpen] = useState(false);

  const toggleInventoryDropdown = () => {
    setIsInventoryOpen(!isInventoryOpen);
  };

  return (
    <div className="sidebar">
      <ul className="sidebar-menu">
        <li className="sidebar-item">Inventory Overview</li>
        <li className="sidebar-item">Inventory Analytics</li>
        <li className="dropDown">
          <button onClick={toggleInventoryDropdown} className="dropdown-btn">
            Medicine Inventory 
            <span className={`dropdown-arrow ${isInventoryOpen ? "open" : ""}`}>
            {isInventoryOpen ? "  ▲" : "  ▼"}
          </span>
          </button>
          {isInventoryOpen && (
            <ul className="dropdown-content">
              <li>Medical Consumables</li>
              <li>Pharmaceutical</li>
              <li>Surgical Instrument</li>
              <li>Medical Device</li>
              <li>PPE</li>
              <li>Non-medical</li>
              <li>Sterilization</li>
              <li>Equipments</li>
            </ul>
          )}
        </li>
      </ul>
    </div>
  );
};

export default Sidebar;
