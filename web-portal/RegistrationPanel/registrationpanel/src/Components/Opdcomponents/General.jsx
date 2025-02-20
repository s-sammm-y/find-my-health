import React, { useEffect, useState } from 'react';
import { useDropdown } from '../../Context/DropdownContext';
import axios from 'axios'; // Ensure correct import

const General = () => {
  const { selectedDropdownValue } = useDropdown();
  const [currentTime, setCurrentTime] = useState(getCurrentTime());
  const [selectedDoctor, setSelectedDoctor] = useState(''); // State to track selected doctor
  const [doctors, setDoctors] = useState([]);
  const [morningTokenCount, setMorningTokenCount] = useState(0); // Initial morning token count
  const [eveningTokenCount, setEveningTokenCount] = useState(0); // Initial evening token count
  const [tokenType, setTokenType] = useState(''); // State to track token type (MORNING/EVENING)
  const [tokens, setTokens] = useState([]);//State to track fetched tokens
  const [selectedToken, setSelectedToken] = useState([]); // State to track clicked token
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

  useEffect(() => {
    const fetchDoctors = async () => {
      try {
        const response = await axios.get('http://localhost:3000/api/doctor-list');
        setDoctors(response.data); // Set the fetched doctors in state
      } catch (error) {
        console.error('Error fetching doctors:', error);
      }
    };

    fetchDoctors();
  }, []);
  
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

  const handleTokenClick = (token) => {
    if (tokenType) { // Only allow click if a tokenType is selected
      setSelectedToken(token)
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

  useEffect(()=>{
    if (tokenType!=null){
      const fetchBookings = async () => {
        try {
          const response = await axios.get(`http://localhost:3000/api/opd`, {
            params: { tokenType },
          });
          setTokens(response.data); // Set the fetched doctors in state
        } catch (error) {
          console.error('Error fetching doctors:', error);
        }
      };
  
      fetchBookings();
    }
  },[tokenType]);

  // useEffect(() => {
  //   console.log(tokens);
  // }, [tokens]);
  
  const renderTokenBoxes = () => {
      return tokens?.map((token, index) => {
        const tokenNumber = token.id; // Assuming each token object has a 'token_number' field
        const isArrived = token.arrived; // Check if the token is marked as arrived
      
        return (
          <div
            key={index}
            className={`border border-gray-300 rounded-lg p-2 h-[50px] w-[50px] flex items-center justify-center cursor-pointer ${
              isArrived ? 'bg-green-500' : 'bg-gray-100'
            } ${!selectedDoctor ? 'cursor-not-allowed opacity-50' : ''}`} // Disable click if no doctor is selected
            onClick={() => handleTokenClick(token)} // Make token clickable only if tokenType is set
          >
            <h2 className='text-center text-sm font-bold'>Token {tokenNumber}</h2>
          </div>
        );
      });
  };

  return (
    <div className='flex w-full h-screen bg-sky-100'>
      <div className='flex-1 h-screen bg-sky-100 relative mr-4'>
        <div className='absolute top-[1rem] left-0 right-0 bottom-0 bg-white overflow-y-auto p-4 mt-4'>
          <h1 className='text-[20px] text-center font-bold'>General</h1>
          <div className='my-4'>
            <select
              className='w-full bg-gray-200 p-2 rounded-md'
              onChange={handleDropdownChange} // Handle change event
            >
              <option value="" disabled selected>Select Doctor</option>
              {doctors.map((doctor) => (
                <option key={doctor.doctor_id} value={doctor.name}>
                  {doctor.name}
                </option>
              ))}
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
          <div className='flex items-center gap-[50px] m-4 ml-[0px]'>
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
        <div className='bg-gray-200 w-full h-[20%] font-medium text-xl p-6 text-center mt-5'>
          <p className='font-bold text-[40px] p-3'>{currentTime}</p>
          <p className='font-bold text-[30px] p-3'>{currentDateDetails}</p>
        </div>
        <div className='absolute top-[25%] left-0 right-0 bottom-0 bg-white overflow-y-auto p-4 mt-4'>
          <div className='flex justify-between items-center'>
            <div>
              <h2 className='text-[20px] font-plain p-2'>Patient Name:</h2>
            <h2 className='text-[20px] font-bold p-3'>{selectedToken.name}</h2>
            </div>
            <div className='flex flex-col items-start space-x-4'>
              <h2 className='text-[20px] font-plain'>Token No:</h2>
              <h2 className='text-[20px] font-bold'>{selectedToken.id}</h2>
            </div>
          </div>

          <div>
            <h2 className='text-[20px] font-plain p-2'>Aadhaar number:</h2>
            <h2 className='text-[20px] font-bold p-3'>{selectedToken.aadhar}</h2>
          </div>

          <div>
            <h2 className='text-[20px] font-plain p-2'>Phone Number:</h2>
            <h2 className='text-[20px] font-bold p-3'>{selectedToken.phone}</h2>
          </div>

          <div className="flex justify-center space-x-4">
            <button className="px-4 py-2 bg-blue-500 text-white rounded">Arrived</button>
            <button className="px-4 py-2 bg-green-500 text-white rounded">Details</button>
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

export default General;