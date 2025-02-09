import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faEye } from '@fortawesome/free-solid-svg-icons';
import { faUserPen } from "@fortawesome/free-solid-svg-icons";

function EachWardBed({beds,handleSeeDetails}) {
    return (
      <>
      <div className="inside-ward">
        <h3>Ward: {beds[0].ward_id.toUpperCase()}</h3>
        <div className="beds">
          {beds.map((bed, idx) => (
            <div className={`each-ward bed ${bed.empty ? 'bg-green-500':bg-red-500}`} key={bed.bed_id}>
              <p>Bed-Id: {bed.bed_id}</p>
              <button className="btn">
              <FontAwesomeIcon icon={faUserPen} 
              className="text-2xl text-black-600 hover:text-black transition-colors duration-300"
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
