import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import Patient from '../Components/patientHistory/Patient'
import Layout from '../Layoyt/Layout';
const Router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      {
        path:"patient",
        element:<Patient/>

      }
    ]
  },
]);

export default Router;
