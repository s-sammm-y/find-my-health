import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import Layout from '../Layout/Layout';
import Opd from '../Components/OPD/Opd';
import Emergency from '../Components/EMERGENCY/Emergency';
import Triage from '../Components/TRIAGE/Triage';
import PatientStatus from '../Components/PatientStatus/PatientStatus';
import BedAvaibility from '../Components/BedAvaibility/BedAvaibility';
import General from '../Components/Opdcomponents/General';
import Skin from '../Components/Opdcomponents/Skin';
import Neurologist from '../Components/Opdcomponents/Neurologist';
import Orthopedic from '../Components/Opdcomponents/Orthopedic';
import Pediatric from '../Components/Opdcomponents/Pediatric';
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
          { path: 'skin', element: <Skin /> },
          { path: 'orthopedic', element: <Orthopedic /> },
          { path: 'neurologist', element: <Neurologist /> },
          { path: 'pediatric', element: <Pediatric /> },
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
      }
    ]
  },
]);

export default Router;
