import { useEffect, useState } from "react";
import axios from "axios";
import Popup from "./components/Add-Bed-Popup";
import Header from "./components/Header/Header";
import Sidebar from "./components/Sidebar/Sidebar";
import EachWardBed from "./components/EachWardBed/EachWardBed"
import BedDetailsModal from "./components/BedDetailsModel/BedDetailsModel"; 
import EditBedPopup from "./components/EditBedPopup/EditBedPopup";
import "./App.css";
import { Outlet, useLocation } from 'react-router-dom';

function App() {
  const [bedDetail, setBedDetail] = useState(null); // Change to hold the selected bed details
  const [beds, setBeds] = useState([]);
  const [selectedBedId, setSelectedBedId] = useState(null);
  const [showPopup, setShowPopup] = useState(false);
  const [loading, setLoading] = useState(false);
  const [showDetailsModal, setShowDetailsModal] = useState(false); // New state for modal visibility
  const [ward,setWards] = useState([]);
  const [showEditPopup,setShowEditPopup] = useState(false);
  const [selectedEditBed,setSelectedEditBed] = useState(null);
  const location = useLocation();



  //fetch each ward
  useEffect(()=>{
    const getWardNames = async ()=>{
      try{
        const response = await axios.get("http://localhost:3002/ward-list")
        setWards(response.data);
        //console.log(response.data)
      }catch(err){
        console.log("Error fetching data in wards")
      }
    }
    getWardNames()
  },[]);
  //group bed by ward_id
  const groupedBeds=beds.reduce((acc,bed)=>{
    if(!acc[bed.ward_id]){
      acc[bed.ward_id]=[];
    }

    acc[bed.ward_id].push(bed);
    return acc;
  },{})

  // Fetch bed data
  useEffect(() => {
    const getBedData = async () => {
      setLoading(true);
      try {
        const response = await axios.get("http://localhost:3002/data");
        setBeds(response.data);
        //console.log(response.data)
      } catch (error) {
        console.error("error fetching data");
      } finally {
        setLoading(false);
      }
    };
    getBedData();
  }, []);

  // Fetch and display bed details in modal
  const handleSeeDetails = async (bedId) => {
    try {
      const response = await axios.get(`http://localhost:3002/bed-details`, {
        params: { bedId },
      });
      setBedDetail(response.data); // Set the fetched bed details
      setSelectedBedId(bedId); 
      setShowDetailsModal(true); // Open the modal
    } catch (err) {
      console.log("error occurred in API");
    }
  };

  // Hide modal
  const handleCloseDetails = () => {
    setShowDetailsModal(false);
    setBedDetail(null);  // Clear the bed details when modal is closed
    setSelectedBedId(null); // Clear the selected bed ID
  };
  // Show/Hide Add Bed Popup
  const handlePopup = () => {
    setShowPopup(true);
  };

  const handleCancelPopup = () => {
    setShowPopup(false);
  };

  // Delete bed
  const handleDeleteBed = async () => {
    try {
      const response = await axios.delete('http://localhost:3002/data', {
        data: { bedId: selectedBedId } // Use the stored bedId
      });
      alert('bed deleted successfully');
      
      // Update the state after deletion
      setBeds((prevBeds) => prevBeds.filter((bed) => bed.bed_id !== selectedBedId));
      handleCloseDetails();  // Close the modal after deletion
      window.location.reload();
    } catch (err) {
      console.error('error', err.response ? err.response.data : err.message);
      alert('Server error');
    }
  };

  //show editpopup
  const handelEditPopup = async(bedID)=>{
    setShowEditPopup(true);
    setSelectedEditBed(bedID)
    //console.log(selectedEditBed)
  }



  return (
    
        <div className="ward-section">
          {ward.length > 0 &&
            Object.keys(groupedBeds).map((wardId, idx) => {
              const wardDetails = ward.find(w => w.ward_id === parseInt(wardId));
              const wardBeds = groupedBeds[wardId];
              return (
                <EachWardBed
                  key={`${ward.ward_id}-${idx}`}
                  beds={wardBeds}
                  handleSeeDetails={handleSeeDetails}
                  handleEditPopup={handelEditPopup}
                />
              );
            })}

          <div className="Add_btn exo-2-ward text-black">
            <button type="button" onClick={handlePopup}>
              Add beds
            </button>
          </div>

          <div className="popup">
            {showPopup && <Popup onClose={handleCancelPopup} />}
          </div>

          {showDetailsModal && (
            <BedDetailsModal
              bedDetail={bedDetail}
              onClose={handleCloseDetails}
              onDelete={handleDeleteBed}
            />
          )}
          {showEditPopup && (
            <EditBedPopup editVar={setShowEditPopup} bedID={selectedEditBed} />
          )}
        </div>
  );
}

export default App;
