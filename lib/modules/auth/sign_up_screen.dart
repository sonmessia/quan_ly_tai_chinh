import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quan_ly_tai_chinh/services/auth_service.dart';

class AuthController {
  static final AuthController instance = AuthController._internal();
  factory AuthController() => instance;
  AuthController._internal();

  Future<void> setCurrentUser(dynamic user) async {
    // Save the user data - implement storage logic here
    // This could use shared preferences, secure storage, or another persistence method
  }

  void logout() {
    // Implement logout logic here
    // This could clear stored user data or tokens
  }

  bool get isLoggedIn {
    // Implement logic to check if user is logged in
    // This could check stored user data or tokens
    return false;
  }

  void checkAuthStatus() {
    // Implement logic to check authentication status
    // This could check stored user data or tokens
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  void _handleSignUp() async {
    // Validate inputs
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        usernameController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await AuthService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        username: usernameController.text.trim(),
      );

      if (mounted) {
        // Store user data (you might want to use a state management solution)
        await AuthController.instance.setCurrentUser(user);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome ${user.username}!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to dashboard or login screen
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepPurple.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  void _goBack() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  void _goToSignIn() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
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
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: size.height - MediaQuery.of(context).padding.top,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: _goBack,
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.deepPurple.shade400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Logo and Title
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade300,
                              Colors.deepPurple.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.deepPurple.shade200.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_circle_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Form Container with Glassmorphism effect
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.shade100
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Email Field
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your email",
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Colors.deepPurple.shade300,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.deepPurple.shade50,
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Password Field
                                TextField(
                                  controller: passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: "Create password",
                                    prefixIcon: Icon(
                                      Icons.lock_outline_rounded,
                                      color: Colors.deepPurple.shade300,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        color: Colors.deepPurple.shade300,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.deepPurple.shade50,
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Confirm Password Field
                                TextField(
                                  controller: confirmPasswordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: "Confirm password",
                                    prefixIcon: Icon(
                                      Icons.lock_outline_rounded,
                                      color: Colors.deepPurple.shade300,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        color: Colors.deepPurple.shade300,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.deepPurple.shade50,
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Username Field
                                TextField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your username",
                                    prefixIcon: Icon(
                                      Icons.person_outline_rounded,
                                      color: Colors.deepPurple.shade300,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.deepPurple.shade50,
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Sign Up Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _handleSignUp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.deepPurple.shade600,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Text(
                                            "Create Account",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Sign In Option
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _goToSignIn,
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: Colors.deepPurple.shade700,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // // Divider with text
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Container(
                      //         height: 1,
                      //         decoration: BoxDecoration(
                      //           gradient: LinearGradient(
                      //             colors: [
                      //               Colors.deepPurple.shade100.withOpacity(0.1),
                      //               Colors.deepPurple.shade200,
                      //               Colors.deepPurple.shade100.withOpacity(0.1),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 16),
                      //       child: Text(
                      //         "Or continue with",
                      //         style: TextStyle(
                      //           color: Colors.deepPurple.shade300,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Container(
                      //         height: 1,
                      //         decoration: BoxDecoration(
                      //           gradient: LinearGradient(
                      //             colors: [
                      //               Colors.deepPurple.shade100.withOpacity(0.1),
                      //               Colors.deepPurple.shade200,
                      //               Colors.deepPurple.shade100.withOpacity(0.1),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // const SizedBox(height: 30),
                      //
                      // // Social Login Buttons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     _buildSocialButton(
                      //       icon: Icons.g_mobiledata_rounded,
                      //       onTap: () {
                      //         // TODO: Implement Google login
                      //       },
                      //     ),
                      //     const SizedBox(width: 20),
                      //     _buildSocialButton(
                      //       icon: Icons.facebook_rounded,
                      //       onTap: () {
                      //         // TODO: Implement Facebook login
                      //       },
                      //     ),
                      //     const SizedBox(width: 20),
                      //     _buildSocialButton(
                      //       icon: Icons.apple_rounded,
                      //       onTap: () {
                      //         // TODO: Implement Apple login
                      //       },
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 30),

                      // Terms and Privacy
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text.rich(
                          TextSpan(
                            text: "By creating an account, you agree to our ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: "Terms of Service",
                                style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, '/signin');
                                  },
                              ),
                              const TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // TODO: Navigate to Privacy Policy
                                  },
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSocialButton({
  //   required IconData icon,
  //   required VoidCallback onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(15),
  //     child: Container(
  //       padding: const EdgeInsets.all(15),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.deepPurple.shade100.withOpacity(0.5),
  //             blurRadius: 10,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Icon(
  //         icon,
  //         size: 30,
  //         color: Colors.deepPurple.shade400,
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
