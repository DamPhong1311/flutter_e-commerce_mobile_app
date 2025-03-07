// src/firebaseConfigs.js
import { initializeApp } from "firebase/app";
import { getFirestore, collection, getDocs, addDoc, deleteDoc, doc } from "firebase/firestore";
import { getAuth, signInWithEmailAndPassword } from "firebase/auth";

// Cấu hình Firebase của bạn
const firebaseConfig = {
    apiKey: "AIzaSyC2G6k6iI78k7Z2dbr-_kh655sPUZ5E0BQ",
    authDomain: "ecommerceappflutter-9c8da.firebaseapp.com",
    projectId: "ecommerceappflutter-9c8da",
    storageBucket: "ecommerceappflutter-9c8da.firebasestorage.app",
    messagingSenderId: "757109925372",
    appId: "1:757109925372:web:728fa4606b53707cb83e79"
  };

// Khởi tạo Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

// Export các hàm cần thiết
export { db, auth, collection, getDocs, addDoc, deleteDoc, doc, signInWithEmailAndPassword };
