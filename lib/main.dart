// ============================================================
// main.dart — Nivakin App Entry Point
// Multi-View Reactive Navigation Architecture with Bottom Navigation Dock
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'theme/nivakin_theme.dart';
import 'state/nivakin_state.dart';
import 'views/home_dashboard_view.dart';
import 'views/intake_view.dart';
import 'views/confidence_view.dart';
import 'views/offline_gemma_chat_view.dart';
import 'views/script_sandbox_view.dart';
import 'views/doctor_prep_view.dart';
import 'views/emergency_view.dart';
import 'views/disguise_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for optimal adolescent mobile UX.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Immersive status bar with transparent overlay.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(const NivakinApp());
}

class NivakinApp extends StatelessWidget {
  const NivakinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NivakinAppState(),
      child: MaterialApp(
        title: 'Nivakin',
        debugShowCheckedModeBanner: false,
        theme: NivakinTheme.lightTheme,
        home: const _NivakinShell(),
      ),
    );
  }
}

// ── App Shell: Single-page router with bottom dock ────────────
class _NivakinShell extends StatelessWidget {
  const _NivakinShell();

  int _getSelectedIndex(AppScreen screen) {
    switch (screen) {
      case AppScreen.homeDashboard:
        return 0;
      case AppScreen.intake:
        return 1;
      case AppScreen.offlineGemmaChat:
        return 2;
      case AppScreen.scriptSandbox:
        return 3;
      case AppScreen.doctorPrep:
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NivakinAppState>();
    final screen = state.currentScreen;

    final hideBottomNav = screen == AppScreen.disguise ||
        screen == AppScreen.emergency ||
        screen == AppScreen.confidence;

    return Scaffold(
      backgroundColor: NivakinColors.blossomWhite,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(screen),
          child: switch (screen) {
            AppScreen.homeDashboard     => const HomeDashboardView(),
            AppScreen.intake            => const IntakeView(),
            AppScreen.confidence        => const ConfidenceView(),
            AppScreen.offlineGemmaChat  => const OfflineGemmaChatView(),
            AppScreen.scriptSandbox     => const ScriptSandboxView(),
            AppScreen.doctorPrep        => const DoctorPrepView(),
            AppScreen.emergency         => const EmergencyView(),
            AppScreen.disguise          => const DisguiseView(),
          },
        ),
      ),
      bottomNavigationBar: hideBottomNav
          ? null
          : Container(
              decoration: const BoxDecoration(
                color: NivakinColors.cardWhite,
                border: Border(top: BorderSide(color: NivakinColors.borderSoft)),
              ),
              child: NavigationBar(
                selectedIndex: _getSelectedIndex(screen),
                onDestinationSelected: (index) {
                  switch (index) {
                    case 0:
                      state.navigateTo(AppScreen.homeDashboard);
                      break;
                    case 1:
                      state.navigateTo(AppScreen.intake);
                      break;
                    case 2:
                      state.navigateTo(AppScreen.offlineGemmaChat);
                      break;
                    case 3:
                      state.navigateTo(AppScreen.scriptSandbox);
                      break;
                    case 4:
                      state.navigateTo(AppScreen.doctorPrep);
                      break;
                  }
                },
                backgroundColor: NivakinColors.cardWhite,
                indicatorColor: NivakinColors.blossomPinkBg,
                elevation: 0,
                height: 64,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined, color: NivakinColors.textSubtle),
                    selectedIcon: Icon(Icons.home_rounded, color: NivakinColors.rosePink),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.favorite_outline, color: NivakinColors.textSubtle),
                    selectedIcon: Icon(Icons.favorite_rounded, color: NivakinColors.rosePink),
                    label: 'Intake',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.chat_bubble_outline_rounded, color: NivakinColors.textSubtle),
                    selectedIcon: Icon(Icons.chat_bubble_rounded, color: NivakinColors.purpleAccent),
                    label: 'Gemma Q&A',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.forum_outlined, color: NivakinColors.textSubtle),
                    selectedIcon: Icon(Icons.forum_rounded, color: NivakinColors.rosePink),
                    label: 'Baat Karein',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.medical_services_outlined, color: NivakinColors.textSubtle),
                    selectedIcon: Icon(Icons.medical_services_rounded, color: NivakinColors.softAmber),
                    label: 'Doctor Card',
                  ),
                ],
              ),
            ),
    );
  }
}
