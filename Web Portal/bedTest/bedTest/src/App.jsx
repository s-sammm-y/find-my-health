import { useEffect, useState } from "react";
import axios from "axios";
import Popup from "./components/Add-Bed-Popup";
import Header from "./components/Header/Header";
import Sidebar from "./components/Sidebar/Sidebar";
import BedDetailsModal from "./components/BedDetailsModel/BedDetailsModel"; 
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faEye } from '@fortawesome/free-solid-svg-icons'; 
import "./App.css";

function App() {
  const [bedDetail, setBedDetail] = useState(null); // Change to hold the selected bed details
  const [beds, setBeds] = useState([]);
  const [selectedBedId, setSelectedBedId] = useState(null);
  const [showPopup, setShowPopup] = useState(false);
  const [loading, setLoading] = useState(false);
  const [showDetailsModal, setShowDetailsModal] = useState(false); // New state for modal visibility

  // Fetch bed data
  useEffect(() => {
    const getBedData = async () => {
      setLoading(true);
      try {
        const response = await axios.get("http://localhost:3000/data");
        setBeds(response.data);
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
      const response = await axios.get(`http://localhost:3000/bed-details`, {
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
      const response = await axios.delete('http://localhost:3000/data', {
        data: { bedId: selectedBedId } // Use the stored bedId
      });
      alert('bed deleted successfully');
      
      // Update the state after deletion
      setBeds((prevBeds) => prevBeds.filter((bed) => bed.bed_id !== selectedBedId));
      handleCloseDetails();  // Close the modal after deletion
    } catch (err) {
      console.error('error', err.response ? err.response.data : err.message);
      alert('Server error');
    }
  };

  return (
    <>
      <Header />
      <div className="main-content">
        <Sidebar />
        <div className="BedContainer">
          {/* Display loading spinner */}
          {loading ? (
            <p>Loading beds...</p>
          ) : (
            <div className="beds">
              {beds.map((bed, idx) => (
                <div
                  className={`bed p-1  ${
                    idx % 2 != 0 ? "red" : "green"
                  }`}
                  key={bed.bed_id}
                >
                  <p>BED ID: {bed.bed_id}</p>
                  <button className="btn"
                    type="button"
                    onClick={() => handleSeeDetails(bed.bed_id)}
                  >
                    <FontAwesomeIcon
                  icon={faEye}
                  className="text-2xl text-black-600 hover:text-blue-600 transition-colors duration-300"
                />
                  </button>
                </div>
              ))}
            </div>
          )}

          {/* Add bed trigger */}
          <div className="Add_btn">
            <button type="button" onClick={handlePopup}>
              Add beds
            </button>
          </div>

          {/* Add bed popup */}
          <div className="popup">
            {showPopup && <Popup onClose={handleCancelPopup} />}
          </div>

          {/* Bed details modal with delete button */}
          {showDetailsModal && (
            <BedDetailsModal
              bedDetail={bedDetail}
              onClose={handleCloseDetails}
              onDelete={handleDeleteBed} // Pass delete handler
            />
          )}
        </div>
      </div>
    </>
  );
}

export default App;
