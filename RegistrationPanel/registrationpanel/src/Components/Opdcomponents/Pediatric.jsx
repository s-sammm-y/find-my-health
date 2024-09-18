import React, { useEffect, useState } from 'react';
import { useDropdown } from '../../Context/DropdownContext'; // Ensure correct import

const Pediatric = () => {
  const { selectedDropdownValue } = useDropdown();
  const [currentTime, setCurrentTime] = useState(getCurrentTime());
  const [selectedDoctor, setSelectedDoctor] = useState(''); // State to track selected doctor
  const [morningTokenCount, setMorningTokenCount] = useState(0); // Initial morning token count
  const [eveningTokenCount, setEveningTokenCount] = useState(0); // Initial evening token count
  const [tokenType, setTokenType] = useState(''); // State to track token type (MORNING/EVENING)
  const [selectedToken, setSelectedToken] = useState(null); // State to track clicked token
  const [isModalOpen, setIsModalOpen] = useState(false); // State to control modal visibility
  const [arrivedTokens, setArrivedTokens] = useState([]); // State to track arrived tokens

  // List of static yellow tokens
  const yellowTokens = new Set([3, 5, 7, 10, 12, 15]); // Adjust these numbers as needed

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

  const handleDropdownChange = (e) => {
    setSelectedDoctor(e.target.value); // Update the state with the selected doctor
  };

  const handleAddToken = () => {
    if (tokenType === 'MORNING') {
      setMorningTokenCount(prevCount => prevCount + 1); // Increment the morning token count
    } else if (tokenType === 'EVENING') {
      setEveningTokenCount(prevCount => prevCount + 1); // Increment the evening token count
    }
  };

  const handleMorningClick = () => {
    if (selectedDoctor) { // Only allow action if a doctor is selected
      setTokenType('MORNING'); // Set token type to MORNING
    }
  };

  const handleEveningClick = () => {
    if (selectedDoctor) { // Only allow action if a doctor is selected
      setTokenType('EVENING'); // Set token type to EVENING
    }
  };

  const handleTokenClick = (tokenNumber) => {
    if (tokenType) { // Only allow click if a tokenType is selected
      setSelectedToken(tokenNumber); // Store the clicked token number
      setIsModalOpen(true); // Open the modal
    }
  };

  const handleArrivedClick = () => {
    setArrivedTokens(prevArrivedTokens => [...prevArrivedTokens, selectedToken]); // Mark the token as arrived
    setIsModalOpen(false); // Close the modal
  };

  const closeModal = () => {
    setIsModalOpen(false); // Close the modal
  };

  const displayModal = () => {
    setIsModalOpen(true); // Open the modal
  };

  const renderTokenBoxes = () => {
    const tokenBoxCount = tokenType === 'EVENING' ? eveningTokenCount : morningTokenCount;
    return Array.from({ length: tokenBoxCount+10 }).map((_, index) => {
      const tokenNumber = index + 1;
      const isArrived = arrivedTokens.includes(tokenNumber); // Check if the token is marked as arrived
      const isYellow = yellowTokens.has(tokenNumber); // Check if token should be yellow

      return (
        <div
          key={index}
          className={`border border-gray-300 rounded-lg p-2 h-[50px] w-[50px] flex items-center justify-center cursor-pointer ${
            isArrived ? 'bg-green-500' : (isYellow ? 'bg-yellow-300' : 'bg-gray-100') // Apply yellow background if in the list
          } ${!selectedDoctor ? 'cursor-not-allowed opacity-50' : ''}`} // Disable click if no doctor is selected
          onClick={() => handleTokenClick(tokenNumber)} // Make token clickable only if tokenType is set
        >
          <h2 className='text-center text-sm font-bold'>Token {tokenNumber}</h2>
        </div>
      );
    });
  };

  return (
    <div className='flex w-full h-screen bg-sky-100'>
      <div className='flex-1 h-screen bg-sky-100 relative mr-4'>
        <div className='bg-gray-200 w-full h-[20%] text-center text-3xl font-bold p-10'>
          REGISTER NEW PATIENT
        </div>

        <div className='absolute top-[20%] left-0 right-0 bottom-0 bg-white overflow-y-auto p-4'>
          <h1 className='text-[20px] text-center font-bold'>Pediatric</h1>
          <div className='my-4'>
            <select
              className='w-full bg-gray-200 p-2 rounded-md'
              onChange={handleDropdownChange} // Handle change event
            >
              <option value="" disabled selected>Select Doctor</option>
              <option value="Doctor 1">Doctor 1</option>
              <option value="Doctor 2">Doctor 2</option>
              <option value="Doctor 3">Doctor 3</option>
            </select>
          </div>
          <div className='h-[110px] w-[100%] border-slate-500 border flex items-center'>
            <div className='flex items-center'>
              <div className='h-[90px] w-[90px] border-slate-600 border m-2'></div>
              <div className='mr-5'>
                <h1 className='font-bold ml-[8px] m-[1px]'>{selectedDoctor || "Doctor's Name"}</h1> {/* Display selected doctor */}
                <h2>Doctor's Qualification</h2>
              </div>
            </div>
          </div>
          <div className='flex items-center gap-[50px] m-5 ml-[0px]'>
            <button
              className={`w-[400px] h-[40px] border-zinc-600 p-2 rounded hover:bg-sky-500 ${tokenType === 'MORNING' ? 'bg-sky-500 text-white' : 'bg-sky-300 text-black'} ${!selectedDoctor ? 'cursor-not-allowed opacity-50' : ''}`}
              onClick={handleMorningClick} // Set token type to MORNING
              disabled={!selectedDoctor} // Disable button if no doctor is selected
            >
              MORNING
            </button>
            <button
              className={`w-[450px] h-[40px] border-zinc-600 p-2 rounded hover:bg-sky-500 ${tokenType === 'EVENING' ? 'bg-sky-500 text-white' : 'bg-sky-300 text-black'} ${!selectedDoctor ? 'cursor-not-allowed opacity-50' : ''}`}
              onClick={handleEveningClick} // Set token type to EVENING
              disabled={!selectedDoctor} // Disable button if no doctor is selected
            >
              EVENING
            </button>
          </div>
          <div className='flex items-center gap-[300px]'>
            <h1 className='text-[20px] font-bold'>Today's Bookings</h1>
            <button
              className='w-[140px] h-[40px] border-zinc-600 bg-sky-300 text-black p-2 rounded hover:bg-sky-500'
              onClick={handleAddToken} // Handle click event
            >
              Add Token+ {tokenType === 'MORNING' ? morningTokenCount : eveningTokenCount} {/* Display token count inside the button */}
            </button>
          </div>

          {tokenType && ( // Render token boxes only if tokenType is set
            <div className='h-[200px] w-[99%] border-slate-500 border m-3 ml-1 overflow-y-auto'>
              <div className='grid grid-cols-5 gap-2 p-2'>
                {renderTokenBoxes()}
              </div>
            </div>
          )}
        </div>
      </div>

      <div className='flex-1 h-screen bg-sky-100 relative ml-4'>
        <div className='bg-gray-200 w-full h-[20%] font-medium text-xl p-6 text-center'>
          <p className='font-bold text-[40px] p-3'>{currentTime}</p>
          <p className='font-bold text-[30px] p-3'>{currentDateDetails}</p>
        </div>
        <div className='absolute top-[20%] left-0 right-0 bottom-0 bg-white overflow-y-auto p-4'>
          <div className='flex justify-between items-center'>
            <div>
              <h1 className='text-[20px] font-semibold p-2'>Patient Name:</h1>
              <h1 className='text-[30px] font-bold p-3'>ANISH MONDAL</h1>
            </div>
            <div className='flex items-center space-x-4'>
              <h1 className='text-[20px] font-semibold'>Current Token:</h1>
              <h1 className='text-[30px] font-bold'>{selectedToken ? `Token ${selectedToken}` : 'N/A'}</h1>
            </div>
          </div>

          <div>
            <h1 className='text-[20px] font-semibold p-2'>Appointment number:</h1>
            <h1 className='text-[30px] font-bold p-3'>12345689</h1>
          </div>

          <div>
            <h1 className='text-[20px] font-semibold p-2'>Booking Time:</h1>
            <h1 className='text-[30px] font-bold p-3'>12:00 PM</h1>
          </div>

          <div>
            <h1 className='text-[20px] font-semibold p-2'>Booking Date:</h1>
            <h1 className='text-[30px] font-bold p-3'>16th September, 2024</h1>
          </div>
        </div>
      </div>

      {/* Modal for clicked token */}
      {isModalOpen && (
        <div className='fixed top-0 left-0 right-0 bottom-0 bg-black bg-opacity-50 flex items-center justify-center'>
          <div className='bg-white p-6 rounded-lg'>
            <h2 className='text-lg font-bold mb-4'>Token {selectedToken}</h2>
            <div className='flex gap-3'>
              <button
                className='bg-green-500 text-white p-2 rounded mr-2 font-bold'
                onClick={handleArrivedClick}
              >
                Mark as Arrived
              </button>
              <button
                className='bg-yellow-300 text-white p-2 rounded font-bold'
                onClick={displayModal}
              >
                Details
              </button>
              <button
                className='bg-gray-500 text-white font-bold p-2 rounded'
                onClick={closeModal}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Pediatric;
