import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import Bed from '../Components/Beds/Bed'
import Triage from "../Components/Triage/Triage"
import Layout from '../Layout/Layout';
const Router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      {
        path:"bed-test",
        element:<Bed/>
      },
      {
        path:"triage",
        element:<Triage/>
      }
    ]
  },
]);

export default Router;
