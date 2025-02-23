import React, { useState, useEffect } from "react";
import "./Notifications.css"
import axios from "axios";

function Notifications() {
  const [notifications, setNotifications] = useState([]);

  useEffect(() => {
    const fetchStock = async () => {
      try {
        const response = await axios.get("http://localhost:3003/api/lowStock");
        setNotifications(response.data);
      } catch (err) {
        console.error("Error fetching notifications:", err);
      }
    };

    fetchStock();
  }, []); 

  return (
    <div className="notifs">
      <h2>Low Stock Notifications</h2>
      <hr></hr>
      {notifications.length > 0 ? (
        <ul>
          {notifications.map((item, index) => (
            <li key={index}>
              <p className="listItem">{item.item_name} - Quantity: {item.quantity}</p>
            </li>
          ))}
        </ul>
      ) : (
        <p>Loading...</p> // Shows loading state until data arrives
      )}
    </div>
  );
}

export default Notifications;
