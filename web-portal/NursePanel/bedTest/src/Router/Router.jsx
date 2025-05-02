import { createBrowserRouter } from 'react-router-dom';
import Triage from '../components/Triage/Triage';
import MainLayout from "../Layout/Layout";
import App from "../App"

const router = createBrowserRouter([
  {
    path: '/',
    element: <MainLayout />,
    children: [
      {
        index: true,
        element: <App /> // or another home component
      },
      {
        path: 'triage',
        element: <Triage />
      }
    ]
  }
]);

export default router;

