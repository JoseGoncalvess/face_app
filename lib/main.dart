import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persona_app/core/repository/user_repository_impl.dart';
import 'package:persona_app/core/services/client/client_service_impl.dart';
import 'package:persona_app/core/services/persistence/persistence_service_impl.dart';
import 'package:persona_app/core/utils/const.dart';
import 'package:persona_app/src/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _prefs = await SharedPreferences.getInstance();
  runApp(MainApp(prefs: _prefs));
}

class MainApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MainApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),

        Provider<ClientServiceImpl>(
          create: (context) {
            final client = context.read<http.Client>();
            return ClientServiceImpl(client: client);
          },
        ),

        Provider<PersistenceServiceImpl>(
          create: (context) {
            return PersistenceServiceImpl(prefs: prefs);
          },
        ),

        Provider<UserRepositoryImpl>(
          create: (context) {
            final clinetService = context.read<ClientServiceImpl>();
            final persistenceService = context.read<PersistenceServiceImpl>();
            return UserRepositoryImpl(
              clientService: clinetService,
              persistenceService: persistenceService,
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,

        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          scaffoldBackgroundColor: Colors.white,

          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),

            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
