import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/models/cart_item.dart';
import 'package:ecommerece_flutter_app/pages/checkout/addAddress.dart'; // Import trang thêm/sửa địa chỉ

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _paymentMethod = 'Credit Card';
  List<Map<String, dynamic>> _addresses = [];
  Map<String, dynamic>? _selectedAddress;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // Lấy danh sách địa chỉ từ Firestore
  Future<void> _loadAddresses() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .get();
      setState(() {
        _addresses = snapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  // Chọn địa chỉ
  void _selectAddress(Map<String, dynamic> address) {
    setState(() {
      _selectedAddress = address;
      _nameController.text = address['name'];
      _phoneController.text = address['phone'];
      _addressController.text =
          '${address['detail']}, ${address['ward']}, ${address['district']}, ${address['province']}';
    });
  }

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      // Xử lý đặt hàng
      print('Order placed!');
      print('Name: ${_nameController.text}');
      print('Address: ${_addressController.text}');
      print('Phone: ${_phoneController.text}');
      print('Payment Method: $_paymentMethod');
      print('Total Price: ${Helper.formatCurrency(widget.totalPrice.toInt())}');

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );

      // Điều hướng về trang chủ hoặc trang cảm ơn
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: KColors.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị thông tin đơn hàng
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...widget.cartItems
                              .map((item) => _buildCartItem(item)),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                Helper.formatCurrency(
                                    widget.totalPrice.toInt()),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: KColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Hiển thị danh sách địa chỉ đã lưu
                  if (_addresses.isNotEmpty) ...[
                    const Text(
                      'Saved Addresses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._addresses.map((address) => _buildAddressCard(address)),
                    const SizedBox(height: 20),
                  ],
                  // Nút "Thêm địa chỉ mới"
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditAddressPage(),
                        ),
                      );
                      _loadAddresses(); // Tải lại danh sách địa chỉ sau khi thêm/sửa
                    },
                    child: const Text('Thêm địa chỉ mới'),
                  ),
                  const SizedBox(height: 20),
                  // Form nhập thông tin thanh toán
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                                hintText: 'Enter your address',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: _paymentMethod,
                              items:
                                  ['Credit Card', 'PayPal', 'Cash on Delivery']
                                      .map((method) => DropdownMenuItem(
                                            value: method,
                                            child: Text(method),
                                          ))
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _paymentMethod = value!;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Payment Method',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // Nút "Place Order" ở dưới cùng
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: KColors.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget để hiển thị thông tin sản phẩm trong giỏ hàng
  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Số lượng: ${item.quantity}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            Helper.formatCurrency(item.total.toInt()),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: KColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget để hiển thị địa chỉ dưới dạng card
  Widget _buildAddressCard(Map<String, dynamic> address) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          address['name'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${address['detail']}, ${address['ward']}, ${address['district']}, ${address['province']}\n${address['phone']}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: () => _selectAddress(address),
        ),
      ),
    );
  }
}
