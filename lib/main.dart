import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persona_app/core/repository/user_repository_impl.dart';
import 'package:persona_app/core/services/client_service.dart';
import 'package:persona_app/core/services/persistence_service.dart';
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

        Provider<ClientService>(
          create: (context) {
            final client = context.read<http.Client>();
            return ClientService(client: client);
          },
        ),

        Provider<PersistenceService>(
          create: (context) {
            return PersistenceService(prefs: prefs);
          },
        ),

        Provider<UserRepositoryImpl>(
          create: (context) {
            final clinetService = context.read<ClientService>();
            final persistenceService = context.read<PersistenceService>();
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
      ),
    );
  }
}
