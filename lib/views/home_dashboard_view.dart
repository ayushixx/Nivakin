// ============================================================
// views/home_dashboard_view.dart
// View 1: Home Dashboard View
// Clean dashboard: quick status, connection chip, 4 action cards,
// dynamic "Myth of the Day" micro-card, and discreet floral panic button.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/nivakin_theme.dart';
import '../state/nivakin_state.dart';

class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({super.key});

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  int _mythIndex = 0;

  static const List<Map<String, String>> _indianMyths = [
    {
      'myth': 'Eating curd, sour foods, or pickles stops your flow or worsens cramps.',
      'fact': '100% Myth! Sour foods have no connection to menstrual flow or uterus contractions. Curd is rich in calcium and great for gut health!',
    },
    {
      'myth': 'Washing your hair during periods makes blood flow freeze.',
      'fact': '100% Myth! Bathing or washing hair is healthy and safe. Warm water relaxes your muscles and reduces period pain.',
    },
    {
      'myth': 'You should avoid playing sports or exercising on your period.',
      'fact': '100% Myth! Light exercise releases endorphins — your body\'s natural pain relievers. Movement eases cramping!',
    },
    {
      'myth': 'First periods are always perfectly 28 days apart.',
      'fact': '100% Myth! Irregular cycles during the first 1–2 years are completely normal as your hormone system builds its rhythm.',
    },
  ];

  void _nextMyth() {
    setState(() {
      _mythIndex = (_mythIndex + 1) % _indianMyths.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();

    return Scaffold(
      backgroundColor: NivakinColors.blossomWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: NivakinColors.blossomPinkBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🌸', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Namaste, Betu 🌸',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: NivakinColors.charcoalSlate,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: NivakinColors.tealBadge,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Offline Safe (Local Gemma)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: NivakinColors.textSubtle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Discreet Floral Panic Icon
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: NivakinColors.blossomPinkBg,
                        borderRadius: BorderRadius.circular(NivakinRadius.pill),
                        border: Border.all(color: NivakinColors.rosePink.withOpacity(0.3)),
                      ),
                      child: const Icon(
                        Icons.local_florist_rounded,
                        color: NivakinColors.rosePink,
                        size: 22,
                      ),
                    ),
                    onPressed: () => state.activateDisguise(),
                    tooltip: 'Quick Disguise Shield',
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily Check-in Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [NivakinColors.blossomPinkBg, NivakinColors.softLilacBg],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(NivakinRadius.card),
                        border: Border.all(color: NivakinColors.rosePink.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(NivakinRadius.pill),
                                ),
                                child: const Text(
                                  '✨ Daily Companion',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: NivakinColors.rosePink,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Text('100% Private', style: TextStyle(fontSize: 11, color: NivakinColors.textSubtle)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'How does your body feel today?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: NivakinColors.charcoalSlate,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ask a question, check symptoms, or practice talking with Mummy or Didi.',
                            style: TextStyle(
                              fontSize: 13,
                              color: NivakinColors.textSubtle,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => state.navigateTo(AppScreen.intake),
                            icon: const Icon(Icons.favorite_rounded, size: 18),
                            label: const Text('Start Intake & Symptom Check'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: NivakinColors.rosePink,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(NivakinRadius.pill),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Quick-Action Grid ──────────────────────────────────
                    const Text(
                      'Explore Nivakin 🌸',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: NivakinColors.charcoalSlate,
                      ),
                    ),
                    const SizedBox(height: 12),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 110,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return _buildActionCard(
                              emoji: '🌸',
                              title: 'Question or Symptom',
                              subtitle: 'Check cramps, cycle dates, or flow',
                              color: NivakinColors.blossomPinkBg,
                              borderColor: NivakinColors.rosePink.withOpacity(0.3),
                              onTap: () => state.navigateTo(AppScreen.intake),
                            );
                          case 1:
                            return _buildActionCard(
                              emoji: '💬',
                              title: 'Ask Offline Gemma',
                              subtitle: 'Zero data local Q&A chat',
                              color: NivakinColors.softLilacBg,
                              borderColor: NivakinColors.softLilac,
                              onTap: () => state.navigateTo(AppScreen.offlineGemmaChat),
                            );
                          case 2:
                            return _buildActionCard(
                              emoji: '📝',
                              title: 'Baat Kaise Karein?',
                              subtitle: 'WhatsApp scripts for Mummy & Didi',
                              color: const Color(0xFFDCF8C6).withOpacity(0.5),
                              borderColor: const Color(0xFF25D366).withOpacity(0.4),
                              onTap: () => state.navigateTo(AppScreen.scriptSandbox),
                            );
                          case 3:
                          default:
                            return _buildActionCard(
                              emoji: '🩺',
                              title: 'Doctor Visit Card',
                              subtitle: '1-Page summary for clinic visits',
                              color: const Color(0xFFFEF3C7),
                              borderColor: NivakinColors.softAmber.withOpacity(0.4),
                              onTap: () => state.navigateTo(AppScreen.doctorPrep),
                            );
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── "Myth of the Day" Micro-Card ───────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NivakinColors.cardWhite,
                        borderRadius: BorderRadius.circular(NivakinRadius.card),
                        border: Border.all(color: NivakinColors.borderSoft),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: NivakinColors.softLilacBg,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text('💡', style: TextStyle(fontSize: 16)),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Myth of the Day',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: NivakinColors.purpleAccent,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: _nextMyth,
                                borderRadius: BorderRadius.circular(NivakinRadius.pill),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: NivakinColors.softLilacBg,
                                    borderRadius: BorderRadius.circular(NivakinRadius.pill),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Next Myth',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: NivakinColors.purpleAccent,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.refresh_rounded, size: 12, color: NivakinColors.purpleAccent),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '❌ MYTH: "${_indianMyths[_mythIndex]['myth']}"',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '✅ FACT: ${_indianMyths[_mythIndex]['fact']}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: NivakinColors.charcoalSlate,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NivakinRadius.card),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(NivakinRadius.card),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: NivakinColors.charcoalSlate,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                color: NivakinColors.textSubtle,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
