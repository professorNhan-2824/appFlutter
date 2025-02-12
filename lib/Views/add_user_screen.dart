import 'package:flutter/material.dart';
import '../config/api_nodejs.dart';  // Import API
import '../model/user.dart';  // Import model User

class addUserScreen extends StatefulWidget {
  @override
  _addUserScreenState createState() => _addUserScreenState();
}

class _addUserScreenState extends State<addUserScreen> {
  final Text_name = TextEditingController();
  final Text_email = TextEditingController();
  bool isLoading = false;

  // Hàm gửi dữ liệu user lên server
  Future<void> submitUser() async {
    setState(() => isLoading = true);

    final response = await ApiService.addUser(
      Text_name.text,
      Text_email.text,
    );

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'])),
    );
    Navigator.pop(context, true);
  }
  // taọ form nhập thông tin user
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thêm người dùng")),
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
              child: Text("Thêm người dùng"),
            )
          ],
        )
      )
    );
  }
}

