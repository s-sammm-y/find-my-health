import React from "react";

function EditBedPopup(){
    return(
        <>
        <div className="modal-overlay fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
            <div className="modal-content bg-white p-6 rounded-md w-96">
            <h2 className="text-xl font-semibold mb-4">Bed Edit</h2>

            <div>
            <label htmlFor="pateint-id">Patient ID:</label>
            <input className="border border-black m-2 rounded-lg babu" type="text" name="patientId" id="" />
            </div>
            
            <div>
            <label htmlFor="dept-ID">Dept ID:</label>
            <input className="border border-black m-2 rounded-lg babu" type="text" name="departmentId" id="" />
            </div>
            
            <div>
            <label htmlFor="ward-id">Ward ID:</label>
            <input className="border border-black m-2 rounded-lg babu" type="text" name="wardId" id="" />
            </div>

            <div>
            <label htmlFor="empty">Is Bed Empty:</label>
                <input 
                className="border border-black m-2 rounded-lg" 
                type="checkbox" 
                name="empty" 
                id="empty" 
                value="true" 
                />
            </div>

            </div>
        </div>
        </>
    )
}

export default EditBedPopup;