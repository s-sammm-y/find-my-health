import express from 'express'
import bodyParser from 'body-parser'
import dotenv from 'dotenv'
import { createClient } from '@supabase/supabase-js'
import cors from 'cors'


dotenv.config()

const app = express()
app.use(cors())
app.use(bodyParser.urlencoded({extended:true}))
app.use(express.json())

const URL = process.env.SUPABASE_URL;
const KEY = process.env.SUPABASE_KEY;

const supabase = createClient(URL,KEY)

const PORT = 5000

app.listen(PORT,()=>{
    console.log("app listening")
})


app.get('/fetch-catagory',async(req,res)=>{
    try{
        const {data,error} = await supabase.from('med_catagory').select('*')
        if(error)
        {
            return res.status(400).json({message:'Medicine catagory fetch failed',error})
        }
        return res.status(200).json({message:'Medicine catagory fetched succesfylly',data})
    }catch(err)
    {
        return res.status(500).json({message:'Server error',error:err.message})
    }
})

app.get('/fetch-medicine',async(req,res)=>{
    try{
        const {data,error}=await supabase.from('medicine').select('*')
        if(error){
            return res.status(400).json({message:'Error fetching medicine data',error})
        }
        return res.status(200).json({message:'Medicine fetched succesfylly',data})
    }catch(err)
    {
        return res.status(500).json({message:'Server error',error:err.message})
    }
})