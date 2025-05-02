import 'package:flutter/material.dart';
import 'package:flutter_app/Services/AuthService.dart';
import 'package:flutter_app/Views/Screens/HomeScreen.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final AuthService _authService = AuthService();
  String userName = '';
  String userEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Tải thông tin người dùng từ local storage
  Future<void> _loadUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.getUserData();

      if (user != null) {
        setState(() {
          userName = user.name;
          userEmail = user.email;
        });
      }
    } catch (e) {
      print('Lỗi khi tải thông tin người dùng: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Xử lý đăng xuất
  Future<void> _handleSignOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.logout();

      if (result['success']) {
        // Chuyển về màn hình đăng nhập sau khi đăng xuất
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Đăng xuất thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã có lỗi xảy ra: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Điều hướng về màn hình Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BirdRecognitionUI()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Section
                    Container(
                      color: const Color.fromRGBO(80, 199, 143, 1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child:
                                  const Icon(Icons.person, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hiển thị tên người dùng từ dữ liệu API
                                Text(
                                  userName.isEmpty
                                      ? 'Chưa đăng nhập'
                                      : userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                // Hiển thị email người dùng từ dữ liệu API
                                Text(
                                  userEmail.isEmpty ? 'Unknown' : userEmail,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    // Section Title
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'General Settings',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),

                    // General Settings Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            icon: Icons.card_membership_outlined,
                            title: 'Select license',
                            hasChevron: true,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: Icons.filter_alt_outlined,
                            title: 'Change State',
                            hasChevron: true,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: Icons.info_outline,
                            title: 'Reference Information',
                            hasChevron: true,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: Icons.bookmark_outline,
                            title: 'Bookmarked question',
                            hasChevron: true,
                          ),
                        ],
                      ),
                    ),

                    // Accessibility Section
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Accessibility',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            icon: Icons.language_outlined,
                            title: 'Language',
                            hasChevron: true,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: Icons.share_outlined,
                            title: 'Share & earn',
                            hasChevron: true,
                          ),
                        ],
                      ),
                    ),

                    // Help & Support Section
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Help & Support',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            icon: Icons.info_outline,
                            title: 'About',
                            hasChevron: true,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: Icons.help_outline,
                            title: 'Help Center',
                            hasChevron: true,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            icon: Icons.call_outlined,
                            title: 'Contact Us',
                            hasChevron: true,
                          ),
                        ],
                      ),
                    ),

                    // Sign Out Section
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),

                    // Kết nối nút Sign Out với hàm đăng xuất
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: _isLoading ? null : _handleSignOut,
                        child: _buildSettingsItem(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          hasChevron: true,
                        ),
                      ),
                    ),

                    // Danger Zone Section
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'Danger Zone',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.grey, size: 18),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildSettingsItem(
                        icon: Icons.delete_outline,
                        title: 'Delete Account',
                        hasChevron: true,
                        isDestructive: true,
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    bool hasChevron = false,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDestructive ? Colors.red : Colors.black87,
                ),
              ),
            ),
            if (hasChevron)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 68,
      endIndent: 16,
      color: Colors.grey[200],
    );
  }
}
