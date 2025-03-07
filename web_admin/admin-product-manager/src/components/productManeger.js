import React, { useState, useEffect } from "react";
import { db } from "../firebaseConfigs";
import { collection, addDoc, updateDoc, doc, deleteDoc, onSnapshot } from "firebase/firestore";
import { Button, Form, Table, Modal } from "react-bootstrap";
import "./productManeger.css"
const ProductManager = () => {
  const [products, setProducts] = useState([]);
  const [filteredProducts, setFilteredProducts] = useState([]);
  const [searchTerm, setSearchTerm] = useState(""); // Thêm state cho từ khóa tìm kiếm
  const [show, setShow] = useState(false);
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
      setFilteredProducts(productList); // Set danh sách sản phẩm đã lọc ban đầu là tất cả sản phẩm
      setCategories([...new Set(productList.map((p) => p.category))]);
      setStores([...new Set(productList.map((p) => p.store))]);
    });
    return () => unsubscribe();
  }, []);

  // Hàm tìm kiếm
  const handleSearchChange = (e) => {
    const value = e.target.value;
    setSearchTerm(value);
    if (value.trim() === "") {
      setFilteredProducts(products); // Nếu không có từ khóa tìm kiếm, hiển thị tất cả sản phẩm
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

  const handleShow = () => {
    setFormData({
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
    setShow(true);
  };

  const handleClose = () => setShow(false);
  const handleEditShow = (product) => {
    setEditData(product);
    setFormData(product); // Set formData with the selected product's data
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
    const imageGalleryArray = formData.imageGallery.split("\n").map((url) => url.trim());
    const newProduct = {
      ...formData,
      priceProduct: parseFloat(formData.priceProduct), // Convert priceProduct to number
      oldPrice: parseFloat(formData.oldPrice), // Convert oldPrice to number
      imageGallery: imageGalleryArray,
    };
    await addDoc(collection(db, "products"), newProduct);
    setShow(false);
  };

  const handleEditSubmit = async () => {
    const imageGalleryArray = typeof formData.imageGallery === "string" 
      ? formData.imageGallery.split("\n").map((url) => url.trim()) 
      : formData.imageGallery; // Nếu imageGallery là mảng, không cần chia tách lại
  
    const updatedProduct = {
      ...formData,
      priceProduct: parseFloat(formData.priceProduct),
      oldPrice: parseFloat(formData.oldPrice),
      imageGallery: imageGalleryArray,
    };
  
    if (editData && editData.id) {
      await updateDoc(doc(db, "products", editData.id), updatedProduct);
      setEditShow(false);
    }
  };
  

  return (
    <div className="container mt-4">
      <h2 className="text-center mb-4">Product Management</h2>
      
      {/* Thanh tìm kiếm */}
      <Form.Control
        type="text"
        placeholder="Search by product name"
        value={searchTerm}
        onChange={handleSearchChange}
        className="mb-3"
      />
      
      <Button variant="primary" onClick={handleShow}>+ Add Product</Button>

      <Table striped bordered hover className="mt-3">
        <thead>
          <tr>
            <th>Image</th>
            <th>Product Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Old Price</th>
            <th>Sale Percent</th>
            <th>Category</th>
            <th>Store</th>
            <th>On Sale</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {filteredProducts.map((product) => (
            <tr key={product.id}>
              <td><img src={product.imageUrl} alt={product.name} width="50" /></td>
              <td>{product.name}</td>
              <td>{product.description}</td>
              <td>{product.priceProduct.toLocaleString()}đ</td>
              <td>{product.oldPrice.toLocaleString()}đ</td>
              <td>{product.salePercent}</td>
              <td>{product.category}</td>
              <td>{product.store}</td>
              <td>{product.isSale ? "Yes" : "No"}</td>
              <td>
                <Button variant="warning" size="sm" onClick={() => handleEditShow(product)}>Edit</Button>
                <Button variant="danger" size="sm" className="ms-2" onClick={() => handleDelete(product.id)}>Delete</Button>
              </td>
            </tr>
          ))}
        </tbody>
      </Table>

      {/* Modal Add Product */}
      <Modal show={show} onHide={handleClose} centered>
        <Modal.Header closeButton>
          <Modal.Title>Add Product</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group>
              <Form.Label>Category</Form.Label>
              <Form.Control as="select" name="category" value={formData.category} onChange={handleChange}>
                <option value="">Select or Enter New</option>
                {categories.map((cat, index) => (
                  <option key={index} value={cat}>{cat}</option>
                ))}
              </Form.Control>
              <Form.Control type="text" name="category" placeholder="Enter new category" onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Store</Form.Label>
              <Form.Control as="select" name="store" value={formData.store} onChange={handleChange}>
                <option value="">Select or Enter New</option>
                {stores.map((store, index) => (
                  <option key={index} value={store}>{store}</option>
                ))}
              </Form.Control>
              <Form.Control type="text" name="store" placeholder="Enter new store" onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Name</Form.Label>
              <Form.Control type="text" name="name" value={formData.name} onChange={handleChange} required />
            </Form.Group>
            <Form.Group>
              <Form.Label>Description</Form.Label>
              <Form.Control as="textarea" name="description" value={formData.description} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Image URL</Form.Label>
              <Form.Control type="text" name="imageUrl" value={formData.imageUrl} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Image Gallery (One per line)</Form.Label>
              <Form.Control as="textarea" name="imageGallery" value={formData.imageGallery} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Price</Form.Label>
              <Form.Control type="number" name="priceProduct" value={formData.priceProduct} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Old Price</Form.Label>
              <Form.Control type="number" name="oldPrice" value={formData.oldPrice} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Sale Percent</Form.Label>
              <Form.Control type="text" name="salePercent" value={formData.salePercent} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Check label="On Sale"  type="checkbox" name="isSale" checked={formData.isSale} onChange={handleChange} />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleClose}>Cancel</Button>
          <Button variant="primary" onClick={handleSubmit}>Save</Button>
        </Modal.Footer>
      </Modal>

      {/* Modal Edit Product */}
      <Modal show={editShow} onHide={handleEditClose} centered>
        <Modal.Header closeButton>
          <Modal.Title>Edit Product</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group>
              <Form.Label>Category</Form.Label>
              <Form.Control as="select" name="category" value={formData.category} onChange={handleChange}>
                <option value="">Select or Enter New</option>
                {categories.map((cat, index) => (
                  <option key={index} value={cat}>{cat}</option>
                ))}
              </Form.Control>
              <Form.Control type="text" name="category" placeholder="Enter new category" onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Store</Form.Label>
              <Form.Control as="select" name="store" value={formData.store} onChange={handleChange}>
                <option value="">Select or Enter New</option>
                {stores.map((store, index) => (
                  <option key={index} value={store}>{store}</option>
                ))}
              </Form.Control>
              <Form.Control type="text" name="store" placeholder="Enter new store" onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Name</Form.Label>
              <Form.Control type="text" name="name" value={formData.name} onChange={handleChange} required />
            </Form.Group>
            <Form.Group>
              <Form.Label>Description</Form.Label>
              <Form.Control as="textarea" name="description" value={formData.description} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Image URL</Form.Label>
              <Form.Control type="text" name="imageUrl" value={formData.imageUrl} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Image Gallery (One per line)</Form.Label>
              <Form.Control as="textarea" name="imageGallery" value={formData.imageGallery} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Price</Form.Label>
              <Form.Control type="number" name="priceProduct" value={formData.priceProduct} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Old Price</Form.Label>
              <Form.Control type="number" name="oldPrice" value={formData.oldPrice} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Label>Sale Percent</Form.Label>
              <Form.Control type="text" name="salePercent" value={formData.salePercent} onChange={handleChange} />
            </Form.Group>
            <Form.Group>
              <Form.Check label="On Sale" type="checkbox"  name="isSale" checked={formData.isSale} onChange={handleChange} />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleEditClose}>Cancel</Button>
          <Button variant="primary" onClick={handleEditSubmit}>Save</Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default ProductManager;
