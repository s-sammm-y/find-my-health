import { useEffect, useState } from "react"
import axios from "axios"
import Popup from "./components/Add-Bed-Popup"
function App() {
 const [bedData,setBedData]=useState([])
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
 useEffect(()=>{
  console.log(beds)
 },[beds])

 //add bed section
const handlePopup=()=>{
  setShowPopup(!showPopup)
}
  return (
  <>
  {/* rendering beds */}
  <div className="bed-container flex bg-blue-400 gap-4">
    {beds.map((bed)=>(
      <div className="bed p-1 bg-red-400" key={bed.bed_id}>
        <p>BED ID:{bed.bed_id}</p>
        <button className="rounded-md bg-green-200" type="button">See details</button>
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