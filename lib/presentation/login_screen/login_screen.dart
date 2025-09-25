import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with demo credentials
    _emailController.text = 'ahmad.wijaya@dentalcare.co.id';
    _passwordController.text = 'demo123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate login API call
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login berhasil! Selamat datang, Dr. Ahmad Wijaya'),
          backgroundColor: AppTheme.successLight,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to home dashboard
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              // Logo Section
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryLight.withValues(alpha: 0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://www.cobradental.co.id/frontsite/themes/images/global/logo.png",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryLight,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Icon(
                          Icons.image_not_supported,
                          color: AppTheme.primaryLight,
                          size: 8.w,
                        ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // Welcome Text
              Text(
                'Selamat Datang',
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryLight,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                'Masuk ke akun Cobra Dental Anda',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondaryLight,
                ),
              ),

              SizedBox(height: 6.h),

              // Login Form
              LoginFormWidget(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: _isLoading,
                rememberMe: _rememberMe,
                onRememberMeChanged: (value) {
                  setState(() => _rememberMe = value ?? false);
                },
                onLogin: _handleLogin,
              ),

              SizedBox(height: 4.h),

              // Demo Account Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: AppTheme.accentLight.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.accentLight,
                          size: 20.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Demo Account',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Email: ahmad.wijaya@dentalcare.co.id',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Password: demo123',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Name: Dr. Ahmad Wijaya',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    Text(
                      'Company: PT Dental Care Sejahtera',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.h),

              // Footer
              Text(
                'Dengan masuk, Anda menyetujui Syarat & Ketentuan\ndan Kebijakan Privasi kami',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondaryLight,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
