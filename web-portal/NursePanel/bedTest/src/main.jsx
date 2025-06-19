import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import {RouterProvider} from 'react-router-dom'; // ✅ Use RouterProvider
import router from './Router/Router'; // ✅ Import your custom router
import './index.css';
import './App.css';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
);