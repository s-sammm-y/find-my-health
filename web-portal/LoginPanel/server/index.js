import express from "express";
import bodyParser from "body-parser";
import { createClient } from '@supabase/supabase-js';
import cors from 'cors';
import dotenv from 'dotenv';
dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL
const supabaseKey = process.env.SUPABASE_KEY
const supabase = createClient(supabaseUrl, supabaseKey)

const app = express();
const port = 3000;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors({
    origin: 'http://localhost:5173', // Allow requests from React frontend
  }));

app.use(express.json());

app.post("/login", async (req, res) => {
  const { username, password, panel } = req.body;

  // Dummy authentication (replace with real database check)
  try {
    // Query Supabase to find the user
    const { data, error } = await supabase
      .from("web_users")
      .select("*")
      .eq("username", username)
      .eq("password", password)
      .eq("panel", panel)
      .single();
    if (error || !data) {
      return res.status(401).json({ success: false, message: "Invalid credentials" });
    }

    // Login successful, redirect
    res.json({ success: true, message: "Login successful" });
  } catch (err) {
    res.status(500).json({ success: false, message: "Server error" });
  }
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
  });  
