import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _noteController = TextEditingController();
  final supabase = Supabase.instance.client;
  List<dynamic> _notes = [];

  Future<void> _fetchNotes() async {
    final user = supabase.auth.currentUser;
    final data = await supabase
        .from("notes")
        .select('*')
        .eq('user_id', user!.id)
        .order('create_at', ascending: false);

        setState(() {
          
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Notes page')],
        ),
      ),
    );
  }
}
