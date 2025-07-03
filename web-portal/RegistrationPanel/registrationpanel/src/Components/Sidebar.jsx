// src/Components/Sidebar.jsx
import React, { useState } from 'react';
import { NavLink } from 'react-router-dom';

const Sidebar = () => {
  const [opdDropdown, setOpdDropdown] = useState(false);

  const toggleOpdDropdown = () => {
    setOpdDropdown(!opdDropdown);
  };

  const closeDropdown = () => {
    setOpdDropdown(false);
  };

  return (
    <div className='fixed top-15 left-0 h-full w-[30vh] bg-white shadow-2xl'>
      <ul className="flex flex-col mt-4 w-full font-medium">
        {/* OPD with dropdown */}
        <li className="p-2">
          <button
            className={`block w-full text-center py-2 px-4 rounded-md duration-200 hover:bg-blue-300 hover:text-white ${
              opdDropdown ? 'bg-blue-500 text-white' : 'bg-white text-black'
            }`}
            onClick={toggleOpdDropdown}
          >
            OPD
          </button>
          {opdDropdown && (
            <ul className="ml-2 mt-2 space-y-1 bg-white shadow-lg p-2 rounded-md">
              {/* Dropdown items */}
              <li className="p-1 text-sm">
                <NavLink
                  to="/opd/general"
                  className={({ isActive }) =>
                    `block w-full text-left py-1 px-3 rounded-md text-sm ${
                      isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
                    } duration-200 hover:bg-blue-300 hover:text-white`
                  }
                  onClick={closeDropdown} // Close dropdown on click
                >
                  GENERAL
                </NavLink>
              </li>
              <li className="p-1 text-sm">
                <NavLink
                  to="/opd/skin"
                  className={({ isActive }) =>
                    `block w-full text-left py-1 px-3 rounded-md text-sm ${
                      isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
                    } duration-200 hover:bg-blue-300 hover:text-white`
                  }
                  onClick={closeDropdown} // Close dropdown on click
                >
                  SKIN
                </NavLink>
              </li>
              <li className="p-1 text-sm">
                <NavLink
                  to="/opd/orthopedic"
                  className={({ isActive }) =>
                    `block w-full text-left py-1 px-3 rounded-md text-sm ${
                      isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
                    } duration-200 hover:bg-blue-300 hover:text-white`
                  }
                  onClick={closeDropdown} // Close dropdown on click
                >
                  ORTHOPEDIC
                </NavLink>
              </li>
              <li className="p-1 text-sm">
                <NavLink
                  to="/opd/neurologist"
                  className={({ isActive }) =>
                    `block w-full text-left py-1 px-3 rounded-md text-sm ${
                      isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
                    } duration-200 hover:bg-blue-300 hover:text-white`
                  }
                  onClick={closeDropdown} // Close dropdown on click
                >
                  NEUROLOGIST
                </NavLink>
              </li>
              <li className="p-1 text-sm">
                <NavLink
                  to="/opd/pediatric"
                  className={({ isActive }) =>
                    `block w-full text-left py-1 px-3 rounded-md text-sm ${
                      isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
                    } duration-200 hover:bg-blue-300 hover:text-white`
                  }
                  onClick={closeDropdown} // Close dropdown on click
                >
                  PEDIATRIC
                </NavLink>
              </li>
            </ul>
          )}
        </li>

        {/* Other sidebar links */}
        <li className="p-2">
          <NavLink
            to="/emergency"
            className={({ isActive }) =>
              `block w-full text-center py-2 px-4 rounded-md ${
                isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
              } duration-200 hover:bg-blue-300 hover:text-white`
            }
          >
            EMERGENCY
          </NavLink>
        </li>
        {/* <li className="p-2">
          <NavLink
            to="/triage"
            className={({ isActive }) =>
              `block w-full text-center py-2 px-4 rounded-md ${
                isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
              } duration-200 hover:bg-blue-300 hover:text-white`
            }
          >
            TRIAGE
          </NavLink>
        </li> */}

        {/* <li className="p-2">
          <NavLink
            to="/patient-status"
            className={({ isActive }) =>
              `block w-full text-center py-2 px-4 rounded-md ${
                isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
              } duration-200 hover:bg-blue-300 hover:text-white`
            }
          >
            PATIENT STATUS
          </NavLink>
        </li> */}

        {/* <li className="p-2">
          <NavLink
            to="/bed-availability"
            className={({ isActive }) =>
              `block w-full text-center py-2 px-4 rounded-md ${
                isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
              } duration-200 hover:bg-blue-300 hover:text-white`
            }
          >
            BED AVAILABILITY
          </NavLink>
        </li> */}
        <li className="p-2">
          <NavLink
            to="/ambulance"
            className={({ isActive }) =>
              `block w-full text-center py-2 px-4 rounded-md ${
                isActive ? 'bg-sky-600 text-white' : 'bg-white text-black'
              } duration-200 hover:bg-blue-300 hover:text-white`
            }
          >
            AMBULANCE
          </NavLink>
        </li>
        <a href="http://localhost:5173/">
          <li className="p-2 mt-6 cursor-pointer hover:underline text-center" style={{ marginTop: '240px' }} >LOGOUT</li>
        </a>
      </ul>
    </div>
  );
};

export default Sidebar;
