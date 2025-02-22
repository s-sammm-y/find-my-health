import React, {useEffect,useState} from "react";
import './Medicineinventory.css'
function Medicineinventory(){
    return(
        <>
        <div className="flex justify-center items-center min-h-screen roboto-slab-font">
            <div className="flex flex-col items-center gap-4 text-white">
                <button className="bg-blue-400 w-[200px] h-10 rounded-lg shadow-md hover:bg-blue-500">
                    Prescription Medications
                </button>
                <button className="bg-blue-400 w-[200px] h-15 rounded-lg shadow-md hover:bg-blue-500">
                    Over-the-Counter Medications
                </button>
                <button className="bg-blue-400 w-[200px] h-10 rounded-lg shadow-md hover:bg-blue-500">
                    Injectable Medications
                </button>
            </div>
        </div>
        </>
    )
}

export default Medicineinventory;