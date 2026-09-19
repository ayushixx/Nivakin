// ============================================================
// views/emergency_view.dart
// Coral Rose emergency escalation screen.
// Shown ONLY when Tier 1 safety interceptor fires.
// Direct-dial Indian emergency numbers: 112, 1098, 181, 104.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../state/nivakin_state.dart';
import '../pipeline/safety_interceptor.dart';
import '../theme/nivakin_theme.dart';

class EmergencyView extends StatelessWidget {
  const EmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();

    final resources = [
      EmergencyResource(
        name: 'National Emergency',
        number: '112',
        description: 'Police, Fire & Medical — 24×7',
      ),
      EmergencyResource(
        name: 'Childline India',
        number: '1098',
        description: '24×7 helpline for children in distress — Free',
      ),
      EmergencyResource(
        name: 'Women\'s Helpline',
        number: '181',
        description: 'Women in distress — available 24 hours',
      ),
      EmergencyResource(
        name: 'NHM Health Helpline',
        number: '104',
        description: 'AFHC / Adolescent Friendly Health Centre locator',
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF1F3), Color(0xFFFFF7F9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, state),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  child: Column(
                    children: [
                      // Alert Header
                      _buildAlertHeader(context)
                          .animate().fadeIn(duration: 300.ms).scale(
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1, 1),
                          ),
                      const SizedBox(height: 24),

                      // Emergency contacts
                      Text(
                        'Tap any number below to call immediately',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: NivakinColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      ...resources.asMap().entries.map((e) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _EmergencyCallCard(resource: e.value)
                              .animate(delay: Duration(milliseconds: 150 + e.key * 100))
                              .fadeIn()
                              .slideY(begin: 0.2, end: 0),
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Reassurance message
                      _buildReassuranceCard(context),
                      const SizedBox(height: 24),
                      // Back button
                      GestureDetector(
                        onTap: () => state.navigateTo(AppScreen.intake),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: NivakinColors.surface,
                            borderRadius: BorderRadius.circular(NivakinRadius.pill),
                            border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_rounded, color: NivakinColors.textMuted, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Go back',
                                style: TextStyle(
                                  color: NivakinColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, NivakinAppState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              gradient: NivakinColors.pinkLilacGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('N', style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18,
              )),
            ),
          ),
          const SizedBox(width: 10),
          Text('nivakin',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: state.activateDisguise,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: NivakinColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
              ),
              child: const Center(child: Text('🌸', style: TextStyle(fontSize: 18))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: NivakinColors.alertSoft,
        borderRadius: BorderRadius.circular(NivakinRadius.lg),
        border: Border.all(color: NivakinColors.alert.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: NivakinColors.alert.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: NivakinColors.alert.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🚨', style: TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Please get help right now',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: NivakinColors.alert,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'What you described sounds serious. This is not your fault and you\'ve done the right thing by asking for help. Please call one of these numbers or ask a trusted adult immediately.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9B2335),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReassuranceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F0FF), Color(0xFFEFF6FF)],
        ),
        borderRadius: BorderRadius.circular(NivakinRadius.lg),
        border: Border.all(color: NivakinColors.secondaryAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text('💜', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text(
            'You are not alone',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF6D28D9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Reaching out for help is the bravest thing you can do. Every adult at these numbers is trained to help you kindly and without judgement. You deserve care. 💜',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6D28D9),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Emergency Call Card ────────────────────────────────────────
class _EmergencyCallCard extends StatelessWidget {
  final EmergencyResource resource;

  const _EmergencyCallCard({required this.resource});

  Future<void> _dial() async {
    final uri = Uri(scheme: 'tel', path: resource.number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dial,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: NivakinColors.surface,
          borderRadius: BorderRadius.circular(NivakinRadius.md),
          border: Border.all(color: NivakinColors.alert.withValues(alpha: 0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: NivakinColors.alert.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: NivakinColors.alertSoft,
                borderRadius: BorderRadius.circular(NivakinRadius.sm),
                border: Border.all(color: NivakinColors.alert.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Center(
                child: Text(
                  resource.number,
                  style: const TextStyle(
                    color: NivakinColors.alert,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(resource.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: NivakinColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(resource.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: NivakinColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: NivakinColors.alert,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: NivakinColors.alert.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
