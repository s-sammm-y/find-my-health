import { createClient } from "@supabase/supabase-js";


const supabaseUrl = "https://aeouxmudgmiawyqnwsic.supabase.co";
const supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFlb3V4bXVkZ21pYXd5cW53c2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3ODA0MzAsImV4cCI6MjA1NDM1NjQzMH0.wK9aPGh5Myh62Mjs1pfHKc6PoFLaj35thvmMpy8qJ1s";


export const supabase = createClient(supabaseUrl, supabaseKey);