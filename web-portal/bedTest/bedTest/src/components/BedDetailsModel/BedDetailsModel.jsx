import React from 'react';
function BedDetailsModal({ bedDetail, onClose ,onDelete}) {
  if (!bedDetail) return null;
  let styles = {marginBottom:"10px"}

  return (
    <div className="modal-overlay fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
      <div className="modal-content bg-white p-6 rounded-md w-96">
        <h2 className="text-xl font-semibold mb-4">Bed Details</h2>
        <div className="details">
          {bedDetail.map((data, index) => (
            <div key={index} className="flex flex-col mb-2">
              <p>Patient ID: {data.dept_id}</p>
              <p>Room No: {data.room}</p>
              <p>Ward: {data.ward_id}</p>
              <p>Department: {data.dept_id} </p>
            </div>
          ))}
        </div>
        {/* Delete button */}
        <div>
        <button style={styles}
          className="btn bg-red-500 text-white px-4 py-2 rounded-md mt-4"
          onClick={onDelete}
        >
          Delete Bed
        </button>
        </div>

        {/* Close button */}
        <div>
        <button className="bg-red-500 text-white px-4 py-2 rounded-md" onClick={onClose}>
          Close
        </button>
        </div>
      </div>
    </div>
  );
}

export default BedDetailsModal;
