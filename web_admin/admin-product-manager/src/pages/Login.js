// src/pages/Login.js
import React, { useState } from "react";
import { auth } from "../firebaseConfigs";
import { signInWithEmailAndPassword } from "firebase/auth";
import { useNavigate } from "react-router-dom";
import "./Login.css";  // optional, create if you have styles

const Login = () => {
  const [email, setEmail]       = useState("");
  const [password, setPassword] = useState("");
  const [error, setError]       = useState("");
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");
    try {

      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      if (userCredential.user.email === "devillhardgamer@gmail.com" || "phong9173123@gmail.com") {
        navigate("/dashboard");
      } else {
        setError("Bạn không có quyền truy cập!");
      }
    } catch {
      setError("Sai tài khoản hoặc mật khẩu!");
    }
  };

 return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-decor login-decor-1"></div>
        <div className="login-decor login-decor-2"></div>
        
        <h2 className="login-title">Admin Dashboard</h2>
        <p className="login-subtitle">Đăng nhập để tiếp tục</p>
        
        <form onSubmit={handleLogin} className="login-form">
          <div className="login-input-group">
            <span className="login-input-icon">📧</span>
            <input
              type="email"
              placeholder="Email"
              onChange={(e) => setEmail(e.target.value)}
              required
              className="login-input"
            />
          </div>
          
          <div className="login-input-group">
            <span className="login-input-icon">🔒</span>
            <input
              type="password"
              placeholder="Mật khẩu"
              onChange={(e) => setPassword(e.target.value)}
              required
              className="login-input"
            />
          </div>
          
          <button type="submit" className="login-button">
            Đăng Nhập
          </button>
          
          {error && <div className="alert">{error}</div>}
        </form>
        
        <div className="login-footer">
          <p>© {new Date().getFullYear()} Admin Dashboard</p>
        </div>
      </div>
    </div>
  );
};
export default Login;
