import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { IoArrowBackSharp } from 'react-icons/io5';
import { IoIosAddCircleOutline } from "react-icons/io";
import { SlCalender } from "react-icons/sl";
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import axios from 'axios';
import Dosage from './Dosage';

const BackButton = () => {
  const navigate = useNavigate();
  const [selectedDate, setSelectedDate] = useState('');
  const [addMed, setAddMed] = useState(0);
  const [selectedData, setSelectedData] = useState([]);
  const [description, setDescription] = useState(''); // New state for textarea
  const [patientName,setPatientName] = useState('');
  const [patientAge,setPatientAge] = useState('');
  const [userId,setUserID] = useState(2);

  const handleClick = () => {
    navigate('/'); // Adjust the route to the patient queue as needed
  };

  //function to call generate pdf api
  const genPdf = async () => {
    try {
        const response = await axios.post('http://localhost:5000/generate-pdf', {
            pdfdata: selectedData,
            name:patientName,
            age:patientAge,
            date:selectedDate,
            user_id:userId
        }, { responseType: 'blob' }); // Ensure the response is treated as a blob

        const blob = new Blob([response.data],{type:'application/pdf'})
        const url = window.URL.createObjectURL(blob);
        window.open(url);

        console.log('PDF generated successfully');
    } catch (err) {
        console.error('Error caught in frontend PDF function', err.message);
        alert('PDF API problem');
    }
};

  const handleSubmit = async() => {
    try{ 
      const response = await axios.post('http://localhost:5000/submit-medicine',{
        /* description:selectedData.description,
        medicine:selectedData.medicine,
        dosage:selectedData.dosage,
        frequency:selectedData.frequency */
        data:selectedData
      })
      console.log('Data posted succesfully',response.data)
    }catch(err){
      console.error(err.message)
      alert('Api issue')
    }
  };

  // Function to handle add medicine
  const handleAddMed = () => {
    setAddMed(prevAddMed => prevAddMed + 1);
    setSelectedData(prevData => [...prevData, { description: '', medicine: '', dosage: '', frequency: ''}]); // Initialize new medicine data
  };

  //deleting a specific meducine
  const handleDelete = () => {
    if (selectedData.length > 0) {
        const updatedData = selectedData.slice(0, -1); // Removes the last object
        setSelectedData(updatedData);
        setAddMed(prev => Math.max(0, prev - 1)); // Ensure it doesn't go below 0
    }
};

  // Function to update selected medicine data
  const updateSelectedMedicine = (index, medicineData) => {
    setSelectedData(prev => {
      const newSelected = [...prev];
      newSelected[index] = medicineData;
      //console.log(`Index: ${index}, Medicine Data:`, medicineData); // Log to check
      return newSelected;
    });
  };

  //function to change handlePatient Name
  const handlePatientName = (e)=>{
    setPatientName(e.target.value);
    console.log(patientName)
  }

  const handlePatientAge = (e)=>{
    setPatientAge(e.target.value)
    console.log(patientAge)
  }

  //function to set description
  const handleDescriptionChange = async (value) => {
    setDescription(value); // Update the description state
  };


  //loading the description as sooon as child object is created inside the parent
  useEffect(() => {
    setSelectedData(prev => {
      return prev.map(medicineData => ({
        ...medicineData,
        description: description // Apply the same description to all objects
      }));
    });
  }, [description]);


  useEffect(() => {
    console.log(selectedData);
  }, [selectedData]);

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
        <div className='w-full bg-white shadow-2xl flex flex-col items-start h-full p-4 overflow-auto'>
          <form className='w-full h-full flex flex-col space-y-4'>
            <div className='bg-gray-100 p-4 rounded-lg space-y-4 w-full'>
              <p className='font-bold'>Medicine</p>

              <div className='py-3'>
                <p>User-Id:{userId}</p>
              </div>

                <label htmlFor="patient-name">
                  Name:-
                </label>

                <input type="text" className='bg-slate-200 rounded-lg p-2 w-full' 
                value={patientName}
                onChange={handlePatientName}/>


                <label htmlFor="patient-age" className='pr-4'
                >
                  Age:-
                </label>
                
                <input type="text" className='bg-slate-200 rounded-lg p-2 w-20' 
                onChange={handlePatientAge}
                value={patientAge}/>

              {/* Render the Dosage component addMed times */}
              {Array.from({ length: addMed }).map((_, index) => (
                <Dosage
                  key={index}
                  updateSelectedMedicine={updateSelectedMedicine} // Pass the function directly
                  index={index} // Pass the index for identification
                />
              ))}

              <div className='space-y-4 mt-4'>
                <h1 className='text-lg font-bold flex items-center'>
                  Add Medicine
                  <button className='inline-flex items-center justify-center rounded-full bg-sky-400 p-1 text-white hover:bg-sky-500 transition-colors duration-300 ml-2'
                    type='button'
                    onClick={handleAddMed}>
                    <IoIosAddCircleOutline className='text-xl' />
                  </button>
                </h1>
                <div>
                  <button type='button' 
                  className='bg-red-400 text-white py-2 px-4 rounded-lg hover:bg-sky-500 transition-colors duration-300 self-center'
                  onClick={handleDelete}>
                    Remove Medicine
                  </button>
                </div>

                <textarea
                  placeholder='Write Description'
                  className='bg-slate-200 rounded-xl p-2 text-black placeholder-black w-full h-[150px] resize-none'
                  style={{ paddingTop: '1rem', paddingBottom: '0.5rem' }}
                  onChange={(e) => { handleDescriptionChange(e.target.value) }}
                />

                <h1 className='text-lg font-bold flex items-center'>
                  Schedule Next Appointment
                  <button className='inline-flex items-center justify-center rounded-full bg-sky-400 p-1 text-white hover:bg-sky-500 transition-colors duration-300 ml-2'>
                    <SlCalender className='text-xl' />
                  </button>
                </h1>

                <DatePicker
                  selected={selectedDate}
                  onChange={async(date) => setSelectedDate(date)}
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
            
            <div className='buttons flex justify-center items-center gap-4 text-center p-3'>
              {/* <button
                type="button"
                onClick={handleSubmit}
                className=' bg-sky-400 text-white py-2 px-3 rounded-lg hover:bg-sky-500 transition-colors duration-300 self-center'
              >
                Submit
              </button> */}

              <button className='bg-sky-400 text-white py-2 px-4 rounded-lg hover:bg-sky-500 transition-colors duration-300 self-center'
              onClick={genPdf}
              type='button'>
                PDF
              </button>
            </div>
          </form>
        </div>

        {/*maybe paditent queue details*/}
        {/* <div className='flex flex-col w-[90%] gap-4'>
          <div className='bg-gray-300 h-[50%] text-center p-3'>Patient details...</div>
          <div className='bg-gray-300 h-[50%] text-center p-3'>Research...</div>
        </div> */}
      </div>
    </div>
  );
};

export default BackButton;
