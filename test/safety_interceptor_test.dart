// ============================================================
// test/safety_interceptor_test.dart
// Verifies that the Tier 1 deterministic safety engine correctly
// detects red-flag symptoms in English and Hinglish.
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:nivakin/pipeline/safety_interceptor.dart';
import 'package:nivakin/models/nivakin_schema.dart';

void main() {
  group('SafetyInterceptor — Heavy Bleeding', () {
    test('detects soaking pads quickly', () {
      final result = SafetyInterceptor.check('I am soaking 2 pads every hour');
      expect(result.isEmergency, isTrue);
    });

    test('detects blood clots', () {
      final result = SafetyInterceptor.check('I passed a large blood clot');
      expect(result.isEmergency, isTrue);
    });

    test('detects overnight leaking', () {
      final result = SafetyInterceptor.check('I leaked onto my sheets last night');
      expect(result.isEmergency, isTrue);
    });

    test('detects Hinglish heavy bleeding', () {
      final result = SafetyInterceptor.check('bahut zyada khoon aa raha hai ruk nahi raha');
      expect(result.isEmergency, isTrue);
    });

    test('normal flow does NOT trigger', () {
      final result = SafetyInterceptor.check('I have moderate period cramps today');
      expect(result.isEmergency, isFalse);
    });
  });

  group('SafetyInterceptor — Syncope', () {
    test('detects fainting', () {
      final result = SafetyInterceptor.check('I fainted during my period yesterday');
      expect(result.isEmergency, isTrue);
    });

    test('detects blacked out', () {
      final result = SafetyInterceptor.check('I blacked out and fell down');
      expect(result.isEmergency, isTrue);
    });

    test('detects Hinglish behosh', () {
      final result = SafetyInterceptor.check('main behosh ho gayi');
      expect(result.isEmergency, isTrue);
    });
  });

  group('SafetyInterceptor — Severe Pain', () {
    test('detects unbearable pain', () {
      final result = SafetyInterceptor.check('The pain is completely unbearable, I can\'t move');
      expect(result.isEmergency, isTrue);
    });

    test('detects 10/10 pain', () {
      final result = SafetyInterceptor.check('my pain is 10/10');
      expect(result.isEmergency, isTrue);
    });

    test('detects Hinglish severe pain', () {
      final result = SafetyInterceptor.check('dard se rona aa raha hai bahut tez');
      expect(result.isEmergency, isTrue);
    });

    test('moderate pain does NOT trigger', () {
      final result = SafetyInterceptor.check('I have a pain of about 5 out of 10 from cramps');
      expect(result.isEmergency, isFalse);
    });
  });

  group('SafetyInterceptor — Pad Level Emergency', () {
    test('fully soaked pad triggers emergency', () {
      expect(SafetyInterceptor.isPadLevelEmergency(PadAbsorptionLevel.fullySoakedFast), isTrue);
    });

    test('changed sheets triggers emergency', () {
      expect(SafetyInterceptor.isPadLevelEmergency(PadAbsorptionLevel.changedSheetsNight), isTrue);
    });

    test('medium soak does NOT trigger emergency', () {
      expect(SafetyInterceptor.isPadLevelEmergency(PadAbsorptionLevel.mediumSoaked), isFalse);
    });

    test('light damp does NOT trigger emergency', () {
      expect(SafetyInterceptor.isPadLevelEmergency(PadAbsorptionLevel.lightDamp), isFalse);
    });

    test('null pad level does NOT trigger emergency', () {
      expect(SafetyInterceptor.isPadLevelEmergency(null), isFalse);
    });
  });

  group('SafetyInterceptor — Resources', () {
    test('emergency result includes Indian emergency numbers', () {
      final result = SafetyInterceptor.check('I am soaking 3 pads per hour and feeling dizzy');
      expect(result.isEmergency, isTrue);
      expect(result.resources.map((r) => r.number), containsAll(['112', '1098']));
    });
  });
}
