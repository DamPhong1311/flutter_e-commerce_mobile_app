import React, { useState } from "react";
import { db, collection, getDocs } from "../firebaseConfigs";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid, Legend } from "recharts";
import { Button, Form, Alert } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import "./BestSellerChart.css";

const MAX_NAME_LENGTH = 18;

function truncateName(name) {
  if (!name) return "";
  return name.length > MAX_NAME_LENGTH ? name.slice(0, MAX_NAME_LENGTH) + "..." : name;
}

const BestSellerChart = () => {
  const [data, setData] = useState([]);
  const [topUserData, setTopUserData] = useState([]);
  const [totalProducts, setTotalProducts] = useState(0);
  const [totalOrderAmount, setTotalOrderAmount] = useState(0);
  const [totalUsers, setTotalUsers] = useState(0);
  const [uniqueProducts, setUniqueProducts] = useState(0);

  // Filter state
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [filterError, setFilterError] = useState("");
  const [hasFiltered, setHasFiltered] = useState(false);

  const navigate = useNavigate();

  // Only fetch when filter is applied
  const handleFilter = (e) => {
    if (e) e.preventDefault();
    if ((startDate && !endDate) || (!startDate && endDate)) {
      setFilterError("Vui lòng chọn cả ngày bắt đầu và ngày kết thúc.");
      return;
    }
    setFilterError("");
    setHasFiltered(true);
    fetchBestSellers();
  };

  const fetchBestSellers = async () => {
    const usersSnapshot = await getDocs(collection(db, "users"));
    const productCount = {};
    let userWithOrder = 0;
    let orderAmount = 0;
    const userPurchaseMap = {};

    for (const userDoc of usersSnapshot.docs) {
      // Get all orders of this user
      const orderedSnapshot = await getDocs(collection(db, "users", userDoc.id, "ordered"));
      // Filter by date if needed
      const orders = orderedSnapshot.docs.filter(orderDoc => {
        const orderData = orderDoc.data();
        if (!orderData.createdAt) return false;
        let createdAt;
        // Firestore Timestamp
        if (orderData.createdAt.seconds) {
          createdAt = new Date(orderData.createdAt.seconds * 1000);
        } else {
          createdAt = new Date(orderData.createdAt);
        }
        if (startDate && endDate) {
          const start = new Date(startDate);
          const end = new Date(endDate + "T23:59:59");
          return createdAt >= start && createdAt <= end;
        }
        return true;
      });

      if (orders.length > 0) userWithOrder++;

      let userOrderTotal = 0;
      let userProductCount = 0;

      orders.forEach(orderDoc => {
        const orderData = orderDoc.data();
        const product = orderData.product;
        // If product is array (multiple products in one order)
        if (Array.isArray(product)) {
          product.forEach(prod => {
            const id = prod.id || prod.productId || prod.name || "unknown";
            const quantity = Number(prod.quantity) || 1;
            const price = Number(prod.price) || 0;
            productCount[id] = (productCount[id] || 0) + quantity;
            userOrderTotal += price * quantity;
            userProductCount += quantity;
          });
        } else if (product) {
          // If only one product
          const id = product.id || product.productId || product.name || "unknown";
          const quantity = Number(product.quantity) || 1;
          const price = Number(product.price) || 0;
          productCount[id] = (productCount[id] || 0) + quantity;
          userOrderTotal += price * quantity;
          userProductCount += quantity;
        }
      });

      orderAmount += userOrderTotal;

      userPurchaseMap[userDoc.id] = {
        total: userOrderTotal,
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
    setTotalOrderAmount(orderAmount);
    setTotalUsers(userWithOrder);
    setUniqueProducts(Object.keys(productCount).length);
  };

  // For single bar, add a dummy bar to make it touch the bottom
  const topUserChartData =
    topUserData.length === 1
      ? [{ ...topUserData[0] }, { name: "", total: 0 }]
      : topUserData;

  // When page loads, do not fetch data until filter or clear filter is clicked
  // Clear filter resets all data and filter state
  const handleClearFilter = () => {
    setStartDate("");
    setEndDate("");
    setFilterError("");
    setHasFiltered(false);
    setData([]);
    setTopUserData([]);
    setTotalProducts(0);
    setTotalOrderAmount(0);
    setTotalUsers(0);
    setUniqueProducts(0);
  };

  return (
    <div className="bestseller-dashboard">
      <div className="bestseller-header">
        <Button
          variant="secondary"
          className="back-btn"
          onClick={() => navigate("/dashboard/products")}
        >
          ← Quản lý sản phẩm
        </Button>
        <h2 className="bestseller-title">Thống kê Doanh số</h2>
        <div style={{ width: 120 }} />
      </div>

      {/* Filter */}
      <div className="bestseller-filter-row">
        <Form className="bestseller-filter-form" onSubmit={handleFilter}>
          <div className="filter-group">
            <Form.Label>Từ ngày</Form.Label>
            <Form.Control
              type="date"
              value={startDate}
              onChange={e => setStartDate(e.target.value)}
              className="filter-date"
            />
          </div>
          <div className="filter-group">
            <Form.Label>Đến ngày</Form.Label>
            <Form.Control
              type="date"
              value={endDate}
              onChange={e => setEndDate(e.target.value)}
              className="filter-date"
            />
          </div>
          <div className="filter-btn-group">
            <Button
              variant="primary"
              className="filter-apply-btn"
              type="submit"
            >
              Lọc
            </Button>
            <Button
              variant="outline-secondary"
              className="filter-clear-btn"
              type="button"
              onClick={handleClearFilter}
            >
              Xoá
            </Button>
          </div>
        </Form>
      </div>
      {filterError && (
        <div className="bestseller-filter-error">
          <Alert variant="danger" className="py-2 px-3 mb-3">{filterError}</Alert>
        </div>
      )}

      <div className="row g-4">
        {/* Best seller products chart */}
        <div className="col-lg-6 col-12">
          <div className="bestseller-chart-card">
            <div className="bestseller-chart-title">Top Sản phẩm Bán chạy nhất</div>
            {!hasFiltered || data.length === 0 ? (
              <div className="bestseller-chart-empty">
                Không có dữ liệu để hiển thị biểu đồ.
              </div>
            ) : (
              <ResponsiveContainer width="100%" height={380}>
                <BarChart
                  data={data.length === 1 ? [{ ...data[0] }, { name: "", orders: 0 }] : data}
                  margin={{ top: 20, right: 20, left: 0, bottom: 0 }}
                  maxBarSize={60}
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
                    formatter={(value, name) => [
                      value,
                      name === "orders" ? "Số lượng đã bán" : name,
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
                    name="Số lượng đã bán"
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
        </div>
        {/* Top user chart */}
        <div className="col-lg-6 col-12">
          <div className="bestseller-chart-card">
            <div className="bestseller-chart-title">Top Khách hàng Chi tiêu nhiều nhất</div>
            {!hasFiltered || topUserData.length === 0 ? (
              <div className="bestseller-chart-empty">
                Không có dữ liệu để hiển thị biểu đồ.
              </div>
            ) : (
              <ResponsiveContainer width="100%" height={380}>
                <BarChart
                  data={topUserChartData}
                  margin={{ top: 20, right: 20, left: 0, bottom: 0 }}
                  maxBarSize={60}
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
                    tickFormatter={(value) => value.toLocaleString("vi-VN")}
                  />
                  <Tooltip
                    contentStyle={{
                      borderRadius: 8,
                      border: "none",
                      boxShadow: "0 2px 8px #eee",
                      fontWeight: 500,
                      fontSize: 15,
                    }}
                    formatter={(value, name) => [
                      value.toLocaleString("vi-VN", { style: "currency", currency: "VND" }),
                      name === "total" ? "Tổng đã mua" : name,
                    ]}
                    labelFormatter={(label, payload) => {
                      if (!payload || !payload.length) return label;
                      const fullName = payload[0]?.payload?.fullName;
                      const productCount = payload[0]?.payload?.productCount;
                      return (
                        <span>
                          {fullName || label}
                          <br />
                          Sản phẩm đã mua: {productCount ?? 0}
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
                    name="Tổng đã mua"
                    radius={[8, 8, 0, 0]}
                    label={{
                      position: "top",
                      fontWeight: 600,
                      fill: "#8f5aff",
                      formatter: (value) => value.toLocaleString("vi-VN", { style: "currency", currency: "VND", minimumFractionDigits: 0, maximumFractionDigits: 0 }),
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
        </div>
      </div>

      {/* Metrics */}
      <div className="dashboard-metrics mt-5">
        <div className="metrics-row">
          <div className="metric-card primary">
            <div className="metric-value">{totalProducts}</div>
            <div className="metric-label">Tổng sản phẩm</div>
          </div>
          <div className="metric-card info">
            <div className="metric-value">
              {totalOrderAmount.toLocaleString("vi-VN", { style: "currency", currency: "VND" })}
            </div>
            <div className="metric-label">Tổng giá trị đơn hàng</div>
          </div>
        </div>
        <div className="metrics-row">
          <div className="metric-card success">
            <div className="metric-value">{totalUsers}</div>
            <div className="metric-label">Khách hàng có đơn hàng</div>
          </div>
          <div className="metric-card warning">
            <div className="metric-value">{uniqueProducts}</div>
            <div className="metric-label">Sản phẩm đã bán (độc nhất)</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default BestSellerChart;