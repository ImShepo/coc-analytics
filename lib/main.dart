import 'package:coc/config/router/app_router.dart';
import 'package:coc/config/theme/app_theme.dart';
import 'package:coc/firebase_options.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/locale_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Keep troop icons warm without large GC pauses while scrolling.
  PaintingBinding.instance.imageCache.maximumSize = 120;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 48 << 20;
  await dotenv.load(fileName: _envFileName());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MainApp()));
}

/// Debug → `.env.development` (local proxy).
/// Release/profile → `.env.production` (Cloud Run).
/// Override: `flutter run --dart-define=ENV_FILE=.env.production`
String _envFileName() {
  const override = String.fromEnvironment('ENV_FILE');
  if (override.isNotEmpty) return override;
  if (kReleaseMode || kProfileMode) return '.env.production';
  return '.env.development';
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      locale: locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
