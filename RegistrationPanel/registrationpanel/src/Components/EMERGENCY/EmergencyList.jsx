import React, { useEffect, useState } from 'react';
import axios from "axios";
import "./Emergency.css";

const EmergencyList = () => {
    const [emergencyData, setEmergencyData] = useState([]);

    useEffect(() => {
        // Fetch data from the backend
        const fetchData = async () => {
            try {
                const response = await axios.get('http://localhost:3000/api/emergency-list');
                setEmergencyData(response.data);
            } catch (error) {
                console.error("Error fetching data:", error);
            }
        };

        fetchData();
    }, []);

    function generateRandomId(min = 1000, max = 9999) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    return (
        <div className="list">
            <h2 className='head'>Emergency Bookings</h2>
            <table className="table table-striped">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Token</th>
                        <th scope="col">Mobile</th>
                        <th scope="col">Est. Arrival</th>
                        <th scope="col">Status</th>
                    </tr>
                </thead>
                <tbody>
                    {emergencyData.map((item, index) => (
                        <tr key={index}>
                            <th scope="row">{index + 1}</th>
                            <td>{generateRandomId()}</td>
                            <td>{item.phone_number}</td>
                            <td>~30m</td>
                            <td><button className="btn btn-primary">Arrived</button></td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default EmergencyList;
