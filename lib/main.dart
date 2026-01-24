import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/price/price_bloc.dart';
import 'bloc/price/price_event.dart';
import 'database/isar_database.dart';
import 'database/price_local_data_source.dart';
import 'domain/pipeline/decision/decision_engine_factory.dart';
import 'repository/price_repository.dart';
import 'services/btc_price_service.dart';
import 'services/notification_service.dart';
import 'services/alarm_manager_service.dart';
import 'l10n/gen/localization.dart';
import 'ui/home_screen.dart';
import 'ui/price_history_screen.dart';
import 'ui/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.initialize();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
    await AlarmManagerService.schedulePriceMonitoring();
  }

  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.notificationService});

  final NotificationService? notificationService;

  @override
  Widget build(BuildContext context) {
    final repository = PriceRepository(
      service: BtcPriceService(),
      localDataSource: PriceLocalDataSource(IsarDatabase.instance),
    );
    final decisionEngine = DecisionEngineFactory.fromRepository(repository);

    final resolvedNotificationService = notificationService ?? NotificationService();

    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) => PriceBloc(
          repository,
          resolvedNotificationService,
          decisionEngine,
        )..add(const PriceStarted()),
        child: MaterialApp(
          onGenerateTitle: (context) => Localization.of(context).appTitle,
          localizationsDelegates: Localization.localizationsDelegates,
          supportedLocales: Localization.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            useMaterial3: true,
          ),
          builder: (context, child) {
            resolvedNotificationService.updateLocale(Localizations.localeOf(context));
            return child ?? const SizedBox.shrink();
          },
          home: const MainScreen(),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PriceHistoryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = Localization.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(height: 65),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home),
              label: localization.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history),
              label: localization.navHistory,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings),
              label: localization.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
