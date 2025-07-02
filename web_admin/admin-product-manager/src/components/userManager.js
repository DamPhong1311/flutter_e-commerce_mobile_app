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
  const [selectedUser, setSelectedUser] = useState(null); 

  useEffect(() => {
    const unsub = onSnapshot(collection(db, "users"), (snap) => {
      const allUsers = snap.docs.map((d) => ({ id: d.id, ...d.data(), orders: [] }));
      setUsers(allUsers);

      allUsers.forEach((u) => {
        onSnapshot(collection(db, `users/${u.id}/ordered`), (osnap) => {
          const userOrders = osnap.docs.map((o) => ({ id: o.id, ...o.data() }));
          setUsers((prevUsers) =>
            prevUsers.map((prevUser) =>
              prevUser.id === u.id ? { ...prevUser, orders: userOrders } : prevUser
            )
          );
          
          if (selectedUser && selectedUser.id === u.id) {
            setSelectedUser(prevUser => ({ ...prevUser, orders: userOrders }));
          }
        });
      });
    });
    return unsub;
  }, [selectedUser]);

  const handleStatusChange = async (uid, oid) => {
    await updateDoc(doc(db, `users/${uid}/ordered`, oid), { status: "Đã giao" });
  };
  
  const handleSelectUser = (user) => {
    setSelectedUser(user);
  };

  const getInitials = (name) => {
    if (!name) return '??';
    return name
      .split(' ')
      .map(part => part[0])
      .join('')
      .toUpperCase()
      .substring(0, 2);
  };

  const filteredUsers = users.filter(
    (u) =>
      (u.name && u.name.toLowerCase().includes(searchTerm.toLowerCase())) ||
      (u.email && u.email.toLowerCase().includes(searchTerm.toLowerCase()))
  );

  return (
    <div className="container mt-4">
      <div className="d-flex justify-content-between align-items-center mb-4">
        <h2 className="text-center mb-0" style={{border: 'none', padding: 0, textAlign: 'left'}}>Quản lý người dùng</h2>
        <Button variant="secondary" onClick={() => navigate("/dashboard/products")}>
          ← Quản lý sản phẩm
        </Button>
      </div>

      <div className="user-management-layout">
        <div className="user-list-panel">
          <input
            type="text"
            placeholder="Tìm theo tên hoặc email..."
            value={searchTerm}
            onChange={(e) => setSearch(e.target.value)}
            className="form-control mb-3"
          />
          <div className="user-list">
            {filteredUsers.length > 0 ? (
              filteredUsers.map((u) => (
                <div 
                  key={u.id} 
                  className={`user-card ${selectedUser?.id === u.id ? 'active' : ''}`} 
                  onClick={() => handleSelectUser(u)}
                >
                  <div className="user-avatar">{getInitials(u.name)}</div>
                  <div className="user-info">
                    <div className="user-name">{u.name}</div>
                    <div className="user-email">{u.email}</div>
                  </div>
                </div>
              ))
            ) : (
              <div className="text-center p-4 text-muted">Không tìm thấy người dùng.</div>
            )}
          </div>
        </div>

        <div className="user-detail-panel">
          {selectedUser ? (
            <div className="user-details-content">
              <h4 className="mb-3">Lịch sử đơn hàng ({selectedUser.orders.length})</h4>
              
              {selectedUser.orders.length === 0 ? (
                <div className="text-center py-5 text-muted">Người dùng này chưa có đơn hàng.</div>
              ) : (
                <div className="orders-list">
                  {selectedUser.orders.map((o) => (
                    <div key={o.id} className="order-card">
                      <div className="order-header">
                        <div className="order-id">Đơn hàng #{o.id.substring(0, 8).toUpperCase()}</div>
                        <div className={`order-status ${o.status === "Pending" || o.status === "Đang chờ" ? "status-pending" : "status-delivered"}`}>
                          {o.status === "Pending" ? "Đang chờ" : o.status}
                        </div>
                      </div>
                      
                      <div className="order-info">
                        <div className="order-info-item">
                          <div className="order-info-label">Tổng tiền</div>
                          <div className="order-info-value">{o.totalPrice.toLocaleString()}đ</div>
                        </div>
                        <div className="order-info-item">
                          <div className="order-info-label">Phương thức thanh toán</div>
                          <div className="order-info-value">{o.paymentMethod}</div>
                        </div>
                        <div className="order-info-item">
                          <div className="order-info-label">Ngày đặt hàng</div>
                          <div className="order-info-value">{new Date(o.timestamp?.toDate()).toLocaleDateString()}</div>
                        </div>
                      </div>
                      
                      <div className="order-address">
                        <div className="order-info-label">Địa chỉ giao hàng</div>
                        <div className="order-info-value">
                          {`${o.address.detail}, ${o.address.ward}, ${o.address.district}, ${o.address.province}`}
                        </div>
                      </div>
                      
                      {/* SỬA LỖI TẠI ĐÂY: Thêm dấu ngoặc () để nhóm điều kiện logic */}
                      {(o.status === "Pending" || o.status === "Đang chờ") && (
                        <div className="order-actions">
                          <Button 
                            className="btn-sm"
                            variant="success"
                            onClick={() => handleStatusChange(selectedUser.id, o.id)}
                          >
                            ✓ Xác nhận đã giao
                          </Button>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>
          ) : (
            <div className="user-detail-placeholder">
              <div className="placeholder-icon">👤</div>
              <h4>Chọn một người dùng</h4>
              <p>Nhấp vào một người dùng từ danh sách để xem chi tiết và lịch sử đơn hàng của họ.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default UserManager;