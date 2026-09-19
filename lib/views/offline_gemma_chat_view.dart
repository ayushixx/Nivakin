// ============================================================
// views/offline_gemma_chat_view.dart
// View 4: On-Device Offline Gemma Q&A View
// Zero latency, zero network calls, 100% private offline companion.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/nivakin_theme.dart';
import '../models/offline_faq_model.dart';
import '../pipeline/local_gemma_engine.dart';
import '../state/nivakin_state.dart';

class OfflineGemmaChatView extends StatefulWidget {
  const OfflineGemmaChatView({super.key});

  @override
  State<OfflineGemmaChatView> createState() => _OfflineGemmaChatViewState();
}

class _OfflineGemmaChatViewState extends State<OfflineGemmaChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'init_1',
      text: 'Namaste! 🌸 I am your offline Gemma companion. Ask me any question about your body, period cycles, hygiene, or myths. Everything stays right on your phone — no internet or server needed!',
      isUser: false,
      timestamp: DateTime.now(),
      isOfflineGemma: true,
    ),
  ];

  bool _isProcessing = false;

  void _sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty || _isProcessing) return;

    _messageController.clear();

    final userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: query,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isProcessing = true;
    });

    _scrollToBottom();

    // Query on-device Gemma engine
    final result = await LocalGemmaEngine.process(query: query);

    String botAnswer = result.faqAnswer ?? 
        'During puberty (ages 11–18), your body experiences many natural changes. Periods can be irregular, discharge is normal, and cramps can be eased with a hot water bottle. Always remember you are safe and healthy!';

    final botMsg = ChatMessage(
      id: (DateTime.now().microsecondsSinceEpoch + 1).toString(),
      text: botAnswer,
      isUser: false,
      timestamp: DateTime.now(),
      isOfflineGemma: true,
    );

    if (mounted) {
      setState(() {
        _messages.add(botMsg);
        _isProcessing = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<NivakinAppState>();

    return Scaffold(
      backgroundColor: NivakinColors.blossomWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: NivakinColors.cardWhite,
                border: Border(bottom: BorderSide(color: NivakinColors.borderSoft)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: NivakinColors.charcoalSlate),
                    onPressed: () => state.navigateTo(AppScreen.homeDashboard),
                    tooltip: 'Back to Dashboard',
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: NivakinColors.softLilacBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('💬', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Offline Gemma Q&A',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: NivakinColors.charcoalSlate,
                          ),
                        ),
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
                              'On-Device • Zero Server Logs',
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
                  IconButton(
                    icon: const Icon(Icons.local_florist_rounded, color: NivakinColors.rosePink),
                    onPressed: () => state.activateDisguise(),
                    tooltip: 'Quick Disguise',
                  ),
                ],
              ),
            ),

            // ── Suggested Offline Prompt Pills ──────────────────────
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: defaultOfflineFaqs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = defaultOfflineFaqs[index];
                  return InkWell(
                    onTap: () => _sendMessage(item.question),
                    borderRadius: BorderRadius.circular(NivakinRadius.pill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: NivakinColors.softLilacBg,
                        borderRadius: BorderRadius.circular(NivakinRadius.pill),
                        border: Border.all(color: NivakinColors.softLilac.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Text(item.emoji, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            item.question,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: NivakinColors.purpleAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1, color: NivakinColors.borderSoft),

            // ── Messages Stream ────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildChatBubble(msg);
                },
              ),
            ),

            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(NivakinColors.rosePink),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Gemma is thinking on-device...',
                      style: TextStyle(fontSize: 12, color: NivakinColors.textSubtle),
                    ),
                  ],
                ),
              ),

            // ── Text Input Dock ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: NivakinColors.cardWhite,
                border: Border(top: BorderSide(color: NivakinColors.borderSoft)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: _sendMessage,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Ask Gemma a sensitive question...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: NivakinColors.textSubtle.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: NivakinColors.blossomWhite,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NivakinRadius.pill),
                          borderSide: const BorderSide(color: NivakinColors.borderSoft),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NivakinRadius.pill),
                          borderSide: const BorderSide(color: NivakinColors.borderSoft),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NivakinRadius.pill),
                          borderSide: const BorderSide(color: NivakinColors.rosePink, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: NivakinColors.rosePink,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: msg.isUser
              ? NivakinColors.rosePink
              : NivakinColors.softLilacBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!msg.isUser)
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🌸 ', style: TextStyle(fontSize: 12)),
                    Text(
                      'Offline Gemma Engine',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: NivakinColors.purpleAccent,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: msg.isUser ? Colors.white : NivakinColors.charcoalSlate,
                fontWeight: msg.isUser ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
