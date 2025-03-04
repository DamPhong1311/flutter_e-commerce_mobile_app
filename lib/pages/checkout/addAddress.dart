import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEditAddressPage extends StatefulWidget {
  final Map<String, dynamic>? address;

  const AddEditAddressPage({Key? key, this.address}) : super(key: key);

  @override
  _AddEditAddressPageState createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedWard;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _nameController.text = widget.address!['name'];
      _phoneController.text = widget.address!['phone'];
      _detailController.text = widget.address!['detail'];
      _selectedProvince = widget.address!['province'];
      _selectedDistrict = widget.address!['district'];
      _selectedWard = widget.address!['ward'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Thêm địa chỉ' : 'Sửa địa chỉ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              // Thêm các trường tỉnh, huyện, xã và địa chỉ cụ thể
              ElevatedButton(
                onPressed: _saveAddress,
                child: const Text('Lưu địa chỉ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final address = {
        'id': widget.address?['id'] ?? DateTime.now().toString(),
        'name': _nameController.text,
        'phone': _phoneController.text,
        'province': _selectedProvince!,
        'district': _selectedDistrict!,
        'ward': _selectedWard!,
        'detail': _detailController.text,
      };

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .doc(address['id'])
            .set(address);
      }

      Navigator.pop(context);
    }
  }
}
