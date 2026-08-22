import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/preferences/app_preferences.dart';
import '../../providers/infrastructure_providers.dart';
import '../../providers/onboarding_provider.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _isSignUp = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_isSignUp) {
        await Supabase.instance.client.auth.signUp(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );
      }
      await _advance();
    } on AuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _skip() async {
    final prefs = await ref.read(appPreferencesProvider.future);
    await prefs.setLocalOnlyMode(true);
    await _advance();
  }

  Future<void> _advance() async {
    await ref
        .read(onboardingStatusProvider.notifier)
        .advance(OnboardingStep.permissions);
    if (mounted) context.go('/onboarding/permissions');
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Text('Create Account',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    Text(
                        'Sign up to sync your data across devices, or skip to use locally.',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 32),
                    GlassCard(
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email address'),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordCtrl,
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                          ),
                        ],
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!,
                          style: const TextStyle(
                              color: AppColors.error, fontSize: 13)),
                    ],
                    const SizedBox(height: 24),
                    if (_loading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      FilledButton(
                          onPressed: _submit,
                          child: Text(_isSignUp ? 'Sign Up' : 'Sign In')),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => setState(() => _isSignUp = !_isSignUp),
                        child: Text(_isSignUp
                            ? 'Already have an account? Sign In'
                            : 'New user? Sign Up'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                          onPressed: _skip, child: const Text('Skip for now')),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
