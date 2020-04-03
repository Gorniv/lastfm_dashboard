import 'package:flutter/material.dart';
import 'package:lastfm_dashboard/blocs/users_bloc.dart';
import 'package:lastfm_dashboard/services/auth/auth_service.dart';
import 'package:lastfm_dashboard/services/lastfm/lastfm_api.dart';
import 'package:lastfm_dashboard/services/local_database/database_service.dart';
import 'package:lastfm_dashboard/services/updater/updater_service.dart';
import 'package:provider/provider.dart';

import 'pages/home_page/home_page.dart';

Future<void> main() async {
  print('ok, let\'s start');
  WidgetsFlutterBinding.ensureInitialized();
  final auth = await AuthService.load();
  print('auth service loaded');
  final dbb = await DatabaseBuilder().build();
  print('db configured');
  final lfm = LastFMApi();

  final usersBloc = await UsersBloc.load(
    dbb, auth
  );
  print('usersBloc initialized');

  final widget = MultiProvider(
    providers: [
      Provider<AuthService>.value(
        value: auth,
      ),
      Provider<LocalDatabaseService>.value(
        value: dbb,
      ),
      Provider<LastFMApi>.value(
        value: lfm,
      ),
      Provider<UpdaterService>.value(
        value: UpdaterService(
          databaseService: dbb, 
          lastFMApi: lfm,
          usersBloc: usersBloc
        )..start(),
      ),
      Provider<UsersBloc>.value(value: usersBloc),
      StreamProvider<UsersViewModel>.value(
        value: usersBloc.model,
        initialData: usersBloc.model.value,
      )
    ],
    child: DashboardApp(),
  );
  print('ready to launch');
  runApp(widget);
}

class DashboardApp extends StatelessWidget {
  // This widget is the root of your application.

  ThemeData theme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
      appBarTheme: AppBarTheme(
          color: Colors.grey[350],
          elevation: 6,
          textTheme: TextTheme(
            headline: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          )),
      cardColor: Colors.grey[350],
      cardTheme: CardTheme(elevation: 3),
      canvasColor: Colors.grey[350],
      scaffoldBackgroundColor: Colors.grey[200],
      fontFamily: 'Google Sans',
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      primaryColor: Colors.grey[900],
      accentColor: Colors.redAccent,
      appBarTheme: AppBarTheme(
          color: Colors.grey[900],
          textTheme: TextTheme(
            headline: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          )),
      textTheme: TextTheme(body2: TextStyle(color: Colors.white60)),
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.grey[850],
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey[900],
      ),
      dividerColor: Colors.grey[800],
      canvasColor: Colors.grey[900],
      fontFamily: 'Google Sans',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Last.fm Dashboard',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        darkTheme: darkTheme(),
        home: HomePage());
  }
}
