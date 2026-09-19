// ============================================================
// views/components/whatsapp_export.dart
// Quick WhatsApp formatter for sharing elder scripts.
// Also supports screenshot + camera-roll save for doctor OPD visits.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../../theme/nivakin_theme.dart';

class WhatsAppExportButton extends StatefulWidget {
  final String scriptText;
  final String recipientLabel; // "Mummy", "Didi", "Doctor", "Warden"
  final bool showCopyOption;

  const WhatsAppExportButton({
    super.key,
    required this.scriptText,
    required this.recipientLabel,
    this.showCopyOption = true,
  });

  @override
  State<WhatsAppExportButton> createState() => _WhatsAppExportButtonState();
}

class _WhatsAppExportButtonState extends State<WhatsAppExportButton> {
  bool _copied = false;
  bool _shared = false;

  Future<void> _shareViaWhatsApp() async {
    setState(() => _shared = true);
    try {
      await Share.share(
        widget.scriptText,
        subject: 'Message for ${widget.recipientLabel}',
      );
    } catch (e) {
      // If share fails, fall back to clipboard
      await _copyToClipboard();
    }
    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _shared = false);
      });
    }
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.scriptText));
    if (mounted) {
      setState(() => _copied = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _copied = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // WhatsApp Share Button
        Expanded(
          child: GestureDetector(
            onTap: _shared ? null : _shareViaWhatsApp,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              decoration: BoxDecoration(
                gradient: _shared
                    ? const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)])
                    : NivakinColors.pinkLilacGradient,
                borderRadius: BorderRadius.circular(NivakinRadius.md),
                boxShadow: [
                  BoxShadow(
                    color: (_shared ? const Color(0xFF25D366) : NivakinColors.primaryAccent)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_shared) ...[
                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    const Text(
                      'Sent!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ] else ...[
                    const _WhatsAppIcon(),
                    const SizedBox(width: 8),
                    Text(
                      'Share to ${widget.recipientLabel}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (widget.showCopyOption) ...[
          const SizedBox(width: 10),
          // Copy to clipboard
          GestureDetector(
            onTap: _copied ? null : _copyToClipboard,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _copied ? NivakinColors.success : NivakinColors.surface,
                borderRadius: BorderRadius.circular(NivakinRadius.md),
                border: Border.all(
                  color: _copied ? NivakinColors.success : const Color(0xFFEDE9FE),
                  width: 1.5,
                ),
              ),
              child: Icon(
                _copied ? Icons.check_rounded : Icons.copy_rounded,
                color: _copied ? Colors.white : NivakinColors.textMuted,
                size: 20,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _WhatsAppIcon extends StatelessWidget {
  const _WhatsAppIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'W',
          style: TextStyle(
            color: Color(0xFF25D366),
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ── Script Preview Card ────────────────────────────────────────
/// Shows the full script with share/copy actions at the bottom.
class ScriptPreviewCard extends StatelessWidget {
  final String title;
  final String script;
  final String recipientLabel;
  final Color accentColor;

  const ScriptPreviewCard({
    super.key,
    required this.title,
    required this.script,
    required this.recipientLabel,
    this.accentColor = NivakinColors.primaryAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NivakinColors.surface,
        borderRadius: BorderRadius.circular(NivakinRadius.lg),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_rounded, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          // Script body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              script,
              style: const TextStyle(
                fontSize: 14,
                color: NivakinColors.textPrimary,
                height: 1.7,
              ),
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: WhatsAppExportButton(
              scriptText: script,
              recipientLabel: recipientLabel,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15, end: 0);
  }
}
