import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image or Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF212121), Color(0xFF000000)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.precision_manufacturing, size: 80, color: Color(0xFFFFAB00))
                      .animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  Text(
                    'VincKiralama',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: const Color(0xFFFFAB00),
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: 12),
                  Text(
                    'İşiniz için en uygun vinci anında kiralayın veya filonuzu yönetin.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                  ).animate().fadeIn(delay: 400.ms),
                  const Spacer(),
                  _buildButton(
                    context,
                    label: 'Müşteri Girişi / Kayıt',
                    icon: Icons.person,
                    onTap: () => context.push('/login?tab=customer'),
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    context,
                    label: 'Firma Girişi',
                    icon: Icons.business,
                    onTap: () => context.push('/login?tab=firm'),
                    isSecondary: true,
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    context,
                    label: 'Firma Başvuru',
                    icon: Icons.add_business,
                    onTap: () => context.push('/apply-firm'),
                    isSecondary: true,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.push('/login?tab=admin'),
                    child: const Text('Admin Girişi', style: TextStyle(color: Colors.white54)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label, required IconData icon, required VoidCallback onTap, bool isSecondary = false}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary ? Colors.white.withOpacity(0.1) : const Color(0xFFFFAB00),
        foregroundColor: isSecondary ? Colors.white : Colors.black,
        elevation: isSecondary ? 0 : 4,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0);
  }
}
