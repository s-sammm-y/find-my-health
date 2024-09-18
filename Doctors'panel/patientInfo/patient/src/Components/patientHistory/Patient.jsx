import React, { useState } from 'react';  // Import useState
import { useNavigate } from 'react-router-dom';
import { IoArrowBackSharp } from 'react-icons/io5';
import { IoIosAddCircleOutline } from "react-icons/io";
import { SlCalender } from "react-icons/sl";
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css'; // Import DatePicker CSS

const BackButton = () => {
  const navigate = useNavigate();
  const [selectedDate, setSelectedDate] = useState(null); // State for managing selected date

  const handleClick = () => {
    navigate('/'); // Adjust the route to the patient queue as needed
  };

  const handleSubmit = () => {
    // Handle form submission
    console.log("Form submitted with date: ", selectedDate);
  };

  return (
    <div className='w-full h-screen bg-sky-100 flex flex-col items-start p-4'>
      <button
        onClick={handleClick}
        className='flex items-center justify-center rounded-xl bg-gray-400 w-[480px] h-[50px] text-black font-semibold hover:bg-gray-500 transition-colors duration-300 mb-4'
      >
        <IoArrowBackSharp className='mr-2' />
        Back to the Patient Queue
      </button>

      <div className='flex w-full h-[90%] gap-4'>
        <div className='w-full max-w-[68vh] bg-white shadow-2xl flex flex-col items-start h-full p-4 overflow-auto'>
          <form action="" className='w-full h-full flex flex-col space-y-4'>
            <textarea
              placeholder='Write Description'
              className='bg-slate-200 rounded-xl p-2 text-black placeholder-black w-full h-[150px] resize-none'
              style={{ paddingTop: '1rem', paddingBottom: '0.5rem' }}
            />
            
            <div className='bg-gray-100 p-4 rounded-lg space-y-4 w-full'>
              <p className='font-bold'>Medicine</p>

              <div className='space-y-2'>
                <div>
                  <label htmlFor="category" className='block text-sm font-medium text-gray-700'>Category</label>
                  <select id="category" className='bg-slate-200 rounded-lg p-2 w-full'>
                    <option value="">Select Category</option>
                    <option value="category1">Category 1</option>
                    <option value="category2">Category 2</option>
                  </select>
                </div>

                <div>
                  <label htmlFor="dosage" className='block text-sm font-medium text-gray-700'>Dosage</label>
                  <select id="dosage" className='bg-slate-200 rounded-lg p-2 w-full'>
                    <option value="">Select Dosage</option>
                    <option value="dosage1">Dosage 1</option>
                    <option value="dosage2">Dosage 2</option>
                  </select>
                </div>

                <div>
                  <label htmlFor="frequency" className='block text-sm font-medium text-gray-700'>Frequency</label>
                  <select id="frequency" className='bg-slate-200 rounded-lg p-2 w-full'>
                    <option value="">Select Frequency</option>
                    <option value="frequency1">Frequency 1</option>
                    <option value="frequency2">Frequency 2</option>
                  </select>
                </div>

                <div>
                  <label htmlFor="medicine" className='block text-sm font-medium text-gray-700'>Medicine</label>
                  <select id="medicine" className='bg-slate-200 rounded-lg p-2 w-full'>
                    <option value="">Select Medicine</option>
                    <option value="medicine1">Medicine 1</option>
                    <option value="medicine2">Medicine 2</option>
                  </select>
                </div>
              </div>

              <div className='space-y-4 mt-4'>
                <h1 className='text-lg font-bold flex items-center'>
                  Add Medicine
                  <button className='inline-flex items-center justify-center rounded-full bg-sky-400 p-1 text-white hover:bg-sky-500 transition-colors duration-300 ml-2'>
                    <IoIosAddCircleOutline className='text-xl' />
                  </button>
                </h1>
                <h1 className='text-lg font-bold flex items-center'>
                  Schedule Next Appointment
                  <button className='inline-flex items-center justify-center rounded-full bg-sky-400 p-1 text-white hover:bg-sky-500 transition-colors duration-300 ml-2'>
                    <SlCalender className='text-xl' />
                  </button>
                </h1>
                <DatePicker
                  selected={selectedDate}
                  onChange={(date) => setSelectedDate(date)}
                  dateFormat="dd/MM/yyyy"
                  placeholderText="Select date"
                  className="bg-slate-200 p-2 rounded-lg w-full mt-2"
                />
                <h1 className='font-bold text-xl'>Advice Admission</h1>
                <div className='space-y-2'>
                  <div className='flex items-center'>
                    <input
                      type="radio"
                      id="advice-admission-yes"
                      name="advice-admission"
                      value="yes"
                      className='mr-2'
                    />
                    <label htmlFor="advice-admission-yes" className='text-sm'>Yes</label>
                  </div>
                  <div className='flex items-center'>
                    <input
                      type="radio"
                      id="advice-admission-no"
                      name="advice-admission"
                      value="no"
                      className='mr-2'
                    />
                    <label htmlFor="advice-admission-no" className='text-sm'>No</label>
                  </div>
                </div>
              </div>
            </div>

            <button
              type="button"
              onClick={handleSubmit}
              className='bg-sky-400 text-white py-2 px-4 rounded-lg hover:bg-sky-500 transition-colors duration-300 self-center'
            >
              Submit
            </button>
          </form>
        </div>

        <div className='flex flex-col w-[90%] gap-4'>
          <div className='bg-gray-300 h-[50%] text-center p-3'>Patient details...</div>
          <div className='bg-gray-300 h-[50%] text-center p-3'>Research...</div>
        </div>
      </div>
    </div>
  );
};

export default BackButton;
