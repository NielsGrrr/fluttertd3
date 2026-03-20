import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/polls_state.dart';

class PollPage extends StatelessWidget {
  const PollPage({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère le sondage sélectionné
    var currentPoll = context.watch<PollsState>().currentPoll;

    if (currentPoll == null) {
      return const Scaffold(body: Center(child: Text('Aucun sondage sélectionné')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentPoll.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/poll_edit'),
          )
        ],
      ),
      body: Center(
        child: Text('Détails de l\'événement : ${currentPoll.description}'),
      ),
    );
  }
}