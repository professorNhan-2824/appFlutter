import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/add_user.dart';
import 'package:flutter_app/config/api_nodejs.dart';
import 'package:flutter_app/model/user.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<User>> futureUsers;

  void fetchUsers() {
    setState(() {
      futureUsers = ApiService.getAllUsers();
    });
  }

  void navigationToAddOrEditUser(BuildContext context, {User? user}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => addUserScreen(user: user), // truyền user nếu sửa
      ),
    );

    if (result == true) {
      fetchUsers(); // Load lại dữ liệu
    }
  }

  void deleteUser(String userId) async {
    final result = await ApiService.deleteUser(userId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? '')),
    );
    fetchUsers(); // Cập nhật lại danh sách
  }

  @override
  void initState() {
    super.initState();
    futureUsers = ApiService.getAllUsers(); // Gọi API lấy dữ liệu user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách người dùng")),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có dữ liệu"));
          }

          List<User> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => navigationToAddOrEditUser(context,
                          user: users[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteUser(users[index].id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationToAddOrEditUser(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
