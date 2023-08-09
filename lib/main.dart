import 'package:cashflow_rdi/home/home_layout.dart';
import 'package:cashflow_rdi/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(prefs.getString("token") == null ? const ProviderScope(child: LoginPages()) : const ProviderScope(child: HomeLayout()));
  FlutterNativeSplash.remove();
}
