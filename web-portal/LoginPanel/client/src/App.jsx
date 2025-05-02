import { useState } from "react";
import "./App.css";

function App() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");


  const handleSubmit = async (e) => {
    e.preventDefault(); // Prevent page reload

    const formData = {
      username,
      password
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
        const panel = data.user.panel;
      
        if (panel === "Registration") {
          window.location.href = "http://localhost:5174/";
        } else if (panel === "Doctor") {
          window.location.href = "http://localhost:5177/";
        } else if (panel === "Nurse") {
          window.location.href = "http://localhost:5175/";
        } else if (panel === "Inventory") {
          window.location.href = "http://localhost:5176/";
        } else {
          setError("Unknown panel. Access denied.");
        }
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
          <button type="submit" disabled={!username || !password}>
            Login
          </button>
        </form>
      </div>
    </div>
  );
}

export default App;
