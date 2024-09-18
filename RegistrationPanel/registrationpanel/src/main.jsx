import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { RouterProvider } from 'react-router-dom';
import './index.css';  // Import your CSS or TailwindCSS styles
import Router from './Router/Router';  // Import the router configuration

// Create a root element and render the application
createRoot(document.getElementById('root')).render(
  <StrictMode>
    <RouterProvider router={Router} />
  </StrictMode>
);
