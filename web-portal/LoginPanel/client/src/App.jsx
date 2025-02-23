import { useState } from "react";
import "./App.css";

function App() {
  const [selectedPanel, setSelectedPanel] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handlePanelChange = (e) => {
    setSelectedPanel(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault(); // Prevent page reload

    const formData = {
      username,
      password,
      panel: selectedPanel,
    };

    try {
      const response = await fetch("http://localhost:3000/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      const data = await response.json();

      if (response.ok) {
        // Redirect to the new page
        if (selectedPanel === 'Registration')
        {
          window.location.href = "http://localhost:5174/";
        }
        else if(selectedPanel === 'Doctor')
        {
          window.location.href = "http://localhost:5177/";
        }
        else if(selectedPanel === 'Nurse')
        {
          window.location.href = "http://localhost:5175/";
        }
        else if(selectedPanel === 'Inventory')
          {
            window.location.href = "http://localhost:5176/";
          }
        else{

        }
      } else {
        setError(data.message || "Invalid credentials");
      }
    } catch (error) {
      setError("Something went wrong. Try again later.");
      console.log(error)
    }
  };

  return (
    <div className="container">
      {/* Navbar */}
      <nav className="navbar">
        <h1>HOSPITAL NAME</h1>
      </nav>

      {/* Login Box */}
      <div className="login-box">
        <h2>Login</h2>
        <form className="login-form" onSubmit={handleSubmit}>
          {/* Error Message */}
          {error && <p className="error-message">{error}</p>}

          {/* Panel Selection Dropdown */}
          <select className="panel-dropdown" onChange={handlePanelChange} required>
            <option value="">Choose Panel</option>
            <option value="Registration">Registration</option>
            <option value="Doctor">Doctor</option>
            <option value="Nurse">Nurse</option>
            <option value="Inventory">Registration</option>
          </select>

          {/* Username Input */}
          <input
            type="text"
            placeholder="Username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />

          {/* Password Input */}
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />

          {/* Login Button */}
          <button type="submit" disabled={!selectedPanel || !username || !password}>
            Login
          </button>
        </form>
      </div>
    </div>
  );
}

export default App;
