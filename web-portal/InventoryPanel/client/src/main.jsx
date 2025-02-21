import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import AppRouter from "./Router/Router"; 
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <AppRouter />
  </StrictMode>,
)
