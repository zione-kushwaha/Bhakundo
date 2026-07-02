import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        if (mounted) {
          CustomSnackbar.show(
            context,
            'Password reset link sent! Check your inbox.',
            isSuccess: true,
          );
          context.pop(); // Go back to Sign In
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          CustomSnackbar.show(
            context,
            e.message ?? 'An error occurred. Please try again.',
            isError: true,
          );
        }
      } catch (e) {
        if (mounted) {
          CustomSnackbar.show(context, e.toString(), isError: true);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundDark,
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1200',
                ),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.backgroundDark.withValues(alpha: 0.85),
                  AppColors.backgroundDark.withValues(alpha: 0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 48.h,
            left: 16.w,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.r),
              onPressed: () => context.pop(),
            ),
          ),
          // Centered responsive box
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 460.w : double.infinity,
                  ),
                  padding: isTablet ? EdgeInsets.all(32.r) : EdgeInsets.zero,
                  decoration: isTablet
                      ? BoxDecoration(
                          color: theme.cardColor.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: theme.dividerTheme.color ?? Colors.grey.withValues(alpha: 0.2),
                          ),
                        )
                      : null,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App Logo
                        Center(
                          child: Container(
                            height: 80.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.primaryColor.withValues(alpha: 0.1),
                            ),
                            padding: EdgeInsets.all(10.r),
                            child: Image.asset(
                              'assets/app/logo.png',
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.sports_soccer,
                                color: theme.primaryColor,
                                size: 40.r,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'RESET PASSWORD',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontSize: 18.sp,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Enter your registered email address and we will send you a password reset link.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Submit Button
                        CustomButton(
                          text: 'SEND RESET LINK',
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
