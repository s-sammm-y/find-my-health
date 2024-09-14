import { useEffect, useState } from "react"
import axios from "axios"
import Popup from "./components/Add-Bed-Popup"
function App() {
 const [bedData,setBedData]=useState([])
 const [bedDetail,setBedDetail]=useState([])
 const [beds,setBeds]=useState([])
 const [showPopup,setShowPopup]=useState(false)

 //this hook is for rendering the beds present in the database
 useEffect(()=>{
  const getBedData = async()=>{
    try{
      const response = await axios.get('http://localhost:3000/data')
      setBeds(response.data)
    }catch(error){
      console.error("error fetching data")
    }
  }
  getBedData();
 },[])

 //use another hook to display the array
 /* useEffect(()=>{
  console.log(beds)
 },[beds]) */


//this function is to see details of beds
const handleSeeDetails = async(bedId)=>{
  try{
    const response = await axios.get(`http://localhost:3000/bed-details`, {
      params: { bedId }  // Pass bedId as query parameter
    });
    setBedDetail((prevDetails)=>({
      ...prevDetails,
      [bedId]:response.data
    }))
  }catch(err){
    console.log('error occured in api')
  }
}

//function to hide patient details
const handleHideDetails=(bedId)=>{
  setBedDetail((prevBedDetail)=>{
    const newDetail={...prevBedDetail}
    delete newDetail[bedId]
    return newDetail
  })
}

useEffect(()=>{
  console.log(bedDetail)
},[bedDetail])

 //add bed section
const handlePopup=()=>{
  setShowPopup(!showPopup)
}
  return (
  <>
  {/* rendering beds */}
  <div className="bed-container flex bg-blue-400 gap-4 h-32">
    {beds.map((bed)=>(
      <div className="bed p-1 bg-red-400" key={`${bed.bed_id}`}>
        <p>BED ID:{bed.bed_id}</p>
        <button className="rounded-md bg-green-200" type="button" onClick={()=>handleSeeDetails(bed.bed_id)}>See details</button>

        {/* rendering clicked beds */}
        {bedDetail[bed.bed_id] && bedDetail[bed.bed_id].map((data, index) => (
        <div className="details flex flex-col" key={`${data.dep_id}-${index}`}>
          dep_id: {data.dep_id}, ward_id: {data.ward_id}

          <button className="rounded-md bg-blue-300" 
          type='button' 
          onClick={()=>{handleHideDetails(bed.bed_id)}}>
            hide details
            </button>
            
        </div>
      ))}

      </div>
    ))}
  </div>
  <div className="bed-add">
    <button type="button" onClick={handlePopup}>Add beds</button>
    {showPopup && <Popup/>}
  </div>
  </>
  )
}

export default App