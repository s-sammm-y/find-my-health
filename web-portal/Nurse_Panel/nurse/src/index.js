import express from 'express'
import dotenv from 'dotenv'
import bodParser from 'body-parser'
import cors from 'cors'
import { createClient } from '@supabase/supabase-js';

dotenv.config()
const app = express();
const port = 3002
app.use(cors({
    origin: "http://localhost:5175", 
    methods: "GET, POST, PUT, DELETE",
    credentials: true, // Allow cookies or authentication headers
  }));
app.use(bodParser.urlencoded({extended:true}))
app.use(express.json())


const URL = process.env.SUPABASE_URL
const KEY = process.env.SUPABASE_KEY
const supabase  =  createClient(URL,KEY)

app.listen(port,()=>{
    console.log("app listening")
})

//fetching bed details for display from database
app.get('/data',async(req,res)=>{
    try{
        const {data,error}=await supabase.from('bed').select('bed_id,empty,ward_id')
        if(error){
        console.log("error fetching data")
    }
        res.json(data)
    }
    catch(err){
        console.log("Enounter unknown error",err)
    }
})

//fetching ward list
app.get('/ward-list',async (req,res)=>{
    try{
        const {data,error}= await supabase.from('bed').select('ward_id,bed_id');
        if(error){
            console.log('error fetching data');
        }
        res.json(data);
        //console.log(data)
    }catch(err){
        console.log("Unknown error");
    }
})

//fetching bed details for particular bed
app.get('/bed-details', async (req, res) => {
    const { bedId } = req.query;

    try {
        const { data, error } = await supabase.rpc('bed_detail', { bedid: bedId });

        if (error) {
            console.error('Error calling function:', error);
            return res.status(500).json({ error: 'Error fetching bed details' });
        }
        console.log(data)
        res.json(data); 
    } catch (err) {
        console.error('Unknown error:', err);
        res.status(500).json({ error: 'Unknown error occurred' });
    }
});

//adding bed 
app.post('/add-bed', async (req, res) => {
    const bedDetails = {
        bed_id: req.body.bed_id,
        dept_id: req.body.dept_id,
        ward_id: req.body.ward_id, 
        patient_id: req.body.patient_id,
        room: req.body.room
    };

    console.log('Received bedDetails:', bedDetails); // Log the received data

    try {
        const { data, error } = await supabase.from('bed').insert(bedDetails);
        console.log('Data inserted:', data);
        if (error) {
            return res.status(400).json({ message: 'Failed to add bed details', error });
        }
        return res.status(200).json({ message: 'Bed details added successfully', data });
    } catch (err) {
        console.error('Unknown error:', err);
        return res.status(500).json({ message: 'Server error', error: err.message });
    }
});

//deleteing bed on delete button
app.delete('/data',async(req,res)=>{
    const {bedId} = req.body
    //console.log(bedId)
    try{
        const {data,error}=await supabase.from('bed').delete('bed_id','fff').eq('bed_id',bedId).select()
        if(error){
            return res.status(400).json({message:'Failed to delete data',error})
        }
        //using status 201 because it is for delete resource and not creating resource
        return res.status(201).json({message:'bed deleted succesfully',data})
    }catch(err){
        return res.status(500).json({message:'server error in backend',error:err.message})
    }
})

//edit bed section

app.put('/edit-bed',async (req,res)=>{
    const editBedDetails = {
        bed_id:req.body.bed_id,
        dept_id:req.body.dept_id,
        ward_id:req.body.ward_id,
        patient_id:req.body.patient_id,
        empty:req.body.empty
    }

    console.log(editBedDetails)

    try{
        const {data,error} = await supabase.from('bed')
        .update({
            dept_id:editBedDetails.dept_id,
            ward_id:editBedDetails.ward_id,
            patient_id:editBedDetails.patient_id,
            empty:editBedDetails.empty
        }).eq('bed_id',editBedDetails.bed_id)

        if(error){
            console.log('Pushing error',error.message);
        }
        console.log('Sent Succesfully:',data)
    }catch(err){
        console.log('Error in back end',err)
    }
    
})

app.put('/remove-bed-details',async (req,res)=>{
    const editBedDetails = {
        bed_id:req.body.bed_id,
        dept_id:req.body.dept_id,
        patient_id:req.body.patient_id,
        empty:req.body.empty
    }

    //console.log(editBedDetails)

    try{
        const {data,error} = await supabase.from('bed')
        .update({
            dept_id:editBedDetails.dept_id,
            patient_id:editBedDetails.patient_id,
            empty:editBedDetails.empty
        }).eq('bed_id',editBedDetails.bed_id)

        if(error){
            console.log('Pushing error',error.message);
        }
        console.log('Sent Succesfully:',data)
    }catch(err){
        console.log('Error in back end',err)
    }
    
})