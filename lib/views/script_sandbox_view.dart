// ============================================================
// views/script_sandbox_view.dart
// "Baat Kaise Karein?" — Interactive conversation simulator & elder script builder.
// Tabs: Mummy, Didi, Doctor, Warden.
// Styled with real WhatsApp conversation bubble aesthetics + practice simulator.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../state/nivakin_state.dart';
import '../models/nivakin_schema.dart';
import '../theme/nivakin_theme.dart';
import 'components/whatsapp_export.dart';

const _tabs = [
  _ScriptTab(label: 'Mummy', emoji: '👩', subtab: 'mummy'),
  _ScriptTab(label: 'Didi',  emoji: '👧', subtab: 'didi'),
  _ScriptTab(label: 'Doctor', emoji: '🩺', subtab: 'doctor'),
  _ScriptTab(label: 'Warden', emoji: '🏫', subtab: 'warden'),
];

class _ScriptTab {
  final String label;
  final String emoji;
  final String subtab;
  const _ScriptTab({required this.label, required this.emoji, required this.subtab});
}

class ScriptSandboxView extends StatefulWidget {
  const ScriptSandboxView({super.key});

  @override
  State<ScriptSandboxView> createState() => _ScriptSandboxViewState();
}

class _ScriptSandboxViewState extends State<ScriptSandboxView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showPracticeChat = false;
  String? _practiceReply;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<NivakinAppState>().setActiveScriptTab(_tabController.index);
        setState(() {
          _showPracticeChat = false;
          _practiceReply = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getScript(ElderScripts scripts, int tabIndex) {
    switch (tabIndex) {
      case 0: return scripts.mummyScript;
      case 1: return scripts.didiScript;
      case 2: return scripts.doctorScript;
      case 3: return scripts.wardenScript;
      default: return scripts.mummyScript;
    }
  }

  Color _getTabAccentColor(int index) {
    return switch (index) {
      0 => NivakinColors.primaryAccent,
      1 => NivakinColors.secondaryAccent,
      2 => NivakinColors.softAmber,
      3 => const Color(0xFF6B7280),
      _ => NivakinColors.primaryAccent,
    };
  }

  void _triggerPracticeReply(String recipient) {
    setState(() => _showPracticeChat = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _practiceReply = _getSimulatedReply(recipient));
      }
    });
  }

  String _getSimulatedReply(String recipient) {
    switch (recipient) {
      case 'Mummy':
        return 'Arre beti, bilkul pareshan mat ho. Main hot water bottle aur warm tea lekar aati hoon. Thoda rest karo 💜';
      case 'Didi':
        return 'Oh no 😩 haan cramps bohot annoying hote hain. Heating pad use kar aur legs elevate karke let jaa. Main warm water lati hoon 🥺';
      case 'Doctor':
        return 'Thank you for explaining so clearly. Let\'s check your history and find comfortable relief options that work well for school hours.';
      case 'Warden':
        return 'Of course, please rest in the sick room. I will inform your class teacher. Get well soon.';
      default:
        return 'Thank you for telling me. I am here to help you 💜';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();
    final scripts = state.response?.elderScripts;

    if (scripts == null) {
      return const Scaffold(body: Center(child: Text('No scripts generated yet')));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: NivakinColors.blossomGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, state),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildTabBar(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs.asMap().entries.map((entry) {
                    final i = entry.key;
                    final tab = entry.value;
                    final script = _getScript(scripts, i);
                    final accent = _getTabAccentColor(i);
                    return _buildScriptTab(
                      context: context,
                      state: state,
                      tab: tab,
                      script: script,
                      accentColor: accent,
                      tabIndex: i,
                    );
                  }).toList(),
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
                borderRadius: BorderRadius.circular(24),
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
                Text('Baat Kaise Karein?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text('Ready-to-share WhatsApp scripts',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NivakinColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: NivakinColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.5),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: NivakinColors.pinkLilacGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.white,
        unselectedLabelColor: NivakinColors.textMuted,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        tabs: _tabs.map((t) => Tab(
          height: 44,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(t.emoji, style: const TextStyle(fontSize: 14)),
              Text(t.label),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildScriptTab({
    required BuildContext context,
    required NivakinAppState state,
    required _ScriptTab tab,
    required String script,
    required Color accentColor,
    required int tabIndex,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHowToHeader(tab, accentColor),
          const SizedBox(height: 16),
          ScriptPreviewCard(
            title: 'Your message for ${tab.label}',
            script: script,
            recipientLabel: tab.label,
            accentColor: accentColor,
          ),
          const SizedBox(height: 16),
          if (!_showPracticeChat)
            _buildPracticeButton(tab, accentColor),
          if (_showPracticeChat)
            _buildPracticeChat(script, tab, accentColor),
        ],
      ),
    );
  }

  Widget _buildHowToHeader(_ScriptTab tab, Color accent) {
    final hints = {
      'mummy': 'Send this over WhatsApp, or read it out loud to Mummy. Written to be respectful and gentle.',
      'didi':  'A casual, warm message for Didi. Send it on WhatsApp or read it out.',
      'doctor':'Structured clinical points. Show your phone screen to the doctor during your visit.',
      'warden':'Formal permission note for school or hostel warden.',
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Text(tab.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hints[tab.subtab] ?? '',
              style: TextStyle(
                fontSize: 13,
                color: accent,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeButton(_ScriptTab tab, Color accent) {
    return GestureDetector(
      onTap: () => _triggerPracticeReply(tab.label),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: NivakinColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💬', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Text(
              'Practice: See how ${tab.label} might reply',
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildPracticeChat(String script, _ScriptTab tab, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Practice chat preview',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: NivakinColors.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: NivakinColors.pinkLilacGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              script.length > 200 ? '${script.substring(0, 200)}...' : script,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.15, end: 0),
        const SizedBox(height: 8),
        if (_practiceReply == null)
          _TypingIndicator(color: accent)
              .animate().fadeIn(duration: 300.ms)
        else
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(tab.emoji, style: const TextStyle(fontSize: 16))),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 260),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: NivakinColors.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(color: const Color(0xFFEDE9FE)),
                    ),
                    child: Text(
                      _practiceReply!,
                      style: const TextStyle(
                        color: NivakinColors.textPrimary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.15, end: 0),
      ],
    );
  }
}

// ── Typing Indicator ──────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  final Color color;
  const _TypingIndicator({required this.color});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: NivakinColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEDE9FE)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: widget.color.withValues(
                  alpha: 0.3 + 0.7 * (((_ctrl.value + i * 0.33) % 1.0)),
                ),
                shape: BoxShape.circle,
              ),
            ),
          )),
        ),
      ),
    );
  }
}
