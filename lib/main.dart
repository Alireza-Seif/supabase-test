import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/screens/note_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://ylsjerwyrvscjdfnsuxc.supabase.co",
    anonKey: "sb_publishable_9tyEAwnPrMjpdExGbixfoQ_1PhHmgfC",
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "supabase app", home: NotesPage());
  }
}
