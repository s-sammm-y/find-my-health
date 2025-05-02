import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import Layout from '../Layout/Layout';
import Opd from '../Components/OPD/Opd';
import Emergency from '../Components/EMERGENCY/Emergency';
import Triage from '../Components/TRIAGE/Triage';
import PatientStatus from '../Components/PatientStatus/PatientStatus';
import BedAvaibility from '../Components/BedAvaibility/BedAvaibility';
import General from '../Components/Opdcomponents/General';
import Chest from '../Components/Opdcomponents/Chest'
import Skin from '../Components/Opdcomponents/Skin';
import Neurologist from '../Components/Opdcomponents/Neurologist';
import Orthopedic from '../Components/Opdcomponents/Orthopedic';
import Pediatric from '../Components/Opdcomponents/Pediatric';
import Ambulance from '../Components/Ambulance/Ambulance'

import ErrorBoundary from '../Components/ErrorBoundary';
import { DropdownProvider } from '../Context/DropdownContext';

const Router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    children: [
      {
        path: 'opd',
        element: (
          <DropdownProvider>
            <ErrorBoundary>
              <Opd />
            </ErrorBoundary>
          </DropdownProvider>
        ),
        children: [
          { path: '', element: <General /> }, // Default content for OPD
          { path: 'general', element: <General /> },
          { path: 'chest', element: <Chest /> },
          { path: 'skin', element: <Skin /> },
          { path: 'orthopedic', element: <Orthopedic /> },
          { path: 'neurologist', element: <Neurologist /> },
          { path: 'pediatric', element: <Pediatric /> },
          { path: 'ambulance',element:<Ambulance/>}
        ]
      },
      {
        path: 'emergency',
        element: <Emergency />
      },
      {
        path: 'triage',
        element: <Triage />
      },
      {
        path: 'patient-status',
        element: <PatientStatus />
      },
      {
        path: 'bed-availability',
        element: <BedAvaibility />
      },
      {
        path: 'ambulance',
        element:<Ambulance/>
      }
    ]
  },
]);

export default Router;
