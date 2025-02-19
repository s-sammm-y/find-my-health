// src/Layout/Layout.jsx
import React from "react";
import Header from "../Components/Header";
import Sidebar from "../Components/Sidebar";
import { Outlet } from "react-router-dom";

const Layout = () => {
  return (
    <div className="flex flex-col h-screen overflow-hidden">
      <Header className="fixed top-0 left-0 w-full z-10 bg-white shadow-md" />

      <div className="flex pt-16">
        <Sidebar className="fixed top-16 left-0 h-[calc(100vh-4rem)] w-[30vh] z-20 bg-white shadow-md" />


        <main className="fixed top-16 left-[30vh] w-[calc(100vw-30vh)] h-[calc(100vh-4rem)] bg-sky-100 p-4">
          <div className="h-full overflow-auto p-2">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );
};

export default Layout;

