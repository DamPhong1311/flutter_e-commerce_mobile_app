// src/components/UserManager.js
import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { db } from "../firebaseConfigs";
import { collection, onSnapshot, doc, updateDoc } from "firebase/firestore";
import { Button } from "react-bootstrap";
import "./productManeger.css";

const UserManager = () => {
  const navigate = useNavigate();
  const [users, setUsers] = useState([]);
  const [searchTerm, setSearch] = useState("");
  const [expandedUserId, setExpandedUserId] = useState(null);

  useEffect(() => {
    const unsub = onSnapshot(collection(db, "users"), (snap) => {
      const all = snap.docs.map((d) => ({ id: d.id, ...d.data(), orders: [] }));
      setUsers(all);
      all.forEach((u) => {
        onSnapshot(collection(db, `users/${u.id}/ordered`), (osnap) => {
          setUsers((prev) =>
            prev.map((pu) =>
              pu.id === u.id
                ? { ...pu, orders: osnap.docs.map((o) => ({ id: o.id, ...o.data() })) }
                : pu
            )
          );
        });
      });
    });
    return unsub;
  }, []);

  const handleStatusChange = async (uid, oid) => {
    await updateDoc(doc(db, `users/${uid}/ordered`, oid), { status: "Delivered" });
  };

  const toggleUserDetails = (userId) => {
    setExpandedUserId(expandedUserId === userId ? null : userId);
  };

  // Get user initials for avatar
  const getInitials = (name) => {
    return name
      .split(' ')
      .map(part => part[0])
      .join('')
      .toUpperCase()
      .substring(0, 2);
  };

  return (
    <div className="container mt-4">
      <div className="d-flex mb-3">
        <h3 className="me-auto">User Management</h3>
        <Button variant="secondary" onClick={() => navigate("/dashboard/products")}>
          ← Products
        </Button>
      </div>

      <div className="search-container">
        <input
          type="text"
          placeholder="Search by name or email"
          value={searchTerm}
          onChange={(e) => setSearch(e.target.value)}
          className="form-control mb-4"
        />
      </div>

      <div className="user-manager-container">
        <div className="user-list">
          {users
            .filter(
              (u) =>
                u.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                u.email.toLowerCase().includes(searchTerm.toLowerCase())
            )
            .map((u) => (
              <div key={u.id}>
                <div className="user-card" onClick={() => toggleUserDetails(u.id)}>
                  <div className="user-avatar">{getInitials(u.name)}</div>
                  <div className="user-info">
                    <div className="user-name">{u.name}</div>
                    <div className="user-email">{u.email}</div>
                  </div>
                </div>
                
                {expandedUserId === u.id && (
                  <div className="user-details">
                    <h5 className="mb-3">Orders ({u.orders.length})</h5>
                    
                    {u.orders.length === 0 ? (
                      <div className="text-center py-4 text-muted">No orders found</div>
                    ) : (
                      u.orders.map((o) => (
                        <div key={o.id} className="order-card">
                          <div className="order-header">
                            <div className="order-id">Order #{o.id.substring(0, 8)}</div>
                            <div className={`order-status ${o.status === "Pending" ? "status-pending" : "status-delivered"}`}>
                              {o.status}
                            </div>
                          </div>
                          
                          <div className="order-info">
                            <div className="order-info-item">
                              <div className="order-info-label">Total</div>
                              <div className="order-info-value">{o.totalPrice.toLocaleString()}đ</div>
                            </div>
                            <div className="order-info-item">
                              <div className="order-info-label">Payment</div>
                              <div className="order-info-value">{o.paymentMethod}</div>
                            </div>
                            <div className="order-info-item">
                              <div className="order-info-label">Date</div>
                              <div className="order-info-value">{new Date(o.timestamp?.toDate()).toLocaleDateString()}</div>
                            </div>
                          </div>
                          
                          <div className="order-address">
                            <div className="order-info-label">Delivery Address</div>
                            <div className="order-info-value">
                              {`${o.address.detail}, ${o.address.ward}, ${o.address.district}, ${o.address.province}`}
                            </div>
                          </div>
                          
                          {o.status === "Pending" && (
                            <div className="order-actions">
                              <Button 
                                size="sm" 
                                variant="success"
                                onClick={() => handleStatusChange(u.id, o.id)}
                              >
                                Confirm Delivery
                              </Button>
                            </div>
                          )}
                        </div>
                      ))
                    )}
                  </div>
                )}
              </div>
            ))}
        </div>
      </div>
    </div>
  );
};

export default UserManager;