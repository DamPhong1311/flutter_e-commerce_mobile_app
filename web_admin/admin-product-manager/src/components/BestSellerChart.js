import React, { useEffect, useState } from "react";
import { db, collection, getDocs } from "../firebaseConfigs";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid, Legend } from "recharts";
import { Button } from "react-bootstrap";
import { useNavigate } from "react-router-dom";

const MAX_NAME_LENGTH = 18;

function truncateName(name) {
  if (!name) return "";
  return name.length > MAX_NAME_LENGTH ? name.slice(0, MAX_NAME_LENGTH) + "..." : name;
}

const BestSellerChart = () => {
  const [data, setData] = useState([]);
  const [topUserData, setTopUserData] = useState([]);
  const [totalProducts, setTotalProducts] = useState(0);
  const [totalCartAmount, setTotalCartAmount] = useState(0);
  const [totalUsers, setTotalUsers] = useState(0);
  const [uniqueProducts, setUniqueProducts] = useState(0);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchBestSellers = async () => {
      const usersSnapshot = await getDocs(collection(db, "users"));
      const productCount = {};
      let userWithCart = 0;
      let cartAmount = 0;

      // Thêm biến cho top users
      const userPurchaseMap = {};

      for (const userDoc of usersSnapshot.docs) {
        const userCartSnapshot = await getDocs(collection(db, "users", userDoc.id, "cart"));
        if (!userCartSnapshot.empty) userWithCart++;
        let userCartTotal = 0;
        let userProductCount = 0;

        userCartSnapshot.forEach((cartDoc) => {
          const cartItem = cartDoc.data();
          const id = cartDoc.id;
          const quantity = Number(cartItem.quantity) || 1;
          const price = Number(cartItem.price) || 0;
          productCount[id] = (productCount[id] || 0) + quantity;
          userCartTotal += price * quantity;
          userProductCount += quantity;
        });

        cartAmount += userCartTotal;

        // Lưu tổng tiền mua và tổng số sản phẩm đã mua của user này
        userPurchaseMap[userDoc.id] = {
          total: userCartTotal,
          name: userDoc.data().displayName || userDoc.data().name || userDoc.id,
          productCount: userProductCount,
        };
      }

      const topProducts = Object.entries(productCount)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 5);

      const productsSnapshot = await getDocs(collection(db, "products"));
      const productsMap = {};
      productsSnapshot.forEach(doc => {
        productsMap[doc.id] = doc.data();
      });

      const chartData = topProducts.map(([id, count]) => ({
        name: truncateName(productsMap[id]?.name || id),
        fullName: productsMap[id]?.name || id,
        orders: count,
      }));

      // Tính top user mua nhiều nhất
      const topUsers = Object.entries(userPurchaseMap)
        .sort((a, b) => b[1].total - a[1].total)
        .slice(0, 5)
        .map(([id, info]) => ({
          name: truncateName(info.name || id),
          fullName: info.name || id,
          total: info.total,
          productCount: info.productCount,
        }));

      setData(chartData);
      setTopUserData(topUsers);
      setTotalProducts(productsSnapshot.size);
      setTotalCartAmount(cartAmount);
      setTotalUsers(userWithCart);
      setUniqueProducts(Object.keys(productCount).length);
    };

    fetchBestSellers();
  }, []);

  return (
    <div className="container mt-4">
      <div className="d-flex mb-3 align-items-center chart-header-row justify-content-center position-relative">
        <h3 className="chart-title text-center w-100 m-0" style={{ textAlign: "center" }}>Overall charts</h3>
        <Button
          variant="secondary"
          className="back-btn position-absolute end-0"
          style={{ top: "50%", transform: "translateY(-50%)" }}
          onClick={() => navigate("/dashboard/products")}
        >
          ← Back
        </Button>
      </div>
      {/* Biểu đồ sản phẩm bán chạy */}
      <div style={{ background: "#fff", borderRadius: 12, boxShadow: "0 2px 12px #eee", padding: 32, marginBottom: 32 }}>
        <div style={{ fontWeight: 600, fontSize: 25, textAlign: "center", marginBottom: 24, color: "#222" }}>
          Top 4 best seller
        </div>
        {data.length === 0 ? (
          <div style={{ textAlign: "center", marginTop: 80, color: "#888" }}>
            No data available to display the chart.
          </div>
        ) : (
          <ResponsiveContainer width="100%" height={360}>
            <BarChart
              data={data}
              margin={{ top: 10, right: 30, left: 0, bottom: 10 }}
              barSize={48}
            >
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis
                dataKey="name"
                tick={{ fontWeight: 500, fontSize: 15 }}
                axisLine={false}
                tickLine={false}
                interval={0}
              />
              <YAxis
                tick={{ fontWeight: 500, fontSize: 15 }}
                axisLine={false}
                tickLine={false}
                allowDecimals={false}
              />
              <Tooltip
                contentStyle={{
                  borderRadius: 8,
                  border: "none",
                  boxShadow: "0 2px 8px #eee",
                  fontWeight: 500,
                  fontSize: 15,
                }}
                formatter={(value, name, props) => [
                  value,
                  name === "orders" ? "Number of products" : name,
                ]}
                labelFormatter={(label, payload) => {
                  if (!payload || !payload.length) return label;
                  const fullName = payload[0]?.payload?.fullName;
                  return fullName || label;
                }}
              />
              <Legend
                wrapperStyle={{
                  fontWeight: 600,
                  fontSize: 16,
                  marginTop: 12,
                }}
              />
              <Bar
                dataKey="orders"
                fill="url(#colorBar)"
                name="Number of products"
                radius={[8, 8, 0, 0]}
                label={{
                  position: "top",
                  fontWeight: 600,
                  fill: "#4f8cff",
                }}
              />
              <defs>
                <linearGradient id="colorBar" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor="#4f8cff" stopOpacity={0.9} />
                  <stop offset="100%" stopColor="#8f5aff" stopOpacity={0.7} />
                </linearGradient>
              </defs>
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>
      {/* Biểu đồ top user mua nhiều nhất */}
      <div style={{ background: "#fff", borderRadius: 12, boxShadow: "0 2px 12px #eee", padding: 32, marginBottom: 32 }}>
        <div style={{ fontWeight: 600, fontSize: 25, textAlign: "center", marginBottom: 24, color: "#222" }}>
          Top 4 users with highest purchase amount
        </div>
        {topUserData.length === 0 ? (
          <div style={{ textAlign: "center", marginTop: 80, color: "#888" }}>
            No data available to display the chart.
          </div>
        ) : (
          <ResponsiveContainer width="100%" height={360}>
            <BarChart
              data={topUserData}
              margin={{ top: 10, right: 30, left: 20, bottom: 10 }}
              barSize={48}
            >
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis
                dataKey="name"
                tick={{ fontWeight: 500, fontSize: 15 }}
                axisLine={false}
                tickLine={false}
                interval={0}
              />
              <YAxis
                tick={{ fontWeight: 500, fontSize: 15 }}
                axisLine={false}
                tickLine={false}
                allowDecimals={false}
              />
              <Tooltip
                contentStyle={{
                  borderRadius: 8,
                  border: "none",
                  boxShadow: "0 2px 8px #eee",
                  fontWeight: 500,
                  fontSize: 15,
                }}
                formatter={(value, name, props) => [
                  value.toLocaleString("vi-VN", { style: "currency", currency: "VND" }),
                  name === "total" ? "Total purchased" : name,
                ]}
                labelFormatter={(label, payload) => {
                  if (!payload || !payload.length) return label;
                  const fullName = payload[0]?.payload?.fullName;
                  const productCount = payload[0]?.payload?.productCount;
                  return (
                    <span>
                      {fullName || label}
                      <br />
                      Bought products: {productCount ?? 0}
                    </span>
                  );
                }}
              />
              <Legend
                wrapperStyle={{
                  fontWeight: 600,
                  fontSize: 16,
                  marginTop: 12,
                }}
              />
              <Bar
                dataKey="total"
                fill="url(#colorBarUser)"
                name="Total purchased"
                radius={[8, 8, 0, 0]}
                label={{
                  position: "top",
                  fontWeight: 600,
                  fill: "#8f5aff",
                  formatter: (value) => value.toLocaleString("vi-VN", { style: "currency", currency: "VND" }),
                }}
              />
              <defs>
                <linearGradient id="colorBarUser" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor="#8f5aff" stopOpacity={0.9} />
                  <stop offset="100%" stopColor="#4f8cff" stopOpacity={0.7} />
                </linearGradient>
              </defs>
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>
      <div className="dashboard-metrics">
        <div className="metrics-row">
          <div className="metric-card primary">
            <div className="metric-value">{totalProducts}</div>
            <div className="metric-label">Total product</div>
          </div>
          <div className="metric-card info">
            <div className="metric-value">
              {totalCartAmount.toLocaleString("vi-VN", { style: "currency", currency: "VND" })}
            </div>
            <div className="metric-label">Total cart amount</div>
          </div>
        </div>
        <div className="metrics-row">
          <div className="metric-card success">
            <div className="metric-value">{totalUsers}</div>
            <div className="metric-label">Users with products in cart</div>
          </div>
          <div className="metric-card warning">
            <div className="metric-value">{uniqueProducts}</div>
            <div className="metric-label">Unique products in cart</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default BestSellerChart;