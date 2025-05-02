import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/HomeScreen.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Container(
                color: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Sanae Delamont',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'delamont@mes.jp',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Section Title
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
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
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
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
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
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
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
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

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildSettingsItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  hasChevron: true,
                ),
              ),

              // Danger Zone Section
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  }) {
    return Padding(
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
