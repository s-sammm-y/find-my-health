import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import App from "../App";
import Notifications from "../components/Notifications/Notifications";
import Analytics from "../components/Analytics/Analytics";
import Medicineinventory from "../components/Medicineinventory/Medicineinventory";
import Header from "../components/Header/Header";
import Sidebar from "../components/Sidebar/Sidebar";

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
            <Route path="/medicineinventory" element={<Medicineinventory/>}/>
          </Routes>
        </div>
      </div>
      </div>
    </Router>
  );
};

export default AppRouter;