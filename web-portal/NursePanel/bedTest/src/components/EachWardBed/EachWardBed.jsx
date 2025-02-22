import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faEye } from '@fortawesome/free-solid-svg-icons';
import { faUserPen } from "@fortawesome/free-solid-svg-icons";
function EachWardBed({beds,handleSeeDetails,handleEditPopup}) {
    return (
      <>
      <div className="inside-ward exo-2-ward">
        <h3 className="bg-blue-400 text-center p-4 text-black rounded-md border border-black shadow-lg">WARD:- {beds[0].ward_id.toUpperCase()}</h3>
        <div className="beds">
          {beds.map((bed, idx) => (
            <div className={`each-ward bed ${bed.empty ? 'bg-green-500':'bg-red-500'}`} key={bed.bed_id}>
              <p className="p-2 text-center">Bed-Id: {bed.bed_id}</p>
              <button className="btn">
              <FontAwesomeIcon icon={faUserPen} 
              className="text-2xl text-black-600 hover:text-black transition-colors duration-300"
              onClick={()=>handleEditPopup(bed.bed_id)}
              />
              </button>
              <button className="btn"
                  type="button"
                      onClick={() => handleSeeDetails(bed.bed_id)}
              > 
                  <FontAwesomeIcon
                    icon={faEye}
                    className="text-2xl text-black-600 hover:text-black transition-colors duration-300"
                  />
                </button>
            </div>
          ))}
        </div>
      </div>
      </>
    );
  }

export default EachWardBed;
