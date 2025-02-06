import { useEffect, useState } from "react";
import axios from "axios";

export default function App(){
  const [patientId,setPatientId]=useState('')
  const [seePatientDetails,setSeePatientDetails]=useState([])
  const [patientDetails,setPatientDetails]=useState('')

{/*   useEffect(()=>{
    console.log(patientId)
  },[patientId]) */}

  //function to fetch pateint details
  const handleSelectPatientDetails=async(data)=>{
    try{
      const response = await axios.get('http://localhost:2000/bed-patient',{
        params: { user_id: data }
      })
      setSeePatientDetails(response.data)
      //alert('data fetched succesfully')
    }catch(err){
      console.error(err)
      alert('wrong patient id Pls write the exact id')
    }
  }

  {/* useEffect(() => {
    if (seePatientDetails && seePatientDetails.data) {
      console.log(seePatientDetails.data[0].bed_id);
    }
  }, [seePatientDetails]); */}


  //function to post description
  const handleAddDescription=async(data)=>{
    //check if pateint details is empty
    if (!seePatientDetails || !seePatientDetails.data || seePatientDetails.data.length === 0) {
      alert('Patient not selected');
      window.location.reload()
      return;
    }

    if(!data)
    {
      alert('description not added')
      window.location.reload()
      return
    }

    try{
      const response=await axios.post('http://localhost:2000/add-description',{
        description:data,
        bed_id:seePatientDetails.data[0].bed_id
      })
      alert('Patient description added succesfylly')
      window.location.reload()
    }catch(err){
      alert('Server error')
      console.error(err)
    }
  }

  return(<>
    <div className="Search">
      <span>Search User:-</span>

      <input className='border border-blue-400 rounded-md mt-2' 
      type="text" 
      name="input-patient" 
      id="patient-search" 
      value={patientId} 
      onChange={(e)=>{
        setPatientId(e.target.value)
      }} />

      {/*Display and select patient details*/}
      <div className="display-details">
        <button className='bg-green-500 border border-blue-300 rounded-md' type="button" onClick={()=>{handleSelectPatientDetails(patientId)}} >Select Patient</button>
        <div className="fetched-details">
        {seePatientDetails && seePatientDetails.data &&
          seePatientDetails.data.map((data,index) => (
            <div key={`${data.name}-${index}`} className="flex flex-row space-x-4 p-4 border border-gray-300 rounded-md">
            <div>Name: {data.name}</div>
            <div>Country: {data.country}</div>
          </div>
          ))}
        </div>


        {/* add description section */}
        <div className="dscription-medicine">
          Write Pateint Description:

          <textarea className="bg-blue-300 border border-blue-700 rounded-md mt-4 ml-4 h-32 p-2" value={patientDetails} onChange={(e)=>{setPatientDetails(e.target.value)}} />

            {/*Save description Button*/}
            <button className="save-description bg-blue-500 rounded-md ml-2 text-white w-10" type="button" onClick={()=>{handleAddDescription(patientDetails)}} >Save</button>

        </div>
      </div>
    </div>
  </>)
}