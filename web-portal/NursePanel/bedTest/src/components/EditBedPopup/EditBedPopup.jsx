import React, { useState } from "react";
import axios from "axios";

function EditBedPopup({ editVar, bedID }) {
    const [BedId, setBedId] = useState(bedID);
    const [editPateint, setEditPatient] = useState("");
    const [editDept, setEditDept] = useState("");
    const [editWard, setEditWard] = useState("");
    const [editEmpty, setEditEmpty] = useState(false);
    const [showSaveText, setShowSaveText] = useState(false);
    const [showRemoveText, setShowRemoveText] = useState(false);
    const [error, setError] = useState("");

    const handleOnChangePatient = (data) => {
        setEditPatient(data.target.value);
    };

    const handleOnChangeDept = (data) => {
        setEditDept(data.target.value);
    };

    const handleOnChangeWard = (data) => {
        setEditWard(data.target.value);
    };

    const handleSave = async () => {
        if (!editWard.trim()) {
            setError("Ward Name is required!");
            return;
        }
        setError("");

        try {
            await axios.put("http://localhost:3000/edit-bed", {
                bed_id: BedId,
                dept_id: editDept,
                ward_id: editWard,
                patient_id: editPateint,
                empty: editEmpty,
            });
            setShowSaveText(true);
        } catch (err) {
            console.error("Error in frontend", err.message);
            alert("Server Error");
        }
    };

    const handleRemoveAll = async (event) => {
        event.preventDefault();
        if (!editWard.trim()) {
            setError("Ward Name is required to remove details!");
            return;
        }
        setError("");

        try {
            await axios.put("http://localhost:3000/remove-bed-details", {
                bed_id: BedId,
                dept_id: null,
                patient_id: null,
                empty: true,
            });
            setShowRemoveText(true);
        } catch (err) {
            console.error("Error in remove all", err);
            alert("Server Error");
        }
    };

    const handleOnCloseEditPopup = () => {
        if (!editWard.trim()) {
            setError("Ward Name is required to close!");
            return;
        }
        setError("");

        editVar(false);
        window.location.reload();
    };

    return (
        <>
            <div className="modal-overlay fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
                <div className="modal-content bg-white p-6 rounded-md w-96">
                    <h2 className="text-xl font-semibold mb-4">Bed-Edit</h2>
                    <h3 className="text-md font-semibold mb-4">Bed-ID: {BedId}</h3>

                    {error && <p className="text-red-500">{error}</p>}

                    <div>
                        <label htmlFor="pateint-id">Patient-ID:</label>
                        <input className="border border-black m-2 rounded-lg" type="text" value={editPateint} onChange={handleOnChangePatient} />
                    </div>

                    <div>
                        <label htmlFor="dept-ID">Dept-Name:</label>
                        <input className="border border-black m-2 rounded-lg" type="text" value={editDept} onChange={handleOnChangeDept} />
                    </div>

                    <div>
                        <label htmlFor="ward-id">Ward-Name:</label>
                        <input className="border border-black m-2 rounded-lg" type="text" value={editWard} onChange={handleOnChangeWard} />
                    </div>

                    <div>
                        <label htmlFor="empty">Bed-Available:</label>
                        <input
                            className="border border-black m-2 rounded-lg"
                            type="checkbox"
                            checked={editEmpty}
                            onChange={(e) => setEditEmpty(e.target.checked)}
                            disabled={editPateint.trim() !== "" || editDept.trim() !== ""}
                        />
                    </div>

                    <div>
                        <button className="btn bg-red-500 text-white px-4 py-2 rounded-md mt-4" onClick={handleOnCloseEditPopup}>
                            Close
                        </button>
                    </div>

                    <div>
                        <button className="btn bg-red-500 text-white px-4 py-2 rounded-md mt-4" onClick={handleSave}>
                            Save
                        </button>
                        <button className="btn bg-red-500 text-white px-4 py-2 rounded-md m-4" onClick={handleRemoveAll}>
                            Remove-All
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}

export default EditBedPopup;
