class Address {
  final String id;
  final String name;
  final String phone;
  final String province;
  final String district;
  final String ward;
  final String detail;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.province,
    required this.district,
    required this.ward,
    required this.detail,
  });

  // Chuyển đổi thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'province': province,
      'district': district,
      'ward': ward,
      'detail': detail,
    };
  }

  // Tạo đối tượng Address từ Map
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      province: map['province'],
      district: map['district'],
      ward: map['ward'],
      detail: map['detail'],
    );
  }

  String get fullAddress {
    return '$detail, $ward, $district, $province';
  }
}
