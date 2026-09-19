// ============================================================
// views/confidence_view.dart
// Redesigned Results View:
//   • Top Card: 1-sentence comforting verdict in clear 18px font
//   • 3 Scannable Pastel Cards:
//       1. Lilac Card — What You Told Us
//       2. Blossom Pink Card — Friendly Science & Myth Busting
//       3. Soft Amber Card — Questions for Doctor & Boundaries
//   • Centerpiece WhatsApp Card styled like a real message with 1-tap Copy
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../state/nivakin_state.dart';
import '../models/nivakin_schema.dart';
import '../theme/nivakin_theme.dart';
import '../pipeline/gemini_orchestrator.dart';

class ConfidenceView extends StatelessWidget {
  const ConfidenceView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();
    final response = state.response;

    if (response == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final triageColor = switch (response.triageLevel) {
      TriageLevel.normalDevelopmental        => NivakinColors.success,
      TriageLevel.practitionerDiscussionNeeded => NivakinColors.softAmber,
      TriageLevel.emergencyEscalation        => NivakinColors.alert,
    };

    final triageLabel = switch (response.triageLevel) {
      TriageLevel.normalDevelopmental         => '✅ Developmentally Normal',
      TriageLevel.practitionerDiscussionNeeded=> '💛 Worth discussing with a clinician',
      TriageLevel.emergencyEscalation         => '🚨 Urgent medical care advised',
    };

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: NivakinColors.blossomGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, state),
              _TriageBanner(color: triageColor, label: triageLabel)
                  .animate().fadeIn(delay: 100.ms).slideY(begin: -0.3, end: 0),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  child: Column(
                    children: [
                      // Top Card: Comforting 1-sentence Verdict (18px font)
                      _ComfortVerdictCard(verdict: response.quickVerdict)
                          .animate(delay: 150.ms).fadeIn().slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),

                      // Menarche reassurance ribbon if applicable
                      if (response.menarcheIrregularityReassurance)
                        _MenarcheReassuranceRibbon()
                            .animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),
                      if (response.menarcheIrregularityReassurance)
                        const SizedBox(height: 16),

                      // 1. Lilac Card — What You Told Us
                      _BucketCard(
                        index: 0,
                        emoji: '📋',
                        title: 'What You Told Us',
                        subtitle: 'Confirmed inputs from your check-in',
                        bgColor: NivakinColors.bucketABg,
                        borderColor: NivakinColors.secondaryAccent.withValues(alpha: 0.35),
                        accentColor: NivakinColors.secondaryAccent,
                        items: response.bucketA_knownFacts
                            .where((f) => !f.startsWith('Verdict:'))
                            .toList(),
                      ),
                      const SizedBox(height: 16),

                      // 2. Blossom Pink Card — Friendly Science & Myth Busting
                      _BucketCard(
                        index: 1,
                        emoji: '🌸',
                        title: 'Friendly Science & Myth Busting',
                        subtitle: 'Clear developmental context without scary words',
                        bgColor: NivakinColors.bucketBBg,
                        borderColor: NivakinColors.primaryAccent.withValues(alpha: 0.35),
                        accentColor: NivakinColors.primaryAccent,
                        items: response.bucketB_friendlyContext,
                      ),
                      const SizedBox(height: 16),

                      // 3. Soft Amber Card — Questions for Doctor & Boundaries
                      _BucketCard(
                        index: 2,
                        emoji: '🩺',
                        title: 'Questions for Doctor',
                        subtitle: 'Boundaries on when to seek clinical checkup',
                        bgColor: NivakinColors.bucketCBg,
                        borderColor: NivakinColors.softAmber.withValues(alpha: 0.35),
                        accentColor: NivakinColors.softAmber,
                        items: response.bucketC_doctorQuestions,
                      ),
                      const SizedBox(height: 20),

                      // Centerpiece WhatsApp Card with 1-tap Copy Message
                      _WhatsAppCenterpieceCard(scripts: response.elderScripts)
                          .animate(delay: 500.ms).fadeIn().slideY(begin: 0.15, end: 0),
                      const SizedBox(height: 24),

                      // CTA Row
                      _CtaRow(state: state),
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
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => state.navigateTo(AppScreen.intake),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: NivakinColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                color: NivakinColors.textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Text('Your Orientation',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: state.activateDisguise,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: NivakinColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
              ),
              child: const Center(child: Text('🌸', style: TextStyle(fontSize: 18))),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top Card: Comfort Verdict (18px Font) ──────────────────────
class _ComfortVerdictCard extends StatelessWidget {
  final String verdict;
  const _ComfortVerdictCard({required this.verdict});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NivakinColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: NivakinColors.primaryAccent.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: NivakinColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: NivakinColors.primaryAccent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Text('🌷', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              verdict,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: NivakinColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Triage Banner ─────────────────────────────────────────────
class _TriageBanner extends StatelessWidget {
  final Color color;
  final String label;
  const _TriageBanner({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Menarche Reassurance Ribbon ───────────────────────────────
class _MenarcheReassuranceRibbon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F0FF), Color(0xFFEFF6FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: NivakinColors.secondaryAccent.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Text('🌱', style: TextStyle(fontSize: 22)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Early Cycle Reassurance: Periods in the first 1–2 years are naturally irregular. Your body is building its monthly rhythm.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6D28D9),
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Scannable Pastel Cards ─────────────────────────────────────
class _BucketCard extends StatelessWidget {
  final int index;
  final String emoji;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color borderColor;
  final Color accentColor;
  final List<String> items;

  const _BucketCard({
    required this.index,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.borderColor,
    required this.accentColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                        ),
                      ),
                      Text(subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: NivakinColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x15000000)),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
            child: Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 13,
                            color: NivakinColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 150 + index * 120)).fadeIn().slideY(begin: 0.1, end: 0);
  }
}

// ── Centerpiece WhatsApp Card ──────────────────────────────────
class _WhatsAppCenterpieceCard extends StatelessWidget {
  final ElderScripts scripts;
  const _WhatsAppCenterpieceCard({required this.scripts});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFECE5DD), // Classic WhatsApp Chat background tint
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25D366).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // WhatsApp Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF075E54),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.mark_chat_read_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'WhatsApp Script for Mummy / Didi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Ready to share',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          // Chat bubble preview
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCF8C6), // WhatsApp outgoing bubble green
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      scripts.mummyScript.isNotEmpty ? scripts.mummyScript : scripts.didiScript,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF111827),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('12:00 PM', style: TextStyle(fontSize: 10, color: Colors.black54)),
                        SizedBox(width: 4),
                        Icon(Icons.done_all_rounded, size: 14, color: Color(0xFF34B7F1)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 1-Tap Copy Message Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () {
                final message = scripts.mummyScript.isNotEmpty ? scripts.mummyScript : scripts.didiScript;
                Clipboard.setData(ClipboardData(text: message));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message copied to clipboard! Ready to paste in WhatsApp 💬'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copy_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Copy Message for WhatsApp',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
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

// ── CTA Row ───────────────────────────────────────────────────
class _CtaRow extends StatelessWidget {
  final NivakinAppState state;
  const _CtaRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => state.navigateTo(AppScreen.scriptSandbox),
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: NivakinColors.pinkLilacGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: NivakinColors.primaryAccent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('💬', style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Text(
                  'Baat Kaise Karein? (Script Sandbox)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.15, end: 0),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => state.navigateTo(AppScreen.doctorPrep),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: NivakinColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🩺', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                Text(
                  'Prepare Doctor Checkup Note',
                  style: TextStyle(
                    color: NivakinColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.15, end: 0),
      ],
    );
  }
}
