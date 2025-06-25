import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import { Container, Row, Col } from "react-bootstrap";
import ProductManager from "../components/productManeger";
import UserManager from "../components/userManager";
import BestSellerChart from "../components/BestSellerChart";

const Dashboard = () => (
  <Container fluid>
    <Row>
      <Col md={12} className="p-3">
        <Routes>
          <Route index element={<Navigate to="products" replace />} />
          <Route path="products" element={<ProductManager />} />
          <Route path="users" element={<UserManager />} />
          <Route path="best-seller-chart" element={<BestSellerChart />} />
          <Route path="*" element={<Navigate to="products" replace />} />
        </Routes>
      </Col>
    </Row>
  </Container>
);

export default Dashboard;