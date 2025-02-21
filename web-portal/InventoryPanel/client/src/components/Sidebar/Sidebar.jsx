import React, { useState } from "react";
import { Link, useLocation } from "react-router-dom";
import "./Sidebar.css"; // Import the CSS file

const Sidebar = () => {
  const [isInventoryOpen, setIsInventoryOpen] = useState(false);
  const location = useLocation(); // Get the current route

  const toggleInventoryDropdown = () => {
    setIsInventoryOpen(!isInventoryOpen);
  };

  return (
    <div className="sidebar">
      <ul className="sidebar-menu">
        <li className={`sidebar-item ${location.pathname === "/" ? "active" : ""}`}>
          <Link to="/">Home</Link>
        </li>
        <li className={`sidebar-item ${location.pathname === "/notifications" ? "active" : ""}`}>
          <Link to="/notifications">Notifications</Link>
        </li>
        <li className={`sidebar-item ${location.pathname === "/analytics" ? "active" : ""}`}>
          <Link to="/analytics">Inventory Analytics</Link>
        </li>
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
