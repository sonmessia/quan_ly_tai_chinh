import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:quan_ly_tai_chinh/modules/settings/profile_screen.dart';

class SpecificSettingsScreen extends StatefulWidget {
  const SpecificSettingsScreen({super.key});

  @override
  _SpecificSettingsScreenState createState() => _SpecificSettingsScreenState();
}

class _SpecificSettingsScreenState extends State<SpecificSettingsScreen> {
  bool isDarkMode = false;
  bool isNotificationEnabled = true;
  bool isBiometricEnabled = false;
  String selectedLanguage = 'English';
  String selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
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
          'Settings',
          style: TextStyle(
            color: Colors.deepPurple.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Decorative background elements
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

          // Main content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  // Profile Button
                  _buildSettingsSection(
                    'Account',
                    [
                      _buildGlassCard(
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade100.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.deepPurple.shade400,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            'Profile Settings',
                            style: TextStyle(
                              color: Colors.deepPurple.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Manage your profile information',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Appearance Settings
                  _buildSettingsSection(
                    'Appearance',
                    [
                      _buildGlassCard(
                        child: SwitchListTile(
                          title: Text(
                            'Dark Mode',
                            style: TextStyle(
                              color: Colors.deepPurple.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Enable dark theme',
                            style: TextStyle(
                              color: Colors.deepPurple.shade300,
                              fontSize: 14,
                            ),
                          ),
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() => isDarkMode = value);
                          },
                          activeColor: Colors.deepPurple.shade400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Notifications Settings
                  _buildSettingsSection(
                    'Notifications',
                    [
                      _buildGlassCard(
                        child: SwitchListTile(
                          title: Text(
                            'Push Notifications',
                            style: TextStyle(
                              color: Colors.deepPurple.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Enable push notifications',
                            style: TextStyle(
                              color: Colors.deepPurple.shade300,
                              fontSize: 14,
                            ),
                          ),
                          value: isNotificationEnabled,
                          onChanged: (value) {
                            setState(() => isNotificationEnabled = value);
                          },
                          activeColor: Colors.deepPurple.shade400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Security Settings
                  _buildSettingsSection(
                    'Security',
                    [
                      _buildGlassCard(
                        child: SwitchListTile(
                          title: Text(
                            'Biometric Authentication',
                            style: TextStyle(
                              color: Colors.deepPurple.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Use fingerprint or face ID',
                            style: TextStyle(
                              color: Colors.deepPurple.shade300,
                              fontSize: 14,
                            ),
                          ),
                          value: isBiometricEnabled,
                          onChanged: (value) {
                            setState(() => isBiometricEnabled = value);
                          },
                          activeColor: Colors.deepPurple.shade400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Preferences Settings
                  _buildSettingsSection(
                    'Preferences',
                    [
                      _buildGlassCard(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'Language',
                                style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Select your preferred language',
                                style: TextStyle(
                                  color: Colors.deepPurple.shade300,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: DropdownButton<String>(
                                value: selectedLanguage,
                                items: ['English', 'Vietnamese', 'Japanese']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Colors.deepPurple.shade700,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() => selectedLanguage = newValue);
                                  }
                                },
                                underline: Container(),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.deepPurple.shade400,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.deepPurple.shade50,
                              height: 1,
                            ),
                            ListTile(
                              title: Text(
                                'Currency',
                                style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Select your preferred currency',
                                style: TextStyle(
                                  color: Colors.deepPurple.shade300,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: DropdownButton<String>(
                                value: selectedCurrency,
                                items: ['USD', 'EUR', 'VND', 'JPY']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Colors.deepPurple.shade700,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() => selectedCurrency = newValue);
                                  }
                                },
                                underline: Container(),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.deepPurple.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // About Section
                  _buildSettingsSection(
                    'About',
                    [
                      _buildGlassCard(
                        child: Column(
                          children: [
                            _buildAboutItem(
                              'Version',
                              '1.0.0',
                            ),
                            Divider(
                              color: Colors.deepPurple.shade50,
                              height: 1,
                            ),
                            _buildAboutItem(
                              'Terms of Service',
                              '',
                              isLink: true,
                            ),
                            Divider(
                              color: Colors.deepPurple.shade50,
                              height: 1,
                            ),
                            _buildAboutItem(
                              'Privacy Policy',
                              '',
                              isLink: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.deepPurple.shade700,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
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

  Widget _buildAboutItem(String title, String value, {bool isLink = false}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.deepPurple.shade700,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isLink
          ? Icon(
        Icons.arrow_forward_ios,
        color: Colors.deepPurple.shade400,
        size: 16,
      )
          : Text(
        value,
        style: TextStyle(
          color: Colors.deepPurple.shade400,
          fontSize: 14,
        ),
      ),
      onTap: isLink
          ? () {
        // Handle link tap
      }
          : null,
    );
  }
}