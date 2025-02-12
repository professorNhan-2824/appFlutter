import 'package:flutter/material.dart';
import '../config/api_nodejs.dart';  // Import API
import '../model/user.dart';  // Import model User
import 'add_user_screen.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<User>> futureUsers;

  void navigationToaddUser(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => addUserScreen()),
    );

    if(result == true){
      setState(() {
        futureUsers = ApiService.getAllUsers();
      });
    }
  }
  @override
  void initState() {
    super.initState();
    futureUsers = ApiService.getAllUsers();  // Gọi API lấy dữ liệu user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách người dùng")),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Đang tải dữ liệu
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}")); // Lỗi API
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có dữ liệu")); // Không có dữ liệu
          }
          List<User> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationToaddUser(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
