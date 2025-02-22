import React, { useEffect, useState } from 'react';
import axios from "axios";
import {supabase} from '../../supabaseClient';
import "./Emergency.css";

const EmergencyList = () => {
    const [emergencyData, setEmergencyData] = useState([]);

    const fetchData = async () => {
        try {
            const response = await axios.get('http://localhost:3001/api/emergency-list');
            setEmergencyData(response.data);
        } catch (error) {
            console.error("Error fetching data:", error);
        }
    };

    useEffect(() => {
        fetchData();
        const subscription = supabase
            .channel('emergency-list-channel')  // Unique channel name
            .on(
                'postgres_changes', 
                { event: 'INSERT', schema: 'public', table: 'emergency' }, 
                () => {
                    console.log("Emergency list updated! Fetching new data...");
                    fetchData();  // Refresh the data when any change happens
                }
            )
            .subscribe();

        // Cleanup subscription on unmount
        return () => {
            supabase.removeChannel(subscription);
        };
    }, [emergencyData]);

    
    const handleArrived = async (emergency_id) => {
        try {
            const response = await axios.post('http://localhost:3001/api/add-triage', {
                emergency_id
            });
            if (response.status === 200) {
                alert('Triage added successfully');
            }
        } catch (error) {
            console.error("Error adding triage:", error);
        }
        const response = await axios.get('http://localhost:3001/api/emergency-list');
        setEmergencyData(response.data);  // Refresh the list
    };
    return (
        <div className = "parent">
            <div className = "list-parent">
                <h1 className="bookinghead">ALL BOOKINGS</h1>
                <div className="list">
                    <table className="table table-striped">
                        <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">name</th>
                                <th scope="col">Problem</th>
                                <th scope="col">Est. Arrival</th>
                                <th scope="col">Status</th>
                                <th scope="col">Verify</th>
                            </tr>
                        </thead>
                        <tbody>
                            {emergencyData.map((item, index) => (
                                <tr key={index}>
                                    <th scope="row">{index + 1}</th>
                                    <td>{item.name}</td>
                                    <td>{item.problem}</td>
                                    <td>~30m</td>
                                    <td><button
                                            className="btn btn-primary"
                                            onClick={() => handleArrived(item.emergency_id)}  // Pass emergency_id when button is clicked
                                        >
                                            Arrived
                                        </button></td>
                                    <td className="verify">verified</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
};

export default EmergencyList;
