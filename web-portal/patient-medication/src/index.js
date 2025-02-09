import express from 'express'
import dotenv from 'dotenv'
import { createClient } from '@supabase/supabase-js'
import bodyParser from 'body-parser'
import cors from 'cors'

dotenv.config()

const app=express()
app.use(express.json())
app.use(bodyParser.urlencoded({extended:true}))
app.use(cors())

const port=2000

const URL=process.env.SUPABASE_URL
const KEY=process.env.SUPABASE_KEY

const supabase = createClient(URL,KEY)

app.listen(port,()=>{
    try{
        console.log(`App running on port:${port}`)
    }catch(err){
        console.log('Something wrong in code')
    }
})

//fetiching patient details
app.get('/bed-patient',async(req,res)=>{
    const {user_id}=req.query
    try{
        const {data,error}=await supabase.from('patient_appointment_booking').select('*').eq('user_id',user_id)
        if(error){
            return res.status(400).json({message:'error fetching data',error})
        }
        return res.status(200).json({message:'data fetched succesfully',data})
    }catch(err){
        return res.status(500).json({message:'server issure',error:err.messege})
    }
})

//updateting pateint description while on bed
app.post('/add-description',async(req,res)=>{
    const des = req.body.description
    const bedId=req.body.bed_id
    try{
        const {data,error}=await supabase.from('bed').update({description:des}).eq('bed_id',bedId)
        if(error)
        {
            return res.status(400).json({message:'Error adding data',error})
        }
        return res.status(201).json({message:'data added succesfully',data})
    }catch(err){
        return res.status(500).json({message:'Sever issue',error:err.message})
    }
})