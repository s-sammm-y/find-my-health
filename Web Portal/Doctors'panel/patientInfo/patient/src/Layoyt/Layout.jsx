import React from 'react';
import Header from '../Components/Header/Header';
import Sidebar from '../Components/Sidebar/Sidebar';
import { Outlet } from 'react-router-dom';


const Layout = () => {
  return (
    <div className="flex flex-col h-screen ">
      
      <Header className="fixed top-0 left-0 w-full z-10" />
      <div className="flex flex-grow ">
        <Sidebar className="fixed top-16 left-0 h-full w-[20vh] z-20" />
        <main className="flex-grow ml-[1vh] bg-sky-100 p-2">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default Layout;
