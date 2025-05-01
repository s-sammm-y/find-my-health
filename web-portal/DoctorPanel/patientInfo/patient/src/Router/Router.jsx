import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import Patient from '../Components/patientHistory/Patient'
import Triage from "../Components/Triage/Triage"
import Layout from '../Layoyt/Layout';
const Router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      {
        path:"patient",
        element:<Patient/>
      },
      {
        path:"triage",
        element:<Triage/>
      }
    ]
  },
]);

export default Router;
