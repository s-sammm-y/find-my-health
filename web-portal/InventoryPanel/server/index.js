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
  //console.log(item_id,quantity)
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

app.get('/get-medicine-inventory',async(req,res)=>{
  const {med_type} = req.query;
  //const med_type = 'otc'
  try{
    const { data, error } = await supabase.rpc('get_medicines_by_type_json', {
      med_type
    });
    if(error){
      return res.status(400).json({message:"Error from database"});
    }

    return res.status(200).json({message:'Data fetched succesfully',data:data});
  }catch(error){
    return res.status(500).json({message:"Server error while fetching data",details:error});
  }
})

app.post('/api/med/update', async (req, res) => {
  const { itemName, quantity, action } = req.body;

  if (!itemName || !quantity || !['add', 'remove'].includes(action)) {
    return res.status(400).json({ message: 'Invalid request' });
  }

  try {
    const { data: current, error: currentError } = await supabase
      .from('medicine')
      .select('quantity')
      .eq('name', itemName)
      .single();

    if (currentError || !current) {
      return res.status(404).json({ message: 'Medicine not found', details: currentError });
    }

    const newQuantity =
      action === 'add'
        ? current.quantity + parseInt(quantity)
        : Math.max(0, current.quantity - parseInt(quantity));

    const { data, error } = await supabase
      .from('medicine')
      .update({ quantity: newQuantity })
      .eq('name', itemName);

    if (error) {
      return res.status(400).json({ message: `Error ${action === 'add' ? 'adding' : 'removing'} quantity`, details: error });
    }

    res.status(200).json({ message: 'Stock updated successfully', data });
  } catch (error) {
    return res.status(500).json({ message: 'Server error', details: error });
  }
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});  
