import React, { useState } from "react";
import "./Sidebar.css"; // optional for styling

import { Link } from 'react-router-dom';


const Sidebar = () => {
  const [isInventoryOpen, setIsInventoryOpen] = useState(false);

  const toggleInventoryDropdown = () => {
    setIsInventoryOpen(!isInventoryOpen);
  };

  return (
    <div className="sidebar">
      <ul className="sidebar-menu">
        <li><Link to="/">Edit bed</Link></li>
        <li><Link to="/triage">Triage</Link></li>
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
        <a href="http://localhost:5173/">
          <li className="p-2 mt-6 cursor-pointer hover:underline text-center" style={{ marginTop: '380px' }} >LOGOUT</li>
        </a>
      </ul>
    </div>
  );
};

export default Sidebar;
