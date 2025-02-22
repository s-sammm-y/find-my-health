import React, { useEffect, useState } from 'react';
import { IoIosAddCircleOutline } from "react-icons/io";
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import axios from 'axios';
import Dosage from './Dosage';

const PrescriptionModal = () => {
  const [showModal, setShowModal] = useState(false);
  const [selectedDate, setSelectedDate] = useState('');
  const [addMed, setAddMed] = useState(0);
  const [selectedData, setSelectedData] = useState([]);
  const [description, setDescription] = useState('');
  const [patientName, setPatientName] = useState('');
  const [patientAge, setPatientAge] = useState('');
  const [userId, setUserID] = useState(null);

  const genPdf = async () => {
    try {
      const response = await axios.post('http://localhost:5000/generate-pdf', {
        pdfdata: selectedData,
        name: patientName,
        age: patientAge,
        date: selectedDate,
        user_id: userId
      }, { responseType: 'blob' });

      const blob = new Blob([response.data], { type: 'application/pdf' });
      const url = window.URL.createObjectURL(blob);
      window.open(url);
    } catch (err) {
      console.error('Error generating PDF', err.message);
      alert('PDF API problem');
    }
  };

  const handleAddMed = () => {
    setAddMed(prev => prev + 1);
    setSelectedData(prev => [...prev, { description: '', medicine: '', dosage: '', frequency: '' }]);
  };

  const handleDelete = () => {
    if (selectedData.length > 0) {
      const updatedData = selectedData.slice(0, -1);
      setSelectedData(updatedData);
      setAddMed(prev => Math.max(0, prev - 1));
    }
  };

  const updateSelectedMedicine = (index, medicineData) => {
    setSelectedData(prev => {
      const newSelected = [...prev];
      newSelected[index] = medicineData;
      return newSelected;
    });
  };

  const handlePatientName = (e) => {
    setPatientName(e.target.value);
  };

  const handlePatientAge = (e) => {
    setPatientAge(e.target.value);
  };

  const handleDescriptionChange = (value) => {
    setDescription(value);
  };

  useEffect(() => {
    setSelectedData(prev => prev.map(medicineData => ({
      ...medicineData,
      description: description
    })));
  }, [description]);

  const patients = [
    { id: 1, name: "John Doe", age: 28 },
    { id: 2, name: "Jane Smith", age: 35 },
    { id: 3, name: "Michael Johnson", age: 42 },
    { id: 4, name: "Michael Johnson", age: 42 },
    { id: 5, name: "Michael Johnson", age: 42 },
    { id: 6, name: "Michael Johnson", age: 42 },
    { id: 7, name: "Michael Johnson", age: 42 },
  ];
  const openModal = (id) => {
    setUserID(id);
    setShowModal(true);
  };
  return (
    <div className="flex flex-col items-center justify-center h-screen">
      <div className="w-full max-w-3xl">
        {patients.map((patient) => (
          <div key={patient.id} className="bg-white p-4 mb-3 rounded-lg shadow-md flex justify-between items-center">
            <div>
              <p className="text-lg font-semibold">{patient.name}</p>
              <p className="text-gray-600">Age: {patient.age}</p>
            </div>
            <button
              onClick={() => openModal(patient.id)}
              className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition"
            >
              Open Prescription
            </button>
          </div>
        ))}
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50">
        <div className="bg-white w-[1000px] max-h-[90vh] p-6 rounded-lg shadow-lg relative flex flex-col">
          
          {/* Close Button */}
          <button
            onClick={() => setShowModal(false)}
            className="absolute top-2 right-2 text-gray-600 hover:text-gray-800"
          >
            ✖
          </button>
      
          {/* Scrollable Content */}
          <div className="flex flex-col gap-3 max-h-[75vh] overflow-y-auto p-2">
            <p className="text-lg font-bold">Prescription Form</p>
            <p>{userId}</p>
            {/* Name Input */}
            <label className="font-semibold">Name:</label>
            <input
              type="text"
              className="bg-gray-200 rounded-lg p-2 w-full"
              value={patientName}
              onChange={handlePatientName}
            />
      
            {/* Age Input */}
            <label className="font-semibold">Age:</label>
            <input
              type="text"
              className="bg-gray-200 rounded-lg p-2 w-full"
              value={patientAge}
              onChange={handlePatientAge}
            />
      
            {/* Description (Fixed Height) */}
            <label className="font-semibold">Description:</label>
            <textarea
              placeholder="Write Description"
              className="bg-gray-200 rounded-lg p-2 w-full h-[100px] "
              onChange={(e) => handleDescriptionChange(e.target.value)}
            />
      
            {/* Medicine Components */}
            {Array.from({ length: addMed }).map((_, index) => (
              <Dosage
                key={index}
                updateSelectedMedicine={updateSelectedMedicine}
                index={index}
              />
            ))}
      
            {/* Add & Remove Medicine Buttons */}
            <div className="flex gap-2">
              <button
                type="button"
                onClick={handleAddMed}
                className="bg-green-500 text-white py-2 px-4 rounded-lg hover:bg-green-600"
              >
                Add Medicine
              </button>
              {addMed > 0 && (
                <button
                  type="button"
                  onClick={handleDelete}
                  className="bg-red-500 text-white py-2 px-4 rounded-lg hover:bg-red-600"
                >
                  Remove Medicine
                </button>
              )}
            </div>
      
            {/* Appointment Date */}
            <h1 className="font-semibold">Schedule Next Appointment:</h1>
            <DatePicker
              selected={selectedDate}
              onChange={(date) => setSelectedDate(date)}
              dateFormat="dd/MM/yyyy"
              placeholderText="Select date"
              className="bg-gray-200 p-2 rounded-lg w-full"
            />
      
            {/* PDF Generation Button */}
            <button
              className="bg-sky-500 text-white py-2 px-4 rounded-lg hover:bg-sky-600"
              onClick={genPdf}
              type="button"
            >
              Generate PDF
            </button>
          </div>
        </div>
      </div>
      
      )}
    </div>
  );
};

export default PrescriptionModal;
