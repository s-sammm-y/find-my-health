import React, { useState } from 'react';
import './SearchBarDropdown.css'; // CSS for styling

function SearchBarDropdown() {
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredItems, setFilteredItems] = useState([]);
  
  const inventory = [
    { id: 1, name: 'Syringes and Needles' },
    { id: 2, name: 'Dressings and Bandages' },
    { id: 3, name: 'Masks' },
    { id: 4, name: 'Gloves' },
    { id: 5, name: 'Thermometers' }
  ];

  // Handle search input changes
  const handleSearchChange = (e) => {
    const searchInput = e.target.value.toLowerCase();
    setSearchTerm(searchInput);

    const filtered = inventory.filter((item) =>
      item.name.toLowerCase().includes(searchInput)
    );
    setFilteredItems(filtered);
  };

  // When an item is clicked, set the search term to that item's name
  const handleItemClick = (item) => {
    setSearchTerm(item.name);
    setFilteredItems([]);  // Hide dropdown after selecting an item
  };

  return (
    <div className="search-bar-container">
      <input
        type="text"
        placeholder="Search Item"
        value={searchTerm}
        onChange={handleSearchChange}
        className="search-input"
      />
      {searchTerm && (
        <div className="dropdown">
          <ul>
            {filteredItems.length > 0 ? (
              filteredItems.map((item) => (
                <li key={item.id} onClick={() => handleItemClick(item)}>
                  {item.name}
                </li>
              ))
            ) : (
              <li>No items found</li>
            )}
          </ul>
        </div>
      )}
    </div>
  );
}

export default SearchBarDropdown;
