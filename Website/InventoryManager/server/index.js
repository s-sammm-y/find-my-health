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
const port = 3000;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors({
    origin: 'http://localhost:5173', // Allow requests from React frontend
  }));
app.use(express.json());
//Get inventory
app.get('/api/inventory', async (req, res) => {
    try {
      const { data, error } = await supabase
        .from('inventory')
        .select('item_name, quantity');
  
      if (error) {
        throw error;
      }
  
      res.json(data);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Server Error');
    }
  });

// Add new item
app.post('/api/inventory', async (req, res) => {
    const { item_name, quantity } = req.body;
    let category = 'MMM'
    let update_timestamp = new Date();
    try {
      const { data, error } = await supabase
        .from('inventory')
        .insert([{ item_name, quantity, category, update_timestamp}]);
  
      if (error) {
        throw error;
      }
  
      res.status(201).send('Item added');
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Server Error');
    }
  });  
  
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
  });  
