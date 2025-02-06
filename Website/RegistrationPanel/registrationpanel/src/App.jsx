// src/App.jsx
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import { DropdownProvider } from './Context/DropdownContext';
import Sidebar from './Components/Sidebar';
import Opd from './components/Opd';

const App = () => {
  return (
    <Router>
      <DropdownProvider>
        <div className="flex">
          <Sidebar />
          <div className="flex-1">
            <Routes>
              <Route path="/opd/:type" element={<Opd />} />
              {/* Define other routes here */}
            </Routes>
          </div>
        </div>
      </DropdownProvider>
    </Router>
  );
};

export default App;
