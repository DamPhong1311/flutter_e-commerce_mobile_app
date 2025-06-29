import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { db } from "../firebaseConfigs";
import { collection, addDoc, updateDoc, doc, deleteDoc, onSnapshot } from "firebase/firestore";
// Thêm Row, Col để chia cột
import { Button, Form, Table, Modal, Row, Col } from "react-bootstrap";
// Dùng file CSS bạn đã xác nhận là ổn
import "./productManeger.css";

const ProductManager = () => {
  const navigate = useNavigate();

  const [products, setProducts] = useState([]);
  const [filteredProducts, setFilteredProducts] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [show, setShow] = useState(false); // State để điều khiển pop-up (modal)
  const [editShow, setEditShow] = useState(false);
  const [editData, setEditData] = useState(null);
  const [categories, setCategories] = useState([]);
  const [stores, setStores] = useState([]);
  const [formData, setFormData] = useState({
    name: "",
    category: "",
    description: "",
    priceProduct: "",
    oldPrice: "",
    salePercent: "",
    imageUrl: "",
    imageGallery: "",
    store: "",
    isSale: false,
  });

  useEffect(() => {
    const unsubscribe = onSnapshot(collection(db, "products"), (snapshot) => {
      const productList = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
      setProducts(productList);
      setFilteredProducts(productList);
      setCategories([...new Set(productList.map((p) => p.category))]);
      setStores([...new Set(productList.map((p) => p.store))]);
    });
    return () => unsubscribe();
  }, []);

  const handleSearchChange = (e) => {
    const value = e.target.value;
    setSearchTerm(value);
    if (value.trim() === "") {
      setFilteredProducts(products);
    } else {
      const filtered = products.filter((product) =>
        product.name.toLowerCase().includes(value.toLowerCase())
      );
      setFilteredProducts(filtered);
    }
  };

  const handleDelete = async (id) => {
    await deleteDoc(doc(db, "products", id));
  };

  // Khi bấm nút, bật state 'show' lên true để modal hiện ra
  const handleShow = () => {
    setFormData({
      name: "", category: "", description: "", priceProduct: "", oldPrice: "",
      salePercent: "", imageUrl: "", imageGallery: "", store: "", isSale: false,
    });
    setShow(true);
  };

  // Khi đóng modal, set state 'show' về false
  const handleClose = () => setShow(false);

  const handleEditShow = (product) => {
    setEditData(product);
    // Chuyển imageGallery từ mảng về chuỗi để hiển thị trong textarea
    const productData = {
      ...product,
      imageGallery: Array.isArray(product.imageGallery) ? product.imageGallery.join('\n') : ''
    };
    setFormData(productData);
    setEditShow(true);
  };
  const handleEditClose = () => setEditShow(false);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData({
      ...formData,
      [name]: type === "checkbox" ? checked : value,
    });
  };

  const handleSubmit = async () => {
    const imageGalleryArray = formData.imageGallery.split("\n").map((url) => url.trim()).filter(url => url);
    const newProduct = {
      ...formData,
      priceProduct: parseFloat(formData.priceProduct) || 0,
      oldPrice: parseFloat(formData.oldPrice) || 0,
      imageGallery: imageGalleryArray,
    };
    await addDoc(collection(db, "products"), newProduct);
    handleClose(); // Đóng modal sau khi lưu
  };

  const handleEditSubmit = async () => {
    const imageGalleryArray = typeof formData.imageGallery === "string" 
      ? formData.imageGallery.split("\n").map((url) => url.trim()).filter(url => url)
      : formData.imageGallery;
  
    const updatedProduct = {
      ...formData,
      priceProduct: parseFloat(formData.priceProduct) || 0,
      oldPrice: parseFloat(formData.oldPrice) || 0,
      imageGallery: imageGalleryArray,
    };
  
    if (editData && editData.id) {
      await updateDoc(doc(db, "products", editData.id), updatedProduct);
      handleEditClose(); // Đóng modal sau khi lưu
    }
  };

  return (
    <div className="container mt-4">
      <h2 className="text-center mb-4">Product Management</h2>
      <div className="d-flex justify-content-between align-items-center mb-3">
        <Button variant="primary" onClick={handleShow}>+ Add Product</Button>
        <Button variant="secondary" onClick={() => navigate("/dashboard/users")}>
          Manage Users
        </Button>
        <Button variant="info" onClick={() => navigate("/dashboard/best-seller-chart")}>
            Charts
          </Button>
      </div>
      <Form.Control
        type="text"
        placeholder="Search by product name"
        value={searchTerm}
        onChange={handleSearchChange}
        className="mb-3"
      />

      {/* Phần bảng hiển thị sản phẩm */}
      <Table striped bordered hover responsive className="table-container">
        <thead>
          <tr>
            <th>Image</th><th>Product Name</th><th>Description</th><th>Price</th><th>Old Price</th>
            <th>Sale Percent</th><th>Category</th><th>Store</th><th>On Sale</th><th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {filteredProducts.map((product) => (
            <tr key={product.id}>
              <td><img src={product.imageUrl} alt={product.name} /></td>
              <td>{product.name}</td><td>{product.description}</td>
              <td>{product.priceProduct?.toLocaleString()}đ</td>
              <td>{product.oldPrice?.toLocaleString()}đ</td>
              <td>{product.salePercent}</td><td>{product.category}</td>
              <td>{product.store}</td><td>{product.isSale ? "Yes" : "No"}</td>
              <td>
                <div className="action-buttons">
                  <Button variant="warning" size="sm" onClick={() => handleEditShow(product)}>Edit</Button>
                  <Button variant="danger" size="sm" onClick={() => handleDelete(product.id)}>Delete</Button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </Table>

      {/* ĐÂY LÀ POP-UP ADD PRODUCT */}
      <Modal
        show={show}
        onHide={handleClose}
        dialogClassName="modal-fullscreen-custom"
      >
        <Modal.Header closeButton>
          <Modal.Title>Add Product</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group className="mb-3">
              <Form.Label>Name</Form.Label>
              <Form.Control type="text" name="name" value={formData.name} onChange={handleChange} required />
            </Form.Group>
            <Row className="mb-3">
              <Col md={6}>
                <Form.Group>
                  <Form.Label>Category</Form.Label>
                  <Form.Control as="select" name="category" value={formData.category} onChange={handleChange}>
                    <option value="">Select or Enter New</option>
                    {categories.map((cat, index) => (<option key={index} value={cat}>{cat}</option>))}
                  </Form.Control>
                  <Form.Control className="mt-2" type="text" name="category" placeholder="Or enter new category" onChange={handleChange} />
                </Form.Group>
              </Col>
              <Col md={6}>
                <Form.Group>
                  <Form.Label>Store</Form.Label>
                  <Form.Control as="select" name="store" value={formData.store} onChange={handleChange}>
                    <option value="">Select or Enter New</option>
                    {stores.map((store, index) => (<option key={index} value={store}>{store}</option>))}
                  </Form.Control>
                  <Form.Control className="mt-2" type="text" name="store" placeholder="Or enter new store" onChange={handleChange} />
                </Form.Group>
              </Col>
            </Row>
            <Form.Group className="mb-3">
              <Form.Label>Description</Form.Label>
              <Form.Control as="textarea" rows={2} name="description" value={formData.description} onChange={handleChange} />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Image URL</Form.Label>
              <Form.Control type="text" name="imageUrl" value={formData.imageUrl} onChange={handleChange} />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Image Gallery (One per line)</Form.Label>
              <Form.Control as="textarea" rows={2} name="imageGallery" value={formData.imageGallery} onChange={handleChange} />
            </Form.Group>
            <Row className="mb-3">
              <Col md={4}><Form.Group><Form.Label>Price</Form.Label><Form.Control type="number" name="priceProduct" value={formData.priceProduct} onChange={handleChange} /></Form.Group></Col>
              <Col md={4}><Form.Group><Form.Label>Old Price</Form.Label><Form.Control type="number" name="oldPrice" value={formData.oldPrice} onChange={handleChange} /></Form.Group></Col>
              <Col md={4}><Form.Group><Form.Label>Sale Percent</Form.Label><Form.Control type="text" name="salePercent" value={formData.salePercent} onChange={handleChange} /></Form.Group></Col>
            </Row>
            <Form.Group>
              <Form.Check label="On Sale" type="checkbox" name="isSale" checked={formData.isSale} onChange={handleChange} />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleClose}>Cancel</Button>
          <Button variant="primary" onClick={handleSubmit}>Save Product</Button>
        </Modal.Footer>
      </Modal>

      {/* ĐÂY LÀ POP-UP EDIT PRODUCT */}
      <Modal
        show={editShow}
        onHide={handleEditClose}
        dialogClassName="modal-fullscreen-custom"
      >
        <Modal.Header closeButton>
          <Modal.Title>Edit Product</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group className="mb-3">
              <Form.Label>Name</Form.Label>
              <Form.Control type="text" name="name" value={formData.name} onChange={handleChange} required />
            </Form.Group>
            <Row className="mb-3">
              <Col md={6}>
                <Form.Group>
                  <Form.Label>Category</Form.Label>
                  <Form.Control as="select" name="category" value={formData.category} onChange={handleChange}>
                    <option value="">Select or Enter New</option>
                    {categories.map((cat, index) => (<option key={index} value={cat}>{cat}</option>))}
                  </Form.Control>
                  <Form.Control className="mt-2" type="text" name="category" placeholder="Or enter new category" onChange={handleChange} />
                </Form.Group>
              </Col>
              <Col md={6}>
                <Form.Group>
                  <Form.Label>Store</Form.Label>
                  <Form.Control as="select" name="store" value={formData.store} onChange={handleChange}>
                    <option value="">Select or Enter New</option>
                    {stores.map((store, index) => (<option key={index} value={store}>{store}</option>))}
                  </Form.Control>
                  <Form.Control className="mt-2" type="text" name="store" placeholder="Or enter new store" onChange={handleChange} />
                </Form.Group>
              </Col>
            </Row>
            <Form.Group className="mb-3">
              <Form.Label>Description</Form.Label>
              <Form.Control as="textarea" rows={2} name="description" value={formData.description} onChange={handleChange} />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Image URL</Form.Label>
              <Form.Control type="text" name="imageUrl" value={formData.imageUrl} onChange={handleChange} />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Image Gallery (One per line)</Form.Label>
              <Form.Control as="textarea" rows={2} name="imageGallery" value={formData.imageGallery} onChange={handleChange} />
            </Form.Group>
            <Row className="mb-3">
              <Col md={4}><Form.Group><Form.Label>Price</Form.Label><Form.Control type="number" name="priceProduct" value={formData.priceProduct} onChange={handleChange} /></Form.Group></Col>
              <Col md={4}><Form.Group><Form.Label>Old Price</Form.Label><Form.Control type="number" name="oldPrice" value={formData.oldPrice} onChange={handleChange} /></Form.Group></Col>
              <Col md={4}><Form.Group><Form.Label>Sale Percent</Form.Label><Form.Control type="text" name="salePercent" value={formData.salePercent} onChange={handleChange} /></Form.Group></Col>
            </Row>
            <Form.Group>
              <Form.Check label="On Sale" type="checkbox" name="isSale" checked={formData.isSale} onChange={handleChange} />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleEditClose}>Cancel</Button>
          <Button variant="primary" onClick={handleEditSubmit}>Save Changes</Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default ProductManager;