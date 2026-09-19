// ============================================================
// models/offline_faq_model.dart
// Data models for offline Gemma Q&A and pre-loaded FAQ topics.
// ============================================================

class OfflineFaqItem {
  final String id;
  final String emoji;
  final String question;
  final String answer;
  final String category;

  const OfflineFaqItem({
    required this.id,
    required this.emoji,
    required this.question,
    required this.answer,
    required this.category,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isOfflineGemma;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isOfflineGemma = false,
  });
}

/// Pre-populated suggested offline Q&A prompt pills for young girls.
const List<OfflineFaqItem> defaultOfflineFaqs = [
  OfflineFaqItem(
    id: 'faq_brown_period',
    emoji: '🌸',
    question: 'Why is my period brown?',
    answer: 'Brown blood is completely normal! It is just older blood that took a little longer to leave your body. It often happens at the very start or end of your period.',
    category: 'Cycle Basics',
  ),
  OfflineFaqItem(
    id: 'faq_wash_hair',
    emoji: '🧼',
    question: 'Can I wash my hair during periods?',
    answer: 'Yes! Washing your hair or taking a warm bath during periods is 100% safe and healthy. Warm water actually helps relax your body and relieve cramps.',
    category: 'Hygiene & Myths',
  ),
  OfflineFaqItem(
    id: 'faq_pad_frequency',
    emoji: '🩸',
    question: 'How often should I change a pad?',
    answer: 'Change your pad every 4 to 6 hours, even on light flow days. This keeps you feeling clean, comfortable, and prevents bacterial growth.',
    category: 'Care & Hygiene',
  ),
  OfflineFaqItem(
    id: 'faq_miss_gym',
    emoji: '🏃‍♀️',
    question: 'What if I miss gym or sports class?',
    answer: 'Light walking or gentle movement can relieve cramps, but if you are in pain, resting is completely okay. You can tell your teacher or warden that you have a stomach cramp.',
    category: 'School Life',
  ),
  OfflineFaqItem(
    id: 'faq_curd_pickles',
    emoji: '🍋',
    question: 'Can I eat pickles or curd during periods?',
    answer: 'Yes! Sour foods like curd, pickles, or lemons do NOT stop your period flow or worsen cramps. Curd is rich in calcium and great for your gut health.',
    category: 'Food Myths',
  ),
  OfflineFaqItem(
    id: 'faq_cramps_relief',
    emoji: '🩹',
    question: 'What helps with mild period cramps?',
    answer: 'A warm water bottle on your tummy, sipping warm water, gentle stretching, and resting with your legs elevated work wonders. Always ask an adult if pain persists.',
    category: 'Comfort',
  ),
];
