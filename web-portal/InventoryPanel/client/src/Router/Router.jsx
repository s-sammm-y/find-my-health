import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import App from "../App";
import Notifications from "../components/Notifications/Notifications";
import Analytics from "../components/Analytics/Analytics";
import Header from "../components/Header/Header";
import Sidebar from "../components/Sidebar/Sidebar";

import PrescriptionMeds from "../components/Medicineinventory/PrescriptionMeds";
import OTCMeds from "../components/Medicineinventory/OTCMeds";
import InjectableMeds from "../components/Medicineinventory/InjectableMeds";

const AppRouter = () => {
  return (
    <Router>
      <div className="app-container">
      <Header /> {/* Header remains fixed */}
      <div className="main-content">
        <Sidebar /> {/* Sidebar remains fixed */}
        <div className="main">
          <Routes>
            <Route path="/" element={<App />} />
            <Route path="/notifications" element={<Notifications />} />
            <Route path="/analytics" element={<Analytics />} />

            <Route path="/medicineinventory/prescription" element={<PrescriptionMeds />} />
            <Route path="/medicineinventory/otc" element={<OTCMeds />} />
            <Route path="/medicineinventory/injectable" element={<InjectableMeds />} />
          </Routes>
        </div>
      </div>
      </div>
    </Router>
  );
};

export default AppRouter;