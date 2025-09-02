import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPopup extends StatelessWidget {
  const SignUpPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F2937),
              Color(0xFF111827),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_rounded,
                size: 40,
                color: Color(0xFF8B5CF6),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Title
            const Text(
              'Unlock Full Access',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle
            const Text(
              'Sign up to access all features and connect with amazing creators',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Features List
            _buildFeatureItem(Icons.message, 'Direct messaging with creators'),
            const SizedBox(height: 8),
            _buildFeatureItem(Icons.bookmark, 'Save favorite listings'),
            const SizedBox(height: 8),
            _buildFeatureItem(Icons.notifications, 'Get notified about new opportunities'),
            const SizedBox(height: 8),
            _buildFeatureItem(Icons.person_add, 'Build your professional profile'),
            
            const SizedBox(height: 24),
            
            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close popup
                  context.go('/auth/signup'); // Navigate to signup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign Up Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Login Link
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close popup
                context.go('/auth/login'); // Navigate to login
              },
              child: const Text(
                'Already have an account? Log in',
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 16,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Continue as Guest
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close popup
              },
              child: const Text(
                'Continue browsing as guest',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF8B5CF6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// Helper function to show the popup
void showSignUpPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const SignUpPopup(),
  );
}
