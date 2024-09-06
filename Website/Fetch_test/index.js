import express from "express";
import bodyParser from "body-parser";
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv';
dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL
const supabaseKey = process.env.SUPABASE_KEY
const supabase = createClient(supabaseUrl, supabaseKey)

const app = express();
const port = 3000;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));


function generateRandomId(min = 1000, max = 9999) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

app.get("/", async (req,res) => {
    const { data, error } = await supabase
    .from('patient_appointment_booking')
    .select('*')
    .eq('arrived', false);

  if (error) {
    console.error('Error fetching patient appointments:', error)
  }
  const { data2, error2 } = await supabase
  .from('opd_patient_queue')
  .select('*')

  console.log(data2)
  

if (error2) {
  console.error('Error fetching patient queue', error)
}
    res.render("index.ejs",{data, data2, bool : false})
  });
  app.post("/sendToQueue", async (req, res) => {
    const { booking_id } = req.body;
    const token = generateRandomId();
  
    // Insert into opd_patient_queue
    const { error: insertError } = await supabase
      .from('opd_patient_queue')
      .insert({ token: token, booking_id: booking_id });
  
    if (insertError) {
      console.error('Error inserting into queue:', insertError);
      return res.status(500).send('Error inserting into queue');
    }
  
    // Update patient_appointment_booking to mark arrived as true
    const { error: updateError } = await supabase
      .from('patient_appointment_booking')
      .update({ arrived: true })
      .eq('booking_id', booking_id);
  
    if (updateError) {
      console.error('Error updating appointment booking:', updateError);
      return res.status(500).send('Error updating appointment booking');
    }
  
    // Fetch the updated patient_appointment_booking data (where arrived is false)
    const { data: data1, error: error1 } = await supabase
      .from('patient_appointment_booking')
      .select('*')
      .eq('arrived', false);
  
    if (error1) {
      console.error('Error fetching patient appointments:', error1);
      return res.status(500).send('Error fetching patient appointments');
    }
  
    // Fetch the updated opd_patient_queue data
    const { data: data2, error: error2 } = await supabase
      .from('opd_patient_queue')
      .select('*');
  
    if (error2) {
      console.error('Error fetching patient queue:', error2);
      return res.status(500).send('Error fetching patient queue');
    }
  
    // Render the updated data
    res.render("index.ejs", { data: data1, data2, bool: false });
  });
  

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
  });  
