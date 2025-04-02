import 'package:flutter/material.dart';
import 'dart:ui';
import 'user_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.deepPurple.shade50,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.deepPurple.shade50,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.deepPurple.shade700,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Profile',
        style: TextStyle(
          color: Colors.deepPurple.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.deepPurple.shade700,
          ),
          onPressed: () => _showOptionsMenu(),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.deepPurple.shade700,
        labelColor: Colors.deepPurple.shade700,
        unselectedLabelColor: Colors.deepPurple.shade300,
        tabs: const [
          Tab(text: 'Profile Info'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildBackgroundDecoration(),
        TabBarView(
          controller: _tabController,
          children: [
            _buildProfileTab(),
            _buildSettingsTab(),
          ],
        ),
      ],
    );
  }

  Widget _buildBackgroundDecoration() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple.shade200.withOpacity(0.3),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple.shade300.withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildProfileDetails(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return _buildGlassCard(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildAvatar(),
          const SizedBox(height: 16),
          _buildUserInfo(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade300,
                Colors.deepPurple.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.shade100.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          UserInfo.currentUser,
          style: TextStyle(
            color: Colors.deepPurple.shade700,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Last Login: ${UserInfo.getCurrentUTCTime()}',
          style: TextStyle(
            color: Colors.deepPurple.shade400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetails() {
    return _buildGlassCard(
      child: Column(
        children: [
          _buildInfoTile(
            'Email',
            'Add Email',
            Icons.email_outlined,
            isEditable: true,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Phone',
            'Add Phone Number',
            Icons.phone_outlined,
            isEditable: true,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Location',
            'Add Location',
            Icons.location_on_outlined,
            isEditable: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Total Transactions', '156', Icons.assessment),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('Total Savings', '\$2,450', Icons.savings),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return _buildGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.deepPurple.shade400,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.deepPurple.shade400,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDivider(),
          if (title == 'Account Settings') ...[
            _buildSettingsTile(
              'Change Password',
              'Update your password',
              Icons.lock_outline,
            ),
            _buildDivider(),
            _buildSettingsTile(
              'Two-Factor Authentication',
              'Add extra security to your account',
              Icons.security,
            ),
          ] else if (title == 'Privacy Settings') ...[
            _buildSettingsTile(
              'Profile Visibility',
              'Choose who can see your profile',
              Icons.visibility_outlined,
            ),
            _buildDivider(),
            _buildSettingsTile(
              'Data Sharing',
              'Manage how your data is shared',
              Icons.share_outlined,
            ),
          ] else if (title == 'Notification Settings') ...[
            _buildSettingsTile(
              'Push Notifications',
              'Manage your notifications',
              Icons.notifications_outlined,
            ),
            _buildDivider(),
            _buildSettingsTile(
              'Email Notifications',
              'Manage email alerts',
              Icons.mail_outline,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.deepPurple.shade400,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.deepPurple.shade700,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.deepPurple.shade300,
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.deepPurple.shade400,
        size: 16,
      ),
      onTap: () {
        // Handle settings tap
      },
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingsSection('Account Settings'),
            const SizedBox(height: 24),
            _buildSettingsSection('Privacy Settings'),
            const SizedBox(height: 24),
            _buildSettingsSection('Notification Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.shade100.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon,
      {bool isEditable = false}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.deepPurple.shade400,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.deepPurple.shade300,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.deepPurple.shade700,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isEditable
          ? IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.deepPurple.shade400,
          size: 20,
        ),
        onPressed: () => _showEditDialog(title),
      )
          : null,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.deepPurple.shade50,
      height: 1,
    );
  }

  void _showEditDialog(String field) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Edit $field'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your $field',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.deepPurple.shade400),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.logout, color: Colors.deepPurple.shade400),
                title: Text('Logout'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red.shade400),
                title: Text('Delete Account'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}