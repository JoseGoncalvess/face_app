import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persona_app/core/models/person.dart';
import 'package:persona_app/core/repository/user_repository_impl.dart';
import 'package:persona_app/core/services/client_service.dart';
import 'package:persona_app/core/services/persistence_service.dart';
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
        home: Scaffold(
          body: Center(
            child: Consumer<ClientService>(
              builder: (context, value, child) {
                Future<Person> user = value.fetchRandomUser();
                user.then((value) => log(value.fullName));
                return Text((user.toString()));
              },
            ),
          ),
          floatingActionButton: Consumer<UserRepositoryImpl>(
            builder: (context, value, child) => FloatingActionButton(
              onPressed: () {
                value.getPersistedUsers().then((users) {
                  for (var user in users) {
                    log('Persisted User: ${user.fullName}');
                  }
                });
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
