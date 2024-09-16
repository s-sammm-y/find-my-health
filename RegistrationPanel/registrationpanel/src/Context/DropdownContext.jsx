import React, { createContext, useContext, useState } from 'react';

const DropdownContext = createContext();

export const DropdownProvider = ({ children }) => {
  const [selectedDropdownValue, setSelectedDropdownValue] = useState('');

  return (
    <DropdownContext.Provider value={{ selectedDropdownValue, setSelectedDropdownValue }}>
      {children}
    </DropdownContext.Provider>
  );
};

export const useDropdown = () => useContext(DropdownContext);
