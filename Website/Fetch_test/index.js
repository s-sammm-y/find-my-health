import express from "express";
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv';
dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL
const supabaseKey = process.env.SUPABASE_KEY
const supabase = createClient(supabaseUrl, supabaseKey)

const app = express();
const port = 3000;
app.use(express.static("public"));

app.get("/", async (req,res) => {
    const { data, error } = await supabase
    .from('patient_appointment_booking')
    .select('*')

  if (error) {
    console.error('Error fetching patient appointments:', error)
  } else {
    console.log('Patient Appointments:', data)
  }
    res.render("index.ejs",{data, bool : false})
  });

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
  });  
