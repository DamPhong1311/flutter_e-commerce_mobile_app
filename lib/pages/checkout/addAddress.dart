import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:ecommerece_flutter_app/services/checkout_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerece_flutter_app/common/constants/colors.dart';

import '../../models/address_model.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  String _province = 'Ho Chi Minh city';
  String _district = 'District 1';
  String _ward = 'Ward A';

  void _saveAddress() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _detailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill in all the required information!")),
      );
      return;
    }

  
    Address newAddress = Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Tạo ID tạm thời
      name: _nameController.text,
      phone: _phoneController.text,
      province: _province,
      district: _district,
      ward: _ward,
      detail: _detailController.text,
    );

    AddressService().saveAddress(AuthService().getUserId(), newAddress);
    // Trả về địa chỉ mới cho CheckoutPage
    Navigator.pop(context, newAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Address")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: _province,
              items: ["Ho Chi Minh city", "Ha Noi city"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _province = value.toString()),
              decoration: const InputDecoration(labelText: "Province/City"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: _district,
              items: ["District 1", "District 2", "District 3"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _district = value.toString()),
              decoration: const InputDecoration(labelText: "District"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: _ward,
              items: ["Ward A", "Ward B", "Ward C"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => _ward = value.toString()),
              decoration: const InputDecoration(labelText: "Ward"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _detailController,
              decoration: const InputDecoration(labelText: "Detail"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: KColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Save Address",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
