// ============================================================
// views/doctor_prep_view.dart
// 1-Page exportable clinical summary card for AFHC/RKSK/OPD.
// Includes WhatsApp share and screenshot-to-camera-roll export.
// Designed for 10-second review during busy Indian OPD clinics.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../state/nivakin_state.dart';
import '../models/nivakin_schema.dart';
import '../theme/nivakin_theme.dart';
import 'components/whatsapp_export.dart';

class DoctorPrepView extends StatelessWidget {
  const DoctorPrepView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();
    final response = state.response;

    if (response == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final card = response.clinicianCard;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: NivakinColors.blossomGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, state),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  child: Column(
                    children: [
                      // Header card
                      _buildHeaderCard(context).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 16),
                      // Main clinical card
                      _buildClinicianCard(context, card)
                          .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      // Questions for doctor
                      _buildQuestionsCard(context, card)
                          .animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 24),
                      // Export actions
                      _buildExportActions(context, response)
                          .animate().fadeIn(delay: 450.ms).slideY(begin: 0.15, end: 0),
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
          GestureDetector(
            onTap: () => state.navigateTo(AppScreen.confidence),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: NivakinColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                color: NivakinColors.textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doctor Visit Card',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('Show this to your doctor or nurse',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NivakinColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: context.read<NivakinAppState>().activateDisguise,
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

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: NivakinColors.pinkLilacGradient,
        borderRadius: BorderRadius.circular(NivakinRadius.lg),
        boxShadow: [
          BoxShadow(
            color: NivakinColors.primaryAccent.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🩺', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          const Text(
            'Patient Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Prepared by Nivakin — Adolescent Health Companion',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'For review by AFHC / RKSK Clinician or Family Doctor',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicianCard(BuildContext context, ClinicianCard card) {
    return Container(
      decoration: BoxDecoration(
        color: NivakinColors.surface,
        borderRadius: BorderRadius.circular(NivakinRadius.lg),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: NivakinColors.primaryAccent.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(emoji: '📋', title: 'Clinical Summary', color: NivakinColors.primaryAccent),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              children: [
                _InfoRow(label: 'Chief Complaint', value: card.chiefSymptom, emoji: '⚠️'),
                _InfoRow(label: 'Duration', value: card.duration, emoji: '📅'),
                _InfoRow(label: 'School / Daily Impact', value: card.impactOnSchool, emoji: '🏫'),
                if (card.reliefMethodsTried.isNotEmpty)
                  _InfoRow(
                    label: 'Remedies Already Tried',
                    value: card.reliefMethodsTried.join(', '),
                    emoji: '💊',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsCard(BuildContext context, ClinicianCard card) {
    return Container(
      decoration: BoxDecoration(
        color: NivakinColors.bucketCBg,
        borderRadius: BorderRadius.circular(NivakinRadius.lg),
        border: Border.all(color: NivakinColors.success.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(emoji: '❓', title: 'Patient\'s Questions for Clinician', color: NivakinColors.success),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              children: card.specificQuestionsToAsk.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 1, right: 10),
                      decoration: BoxDecoration(
                        color: NivakinColors.success.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${e.key + 1}',
                          style: const TextStyle(
                            color: NivakinColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.value,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: NivakinColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportActions(BuildContext context, NivakinNavigationResponse response) {
    final shareText = _buildShareText(response.clinicianCard);
    return Column(
      children: [
        // WhatsApp share (to send to doctor's WhatsApp)
        WhatsAppExportButton(
          scriptText: shareText,
          recipientLabel: 'Doctor',
        ),
        const SizedBox(height: 12),
        // Plain share (to save or send via any app)
        GestureDetector(
          onTap: () => Share.share(shareText, subject: 'My Health Summary — Nivakin'),
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
                Icon(Icons.share_rounded, color: NivakinColors.textMuted, size: 18),
                SizedBox(width: 10),
                Text(
                  'Share / Save to Camera Roll',
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
        const SizedBox(height: 16),
        // Disclaimer
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(NivakinRadius.md),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Text(
            '🔒 This summary was prepared by the patient using Nivakin. It is not a medical diagnosis. A clinician should evaluate all information in person.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: NivakinColors.textMuted,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  String _buildShareText(ClinicianCard card) {
    final buffer = StringBuffer();
    buffer.writeln('🩺 NIVAKIN — PATIENT HEALTH SUMMARY');
    buffer.writeln('=====================================');
    buffer.writeln('Chief Complaint: ${card.chiefSymptom}');
    buffer.writeln('Duration: ${card.duration}');
    buffer.writeln('School Impact: ${card.impactOnSchool}');
    if (card.reliefMethodsTried.isNotEmpty) {
      buffer.writeln('Remedies Tried: ${card.reliefMethodsTried.join(', ')}');
    }
    buffer.writeln('');
    buffer.writeln('Questions for Doctor:');
    for (int i = 0; i < card.specificQuestionsToAsk.length; i++) {
      buffer.writeln('${i + 1}. ${card.specificQuestionsToAsk[i]}');
    }
    buffer.writeln('');
    buffer.writeln('Prepared by Nivakin — Adolescent Health Companion');
    buffer.writeln('(This is a patient-prepared summary. Not a medical diagnosis.)');
    return buffer.toString();
  }
}

// ── Helper Widgets ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.emoji,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: NivakinColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: NivakinColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
