// ============================================================
// views/disguise_view.dart
// NCERT Class 10 Chapter 8 "How do Organisms Reproduce?"
// Instant privacy shield — activated by the 🌸 flower button.
// All sensitive session inputs are purged from memory by NivakinAppState.activateDisguise().
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nivakin_state.dart';

class DisguiseView extends StatelessWidget {
  const DisguiseView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildNcertTopBar(context, state),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChapterHeader(),
                    const SizedBox(height: 20),
                    _buildSection('8.1 How do Organisms Reproduce?',
                      'Reproduction is the process by which organisms produce offspring of their own kind. It ensures the continuity of a species from generation to generation. Reproduction may be sexual or asexual. In asexual reproduction, a single organism is capable of producing offspring.\n\n'
                      'In sexual reproduction, two individuals, typically of opposite sexes, are involved. Sexual reproduction allows for greater variation in the offspring, which is essential for the evolution of a species. The process involves the formation of gametes (reproductive cells) and their fusion (fertilisation) to produce a zygote.'),
                    const SizedBox(height: 16),
                    _buildSection('8.2 Reproduction in Plants',
                      'Plants can reproduce both sexually and asexually. Asexual reproduction in plants occurs through:\n\n'
                      '• Vegetative propagation (e.g., runners in strawberry, bulbs in onion)\n'
                      '• Fragmentation (e.g., Spirogyra)\n'
                      '• Spore formation (e.g., Rhizopus, ferns)\n'
                      '• Budding (e.g., Yeast)\n\n'
                      'Sexual reproduction in flowering plants involves the flower, which contains both male (stamen) and female (pistil) reproductive organs. Pollination transfers pollen from anther to stigma. After fertilisation, the ovule develops into a seed and the ovary becomes the fruit.'),
                    const SizedBox(height: 16),
                    _buildSection('8.3 Human Reproductive System',
                      'Human reproduction is sexual. The male reproductive system consists of the testes, vas deferens, seminal vesicles, prostate gland, and penis. The testes produce sperms and the male sex hormone testosterone.\n\n'
                      'The female reproductive system consists of two ovaries, two fallopian tubes, the uterus, and the vagina. The ovaries produce eggs and the female sex hormones oestrogen and progesterone.\n\n'
                      'Fertilisation occurs in the fallopian tube. The fertilised egg (zygote) travels to the uterus and implants in the uterine wall, developing over 9 months into a baby.'),
                    const SizedBox(height: 16),
                    _buildSection('8.4 Reproductive Health',
                      'Maintaining reproductive health is important for every individual. Adolescence (ages 10–19) marks the onset of puberty, during which the body undergoes significant physical, hormonal, and psychological changes.\n\n'
                      'In girls: Growth in height, development of breasts, widening of hips, growth of pubic and underarm hair, onset of menstruation (menarche).\n\n'
                      'In boys: Voice deepening, growth of facial hair, broadening of shoulders, production of sperm begins.\n\n'
                      'Menstruation is a natural, monthly process in which the uterine lining is shed if fertilisation has not occurred. The menstrual cycle is approximately 28 days, though individual variation is common, especially in the first 1–2 years after menarche.'),
                    const SizedBox(height: 16),
                    _buildDiagramCard(),
                    const SizedBox(height: 16),
                    _buildSection('Key Terms',
                      '• Gamete: A reproductive cell (sperm or egg) that contains half the genetic material of a normal body cell.\n'
                      '• Zygote: The fertilised egg formed by fusion of sperm and egg.\n'
                      '• Menarche: The first occurrence of menstruation.\n'
                      '• Puberty: The period of physical and hormonal maturation.\n'
                      '• Pollination: Transfer of pollen from anther to stigma in plants.\n'
                      '• Fertilisation: Fusion of male and female gametes.'),
                    const SizedBox(height: 24),
                    _buildExerciseBox(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNcertTopBar(BuildContext context, NivakinAppState state) {
    return Container(
      color: const Color(0xFF1A3A6B),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          const Text('📚', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NCERT Science Class X',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                Text('Chapter 8 — How do Organisms Reproduce?',
                  style: TextStyle(
                    color: Color(0xFFBFD3F2),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Hidden tap area (48x48dp touch target) to return to Nivakin
          GestureDetector(
            onTap: state.deactivateDisguise,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.bookmark_outlined, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chapter 8',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'How do Organisms Reproduce?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 3, width: 60, color: const Color(0xFF1A3A6B)),
        const SizedBox(height: 12),
        const Text(
          'In this chapter, we will study the different modes of reproduction used by various organisms. We will understand why reproduction is essential for continuity of life.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF374151),
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String heading, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A3A6B),
          ),
        ),
        const SizedBox(height: 8),
        Text(body,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF374151),
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildDiagramCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFD3F2), width: 1.5),
      ),
      child: Column(
        children: [
          const Text('Fig. 8.1 — Schematic Diagram of Human Reproductive System',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF1A3A6B),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                '[ Diagram: Female Reproductive System ]\n'
                'Ovary → Fallopian Tube → Uterus → Cervix → Vagina',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  height: 1.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Source: NCERT Science Textbook Class X, Chapter 8',
            style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFBC02D), width: 1.5),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📝 Exercises — Chapter 8',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Color(0xFF78350F),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '1. What is the significance of reproduction in organisms?\n'
            '2. What is the difference between asexual and sexual reproduction?\n'
            '3. Name the male and female gametes in humans.\n'
            '4. Where does fertilisation occur in the human female body?\n'
            '5. Define menarche. What changes occur during puberty in females?',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
