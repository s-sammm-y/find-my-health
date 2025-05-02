import React, { useEffect, useState } from 'react';
import axios from 'axios';

const Ambulance = () => {
  const [ambulanceList, setAmbulanceList] = useState([]);
  const [emergencyData, setEmergencyData] = useState([]);
  const [selected, setSelected] = useState(null);
  const [showAssignModal, setShowAssignModal] = useState(false);
  const [currentEmergencyId, setCurrentEmergencyId] = useState(null);
  const [availableAmbulances, setAvailableAmbulances] = useState([]);

  useEffect(() => {
    const fetchAmbulances = async () => {
      try {
        const ambulances = await axios.get('http://localhost:3001/api/ambulance');
        setAmbulanceList(ambulances.data.data);
      } catch (error) {
        console.log("Error Getting Ambulance details", error);
      }
    };

    const fetchEmergencyList = async () => {
      try {
        const response = await axios.get('http://localhost:3001/api/emergency-ambulance');
        setEmergencyData(response.data);
      } catch (error) {
        console.error("Error fetching emergency data:", error);
      }
    };

    fetchAmbulances();
    fetchEmergencyList();
  }, []);

  const handleAssignAmbulance = (userId) => {
    const available = ambulanceList.filter(a => !a.ambulance_occupied);
    setAvailableAmbulances(available);
    setCurrentEmergencyId(userId);
    setShowAssignModal(true);
  };

  const handleConfirmAssign = async (ambulanceId) => {
    try {
      await axios.post('http://localhost:3001/api/assign-ambulance', {
        user_id: currentEmergencyId,
        ambulance_id: ambulanceId
      });
    
      const [ambulances, emergencies] = await Promise.all([
        axios.get('http://localhost:3001/api/ambulance'),
        axios.get('http://localhost:3001/api/emergency-ambulance')
      ]);
      setAmbulanceList(ambulances.data.data);
      setEmergencyData(emergencies.data);

      setShowAssignModal(false);
    } catch (error) {
      console.error("Error assigning ambulance:", error);
    }
  };

  const handleArrived = async (user_id) => {
    try {
      await axios.post('http://localhost:3001/api/ambulance-arrived', {
        user_id: user_id
      });

      const [ambulances, emergencies] = await Promise.all([
        axios.get('http://localhost:3001/api/ambulance'),
        axios.get('http://localhost:3001/api/emergency-ambulance')
      ]);
      setAmbulanceList(ambulances.data.data);
      setEmergencyData(emergencies.data);
    } catch (error) {
      console.error("Error marking arrived:", error);
    }
  };

  return (
    <div className="min-h-screen w-full flex flex-col items-center justify-center p-6 space-y-10 bg-gray-50">
      <div className="flex flex-wrap justify-center items-center gap-12">
      {Array.isArray(ambulanceList) &&
        ambulanceList.map((item, idx) => {
            const isSelected = selected === idx;
            const isOccupied = item.ambulance_occupied;
            const diamondClass = isOccupied ? 'bg-red-500' : 'bg-blue-500';

            return (
            <div
                key={item.ambulance_id || idx}
                className={`${diamondClass} ${isSelected ? 'w-60 h-60' : 'w-16 h-16'} transform rotate-45 flex items-center rounded-md justify-center cursor-pointer hover:${isOccupied ? 'bg-red-600' : 'bg-blue-600'} transition-all duration-300`}
            >
                <div className="transform -rotate-45 text-white text-center">
                {isSelected ? (
                    <div>
                    <p className="font-bold mb-1">Ambulance: {item.ambulance_license_number}</p>
                    <p className="text-sm">Driver: {item.driver_name}</p>
                    <p className="text-sm">Driver License: {item.driver_license_number}</p>
                    <p className="text-sm">Driver Phone: {item.driver_phone}</p>
                    <p className="text-sm">Status: {isOccupied ? 'Occupied' : 'Available'}</p>
                    <button onClick={() => setSelected(null)} className="mt-2 px-3 py-1 bg-white text-blue-500 rounded hover:bg-gray-100 text-sm">Close</button>
                    </div>
                ) : (
                    <button onClick={() => setSelected(idx)} className="text-xs font-semibold">
                    {item.ambulance_license_number}
                    </button>
                )}
                </div>
            </div>
        )})}

      </div>

      <div className="w-full max-w-4xl overflow-x-auto">
        <table className="min-w-full table-auto border border-gray-300 shadow-md bg-white rounded">
          <thead className="bg-gray-100">
            <tr>
              <th className="border px-4 py-2">#</th>
              <th className="border px-4 py-2">Name</th>
              <th className="border px-4 py-2">Problem</th>
              <th className="border px-4 py-2">Booking Time</th>
              <th className='border px-4 py-2'>Assign Ambulance</th>
              <th className='border px-4 py-2'>Arrived</th>
            </tr>
          </thead>
          <tbody>
          {emergencyData.map((item, index) => {
            const assignedAmbulance = ambulanceList.find(a => a.user_id === item.user_id);
            const isAssigned = Boolean(assignedAmbulance);

            return (
                <tr key={item.emergency_id}>
                    <td className="border px-4 py-2">{index + 1}</td>
                    <td className="border px-4 py-2">{item.name}</td>
                    <td className="border px-4 py-2">{item.problem}</td>
                    <td className="border px-4 py-2">{new Date(item.created_at).toLocaleString()}</td>

                    <td className="assign-ambulance px-4 py-2 border">
                        <div className="flex flex-col items-start space-y-1">
                            <button
                                className={`px-4 py-1 rounded shadow-md transition duration-200 ${
                                    isAssigned
                                        ? 'bg-green-500 text-white cursor-not-allowed'
                                        : 'bg-blue-500 hover:bg-blue-600 text-white'
                                }`}
                                onClick={() => !isAssigned && handleAssignAmbulance(item.user_id)}
                                disabled={isAssigned}
                            >
                                {isAssigned ? "Assigned" : "Assign"}
                            </button>

                            {isAssigned && (
                                <span className="text-sm text-gray-700">
                                    🚑 {assignedAmbulance.ambulance_license_number}
                                </span>
                            )}
                        </div>
                    </td>

                    <td className="arrived px-4 py-2 border">
                        <button
                            className={`bg-blue-500 hover:bg-blue-600 text-white px-4 py-1 rounded shadow-md transition duration-200 ${
                                !isAssigned ? 'bg-red-500 cursor-not-allowed' : ''
                            }`}
                            onClick={() => handleArrived(item.user_id)}
                            disabled={!isAssigned}  // Disable if not assigned
                        >
                            Arrived
                        </button>
                    </td>
                </tr>
            );
        })}
          </tbody>
        </table>
      </div>

            {showAssignModal && (
            <div className="modal-overlay fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
                <div className="modal-content relative bg-white p-6 rounded-md w-96 h-96 overflow-hidden flex flex-col">
                <h2 className="text-xl font-semibold mb-4">Available Ambulances</h2>
                
                <div className="overflow-y-auto space-y-3 flex-1">
                    {availableAmbulances.length === 0 ? (
                    <p>No ambulances available.</p>
                    ) : (
                    availableAmbulances.map((amb, index) => (
                        <div key={index} className="border p-2 rounded shadow">
                        <p><strong>License:</strong> {amb.ambulance_license_number}</p>
                        <p><strong>Driver:</strong> {amb.driver_name}</p>
                        <p><strong>Driver License:</strong> {amb.driver_license_number}</p>
                        <button
                            className="mt-2 bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600"
                            onClick={() => handleConfirmAssign(amb.ambulance_id)}
                        >
                            Assign This Ambulance
                        </button>
                        </div>
                    ))
                    )}
                </div>

                <div className="mt-4">
                    <button
                    className="w-full bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
                    onClick={() => setShowAssignModal(false)}
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

export default Ambulance;
