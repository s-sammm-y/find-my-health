import express from "express";
import bodyParser from "body-parser";
import { createClient } from '@supabase/supabase-js';
import { GoogleGenerativeAI } from "@google/generative-ai";
import cors from 'cors';
import dotenv from 'dotenv';
dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL
const supabaseKey = process.env.SUPABASE_KEY
const supabase = createClient(supabaseUrl, supabaseKey)
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const app = express();
const port = 3001;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors({
    origin: "http://localhost:5174", 
    methods: "GET, POST, PUT, PATCH, DELETE",
    credentials: true, 
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

    // Step 1: Fetch the problem
    const { data: emergencyData, error: fetchError } = await supabase
        .from('emergency_booking')
        .select('problem')
        .eq('emergency_id', emergency_id)
        .single();

    if (fetchError || !emergencyData) {
        return res.status(404).json({ error: 'Emergency record not found' });
    }

    const problem = emergencyData.problem;

    // Step 2: Use Gemini to generate diagnosis
    const prompt = `Patient problem: "${problem}". Triage summary: give only numbered, actionable steps a doctor would say. Maximum 9 bullet points. Mention tests if possible. Skip the introduction.`;

    let diagnosis = '';
    try {
        const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });
        const result = await model.generateContent(prompt);
        const response = await result.response;
        diagnosis = response.text();
    } catch (aiError) {
        console.error("Gemini API Error:", aiError.message);
        return res.status(500).json({ error: "Failed to generate diagnosis using Gemini" });
    }

    // Step 3: Insert into triage
    const { data, error: insertError } = await supabase
        .from('triage')
        .insert([{ emergency_key: emergency_id, diagnosis }]);

    if (insertError) {
        return res.status(500).json({ error: insertError.message });
    }

    // Step 4: Update emergency_booking
    const { error: updateError } = await supabase
        .from('emergency_booking')
        .update({ triage: true })
        .eq('emergency_id', emergency_id);

    if (updateError) {
        return res.status(500).json({ error: updateError.message });
    }

    return res.status(200).json({ message: "Triage added successfully", data });
});
app.get('/api/opd', async (req,res)=>{
    const {tokenType,test} = req.query;
    let time;
    let opd = 'General';
    if (tokenType == "EVENING"){
        time = "afternoon"
    }else{
        time = "morning"
    }
    const { data, error } = await supabase
    .from('opd_bookings')
    .select('*')
    .eq('time_slot', time)
    .eq('OPD_dept',opd)
    .eq('appointment_date', test)
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