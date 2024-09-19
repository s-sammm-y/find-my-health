import { useState,useEffect } from "react"
import axios from "axios"
export default function Popup({onChange}) {

    const [roomNo, setRoomNumber] = useState('')
    const [bedId, setBedId] = useState('')
    //static fields
    const [depID,setDepId]=useState('xxy')
    const [patientId,setPatientId] =useState('')
    const [wardId,setWardId] = useState('ggg')


    const handleInputChange = (event) => {
        setBedId(event.target.value)
        //console.log(bedId)
    }


    const handleRoomNumber = (data) => {
        setRoomNumber(data.target.value)
        //console.log(roomNo)
    }


    const handleOnCancle=()=>{
        setRoomNumber('');
        setBedId('');
        onChange();
    }


    //function to addbed
    const confirmAddBed=async()=>{
        try{
            const response = await axios.post('http://localhost:3000/add-bed',{
                bed_id:bedId,
                dept_id:depID,
                ward_id:wardId,
                patient_id:patientId,
                room:roomNo
            })
            //console.log(response.data)
            setBedId('')
            setRoomNumber('')
            window.location.reload(); 
        }catch(err){
            console.error('Error:', err.response ? err.response.data : err.message);
            alert('Server error');
        }
    }


    /* useEffect(() => {
        console.log("Room Number:", roomNo)
        console.log("Bed ID:", bedId)
    }, [roomNo, bedId]) */


    return (<>
        <div className="popup-box">
            <form>
                <div className="pop-up-from">


                    {/* input box for bedId adding */}
                    <div className="bed-add-id">
                        <label htmlFor="bedId">Bed-Id</label>
                        <input className='border border-black rounded-md ml-2' id='bed-id' type='text' value={bedId} onChange={handleInputChange} />
                    </div>


                    {/* input for number of rooms */}
                    <div className="room-add-num">
                        <label htmlFor="room-number ">Room</label>
                        <input className='border border-green-600 m-2 rounded-md' type="number" value={roomNo} onChange={handleRoomNumber} />
                    </div>


                    {/* cancle or add button trigger */}
                    <div className="add-cancle">
                        <button className='confirm-and-add bg-blue-300 rounded-md' onClick={confirmAddBed}>Confirm</button>
                        <button className='hide-popup bg-green-400 ml-2 rounded-md' onClick={handleOnCancle}>Cancle</button>
                    </div>
                </div>
            </form>
        </div>
    </>)
}