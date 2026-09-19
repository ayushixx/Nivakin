// ============================================================
// pipeline/gemini_orchestrator.dart
// TIER 3 — Gemini 1.5 Flash Cloud Orchestrator.
// Grounded AI Navigation Engine using official google_generative_ai SDK.
// Enforces temperature: 0.2, responseMimeType: 'application/json'.
// NEVER outputs medical diagnoses or drug dosages.
// ============================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/nivakin_schema.dart';
import '../config/feature_flags.dart';

extension NivakinResponseNavigationExt on NivakinNavigationResponse {
  String get quickVerdict {
    if (bucketA_knownFacts.isNotEmpty && bucketA_knownFacts.first.startsWith('Verdict:')) {
      return bucketA_knownFacts.first.replaceFirst('Verdict:', '').trim();
    }
    if (bucketB_friendlyContext.isNotEmpty) {
      return bucketB_friendlyContext.first;
    }
    return 'Your body is going through normal developmental changes, and everything is going to be okay.';
  }

  String get nextStep {
    if (bucketC_doctorQuestions.isNotEmpty && bucketC_doctorQuestions.last.startsWith('Next Step:')) {
      return bucketC_doctorQuestions.last.replaceFirst('Next Step:', '').trim();
    }
    return 'Use a warm water bottle, rest, and share the WhatsApp script with Mummy or Didi.';
  }
}

class GeminiOrchestrator {
  static const String _modelId = 'gemini-1.5-flash';
  static const double _temperature = 0.2; // Strict grounding to eliminate hallucinations
  static const String _responseMimeType = 'application/json';

  /// Main synthesis call using official google_generative_ai SDK.
  /// Falls back to a curated local response if Gemini is unavailable or unconfigured.
  static Future<NivakinNavigationResponse> synthesize({
    required ExtractedSlots slots,
    required String language, // 'english' | 'hindi' | 'hinglish'
    String? apiKey,
  }) async {
    final effectiveApiKey = apiKey ?? const String.fromEnvironment('GEMINI_API_KEY');

    if (!FeatureFlags.useGeminiCloud || effectiveApiKey.isEmpty) {
      debugPrint('[GeminiOrchestrator] Cloud disabled or no API key — using grounded local response');
      return _buildLocalFallbackResponse(slots, language);
    }

    try {
      final prompt = _buildPrompt(slots, language);
      
      final model = GenerativeModel(
        model: _modelId,
        apiKey: effectiveApiKey,
        generationConfig: GenerationConfig(
          temperature: _temperature,
          responseMimeType: _responseMimeType,
        ),
      );

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        final jsonStr = _sanitizeJson(response.text!);
        final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
        return _parseAndValidateResponse(jsonMap, slots, language);
      } else {
        debugPrint('[GeminiOrchestrator] Empty response from GenAI SDK — using fallback');
        return _buildLocalFallbackResponse(slots, language);
      }
    } catch (e) {
      debugPrint('[GeminiOrchestrator] GenAI SDK Exception: $e — falling back to grounded response');
      return _buildLocalFallbackResponse(slots, language);
    }
  }

  static String _sanitizeJson(String rawText) {
    var cleaned = rawText.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    return cleaned.trim();
  }

  static NivakinNavigationResponse _parseAndValidateResponse(
    Map<String, dynamic> j,
    ExtractedSlots slots,
    String language,
  ) {
    final isNewToMenstruation = slots.menarcheStage.isNewToMenstruation;
    final hasSchoolImpact = slots.schoolMissed == true;

    final rawVerdict = j['quick_verdict'] ?? j['quickVerdict'] ?? '';
    final rawNextStep = j['next_step'] ?? j['nextStep'] ?? '';

    final rawBucketA = List<String>.from(j['bucket_a_facts'] ?? j['bucketA_knownFacts'] ?? []);
    final rawBucketB = List<String>.from(j['bucket_b_biology_and_myths'] ?? j['bucketB_friendlyContext'] ?? []);
    final rawBucketC = List<String>.from(j['bucket_c_doctor_boundaries'] ?? j['bucketC_doctorQuestions'] ?? []);

    if (rawVerdict.isNotEmpty && !rawBucketA.any((b) => b.startsWith('Verdict:'))) {
      rawBucketA.insert(0, 'Verdict: $rawVerdict');
    }
    if (rawNextStep.isNotEmpty && !rawBucketC.any((b) => b.startsWith('Next Step:'))) {
      rawBucketC.add('Next Step: $rawNextStep');
    }

    final scriptsMap = j['whatsapp_scripts'] as Map<String, dynamic>?;
    final mummyScript = scriptsMap?['mummy'] ?? _getMummyScript(slots, language, hasSchoolImpact);
    final didiScript  = scriptsMap?['didi'] ?? _getDidiScript(slots, language);
    final doctorScript = scriptsMap?['doctor'] ?? _getDoctorScript(slots);
    final wardenScript = scriptsMap?['warden'] ?? _getWardenScript(slots);

    return NivakinNavigationResponse(
      triageLevel: TriageLevelJson.fromJson(j['triageLevel'] ?? 'NORMAL_DEVELOPMENTAL'),
      bucketA_knownFacts: rawBucketA.isNotEmpty ? rawBucketA : _buildLocalFallbackResponse(slots, language).bucketA_knownFacts,
      bucketB_friendlyContext: rawBucketB.isNotEmpty ? rawBucketB : _buildLocalFallbackResponse(slots, language).bucketB_friendlyContext,
      bucketC_doctorQuestions: rawBucketC.isNotEmpty ? rawBucketC : _buildLocalFallbackResponse(slots, language).bucketC_doctorQuestions,
      menarcheIrregularityReassurance: j['menarcheIrregularityReassurance'] ?? isNewToMenstruation,
      elderScripts: ElderScripts(
        mummyScript: mummyScript,
        didiScript: didiScript,
        doctorScript: doctorScript,
        wardenScript: wardenScript,
      ),
      clinicianCard: ClinicianCard(
        chiefSymptom: slots.primarySymptom ?? 'Period discomfort',
        duration: slots.durationDays != null ? '${slots.durationDays} days' : 'Current cycle',
        impactOnSchool: hasSchoolImpact ? 'Affecting school attendance' : 'Manageable',
        specificQuestionsToAsk: rawBucketC,
        reliefMethodsTried: slots.reliefMethodsTried,
      ),
    );
  }

  static String _buildPrompt(ExtractedSlots slots, String language) {
    return '''
You are Nivakin, a grounded, empathetic, non-hallucinating health navigation companion for young girls (ages 11–18) in India.
Config: response_mime_type: "$_responseMimeType", temperature: $_temperature
Language output: $language (Hinglish = natural English + Hindi mix, e.g. "Mummy, mujhe cramps hain")
Extracted slots: ${jsonEncode(slots.toJson())}

Respond ONLY with a valid JSON object matching this exact 3-bucket contract schema:
{
  "triageLevel": "NORMAL_DEVELOPMENTAL" | "PRACTITIONER_DISCUSSION_NEEDED" | "EMERGENCY_ESCALATION",
  "quick_verdict": "One comforting, clear sentence explaining the situation directly to an 11-year-old.",
  "bucket_a_facts": ["Confirmed inputs from the user (age/stage, symptom, duration, flow)."],
  "bucket_b_biology_and_myths": ["Physiological developmental context (e.g., anovulatory early cycles) and myth-busting (curd, sour foods, hair wash taboos)."],
  "bucket_c_doctor_boundaries": ["Explicit boundaries on what needs a clinical physical checkup."],
  "next_step": "The single most important practical action right now (e.g. warm water bottle, rest, WhatsApp script).",
  "menarcheIrregularityReassurance": true|false,
  "whatsapp_scripts": {
    "mummy": "Respectful script for Mummy highlighting study impact in $language.",
    "didi": "Warm, casual script for Didi in $language.",
    "doctor": "Structured clinical summary points for doctor visit.",
    "warden": "Formal permission note for school/hostel warden."
  }
}

STRICT BOUNDARY RULES:
1. NEVER output medical diagnoses (e.g., "Endometriosis", "PCOS", "Adenomyosis", "Cysts").
2. NEVER output specific drug dosages or prescription names.
3. Reading comprehension level: Grade 5–6 (plain words, warm reassuring tone, short sentences).
4. Myth busting MUST explicitly tackle curd, sour foods, hair washing, or pickle taboos if relevant.
''';
  }

  // ── Curated Grounded Local Fallback Response ───────────────────
  static NivakinNavigationResponse _buildLocalFallbackResponse(
    ExtractedSlots slots,
    String language,
  ) {
    final isNewToMenstruation = slots.menarcheStage.isNewToMenstruation;
    final hasSchoolImpact = slots.schoolMissed == true;
    final painScale = slots.painScale ?? 0;
    final isPractitionerLevel = painScale >= 7 || 
        (slots.durationDays != null && slots.durationDays! > 7);

    final triageLevel = isPractitionerLevel
        ? TriageLevel.practitionerDiscussionNeeded
        : TriageLevel.normalDevelopmental;

    final symptom = slots.primarySymptom ?? 'period discomfort';

    final quickVerdictText = isNewToMenstruation
        ? 'Your body is going through normal early cycle changes, and everything is going to be completely okay.'
        : 'Period cramps and flow changes happen as your body grows, and there are simple ways to feel better right now.';

    final bucketA = <String>[
      'Verdict: $quickVerdictText',
      'What you told us: ${symptom[0].toUpperCase()}${symptom.substring(1)}',
      if (slots.painScale != null) 'Pain level: ${slots.painScale} out of 10',
      if (slots.durationDays != null) 'Duration: ${slots.durationDays} days',
      if (slots.padLevel != null) 'Flow rate: ${slots.padLevel!.label}',
      if (hasSchoolImpact) 'Impact: Making it hard to study or attend school',
    ];

    final bucketB = <String>[
      if (isNewToMenstruation)
        '💜 Early Cycle Biology: Periods in the first 1–2 years are often irregular (anovulatory cycles). Your ovaries and hormones are just building their natural monthly rhythm.',
      '🌸 Why Cramps Happen: Prostaglandins cause gentle womb contractions to clear the lining. This is normal body work, not illness.',
      '🥗 Myth Buster: Curd, sour foods, and pickles do NOT affect period flow or pain. You can eat whatever healthy food feels good!',
      '🚿 Myth Buster: Washing your hair during your period is 100% safe. A warm bath or shower actually relaxes tummy muscles.',
      '🧘 Quick Comfort: A warm water bottle on your lower tummy or gentle Child\'s Pose stretching brings fast relief.',
    ];

    final bucketC = <String>[
      'Doctor Checkup Boundary: If cramps keep you out of school for 2+ consecutive cycles, a doctor can check for gentle relief options.',
      'Doctor Checkup Boundary: If a period lasts more than 7 full days continuously, a clinician should evaluate your iron levels.',
      'Doctor Checkup Boundary: If pain strikes suddenly on one side without relief from heat, get a doctor\'s checkup.',
      'Next Step: Apply a warm water bottle, drink warm water, and share the ready WhatsApp script with Mummy or Didi.',
    ];

    final mummyScript  = _getMummyScript(slots, language, hasSchoolImpact);
    final didiScript   = _getDidiScript(slots, language);
    final doctorScript = _getDoctorScript(slots);
    final wardenScript = _getWardenScript(slots);

    return NivakinNavigationResponse(
      triageLevel: triageLevel,
      bucketA_knownFacts: bucketA,
      bucketB_friendlyContext: bucketB,
      bucketC_doctorQuestions: bucketC,
      menarcheIrregularityReassurance: isNewToMenstruation,
      elderScripts: ElderScripts(
        mummyScript: mummyScript,
        didiScript: didiScript,
        doctorScript: doctorScript,
        wardenScript: wardenScript,
      ),
      clinicianCard: ClinicianCard(
        chiefSymptom: symptom,
        duration: slots.durationDays != null ? '${slots.durationDays} days' : 'Current cycle',
        impactOnSchool: hasSchoolImpact ? 'Affecting school attendance / study' : 'Manageable',
        specificQuestionsToAsk: [
          'Is this pain pattern typical for my age and stage?',
          'What non-drowsy options help manage school-time pain?',
        ],
        reliefMethodsTried: slots.reliefMethodsTried,
      ),
    );
  }

  // ── Script Generators ─────────────────────────────────────────

  static String _getMummyScript(ExtractedSlots slots, String lang, bool schoolImpact) {
    if (lang == 'hinglish') {
      return 'Mummy, mujhe aaj period cramps bahut zyada hain'
          '${schoolImpact ? ' aur padhai nahi ho pa rahi' : ''}. '
          '${slots.painScale != null && slots.painScale! >= 6 ? 'Dard kaafi tez hai (${slots.painScale}/10). ' : ''}'
          'Kya aap ek hot water bottle de sakti hain? '
          '${slots.reliefMethodsTried.isNotEmpty ? 'Maine already ${slots.reliefMethodsTried.first} try kiya hai. ' : ''}'
          'Agar thik nahi hua, toh kya hum doctor se baat kar sakte hain?';
    } else if (lang == 'hindi') {
      return 'माँ, आज मुझे पीरियड क्रैम्प्स बहुत ज़्यादा हैं'
          '${schoolImpact ? ' और पढ़ाई नहीं हो पा रही' : ''}. '
          'क्या आप एक गर्म पानी की बोतल दे सकती हैं? '
          'अगर ठीक नहीं हुआ तो क्या हम डॉक्टर के पास जा सकते हैं?';
    } else {
      return 'Mum, I\'m having really bad period cramps today'
          '${schoolImpact ? ' and I\'m finding it hard to study' : ''}. '
          '${slots.painScale != null && slots.painScale! >= 6 ? 'The pain is about ${slots.painScale}/10. ' : ''}'
          'Could you please get me a hot water bottle? '
          'If it doesn\'t ease up soon, can we consult a doctor?';
    }
  }

  static String _getDidiScript(ExtractedSlots slots, String lang) {
    if (lang == 'hinglish') {
      return 'Didi, mujhe period cramps aa rahe hain aur bura lag raha hai 😩 '
          '${slots.painScale != null ? 'Dard ${slots.painScale}/10 jitna hai. ' : ''}'
          'Heating pad se thoda aaram aayega kya? Tujhe kya help karta hai? 🥺';
    } else if (lang == 'hindi') {
      return 'दीदी, मुझे क्रैम्प्स आ रहे हैं 😩 '
          '${slots.painScale != null ? 'दर्द ${slots.painScale}/10 है। ' : ''}'
          'कुछ tips बताओ जो तुम्हारे लिए काम करती हैं 🥺';
    } else {
      return 'Didi, I\'m getting bad period cramps right now 😩 '
          '${slots.painScale != null ? 'Pain is around ${slots.painScale}/10. ' : ''}'
          'What helps you most when you get cramps like this? 🥺';
    }
  }

  static String _getDoctorScript(ExtractedSlots slots) {
    return '''Doctor, I would like to discuss my menstrual health:

• Chief symptom: ${slots.primarySymptom ?? 'Menstrual cramps / cycle question'}
• Duration: ${slots.durationDays != null ? '${slots.durationDays} days' : 'Ongoing this cycle'}
• Pain scale: ${slots.painScale != null ? '${slots.painScale}/10' : 'Moderate'}
• Flow rate: ${slots.padLevel?.label ?? 'Normal'}
• School impact: ${slots.schoolMissed == true ? 'Unable to attend / focus on study' : 'Minimal'}
• Menarche stage: ${slots.menarcheStage.displayLabel}

Questions to discuss:
- Is this symptom pattern typical for my age?
- What safe relief options do you recommend for school days?''';
  }

  static String _getWardenScript(ExtractedSlots slots) {
    return 'Respected Ma\'am,\n\n'
        'I am feeling unwell due to period cramps today'
        '${slots.painScale != null && slots.painScale! >= 6 ? ' (pain scale approx ${slots.painScale}/10)' : ''}. '
        'It is difficult to focus on class right now.\n\n'
        'May I please rest in the sick room for a short while? '
        'I will return to class as soon as I feel better.\n\n'
        'Thank you,\n'
        '[Your Name]';
  }
}
