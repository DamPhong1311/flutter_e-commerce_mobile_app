import React, { useState } from "react";
import { auth, signInWithEmailAndPassword } from "../firebaseConfigs";
import { useNavigate } from "react-router-dom";
import './Login.css';  // Import CSS vào

const Login = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");  // Thêm state cho lỗi
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");  // Reset lỗi trước mỗi lần đăng nhập
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      if (userCredential.user.email === "devillhardgamer@gmail.com" || "phong9173123@gmail.com") {
        navigate("/dashboard");
      } else {
        setError("Bạn không có quyền truy cập!");
      }
    } catch (error) {
      setError("Sai tài khoản hoặc mật khẩu!");
    }
  };

  return (
    <div className="login-container">
      <h2 className="login-title">Đăng Nhập Admin</h2>
      <form onSubmit={handleLogin} className="login-form">
        <input
          type="email"
          placeholder="Email"
          onChange={(e) => setEmail(e.target.value)}
          required
          className="login-input"
        />
        <input
          type="password"
          placeholder="Mật khẩu"
          onChange={(e) => setPassword(e.target.value)}
          required
          className="login-input"
        />
        <button type="submit" className="login-button">Đăng Nhập</button>
      </form>
      {error && <div className="alert">{error}</div>} {/* Hiển thị thông báo lỗi nếu có */}
    </div>
  );
};

export default Login;
