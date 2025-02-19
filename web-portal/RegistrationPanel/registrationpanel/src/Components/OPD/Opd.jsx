import React, { useEffect, useState } from 'react';
import { Outlet, useLocation } from 'react-router-dom'; // useLocation for path checking

const Opd = () => {
  const { pathname } = useLocation(); // Get the current path
  const [currentTime, setCurrentTime] = useState(getCurrentTime());

  function getCurrentDateDetails() {
    const date = new Date();
    const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const monthsOfYear = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    const dayOfWeek = daysOfWeek[date.getDay()];
    const month = monthsOfYear[date.getMonth()];
    const day = date.getDate();
    const year = date.getFullYear();
    return `${dayOfWeek}, ${month} ${day}, ${year}`;
  }

  function getCurrentTime() {
    const date = new Date();
    const hours = date.getHours();
    const minutes = date.getMinutes();
    const seconds = date.getSeconds();
    return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
  }

  const currentDateDetails = getCurrentDateDetails();

  useEffect(() => {
    const intervalId = setInterval(() => {
      setCurrentTime(getCurrentTime());
    }, 1000);
    return () => clearInterval(intervalId);
  }, []);

  const isSubRoute = pathname !== '/opd'; // Check if we're on a subroute like /opd/general

  return (
    <div className="w-full h-screen bg-sky-100">
      {/* Show OPD content only if we're exactly on the /opd route */}
      {!isSubRoute && (
        <div className='flex w-full h-screen'>
          <div className='flex-1 bg-sky-100 relative mr-4'>
            
            <div className='absolute top-[20%] left-0 right-0 bottom-0 bg-white overflow-y-auto p-4 ki2'></div>
          </div>

          <div className='flex-1 h-screen bg-sky-100 relative ml-2'>
            <div className='bg-gray-200 w-full h-[20%] font-medium text-xl p-6 text-center mt-5'>
              <p>{currentDateDetails}</p>
              <p className='font-bold text-[50px] p-3'>{currentTime}</p>
            </div>
            <div className='absolute top-[20%] left-0 right-0 bottom-0 bg-white overflow-y-auto p-4'></div>
          </div>
        </div>
      )}
      <Outlet /> {/* This will render sub-routes like General, Skin, etc. */}
    </div>
  );
};

export default Opd;







