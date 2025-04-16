import 'package:flutter/material.dart';
import 'package:flutter_app/config/api_nodejs.dart';
import 'package:flutter_app/model/user.dart';

class addUserScreen extends StatefulWidget {
  final User? user; // Nếu null thì là thêm mới, ngược lại là sửa

  addUserScreen({this.user});

  @override
  _addUserScreenState createState() => _addUserScreenState();
}

class _addUserScreenState extends State<addUserScreen> {
  final TextEditingController Text_name = TextEditingController();
  final TextEditingController Text_email = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Nếu có user, điền thông tin cũ vào form
    if (widget.user != null) {
      Text_name.text = widget.user!.name;
      Text_email.text = widget.user!.email;
    }
  }

  // Hàm xử lý khi nhấn nút thêm / sửa
  Future<void> submitUser() async {
    setState(() => isLoading = true);

    Map<String, dynamic> response;

    if (widget.user != null) {
      // Sửa user
      response = await ApiService.updateUser(
        widget.user!.id,
        Text_name.text,
        Text_email.text,
      );
    } else {
      // Thêm user
      response = await ApiService.addUser(
        Text_name.text,
        Text_email.text,
      );
    }

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'])),
    );

    if (response['success']) {
      Navigator.pop(context, true); // Trả về true để reload lại danh sách
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Sửa người dùng" : "Thêm người dùng"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: Text_name,
              decoration: InputDecoration(labelText: "Tên"),
            ),
            TextField(
              controller: Text_email,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: submitUser,
                    child: Text(
                        isEdit ? "Cập nhật người dùng" : "Thêm người dùng"),
                  )
          ],
        ),
      ),
    );
  }
}
