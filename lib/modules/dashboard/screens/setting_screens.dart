import 'package:flutter/material.dart';

class SettingScreens extends StatefulWidget {
  const SettingScreens({super.key});

  @override
  _SettingScreensState createState() => _SettingScreensState();
}

class _SettingScreensState extends State<SettingScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Avatar + Sign In
            ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 32, color: Colors.white),
              ),
              title: const Text('Sign In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: const Text('Sign in, more exciting!'),
              onTap: () {
                // TODO: Navigate to login screen
              },
            ),
            const SizedBox(height: 16),
            _buildDivider(),

            // Premium Member
            _buildSettingItem(
              icon: Icons.workspace_premium,
              iconColor: Colors.amber,
              title: 'Premium Member',
              onTap: () {},
              isBold: true,
            ),

            _buildSettingItem(
              icon: Icons.thumb_up_alt_outlined,
              iconColor: Colors.orange,
              title: 'Recommend to friends',
              onTap: () {},
            ),

            _buildSettingItem(
              icon: Icons.rate_review_outlined,
              iconColor: Colors.blue,
              title: 'Rate the app',
              onTap: () {},
            ),

            _buildSettingItem(
              icon: Icons.block,
              iconColor: Colors.redAccent,
              title: 'Block Ads',
              onTap: () {},
            ),

            _buildSettingItem(
              icon: Icons.settings,
              iconColor: Colors.grey,
              title: 'Settings',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color iconColor,
    bool isBold = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 1,
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.black12,
    );
  }
}
