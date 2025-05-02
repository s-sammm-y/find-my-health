import React, { useState } from "react";
import { Link, useLocation } from "react-router-dom";
import "./Sidebar.css"; // Import the CSS file

const Sidebar = () => {
  const [isInventoryOpen, setIsInventoryOpen] = useState(false);
  const location = useLocation(); // Get the current route

  const toggleInventoryDropdown = () => {
    setIsInventoryOpen(!isInventoryOpen);
  };

  const isActive = location.pathname.startsWith("/Medicineinventory");

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
        <li className={`sidebar-item ${isActive ? "active" : ""}`}>
      <div
        onClick={toggleInventoryDropdown}
        className="cursor-pointer font-semibold hover:text-blue-500"
      >
        Medicine Inventory
      </div>

      {/* MEDICINE INVENTORY ITEMS */}
      {(isInventoryOpen || isActive) && (
        <div className="ml-4 mt-2 flex flex-col gap-2">
          <Link to="/medicineinventory/prescription">
            <button className="bg-blue-400 w-[200px] h-12 rounded-lg shadow-md hover:bg-blue-500 text-white">
              Prescription Medications
            </button>
          </Link>
          <Link to="/medicineinventory/otc">
            <button className="bg-blue-400 w-[200px] h-12 rounded-lg shadow-md hover:bg-blue-500 text-white">
              Over-the-Counter Medications
            </button>
          </Link>
          <Link to="/medicineinventory/injectable">
            <button className="bg-blue-400 w-[200px] h-12 rounded-lg shadow-md hover:bg-blue-500 text-white">
              Injectable Medications
            </button>
          </Link>
        </div>
      )}
    </li>
    <a href="http://localhost:5173/">
          <li className="sidebar-item" style={{ marginTop: '290px' }} >LOGOUT</li>
        </a>
      </ul>
    </div>
  );
};

export default Sidebar;
