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
const port = 3003;
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors({
    origin: "http://localhost:5176", 
    methods: "GET, POST, PUT, DELETE",
    credentials: true, // Allow cookies or authentication headers
  }));
app.use(express.json());
//Get inventory
app.get('/api/inventory', async (req, res) => {
    try {
      const { data, error } = await supabase
        .from('inventory')
        .select('*');
  
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
    let category = 'test'
    try {
      const { data, error } = await supabase
        .from('inventory')
        .insert([{ item_name, category, quantity}]);
  
      if (error) {
        throw error;
      }
  
      res.status(201).send('Item added');
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Server Error');
    }
  });
// Get low stock notifs
app.get('/api/lowStock',async(req,res)=>{
  try {
    const { data, error } = await supabase
      .from('inventory')
      .select('*')
      .lt('quantity', 100); // Fetch only stocks where quantity < 100
  
    if (error) {
      throw error;
    }
  
    res.json(data);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
}) 
  
//Update item quantity
app.put('/api/inventory/:item_id', async (req, res) => {
  const { item_id } = req.params;
  const { quantity } = req.body;

  try {
    // First, get the current quantity
    const { data: currentData, error: fetchError } = await supabase
      .from('inventory')
      .select('quantity')
      .eq('item_id', item_id)
      .single();

    if (fetchError) {
      throw fetchError;
    }

    const currentQuantity = currentData.quantity;

    // Calculate the new quantity
    const newQuantity = currentQuantity + parseInt(quantity);

    // Update the quantity in the database
    const { data, error } = await supabase
      .from('inventory')
      .update({ quantity: newQuantity})
      .eq('item_id', item_id);

    if (error) {
      throw error;
    }

    res.status(200).send('Quantity updated');
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
  });  
