import React, { useEffect, useState } from 'react';
import axios from 'axios';

export default function Medicine({ updateSelectedMedicine, index ,deleteMedicine}) {
    const [categoryDetails, setCategoryDetails] = useState([]);
    const [medicineOptions, setMedicineOptions] = useState([]);
    const [changedData, setChangedData] = useState({ description:'',medicine: '', dosage: '', frequency: ''});
    const [currentIndex,setCurrentIndex]=useState(index);

    // Fetch categories
    useEffect(() => {
        const fetchCategories = async () => {
            try {
                const response = await axios.get('http://localhost:5000/fetch-catagory');
                setCategoryDetails(response.data.data);
            } catch (err) {
                console.error('Error fetching categories', err);
                alert('Error selecting category');
            }
        };
        fetchCategories();
    }, []);

    // Fetch medicines based on category selection
    const handleMedicineDetails = async (e) => {
        const categoryId = e.target.value;

        if (categoryId) {
            try {
                const response = await axios.get('http://localhost:5000/fetch-medicine', {
                    params: { category_id: categoryId }
                });
                setMedicineOptions(response.data.data);
            } catch (err) {
                console.error('Error fetching medicines', err);
            }
        } else {
            setMedicineOptions([]);
        }
    };
    

    // Handle data changes and update state
    const handleDataChange = (key, value) => {
        const updatedData = { ...changedData, [key]: value };
        setChangedData(updatedData);
        //console.log(`At handleDataChange ${index}:`, updatedData);
        updateSelectedMedicine(index, updatedData);
    };

    return (
        <div className='space-y-2'>
            <div>
                <label htmlFor="category" className='block text-sm font-medium text-gray-700'>Category</label>
                <select id="category" className='bg-slate-200 rounded-lg p-2 w-full' onChange={handleMedicineDetails}>
                    <option value="">Select Category</option>
                    {categoryDetails.map(data => (
                        <option key={data.id} value={data.id}>{data.name}</option>
                    ))}
                </select>
            </div>

            <div>
                <label htmlFor="dosage" className='block text-sm font-medium text-gray-700'>Dosage</label>
                <input
                    id='dosage'
                    type="text"
                    className='bg-slate-200 rounded-lg p-2 w-full'
                    onChange={(e) => handleDataChange('dosage', e.target.value)}
                />
            </div>

            <div>
                <label htmlFor="frequency" className='block text-sm font-medium text-gray-700'>Frequency</label>
                <input
                    type="text"
                    className='bg-slate-200 rounded-lg p-2 w-full'
                    id='frequency'
                    onChange={(e) => handleDataChange('frequency', e.target.value)}
                />
            </div>

            <div>
                <label htmlFor="medicine" className='block text-sm font-medium text-gray-700'>Medicine</label>
                <select
                    id="medicine"
                    className='bg-slate-200 rounded-lg p-2 w-full'
                    onChange={(e) => handleDataChange('medicine', e.target.value)}
                >
                    <option value="">Select Medicine</option>
                    {medicineOptions.map(data => (
                        <option key={data.id} value={data.name}>{data.name}</option>
                    ))}
                </select>

                <div className='pt-4'>
                    <button type='button' 
                    className='bg-red-400 text-white py-2 px-4 rounded-lg hover:bg-sky-500 transition-colors duration-300 self-center'
                    onClick={()=>deleteMedicine(currentIndex)}
                    >
                        Remove
                    </button>
                </div>
            </div>
        </div>
    );
}
