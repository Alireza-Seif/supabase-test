import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/widgets/my_button.dart';
import 'package:supabase_test/widgets/my_text_field.dart';

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
    if (user == null) return;
    try {
      final data = await supabase
          .from('notes')
          .select('*')
          .eq('user_id', user.id);

      if (!mounted) return;
      setState(() {
        _notes = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fetch notes failed: $e')));
    }
  }

  Future<void> _addNote() async {
    final title = _noteController.text.trim();
    if (title.isEmpty) return;

    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('notes').insert({
        'title': title,
        'user_id': user.id,
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Add note failed: $e')));
      return;
    }

    _noteController.clear();
    await _fetchNotes();
  }

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 20,
            children: [
              MyTextField(
                myTextFieldController: _noteController,
                myTextFieldText: 'Title',
              ),
              MyButton(onTap: _addNote, text: 'Add Note'),
              Expanded(
                child: _notes.isEmpty
                    ? const Center(child: Text('No notes yet'))
                    : ListView.builder(
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          final note = _notes[index] as Map<String, dynamic>;
                          final title = (note['title'] ?? '') as String;
                          final createdAt =
                              (note['create_at'] ?? note['created_at'] ?? '')
                                  .toString();

                          return Card(
                            child: ListTile(
                              title: Text(title),
                              subtitle: Text(createdAt),
                            ),
                          );
                        },
                     ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
