// src/App.js
import React from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import Login        from "./pages/Login";
import Dashboard    from "./pages/Dashboard";
import UserManager  from "./components/userManager";

function App() {
  return (
    <Router>
      <Routes>
        {/* Public login page */}
        <Route path="/" element={<Login />} />

        {/* Dashboard shell */}
        <Route path="/dashboard/*" element={<Dashboard />} />

        {/* Direct route to UserManager (if you ever want to link here directly) */}
        <Route path="/dashboard/users" element={<UserManager />} />

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
}

export default App;
