// ============================================================
// models/nivakin_schema.dart
// Typed data contracts for the full Nivakin pipeline.
// Strict JSON serialization for Gemini Cloud <-> Flutter layer.
// ============================================================

enum TriageLevel {
  normalDevelopmental,
  practitionerDiscussionNeeded,
  emergencyEscalation,
}

extension TriageLevelJson on TriageLevel {
  String toJson() {
    switch (this) {
      case TriageLevel.normalDevelopmental:
        return 'NORMAL_DEVELOPMENTAL';
      case TriageLevel.practitionerDiscussionNeeded:
        return 'PRACTITIONER_DISCUSSION_NEEDED';
      case TriageLevel.emergencyEscalation:
        return 'EMERGENCY_ESCALATION';
    }
  }

  static TriageLevel fromJson(String value) {
    switch (value) {
      case 'PRACTITIONER_DISCUSSION_NEEDED':
        return TriageLevel.practitionerDiscussionNeeded;
      case 'EMERGENCY_ESCALATION':
        return TriageLevel.emergencyEscalation;
      default:
        return TriageLevel.normalDevelopmental;
    }
  }
}

// ── Menarche Staging (adolescent-specific) ────────────────────
enum MenarcheStage {
  lessThanOneYear,   // < 1 year since first period → cycles WILL be irregular; normal
  oneToTwoYears,     // 1–2 years → still normalising
  moreThanTwoYears,  // 2+ years → established cycle
  unknown,
}

extension MenarcheStageLabel on MenarcheStage {
  String get displayLabel {
    switch (this) {
      case MenarcheStage.lessThanOneYear:   return 'Less than 1 year ago';
      case MenarcheStage.oneToTwoYears:     return '1–2 years ago';
      case MenarcheStage.moreThanTwoYears:  return '2+ years ago';
      case MenarcheStage.unknown:           return 'Not sure';
    }
  }

  bool get isNewToMenstruation =>
    this == MenarcheStage.lessThanOneYear ||
    this == MenarcheStage.oneToTwoYears;
}

// ── Pad Absorption Level (Indian adolescent-appropriate) ──────
enum PadAbsorptionLevel {
  lightDamp,        // A few spots / light spotting
  mediumSoaked,     // Half or more soaked  
  fullySoakedFast,  // Fully soaked in < 1–2 hours → red flag
  changedSheetsNight, // Leaked onto clothes/sheets overnight → red flag
}

extension PadLevelLabel on PadAbsorptionLevel {
  String get label {
    switch (this) {
      case PadAbsorptionLevel.lightDamp:          return 'Light / spotting';
      case PadAbsorptionLevel.mediumSoaked:       return 'Normal / medium flow';
      case PadAbsorptionLevel.fullySoakedFast:    return 'Soaking through quickly';
      case PadAbsorptionLevel.changedSheetsNight: return 'Leaked onto clothes / sheets';
    }
  }

  String get emoji {
    switch (this) {
      case PadAbsorptionLevel.lightDamp:          return '🩸';
      case PadAbsorptionLevel.mediumSoaked:       return '🩸🩸';
      case PadAbsorptionLevel.fullySoakedFast:    return '🩸🩸🩸';
      case PadAbsorptionLevel.changedSheetsNight: return '⚠️';
    }
  }

  bool get isHeavyBleeding =>
    this == PadAbsorptionLevel.fullySoakedFast ||
    this == PadAbsorptionLevel.changedSheetsNight;
}

// ── Extracted Slots (Tier 2 output → Tier 3 input) ────────────
class ExtractedSlots {
  final String? primarySymptom;
  final int? durationDays;
  final int? painScale;           // 1–10
  final bool? schoolMissed;
  final PadAbsorptionLevel? padLevel;
  final List<String> reliefMethodsTried;
  final MenarcheStage menarcheStage;
  final String? rawQuery;

  const ExtractedSlots({
    this.primarySymptom,
    this.durationDays,
    this.painScale,
    this.schoolMissed,
    this.padLevel,
    this.reliefMethodsTried = const [],
    this.menarcheStage = MenarcheStage.unknown,
    this.rawQuery,
  });

  Map<String, dynamic> toJson() => {
    'primarySymptom': primarySymptom,
    'durationDays': durationDays,
    'painScale': painScale,
    'schoolMissed': schoolMissed,
    'padLevel': padLevel?.label,
    'reliefMethodsTried': reliefMethodsTried,
    'menarcheStage': menarcheStage.displayLabel,
    'rawQuery': rawQuery,
  };

  ExtractedSlots copyWith({
    String? primarySymptom,
    int? durationDays,
    int? painScale,
    bool? schoolMissed,
    PadAbsorptionLevel? padLevel,
    List<String>? reliefMethodsTried,
    MenarcheStage? menarcheStage,
    String? rawQuery,
  }) => ExtractedSlots(
    primarySymptom: primarySymptom ?? this.primarySymptom,
    durationDays: durationDays ?? this.durationDays,
    painScale: painScale ?? this.painScale,
    schoolMissed: schoolMissed ?? this.schoolMissed,
    padLevel: padLevel ?? this.padLevel,
    reliefMethodsTried: reliefMethodsTried ?? this.reliefMethodsTried,
    menarcheStage: menarcheStage ?? this.menarcheStage,
    rawQuery: rawQuery ?? this.rawQuery,
  );
}

// ── Elder Scripts ─────────────────────────────────────────────
class ElderScripts {
  final String mummyScript;
  final String didiScript;
  final String doctorScript;
  final String wardenScript; // school/hostel warden

  const ElderScripts({
    required this.mummyScript,
    required this.didiScript,
    required this.doctorScript,
    required this.wardenScript,
  });

  factory ElderScripts.fromJson(Map<String, dynamic> j) => ElderScripts(
    mummyScript:  j['mummyScript']  ?? '',
    didiScript:   j['didiScript']   ?? '',
    doctorScript: j['doctorScript'] ?? '',
    wardenScript: j['wardenScript'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'mummyScript':  mummyScript,
    'didiScript':   didiScript,
    'doctorScript': doctorScript,
    'wardenScript': wardenScript,
  };
}

// ── Clinician Card ────────────────────────────────────────────
class ClinicianCard {
  final String chiefSymptom;
  final String duration;
  final String impactOnSchool;
  final List<String> specificQuestionsToAsk;
  final List<String> reliefMethodsTried;

  const ClinicianCard({
    required this.chiefSymptom,
    required this.duration,
    required this.impactOnSchool,
    required this.specificQuestionsToAsk,
    required this.reliefMethodsTried,
  });

  factory ClinicianCard.fromJson(Map<String, dynamic> j) => ClinicianCard(
    chiefSymptom:           j['chiefSymptom']       ?? '',
    duration:               j['duration']           ?? '',
    impactOnSchool:         j['impactOnSchool']     ?? '',
    specificQuestionsToAsk: List<String>.from(j['specificQuestionsToAsk'] ?? []),
    reliefMethodsTried:     List<String>.from(j['reliefMethodsTried']     ?? []),
  );

  Map<String, dynamic> toJson() => {
    'chiefSymptom':           chiefSymptom,
    'duration':               duration,
    'impactOnSchool':         impactOnSchool,
    'specificQuestionsToAsk': specificQuestionsToAsk,
    'reliefMethodsTried':     reliefMethodsTried,
  };
}

// ── MASTER RESPONSE CONTRACT (NivakinNavigationResponse) ──────
class NivakinNavigationResponse {
  final TriageLevel triageLevel;
  final List<String> bucketA_knownFacts;
  final List<String> bucketB_friendlyContext;
  final List<String> bucketC_doctorQuestions;
  final ElderScripts elderScripts;
  final ClinicianCard clinicianCard;
  final bool menarcheIrregularityReassurance; // auto-populated from MenarcheStage

  const NivakinNavigationResponse({
    required this.triageLevel,
    required this.bucketA_knownFacts,
    required this.bucketB_friendlyContext,
    required this.bucketC_doctorQuestions,
    required this.elderScripts,
    required this.clinicianCard,
    this.menarcheIrregularityReassurance = false,
  });

  factory NivakinNavigationResponse.fromJson(Map<String, dynamic> j) =>
    NivakinNavigationResponse(
      triageLevel: TriageLevelJson.fromJson(j['triageLevel'] ?? 'NORMAL_DEVELOPMENTAL'),
      bucketA_knownFacts:       List<String>.from(j['bucketA_knownFacts']       ?? []),
      bucketB_friendlyContext:  List<String>.from(j['bucketB_friendlyContext']   ?? []),
      bucketC_doctorQuestions:  List<String>.from(j['bucketC_doctorQuestions']  ?? []),
      elderScripts:    ElderScripts.fromJson(j['elderScripts']   ?? {}),
      clinicianCard:   ClinicianCard.fromJson(j['clinicianCard'] ?? {}),
      menarcheIrregularityReassurance: j['menarcheIrregularityReassurance'] ?? false,
    );

  Map<String, dynamic> toJson() => {
    'triageLevel':                      triageLevel.toJson(),
    'bucketA_knownFacts':               bucketA_knownFacts,
    'bucketB_friendlyContext':          bucketB_friendlyContext,
    'bucketC_doctorQuestions':          bucketC_doctorQuestions,
    'elderScripts':                     elderScripts.toJson(),
    'clinicianCard':                    clinicianCard.toJson(),
    'menarcheIrregularityReassurance':  menarcheIrregularityReassurance,
  };
}
