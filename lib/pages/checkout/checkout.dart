import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerece_flutter_app/pages/checkout/addAddress.dart';
import 'package:ecommerece_flutter_app/models/cart_item.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';

import '../../models/address_model.dart';
import '../../services/checkout_service.dart';
import '../../services/notification_service.dart';

class CheckoutPage extends StatefulWidget {
  final CartItem cartItem;
  final double totalPrice;

  const CheckoutPage({
    Key? key,
    required this.cartItem,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Address? _selectedAddress;
  String _paymentMethod = "Cash on delivery";
  final AddressService _addressService = AddressService();

  void _navigateToAddAddress() async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAddressPage()),
    );

    if (newAddress != null) {
      setState(() {
        _selectedAddress = newAddress;
      });
    }
  }

  void _showAddressSelectionDialog() async {
    final addresses = await _addressService.getAddresses();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Address"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return ListTile(
                  title: Text(address.name),
                  subtitle: Text(address.fullAddress),
                  onTap: () {
                    setState(() {
                      _selectedAddress = address;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: _navigateToAddAddress,
              child: const Text("Add New Address"),
            ),
          ],
        );
      },
    );
  }

  void _placeOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add shipping address!")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Order"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Are you sure you want to place this order?"),
              const SizedBox(height: 16),
              Text(
                  "Total: ${Helper.formatCurrency(widget.totalPrice.toInt())}"),
              const SizedBox(height: 8),
              Text("Payment Method: $_paymentMethod"),
              const SizedBox(height: 8),
              Text("Address: ${_selectedAddress!.fullAddress}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                String userId = AuthService()
                    .getUserId(); // Giả sử có userId, bạn có thể lấy từ FirebaseAuth
                await FirebaseFirestore.instance.collection('users').doc(userId).collection('ordered').add({
              
                  "address": _selectedAddress!.toMap(),
                  "paymentMethod": _paymentMethod,
                  "totalPrice": widget.totalPrice,
                  "status": "Pending",
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Check Out Success!")),
                );
                 await NotificationService.addNotification(
                  AuthService().getUserId(),
                  'You have successfully ordered ${widget.cartItem.name}! Thank you!',
                );
                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Out"),
     
        elevation: 1,
        iconTheme: IconThemeData(color: Helper.isDarkMode(context) ? KColors.dartModeColor : Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Danh sách sản phẩm
                  Container(
                
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Product",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _buildCartItem(widget.cartItem)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Địa chỉ giao hàng
                  Container(
              
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on,
                            color: KColors.primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _selectedAddress != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${_selectedAddress!.name} - ${_selectedAddress!.phone}",
                                        style:Theme.of(context).textTheme.titleMedium),
                                    Text(
                                        "${_selectedAddress!.detail}, ${_selectedAddress!.ward}, ${_selectedAddress!.district}, ${_selectedAddress!.province}",
                                        style: Theme.of(context).textTheme.labelLarge),
                                  ],
                                )
                              : const Text(
                                  "Empty address, please add a new address"),
                        ),
                        GestureDetector(
                          onTap: _showAddressSelectionDialog,
                          child: const Icon(Icons.arrow_forward_ios,
                              size: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Phương thức thanh toán
                  Container(
                   
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Payment",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _paymentMethod,
                          items: [
                            "Cash on delivery",
                            "Visa",
                          ]
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
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Thanh toán
          Container(
            // color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("Total",
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      Helper.formatCurrency(widget.totalPrice.toInt()),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: KColors.primaryColor),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  child: Text("Place Order",
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return ListTile(
      leading: Image.network(item.imageUrl,
          width: 50, height: 50, fit: BoxFit.cover),
      title:
          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Quantity: ${item.quantity}"),
      trailing: Text(Helper.formatCurrency(item.total.toInt()),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: KColors.primaryColor)),
    );
  }
}
