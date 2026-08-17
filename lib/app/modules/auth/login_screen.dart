import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const Center(
                  child: Text('🍲', style: TextStyle(fontSize: 40)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Khmer Food Explorer',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to save favorite recipes, leave reviews, and access AI chef guidance.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.snackbar('Forgot Password', 'Password reset email sent to your address.');
                },
                child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final pass = _passwordController.text;
                if (email.isNotEmpty) {
                  _authCtrl.login(email, pass);
                  Get.offAllNamed(AppRoutes.SHELL);
                } else {
                  Get.snackbar('Error', 'Please enter email address');
                }
              },
              child: Text('login'.tr),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.g_mobiledata, size: 28),
              label: const Text('Continue with Google'),
              onPressed: () {
                _authCtrl.login('user@gmail.com', 'google');
                Get.offAllNamed(AppRoutes.SHELL);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _authCtrl.loginAsGuest();
                Get.offAllNamed(AppRoutes.SHELL);
              },
              child: Text('guest_mode'.tr, style: const TextStyle(color: AppColors.textSecondaryDark)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account? ', style: TextStyle(color: AppColors.textSecondaryDark)),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.REGISTER);
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
