import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/polls_state.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({super.key});

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  
  @override
  void initState() {
    super.initState();
    // 👇 On demande à PollsState de charger les données dès l'ouverture de la page !
    // Le future.microtask permet d'attendre que la page soit bien construite avant d'appeler le provider.
    Future.microtask(() => context.read<PollsState>().fetchPolls());
  }

  @override
  Widget build(BuildContext context) {
    // On écoute les changements de PollsState
    var pollsState = context.watch<PollsState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Événements')),
      
      // 👇 On vérifie si la liste est vide pour afficher un message
      body: pollsState.polls.isEmpty
          ? const Center(child: Text('Aucun événement trouvé ou en cours de chargement...'))
          : ListView.builder(
              itemCount: pollsState.polls.length,
              itemBuilder: (context, index) {
                var poll = pollsState.polls[index];
                return ListTile(
                  title: Text(poll.name),
                  subtitle: Text(poll.description), // 👈 On peut même afficher la description
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.read<PollsState>().setCurrentPoll(poll);
                    Navigator.pushNamed(context, '/poll'); 
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PollsState>().setCurrentPoll(null);
          Navigator.pushNamed(context, '/poll_edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}