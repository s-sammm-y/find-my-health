import axios from 'axios'
import express from 'express'
import bodyParser from 'body-parser'
import dotenv from 'dotenv'
import { createClient } from '@supabase/supabase-js'
import cors from 'cors'
import PDFDocument from 'pdfkit';
import fs from 'fs'
import path from 'path'



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
    const categoryId=req.query.category_id
    try{
        const {data,error}=await supabase.from('medicine').select('*').eq('category_id',categoryId)
        if(error){
            return res.status(400).json({message:'Error fetching medicine data',error})
        }
        return res.status(200).json({message:'Medicine fetched succesfylly',data})
    }catch(err)
    {
        return res.status(500).json({message:'Server error',error:err.message})
    }
})

// app.post('/submit-medicine',async(req,res)=>{
//     const selectedData = req.body.data
//     //console.log(selectedData)
//     try{
//         const {data,error}=await supabase.from('user_prescription_details').insert(selectedData)
//         if(error){
//             return res.status(400).json({messege:'error posting details',error})
//         }
//         return res.status(201).json({message:'details added succesfully',data})
//     }catch(err){
//         return res.status(500).json({message:'server error',error:err.message})
//     }
// })

app.post('/generate-pdf', async (req, res) => {
    const { pdfdata, name, age, date, user_id } = req.body;

    try {
        const doc = new PDFDocument({ margin: 40 });
        let buffers = [];

        doc.on('data', buffers.push.bind(buffers));
        doc.on('end', async () => {
            const pdfBuffer = Buffer.concat(buffers);

            // Define file path inside Supabase Storage
            const filePath = `user_${user_id}/${Date.now()}_${name}.pdf`;

            // Upload PDF to Supabase Storage
            const { data: uploadData, error: uploadError } = await supabase.storage
                .from('prescriptions')
                .upload(filePath, pdfBuffer, {
                    contentType: 'application/pdf',
                });

            if (uploadError) {
                console.error('Supabase upload error:', uploadError);
                return res.status(500).json({ error: 'Error uploading PDF' });
            }

            console.log('PDF uploaded to Supabase:', filePath);

            // Store the file path in the database
            const { data: dbData, error: dbError } = await supabase
                .from('user_prescription_details')
                .insert([
                    { user_id, pdf: filePath }
                ]);

            if (dbError) {
                console.error('Database insert error:', dbError);
                return res.status(500).json({ error: 'Error storing PDF path' });
            }

            console.log('PDF path saved to database');

            // Send the PDF buffer as response to frontend
            res.set({
                'Content-Type': 'application/pdf',
                'Content-Disposition': `inline; filename="${name}.pdf"`,
            });
            res.send(pdfBuffer);
        });

        // Generate the PDF
        const imageUrl = "http://localhost:5173/head.png";
        const response = await axios.get(imageUrl, { responseType: 'arraybuffer' });
        const imageBuffer = Buffer.from(response.data, 'binary');
        const date = new Date();
        const foramttedDate = `${("0" + date.getDate()).slice(-2)}-${("0" + (date.getMonth() + 1)).slice(-2)}-${date.getFullYear()}`;

        doc.image(imageBuffer, 50, 20, { width: 500 });
        doc.moveDown(10);
        doc.moveTo(40, 180).lineTo(570, 180).stroke();
        doc.moveDown(1.5);

        doc.font('Helvetica-Bold').fontSize(14).text(`Patient Name: `, { continued: true }).font('Helvetica').text(name).moveDown(0.5);
        doc.font('Helvetica-Bold').text(`Age: `, { continued: true }).font('Helvetica').text(`${age} years`).moveDown(0.5);
        doc.font('Helvetica-Bold').text('Date:',{continued:true}).font('Helvetica').text(foramttedDate).moveDown(0.5);
        doc.font('Helvetica-Bold').text(`Next Appointment Date: `, { continued: true }).font('Helvetica').text(date).moveDown(1.5);

        pdfdata.forEach((item, index) => {
            doc.font('Helvetica-Bold').fontSize(12).text(`Medicine ${index + 1}`, { underline: true }).moveDown(0.5);
            doc.font('Helvetica-Bold').text(`Medicine: `, { continued: true }).font('Helvetica').text(item.medicine).moveDown(0.3);
            doc.font('Helvetica-Bold').text(`Dosage: `, { continued: true }).font('Helvetica').text(item.dosage).moveDown(0.3);
            doc.font('Helvetica-Bold').text(`Frequency: `, { continued: true }).font('Helvetica').text(item.frequency).moveDown(1);
        });

        doc.font('Helvetica-Bold').text(`Description: `, { continued: true }).font('Helvetica').text(pdfdata[0].description).moveDown(0.3);
        doc.end(); // End the PDF document

    } catch (err) {
        console.log("Error generating PDF", err);
        res.status(500).send("Error generating PDF");
    }
});


//create url
app.get('/get-prescriptions/:userId', async (req, res) => {
    const { userId } = req.params;

    // Fetch all stored PDF paths for the user
    const { data, error } = await supabase
        .from('user_prescription_details')
        .select('pdf')
        .eq('user_id', 2); // Fetch all PDFs for this user

    if (error || !data || data.length === 0) {
        console.error('Error fetching prescriptions:', error);
        return res.status(404).json({ error: 'No prescriptions found' });
    }

    // Generate signed URLs for each PDF
    const signedUrls = await Promise.all(
        data.map(async (prescription) => {
            const { data: signedUrlData, error: urlError } = await supabase
                .storage
                .from('prescriptions')
                .createSignedUrl(prescription.pdf, 60 * 60); // URL expires in 1 hour

            if (urlError) {
                console.error('Error generating signed URL:', urlError);
                return null; // Skip if error occurs
            }

            return {
                filePath: prescription.pdf,
                url: signedUrlData.signedUrl
            };
        })
    );

    // Remove any failed URL generations (null values)
    const validUrls = signedUrls.filter(url => url !== null);

    res.json({ urls: validUrls });
});


