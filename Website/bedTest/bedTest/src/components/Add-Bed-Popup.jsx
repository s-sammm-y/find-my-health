import { useState } from "react"

export default function Popup(){
    const [bedId,setBedId]=useState('')
    const handleInputChange=(event)=>{
        setBedId(event.target.value)
        console.log(bedId)
    }
    return(<>
    <div className="popup-box">
        <form>
            <div className="pop-up-from">
                <label htmlFor="bedId ">Bed-Id</label>
                <input id='bed-id' type='text' value={bedId} onChange={handleInputChange}/>
            </div>
        </form>
    </div>
    </>)
}