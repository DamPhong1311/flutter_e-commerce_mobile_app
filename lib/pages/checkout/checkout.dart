import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerece_flutter_app/pages/checkout/payment_success.dart';
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
  String _paymentMethod = "Cash_on_delivery".tr();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check_Out".tr()),
        elevation: 1,
        iconTheme: IconThemeData(
            color: Helper.isDarkMode(context)
                ? KColors.dartModeColor
                : Colors.black),
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
                        Text("Product".tr(),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Text(
                                        "${_selectedAddress!.detail}, ${_selectedAddress!.ward}, ${_selectedAddress!.district}, ${_selectedAddress!.province}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge),
                                  ],
                                )
                              : Text("add_address_empty".tr()),
                        ),
                        GestureDetector(
                          onTap: _showAddressSelectionDialog,
                          child: const Icon(Icons.arrow_forward_ios, size: 16),
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
                        Text("Payment".tr(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _paymentMethod,
                          items: [
                            "Cash_on_delivery".tr(),
                            "Visa".tr(),
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
                    Text("Total".tr(),
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
                  child: Text("Place_Order".tr(),
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressSelectionDialog() async {
    final addresses = await _addressService.getAddresses();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select_Address".tr()),
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
              child: Text("Cancel".tr()),
            ),
            TextButton(
              onPressed: _navigateToAddAddress,
              child: Text("Add_New_Address".tr()),
            ),
          ],
        );
      },
    );
  }

  void _placeOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please_add_shipping_address!".tr())),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm_Order".tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Confirm_notification".tr()),
              const SizedBox(height: 16),
              Text("total_price".tr(
                  args: [Helper.formatCurrency(widget.totalPrice.toInt())])),
              const SizedBox(height: 8),
              Text("payment_method".tr(namedArgs: {"method": _paymentMethod})),
              const SizedBox(height: 8),
              Text("address"
                  .tr(namedArgs: {"address": _selectedAddress!.fullAddress})),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel".tr()),
            ),
            TextButton(
              onPressed: () async {
                String userId = AuthService().getUserId();
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('ordered')
                    .add({
                  "address": _selectedAddress!.toMap(),
                  "paymentMethod": _paymentMethod,
                  "totalPrice": widget.totalPrice,
                  "status": "Pending",
                  "product": {
                    "name": widget.cartItem.name,
                    "imageUrl": widget.cartItem.imageUrl,
                    "price": widget.cartItem.price,
                    "quantity": widget.cartItem.quantity,
                    "total": widget.cartItem.total,
                  },
                  "createdAt": FieldValue.serverTimestamp(),
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentSuccessScreen()));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Check_Out_Success".tr())),
                );
                await NotificationService.addNotification(
                    AuthService().getUserId(),
                    "You have successfully ordered ${widget.cartItem.name}! Thank you!");
              },
              child: Text("Confirm".tr()),
            ),
          ],
        );
      },
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
