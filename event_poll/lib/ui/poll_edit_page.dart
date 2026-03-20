import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/polls_state.dart';

class PollEditPage extends StatefulWidget {
  const PollEditPage({super.key});

  @override
  State<PollEditPage> createState() => _PollEditPageState();
}

class _PollEditPageState extends State<PollEditPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';

  @override
  void initState() {
    super.initState();
    // Si on édite un sondage existant, on pré-remplit les champs !
    var currentPoll = context.read<PollsState>().currentPoll;
    if (currentPoll != null) {
      title = currentPoll.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.read<PollsState>().currentPoll == null ? 'Nouvel événement' : 'Modifier l\'événement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Titre de l\'événement'),
                onChanged: (value) => title = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Ici tu pourras appeler ta méthode pour sauvegarder sur le serveur
                  print("Sauvegarde de : $title");
                },
                child: const Text('Enregistrer'),
              )
            ],
          ),
        ),
      ),
    );
  }
}