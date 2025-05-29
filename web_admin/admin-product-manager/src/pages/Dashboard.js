// src/pages/Dashboard.js
import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import { Container, Col,  } from "react-bootstrap";
import ProductManager from "../components/productManeger";
import UserManager    from "../components/userManager";

const Dashboard = () => (
  <Container fluid>
      <Col md={10} className="p-3">
        <Routes>
          <Route index element={<Navigate to="products" replace />} />
          <Route path="products" element={<ProductManager />} />
          <Route path="users" element={<UserManager />} />
          <Route path="*" element={<Navigate to="products" replace />} />
        </Routes>
      </Col>
  </Container>
);

export default Dashboard;
