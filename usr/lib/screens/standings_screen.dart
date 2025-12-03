import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/match_result.dart';

class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  bool? _filterSRL; // null = all, true = SRL, false = Real

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('League Standings'),
        actions: [
          PopupMenuButton<bool?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterSRL = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Leagues')),
              const PopupMenuItem(value: true, child: Text('SRL Only')),
              const PopupMenuItem(value: false, child: Text('Real Football Only')),
            ],
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: MockDataService(),
        builder: (context, child) {
          final standings = MockDataService().getStandings(onlySRL: _filterSRL);
          
          if (standings.isEmpty) {
            return const Center(child: Text('No matches played yet.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Team', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('P'), tooltip: 'Played'),
                  DataColumn(label: Text('W'), tooltip: 'Won'),
                  DataColumn(label: Text('D'), tooltip: 'Drawn'),
                  DataColumn(label: Text('L'), tooltip: 'Lost'),
                  DataColumn(label: Text('GF'), tooltip: 'Goals For'),
                  DataColumn(label: Text('GA'), tooltip: 'Goals Against'),
                  DataColumn(label: Text('GD'), tooltip: 'Goal Difference'),
                  DataColumn(label: Text('Pts', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: standings.map((team) {
                  return DataRow(cells: [
                    DataCell(Text(team.teamName, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(team.played.toString())),
                    DataCell(Text(team.won.toString())),
                    DataCell(Text(team.drawn.toString())),
                    DataCell(Text(team.lost.toString())),
                    DataCell(Text(team.goalsFor.toString())),
                    DataCell(Text(team.goalsAgainst.toString())),
                    DataCell(Text(team.goalDifference.toString())),
                    DataCell(Text(team.points.toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
