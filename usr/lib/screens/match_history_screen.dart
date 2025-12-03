import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // You might need to add intl to pubspec, but for now I'll use basic formatting if package not present, but standard DateTime works
import '../services/mock_data_service.dart';

class MatchHistoryScreen extends StatelessWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match History'),
      ),
      body: ListenableBuilder(
        listenable: MockDataService(),
        builder: (context, child) {
          final matches = MockDataService().matches.reversed.toList(); // Newest first

          if (matches.isEmpty) {
            return const Center(child: Text('No matches recorded.'));
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return Dismissible(
                key: Key(match.id),
                background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  MockDataService().deleteMatch(match.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Match deleted')));
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: match.isSRL ? Colors.deepPurple : Colors.green,
                      child: Text(match.isSRL ? 'SRL' : 'Real', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(match.homeTeam, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold))),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('${match.homeScore} - ${match.awayScore}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(child: Text(match.awayTeam, style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    subtitle: Center(child: Text(match.date.toString().split('.')[0], style: const TextStyle(fontSize: 12))),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
