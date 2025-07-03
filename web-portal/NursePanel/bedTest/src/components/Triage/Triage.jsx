import React, { useEffect, useState } from 'react'
import axios from 'axios'
import './Triage.css'

const Triage = () => {
  const [triageData, setTriageData] = useState([])
  const [loading, setLoading] = useState(true)
  const [selectedDiagnosis, setSelectedDiagnosis] = useState(null)
  const [showDiagnosisPopup, setShowDiagnosisPopup] = useState(false)

  const [selectedItem, setSelectedItem] = useState(null)
  const [showActionPopup, setShowActionPopup] = useState(false)

  useEffect(() => {
    const fetchTriage = async () => {
      try {
        const response = await axios.get('http://localhost:3002/triage-list')
        setTriageData(response.data)
      } catch (err) {
        console.error('Error fetching triage data:', err)
      } finally {
        setLoading(false)
      }
    }

    fetchTriage()
  }, [])

  const openDiagnosisPopup = (diagnosis) => {
    setSelectedDiagnosis(diagnosis)
    setShowDiagnosisPopup(true)
  }

  const openActionPopup = (item) => {
    setSelectedItem(item)
    setShowActionPopup(true)
  }

  return (
    <div className="triage-container">
      {loading ? (
        <p>Loading...</p>
      ) : (
        <div className="card-list">
          {triageData.map((item, index) => (
            <div className="patient-card" key={index}>
              <div onClick={() => openDiagnosisPopup(item.diagnosis)} style={{ cursor: 'pointer' }}>
                <p>{item.name}</p>
                <p>{item.problem}</p>
              </div>
              <button className="action-button" onClick={() => openActionPopup(item)}>Details</button>
            </div>
          ))}
        </div>
      )}

      {/* Diagnosis Popup */}
      {showDiagnosisPopup && (
        <div className="popup-overlay" onClick={() => setShowDiagnosisPopup(false)}>
          <div className="popup-content" onClick={(e) => e.stopPropagation()}>
            <h3>Diagnosis</h3>
            <p>{selectedDiagnosis}</p>
            <button onClick={() => setShowDiagnosisPopup(false)}>Close</button>
          </div>
        </div>
      )}

      {/* Action Popup */}
      {showActionPopup && (
        <div className="popup-overlay" onClick={() => setShowActionPopup(false)}>
          <div className="popup-content" onClick={(e) => e.stopPropagation()}>
          <h2 style={{ fontWeight: 700 }}>Details for {selectedItem.name}</h2>
            <p><strong>Problem:</strong> {selectedItem.problem}</p>
            <p><strong>Diagnosis:</strong> {selectedItem.diagnosis}</p>
            <button className="close" onClick={() => setShowActionPopup(false)}>Close</button>
          </div>
        </div>
      )}
    </div>
  )
}

export default Triage
