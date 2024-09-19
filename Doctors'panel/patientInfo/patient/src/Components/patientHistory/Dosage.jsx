import React, { useEffect, useState } from 'react';  // Import useState
import 'react-datepicker/dist/react-datepicker.css'; // Import DatePicker CSS
import axios from 'axios'

export default function Medicine({updateSelectedMedicine}) {
    const [categoryDetails, setCategoryDetails] = useState([])
    const [medicineOptions, setMedicineOptions] = useState([])
    const [selectedMedicine,setSelectedMedicine]= useState([])

    //function to fetch catagories
    useEffect(() => {
        const handleCatagoryData = async () => {
            try {
                const response = await axios.get('http://localhost:5000/fetch-catagory')
                setCategoryDetails(response.data.data)
            } catch (err) {
                console.error('Feror fetching api', err)
                alert('Error selecting catagory')
            }
        }
        handleCatagoryData();
    }, [])


    //function to handle catagory change
    const handleMedicineDetails = async (e) => {
        const catagoryId = e.target.value

        if (catagoryId) {
            try {
                const response = await axios.get('http://localhost:5000/fetch-medicine', {
                    params: { category_id: catagoryId }
                })
                setMedicineOptions(response.data.data)
            } catch (err) {
                console.error('Error in medicine api', err)
            }
        } else {
            alert('category not selected')
        }
    }

    //function to pass new selected medicine as a callback
    const handleMedicineChange=(e)=>{
        const val = e.target.value
        const updatedMedicine = val? [val]:[]
        setSelectedMedicine(updatedMedicine)
        updateSelectedMedicine(updatedMedicine)
    }

    /* useEffect(() => {
        console.log(selectedMedicine)
    }, [selectedMedicine])  */

    return (<>
        <div className='space-y-2'>
            <div>
                <label htmlFor="category" className='block text-sm font-medium text-gray-700'>Category</label>
                <select id="category" className='bg-slate-200 rounded-lg p-2 w-full' value={categoryDetails.data} onChange={handleMedicineDetails} >
                    <option value="">Select Category</option>
                    {categoryDetails.map(data => (
                        <option key={data.id} value={data.id}>{data.name}</option>
                    ))}
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
                <select id="medicine" className='bg-slate-200 rounded-lg p-2 w-full' onChange={handleMedicineChange}>
                    <option value="">Select Medicine</option>
                    {medicineOptions.map(data => (
                        <option key={data.id} value={data.name}> {data.name} </option>
                    ))}
                </select>
            </div>
        </div>
    </>)
}