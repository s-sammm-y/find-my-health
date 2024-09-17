import express from 'express'
import dotenv from 'dotenv'
import bodParser from 'body-parser'
import cors from 'cors'
import { createClient } from '@supabase/supabase-js';

dotenv.config()
const app = express();
const port = 3000
app.use(cors())
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
        const {data,error}=await supabase.from('bed').select('bed_id')
        if(error){
        console.log("error fetching data")
    }
        res.json(data)
    }
    catch(err){
        console.log("Enounter unknown error",err)
    }
})

//fetching bed details for particular bed
app.get('/bed-details',async(req,res)=>{
    const {bedId}=req.query
    try{
        const {data,error}=await supabase.from('bed').select('dept_id,ward_id,room,patient_id').eq('bed_id',bedId)
        if(error){
            console.log('error fetching data')
        }
        res.json(data)
    }catch(err){
        console.log('Unknonwn error')
    }
})

//adding bed 
app.post('/add-bed', async (req, res) => {
    const bedDetails = {
        bed_id: req.body.bed_id,
        dept_id: req.body.dept_id,
        ward_id: req.body.ward_id, 
        patient_id: req.body.patient_id,
        room: req.body.room
    };

    try {
        const { data, error } = await supabase.from('bed').insert(bedDetails);

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