import React, { useEffect, useState } from 'react';
import axios from "axios";
import {supabase} from '../../supabaseClient';
import "./Emergency.css";

const EmergencyList = () => {
    const [emergencyData, setEmergencyData] = useState([]);
    const [loading, setLoading] = useState(false);

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
    }, []);

    
    const handleArrived = async (emergency_id) => {
        setLoading(true);
        try {
            const response = await axios.post('http://localhost:3001/api/add-triage', {
                emergency_id
            });
            if (response.status === 200) {
                setLoading(false)
            }
        } catch (error) {
            console.error("Error adding triage:", error);
        }
        const response = await axios.get('http://localhost:3001/api/emergency-list');
        setEmergencyData(response.data);  // Refresh the list
    };
    const handleReject = async (emergency_id) => {
        
    }
    return (
        <div className = "parent">
            {loading && (
                <div className="loading-popup">
                    <div className="loading-content">
                        <div className="spinner"></div>
                        <p>Adding triage, please wait...</p>
                    </div>
                </div>
            )}
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
                                <th scope="col">Booking Time</th>
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
                                    <td>{item.created_at}</td>
                                    <td><button
                                            className="btn btn-primary"
                                            onClick={() => handleArrived(item.emergency_id)}  // Pass emergency_id when button is clicked
                                        >
                                            Arrived
                                        </button></td>
                                    <td className="verify">
                                        <button
                                            className="btn btn-primary"
                                            onClick={() => handleArrived(item.emergency_id)}  // Pass emergency_id when button is clicked
                                        >
                                            Reject
                                        </button>
                                        </td>
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
