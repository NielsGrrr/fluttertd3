import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/polls_state.dart';

class PollsPage extends StatelessWidget {
  const PollsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pollsState = context.watch<PollsState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Événements')),
      body: ListView.builder(
        itemCount: pollsState.polls.length,
        itemBuilder: (context, index) {
          var poll = pollsState.polls[index];
          return ListTile(
            title: Text(poll.name), // Adapte selon les propriétés de ton modèle Poll
            onTap: () {
              // 1. On définit le sondage actuel
              context.read<PollsState>().setCurrentPoll(poll);
              // 2. On navigue vers la page de détail
              Navigator.pushNamed(context, '/poll'); 
            },
          );
        },
      ),
      // Un bouton flottant pour créer un nouveau sondage
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pour une création, on vide le sondage actuel
          context.read<PollsState>().setCurrentPoll(null);
          Navigator.pushNamed(context, '/poll_edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}