import React from 'react';
import { NavLink } from 'react-router-dom';

const Sidebar = () => {
  return (
    <div className='h-screen w-[20vh] bg-white shadow-2xl flex items-start justify-center'>
      <ul className="flex flex-col mt-4 w-full font-medium">
        
        <li className="p-2">
          <NavLink
            to="/bed-test"
            className={({ isActive }) =>
              `block w-full text-center py-2 px-4 rounded-md ${
                isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
              } duration-200 hover:bg-blue-300 hover:text-white`
            }
          >
            BEDS
          </NavLink>
          <NavLink
            to="/triage"
            className={({ isActive }) =>
              `block w-full text-center py-2 px-8 rounded-md ${
                isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
              } duration-200 hover:bg-blue-300 hover:text-white`
            }
          >
            TRIAGE
          </NavLink>
        </li>

        
      </ul>
    </div>
  );
};

export default Sidebar;
