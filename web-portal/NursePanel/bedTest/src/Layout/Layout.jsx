// src/components/MainLayout.jsx
import React from 'react';
import Sidebar from '../components/Sidebar/Sidebar';
import Header from '../components/Header/Header';
import './Layout.css'
import { Outlet } from 'react-router-dom';

const MainLayout = () => {
  return (
    <>
      <Header />
      <div className="main-content">
        <Sidebar />
          <Outlet />
      </div>
    </>
  );
};

export default MainLayout;
