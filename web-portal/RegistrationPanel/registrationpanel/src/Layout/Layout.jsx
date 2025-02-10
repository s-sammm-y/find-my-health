// src/Layout/Layout.jsx
import React from 'react';
import Header from '../Components/Header'; 
import Sidebar from '../Components/Sidebar'; 
import { Outlet } from 'react-router-dom';

const Layout = () => {
  return (
    <div className="flex flex-col h-screen">
      <Header className="fixed top-0 left-0 w-full z-10 bg-white" />
      <div className="flex flex-grow ">
        <Sidebar className="fixed top-16 left-0 h-full w-[30vh] z-20 bg-white" />
        <main className="flex-grow ml-[30vh] bg-sky-100 p-4">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default Layout;
