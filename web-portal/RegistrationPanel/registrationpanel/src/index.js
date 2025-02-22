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
const port = 3001;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors({
    origin: "http://localhost:5174", // Ensure this is the correct frontend URL
    methods: "GET, POST, PUT, DELETE",
    credentials: true, // Allow cookies or authentication headers
  }));
app.use(express.json());

app.get('/api/emergency-list', async (req, res) => {
    const { data, error } = await supabase
        .from('emergency_booking')  
        .select('*')
        .eq('triage', false);;  

    if (error) {
        return res.status(500).json({ error: error.message });
    }

    return res.status(200).json(data);
});
app.get('/api/triage-list', async (req, res) => {
    const { data, error } = await supabase
        .from('triage')  
        .select('*')
        .eq('triage', false);  

    if (error) {
        return res.status(500).json({ error: error.message });
    }

    return res.status(200).json(data);
});
app.get('/api/doctor-list', async(req,res)=>{
    const { data, error } = await supabase
    .from('doctors')
    .select('*')
    .eq('opd_department', 'General');

if (error) {
    return res.status(500).json({ error: error.message });
}

return res.status(200).json(data);
})
app.post('/api/add-triage', async (req, res) => {
    const { emergency_id } = req.body;

    const { data, error } = await supabase
        .from('triage')  // Supabase table for triage
        .insert([{ emergency_key : emergency_id }]);
    const { error: updateError } = await supabase
        .from('emergency_booking')
        .update({ triage : true })
        .eq('emergency_id', emergency_id);
    
    if (error) {
        return res.status(500).json({ error: error.message });
    }
    

    return res.status(200).json({ message: "Triage added successfully", data });
});
app.get('/api/opd', async (req,res)=>{
    const {tokenType,formattedDate} = req.query;
    const { data, error } = await supabase
    .from('opd_bookings')
    .select('*')
    .eq('time_slot', tokenType.toLowerCase())
    .eq('appointment_date', formattedDate)
    .order('token', { ascending: true });

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    return res.status(200).json(data);
})
app.patch('/api/opd/arrive', async (req, res) => {
    const { id } = req.body;
    
    if (!id) {
        return res.status(400).json({ error: "Token ID is required" });
    }
    console.log(id)
    const {error } = await supabase
        .from('opd_bookings')
        .update({ arrived: true })
        .eq('id', parseInt(id))
        
    if (error) {
        console.error("Supabase Error:", error);
        return res.status(500).json({ error: error.message });
    }
    
    return res.status(204).send(); // No content returned on success
});
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
  });  