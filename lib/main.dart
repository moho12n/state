import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
SharedPreferences prefs;
FlutterToast flutterToast;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await _prefs;
  if (prefs.getString('state') != null)
    print('shared preferecens is :' + prefs.getString('state'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(body: AppLifecycleReactor()),
    );
  }
}

class AppLifecycleReactor extends StatefulWidget {
  const AppLifecycleReactor({Key key}) : super(key: key);

  @override
  _AppLifecycleReactorState createState() => _AppLifecycleReactorState();
}

class _AppLifecycleReactorState extends State<AppLifecycleReactor>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    prefs.setString('state', 'initstate');
    flutterToast = FlutterToast(context);
  }

  @mustCallSuper
  @protected
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);

    print('dispose called.............');
    super.dispose();
  }

  @override
  void deactivate() {
    print("desac");
    super.deactivate();
    //this method not called when user press android back button or quit
    print('deactivate');
    prefs.setString('state', 'quitted');
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      flutterToast.showToast(
        child: Text('toast' + state.toString()),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
      print('state of print is : ' + state.toString());
      prefs.setString('state', state.toString());
      _notification = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Last notification: $_notification',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
