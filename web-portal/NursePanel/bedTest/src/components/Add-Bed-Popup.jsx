import { useState,useEffect } from "react"
import axios from "axios"
export default function Popup({onChange}) {

    const [roomNo, setRoomNumber] = useState('')
    const [bedId, setBedId] = useState('')
    //static fields
    const [depID,setDepId]=useState('')
    const [patientId,setPatientId] =useState('')
    const [wardID,setWardID] = useState('')

    const handleInputChange = (event) => {
        setBedId(event.target.value)
        //console.log(bedId)
    }


    const handleRoomNumber = (data) => {
        setRoomNumber(data.target.value)
        //console.log(roomNo)
    }

    const handleWardName = (data)=>{
        setWardID(data.target.value)
        console.log(wardID)
    }

    const handleOnCancle=()=>{
        setRoomNumber('');
        setBedId('');
        setWardID('')
        onChange();
    }


    //function to addbed
    const confirmAddBed=async(event)=>{
        event.preventDefault();
        console.log('Bed data being sent:', {
            bed_id: bedId,
            dept_id: depID,
            ward_id: wardID,  // This will show what wardID is being sent
            patient_id: patientId,
            room: roomNo
        });
        try{
            const response = await axios.post('http://localhost:3000/add-bed',{
                bed_id:bedId,
                dept_id:depID,
                ward_id:wardID,
                patient_id:patientId,
                room:roomNo
            })
            console.log(response.data)
            setBedId('')
            setRoomNumber('')
            setWardID('')
            window.location.reload(); 
        }catch(err){
            console.error('Error:-', err.response ? err.response.data : err.message);
            alert('Server error');
        }
    }


    /* useEffect(() => {
        console.log("Room Number:", roomNo)
        console.log("Bed ID:", bedId)
    }, [roomNo, bedId]) */


    return (<>
        <div className="popup-box exo-2-ward">
            <form>
                <div className="pop-up-from">
                    {/* input box for bedId adding */}
                    <div className="bed-add-id">
                        <label htmlFor="bedId">Bed-Id</label>
                        <input className='border border-black rounded-md ml-2 babu' id='bed-id' type='text' value={bedId} onChange={handleInputChange} />
                    </div>


                    {/* input for number of rooms */}
                    <div className="room-add-num">
                        <label htmlFor="room-number ">Room:-</label>
                        <input className='border border-black m-2 rounded-md babu' type="number" value={roomNo} onChange={handleRoomNumber} />
                    </div>

                    {/*input for ward */}
                    <div className="ward-add-id">
                        <label htmlFor="ward-name">Ward:-</label>
                        <input className="border border-black m-2 rounded-md babu" id='ward-id' type='text' value={wardID} onChange={handleWardName}/>
                    </div>

                    {/* cancle or add button trigger */}
                    <div className="add-cancle">
                        <button className='confirm-and-add bg-blue-300 rounded-lg w-20 border border-black' onClick={confirmAddBed}>Confirm</button>
                        <button className='hide-popup bg-green-400 ml-2 rounded-lg w-20 border border-black' onClick={handleOnCancle}>Cancle</button>
                    </div>
                </div>
            </form>
        </div>
    </>)
}