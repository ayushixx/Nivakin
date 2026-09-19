// ============================================================
// views/components/pad_meter_chip.dart
// Visual pad absorption selector using intuitive icon tiers.
// Replaces clinical "mL" metrics with culturally accurate
// pad soak rate descriptions for Indian adolescents.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/nivakin_schema.dart';
import '../../theme/nivakin_theme.dart';

class PadMeterChip extends StatelessWidget {
  final PadAbsorptionLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  const PadMeterChip({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  Color get _bgColor {
    if (!isSelected) return NivakinColors.surface;
    switch (level) {
      case PadAbsorptionLevel.lightDamp:        return const Color(0xFFFFF0F9);
      case PadAbsorptionLevel.mediumSoaked:     return const Color(0xFFFCE7F3);
      case PadAbsorptionLevel.fullySoakedFast:  return const Color(0xFFFFF1F3);
      case PadAbsorptionLevel.changedSheetsNight: return const Color(0xFFFFF1F3);
    }
  }

  Color get _borderColor {
    if (!isSelected) return const Color(0xFFEDE9FE);
    switch (level) {
      case PadAbsorptionLevel.lightDamp:        return NivakinColors.primaryAccent.withValues(alpha: 0.4);
      case PadAbsorptionLevel.mediumSoaked:     return NivakinColors.primaryAccent;
      case PadAbsorptionLevel.fullySoakedFast:  return NivakinColors.alert;
      case PadAbsorptionLevel.changedSheetsNight: return NivakinColors.alert;
    }
  }

  String get _title {
    switch (level) {
      case PadAbsorptionLevel.lightDamp:          return 'Light / Spotting';
      case PadAbsorptionLevel.mediumSoaked:       return 'Normal Flow';
      case PadAbsorptionLevel.fullySoakedFast:    return 'Soaking Fast';
      case PadAbsorptionLevel.changedSheetsNight: return 'Leaked Overnight';
    }
  }

  String get _subtitle {
    switch (level) {
      case PadAbsorptionLevel.lightDamp:          return 'A few spots on the pad';
      case PadAbsorptionLevel.mediumSoaked:       return 'Pad half or mostly full';
      case PadAbsorptionLevel.fullySoakedFast:    return 'Soaked through in 1–2 hrs';
      case PadAbsorptionLevel.changedSheetsNight: return 'Leaked onto clothes or sheets';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(NivakinRadius.md),
          border: Border.all(color: _borderColor, width: isSelected ? 2 : 1.5),
          boxShadow: isSelected
              ? [BoxShadow(color: _borderColor.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          children: [
            // Pad visual indicator
            _PadVisualIcon(level: level, isSelected: isSelected),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: level.isHeavyBleeding
                          ? NivakinColors.alert
                          : NivakinColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: NivakinColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: level.isHeavyBleeding ? NivakinColors.alert : NivakinColors.primaryAccent,
                size: 20,
              ).animate().scale(duration: 200.ms, curve: Curves.elasticOut),
          ],
        ),
      ).animate(target: isSelected ? 1 : 0).scale(
        begin: const Offset(1, 1),
        end: const Offset(1.01, 1.01),
        duration: 150.ms,
      ),
    );
  }
}

// ── Pad Visual Icon ────────────────────────────────────────────
// Uses filled/unfilled segments to represent absorption visually.
class _PadVisualIcon extends StatelessWidget {
  final PadAbsorptionLevel level;
  final bool isSelected;

  const _PadVisualIcon({required this.level, required this.isSelected});

  int get _filledSegments {
    switch (level) {
      case PadAbsorptionLevel.lightDamp:          return 1;
      case PadAbsorptionLevel.mediumSoaked:       return 2;
      case PadAbsorptionLevel.fullySoakedFast:    return 3;
      case PadAbsorptionLevel.changedSheetsNight: return 3;
    }
  }

  Color get _fillColor {
    if (level.isHeavyBleeding) return NivakinColors.alert;
    if (level == PadAbsorptionLevel.mediumSoaked) return NivakinColors.primaryAccent;
    return NivakinColors.primaryAccent.withValues(alpha: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pad outline
          Container(
            width: 28,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
            ),
          ),
          // Filled segments (blood visualization)
          Positioned(
            bottom: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final isFilled = i < _filledSegments;
                return Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 18,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isFilled ? _fillColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).reversed.toList(),
            ),
          ),
          // Warning icon for emergency levels
          if (level.isHeavyBleeding)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: NivakinColors.alert,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.priority_high_rounded, size: 10, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Full Pad Meter Selector Widget ──────────────────────────────
class PadMeterSelector extends StatelessWidget {
  final PadAbsorptionLevel? selected;
  final ValueChanged<PadAbsorptionLevel> onChanged;

  const PadMeterSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How heavy is your flow?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'Tap the option that best describes your pad right now',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: NivakinColors.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        ...PadAbsorptionLevel.values.map((level) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PadMeterChip(
            level: level,
            isSelected: selected == level,
            onTap: () => onChanged(level),
          ),
        )),
        if (selected?.isHeavyBleeding == true)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NivakinColors.alertSoft,
              borderRadius: BorderRadius.circular(NivakinRadius.md),
              border: Border.all(color: NivakinColors.alert.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: NivakinColors.alert, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Heavy flow detected — we\'ll make sure you get the right guidance.',
                    style: TextStyle(
                      color: NivakinColors.alert,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
