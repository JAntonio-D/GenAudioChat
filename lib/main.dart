import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/filter_chip_controller.dart';
import 'package:test_app/controllers/loader_controller.dart';
import 'package:test_app/screens/category_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/widgets/global_loader.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FilterChipController()),
        ChangeNotifierProvider(create: (_) => LoaderController()),
      ],
      child: ChipApp(),
    ),
  );
}

class ChipApp extends StatelessWidget {
  const ChipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(useMaterial3: true),
      home: Stack(
        children: [
          CategoryScreen(),
          GlobalLoader(),
        ],
      ),
    );
  }
}
