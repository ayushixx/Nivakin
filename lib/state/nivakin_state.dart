// ============================================================
// state/nivakin_state.dart
// Provider-based state management for the full Nivakin pipeline.
// Tracks intake, disguise mode, language, and pipeline results.
// ============================================================

import 'package:flutter/material.dart';
import '../models/nivakin_schema.dart';
import '../pipeline/safety_interceptor.dart';
import '../pipeline/local_gemma_engine.dart';
import '../pipeline/gemini_orchestrator.dart';
import '../config/feature_flags.dart';

enum AppScreen {
  homeDashboard,
  intake,
  confidence,
  offlineGemmaChat,
  scriptSandbox,
  doctorPrep,
  emergency,
  disguise, // NCERT faux screen
}

enum ProcessingState {
  idle,
  tier1Safety,  // Running deterministic check
  tier2Local,   // Running local slot extractor
  tier3Cloud,   // Running Gemini synthesis
  done,
  error,
}

class NivakinAppState extends ChangeNotifier {
  // ── Screen Routing ──────────────────────────────────────────
  AppScreen _currentScreen = AppScreen.homeDashboard;
  AppScreen get currentScreen => _currentScreen;

  // ── Disguise Mode ───────────────────────────────────────────
  bool _isDisguised = false;
  bool get isDisguised => _isDisguised;

  // ── Language ────────────────────────────────────────────────
  String _language = FeatureFlags.defaultScriptLanguage;
  String get language => _language;

  // ── Intake State ────────────────────────────────────────────
  final TextEditingController queryController = TextEditingController();
  final List<String> _selectedChips = [];
  List<String> get selectedChips => List.unmodifiable(_selectedChips);

  PadAbsorptionLevel? _padLevel;
  PadAbsorptionLevel? get padLevel => _padLevel;

  MenarcheStage _menarcheStage = MenarcheStage.unknown;
  MenarcheStage get menarcheStage => _menarcheStage;

  // ── Pipeline State ──────────────────────────────────────────
  ProcessingState _processingState = ProcessingState.idle;
  ProcessingState get processingState => _processingState;

  SafetyInterceptorResult? _safetyResult;
  SafetyInterceptorResult? get safetyResult => _safetyResult;
  NivakinNavigationResponse? _response;
  NivakinNavigationResponse? get response => _response;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── Script Sandbox State ────────────────────────────────────
  int _activeScriptTab = 0; // 0=Mummy, 1=Didi, 2=Doctor, 3=Warden
  int get activeScriptTab => _activeScriptTab;

  // ── Quick Disguise (Privacy Shield) ─────────────────────────
  /// Instantly swaps to NCERT screen and WIPES all sensitive state from memory.
  void activateDisguise() {
    // Step 1: Clear all TextEditingControllers (undo buffer wipe)
    queryController.clear();

    // Step 2: Invalidate all intake + pipeline state
    _selectedChips.clear();
    _padLevel = null;
    _menarcheStage = MenarcheStage.unknown;
    _response = null;
    _safetyResult = null;
    _errorMessage = null;
    _processingState = ProcessingState.idle;

    // Step 3: Navigate to disguise screen
    _isDisguised = true;
    _currentScreen = AppScreen.disguise;
    notifyListeners();
  }

  void deactivateDisguise() {
    _isDisguised = false;
    _currentScreen = AppScreen.homeDashboard;
    notifyListeners();
  }

  // ── Intake Actions ───────────────────────────────────────────
  void toggleChip(String chip) {
    if (_selectedChips.contains(chip)) {
      _selectedChips.remove(chip);
    } else {
      _selectedChips.add(chip);
    }
    notifyListeners();
  }

  void setPadLevel(PadAbsorptionLevel level) {
    _padLevel = level;
    notifyListeners();
  }

  void setMenarcheStage(MenarcheStage stage) {
    _menarcheStage = stage;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void setActiveScriptTab(int tab) {
    _activeScriptTab = tab;
    notifyListeners();
  }

  void navigateTo(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  // ── Full Pipeline Run ─────────────────────────────────────────
  Future<void> runPipeline() async {
    final rawQuery = [
      queryController.text.trim(),
      ..._selectedChips,
    ].where((s) => s.isNotEmpty).join('. ');

    if (rawQuery.isEmpty) return;

    // TIER 1: Deterministic Safety Check (synchronous)
    _processingState = ProcessingState.tier1Safety;
    notifyListeners();

    final safety = SafetyInterceptor.check(rawQuery);
    final padEmergency = SafetyInterceptor.isPadLevelEmergency(_padLevel);

    if (safety.isEmergency || padEmergency) {
      _safetyResult = safety.isEmergency ? safety : SafetyInterceptorResult(
        isEmergency: true,
        triggerReason: 'Very heavy bleeding detected — please seek medical help right away.',
        resources: safety.resources.isEmpty
            ? const [
                EmergencyResource(name: 'National Emergency', number: '112', description: 'Police, Fire & Medical'),
                EmergencyResource(name: 'Childline India', number: '1098', description: '24×7 helpline'),
              ]
            : safety.resources,
      );
      _processingState = ProcessingState.done;
      _currentScreen = AppScreen.emergency;
      notifyListeners();
      return;
    }

    // TIER 2: Local Slot Extraction
    _processingState = ProcessingState.tier2Local;
    notifyListeners();

    final localResult = await LocalGemmaEngine.process(
      query: rawQuery,
      selectedPadLevel: _padLevel,
      selectedMenarcheStage: _menarcheStage,
    );

    // If FAQ resolved, skip Tier 3 and build a simplified response
    if (localResult.resolvedByFaq && localResult.faqAnswer != null) {
      _response = NivakinNavigationResponse(
        triageLevel: TriageLevel.normalDevelopmental,
        bucketA_knownFacts: ['You asked: $rawQuery'],
        bucketB_friendlyContext: [localResult.faqAnswer!],
        bucketC_doctorQuestions: ['Is there anything else about this topic I should know?'],
        menarcheIrregularityReassurance: localResult.slots.menarcheStage.isNewToMenstruation,
        elderScripts: ElderScripts(
          mummyScript: 'Mum, I had a question about my body and I found some helpful information. Can we talk?',
          didiScript: 'Didi, I had a question about periods — can I tell you what I found?',
          doctorScript: 'Doctor, I have a question about ${localResult.slots.primarySymptom ?? 'my menstrual health'}.',
          wardenScript: 'Ma\'am, I have a health-related question I\'d like some guidance on.',
        ),
        clinicianCard: ClinicianCard(
          chiefSymptom: localResult.slots.primarySymptom ?? rawQuery,
          duration: 'Informational query',
          impactOnSchool: 'Not specified',
          specificQuestionsToAsk: ['Any further guidance on this topic?'],
          reliefMethodsTried: [],
        ),
      );
      _processingState = ProcessingState.done;
      _currentScreen = AppScreen.confidence;
      notifyListeners();
      return;
    }

    // TIER 3: Gemini Cloud Synthesis
    _processingState = ProcessingState.tier3Cloud;
    notifyListeners();

    try {
      _response = await GeminiOrchestrator.synthesize(
        slots: localResult.slots,
        language: _language,
      );
      _processingState = ProcessingState.done;
      _currentScreen = AppScreen.confidence;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _processingState = ProcessingState.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }
}
