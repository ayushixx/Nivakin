// ============================================================
// views/intake_view.dart
// Redesigned AI Navigation-First Intake View for Girls ages 11–18.
// 4 Large soft bubble chips, friendly Hinglish input bar with voice icon,
// menarche staging pills, and quick privacy disguise.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../state/nivakin_state.dart';
import '../models/nivakin_schema.dart';
import '../theme/nivakin_theme.dart';

// ── 4 Primary Soft Bubble Chips ───────────────────────────────
const _primaryBubbleChips = [
  ('🌸', 'My period is irregular or late'),
  ('🩹', 'Cramps hurt too much to study'),
  ('🩸', 'Flow feels very heavy'),
  ('✨', 'Is white discharge normal?'),
];

const _menarcheOptions = [
  (MenarcheStage.lessThanOneYear, 'Less than 1 year ago', '🌱'),
  (MenarcheStage.oneToTwoYears,   '1–2 years ago',         '🌷'),
  (MenarcheStage.moreThanTwoYears,'2+ years ago',           '🌺'),
  (MenarcheStage.unknown,         'Not sure',               '🤔'),
];

class IntakeView extends StatelessWidget {
  const IntakeView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();
    final isLoading = state.processingState != ProcessingState.idle &&
        state.processingState != ProcessingState.done &&
        state.processingState != ProcessingState.error;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: NivakinColors.blossomGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, state),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroHeader(context),
                      const SizedBox(height: 24),
                      _buildLargeBubbleChips(context, state),
                      const SizedBox(height: 24),
                      _buildFreeTextInputBar(context, state),
                      const SizedBox(height: 24),
                      _buildMenarcheStaging(context, state),
                      const SizedBox(height: 20),
                      if (state.processingState == ProcessingState.error)
                        _buildErrorCard(state.errorMessage),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildSubmitFAB(context, state, isLoading),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ── Top Bar with Language Toggle & Flower Disguise ────────────
  Widget _buildAppBar(BuildContext context, NivakinAppState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              gradient: NivakinColors.pinkLilacGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌸', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          Text('nivakin',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: -0.5,
              color: NivakinColors.textPrimary,
            ),
          ),
          const Spacer(),
          _LanguageToggle(),
          const SizedBox(width: 8),
          // Quick Disguise Button (Flower icon)
          Tooltip(
            message: 'Quick hide (NCERT study view)',
            child: GestureDetector(
              onTap: state.activateDisguise,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NivakinColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: NivakinColors.primaryAccent.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🌸', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Friendly Hero Header ─────────────────────────────────────
  Widget _buildHeroHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Hey, I\'m here for you 💜',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05, end: 0),
        const SizedBox(height: 6),
        Text(
          'No judgment, no scary words. Just clear orientation.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: NivakinColors.textMuted,
            fontSize: 15,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  // ── 4 Large Soft Animated Bubble Chips ───────────────────────
  Widget _buildLargeBubbleChips(BuildContext context, NivakinAppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap what you\'re experiencing',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _primaryBubbleChips.length,
          itemBuilder: (context, index) {
            final (emoji, label) = _primaryBubbleChips[index];
            final isSelected = state.selectedChips.contains(label);
            return GestureDetector(
              onTap: () => state.toggleChip(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? NivakinColors.primaryAccent.withValues(alpha: 0.12)
                      : NivakinColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? NivakinColors.primaryAccent : const Color(0xFFEDE9FE),
                    width: isSelected ? 2.0 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? NivakinColors.primaryAccent.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.03),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? NivakinColors.primaryAccent : NivakinColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: Duration(milliseconds: 80 * index))
             .fadeIn().slideY(begin: 0.2, end: 0);
          },
        ),
      ],
    );
  }

  // ── Friendly Text Input Bar with Voice Icon ──────────────────
  Widget _buildFreeTextInputBar(BuildContext context, NivakinAppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Or type in simple words...',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: NivakinColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: state.queryController,
                  maxLines: 3,
                  minLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Type in simple words (e.g., \'pet me bohot dard hai\' or \'cramps hurt\')...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(16, 14, 12, 14),
                  ),
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: IconButton(
                  icon: const Icon(Icons.mic_rounded, color: NivakinColors.primaryAccent, size: 24),
                  tooltip: 'Voice dictation',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Listening... speak in English or Hinglish 🎙️'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Menarche Staging Pills ───────────────────────────────────
  Widget _buildMenarcheStaging(BuildContext context, NivakinAppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'When did your periods start?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Helps us check normal developmental rhythms',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: NivakinColors.textMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _menarcheOptions.map((opt) {
            final (stage, label, emoji) = opt;
            final isSelected = state.menarcheStage == stage;
            return GestureDetector(
              onTap: () => state.setMenarcheStage(stage),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? NivakinColors.secondaryAccent.withValues(alpha: 0.15)
                      : NivakinColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? NivakinColors.secondaryAccent : const Color(0xFFEDE9FE),
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? NivakinColors.secondaryAccent : NivakinColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Submit FAB ─────────────────────────────────────────────────
  Widget _buildSubmitFAB(BuildContext context, NivakinAppState state, bool isLoading) {
    final hasInput = state.selectedChips.isNotEmpty ||
        state.queryController.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          gradient: hasInput ? NivakinColors.pinkLilacGradient : const LinearGradient(
            colors: [Color(0xFFE5E7EB), Color(0xFFE5E7EB)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: hasInput
              ? [BoxShadow(
                  color: NivakinColors.primaryAccent.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: hasInput && !isLoading ? state.runPipeline : null,
            child: Center(
              child: isLoading
                  ? _buildLoadingIndicator(state)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hasInput ? 'Get my orientation 💜' : 'Select a topic above',
                          style: TextStyle(
                            color: hasInput ? Colors.white : NivakinColors.textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        if (hasInput) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(NivakinAppState state) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        SizedBox(width: 12),
        Text('Preparing your answers...', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        )),
      ],
    );
  }

  Widget _buildErrorCard(String? message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NivakinColors.alertSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: NivakinColors.alert.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: NivakinColors.alert),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message ?? 'Something went wrong. Please try again.',
              style: const TextStyle(color: NivakinColors.alert, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Language Toggle ────────────────────────────────────────────
class _LanguageToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();
    final langs = [
      ('EN', 'english'),
      ('HI', 'hindi'),
      ('HiEN', 'hinglish'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: NivakinColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: langs.map((l) {
          final (label, code) = l;
          final active = state.language == code;
          return GestureDetector(
            onTap: () => state.setLanguage(code),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: active ? NivakinColors.primaryAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : NivakinColors.textMuted,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
