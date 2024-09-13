import React from 'react';
import './Popup.css';

const Popup = ({ show, onClose, children }) => {
  if (!show) return null;

  return (
    <div className="popup-overlay">
      <div className="popup-content">
        <button className="close-popup" onClick={onClose}>X</button>
        {children}
      </div>
    </div>
  );
};

export default Popup;