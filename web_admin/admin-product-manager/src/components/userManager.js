// src/components/UserManager.js
import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { db } from "../firebaseConfigs";
import {
  collection,
  onSnapshot,
  doc,
  updateDoc,
} from "firebase/firestore";
import { Button } from "react-bootstrap";
// import "./userManager.css"; // optional

const UserManager = () => {
  const navigate = useNavigate();
  const [users, setUsers]       = useState([]);
  const [searchTerm, setSearch] = useState("");

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

  return (
    <div className="container mt-4">
      <div className="d-flex mb-3">
        <h3 className="me-auto">User Management</h3>
        <Button variant="secondary" onClick={() => navigate("/dashboard/products")}>
          ← Products
        </Button>
      </div>

      <input
        type="text"
        placeholder="Search by name or email"
        value={searchTerm}
        onChange={(e) => setSearch(e.target.value)}
        className="form-control mb-3"
        style={{ maxWidth: 300 }}
      />

      {users
        .filter(
          (u) =>
            u.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
            u.email.toLowerCase().includes(searchTerm.toLowerCase())
        )
        .map((u) => (
          <div key={u.id} className="border p-3 mb-3 rounded">
            <h5>
              {u.name} ({u.email})
            </h5>
            {u.orders.map((o) => (
              <div key={o.id} className="mb-2">
                <p>
                  <b>Status:</b> {o.status}
                </p>
                <p>
                  <b>Total:</b> {o.totalPrice.toLocaleString()}đ
                </p>
                <p>
                  <b>Payment:</b> {o.paymentMethod}
                </p>
                <p>
                  <b>Address:</b>{" "}
                  {`${o.address.detail}, ${o.address.ward}, ${o.address.district}, ${o.address.province}`}
                </p>
                {o.status === "Pending" && (
                  <Button size="sm" onClick={() => handleStatusChange(u.id, o.id)}>
                    Confirm Delivery
                  </Button>
                )}
              </div>
            ))}
          </div>
        ))}
    </div>
  );
};

export default UserManager;
