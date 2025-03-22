import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  final List<Map<String, String>> teamMembers = [
    {
      "name": "Đàm Quang Phong",
      "mssv": "22010466",
      "role": "Làm trang chủ Home, tìm kiếm, giỏ hàng, trang tài khoản, đăng nhập đăng kí, kết nối firebase",
    },
    {
      "name": "Lại Quang Tuấn",
      "mssv": "22010438",
      "role": "Làm trang thông tin sản phẩm, thanh toán, trang thông báo, viết báo cáo",
    },
    {
      "name": "Trịnh Đức Việt",
      "mssv": "22010096",
      "role": "Làm trang Store, các phần chia loại sản phẩm, làm slide, tạo dữ liệu cho firestore database",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About_Us".tr()),
      
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: teamMembers.length,
          itemBuilder: (context, index) {
            final member = teamMembers[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(member["name"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("MSSV: ${member["mssv"]}\nĐóng góp: ${member["role"]}"),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(member["name"]![0], style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
