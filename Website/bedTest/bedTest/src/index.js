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

//fetching bed detals from database
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
