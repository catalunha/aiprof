import 'package:aiprof/models/simulation_model.dart';
import 'package:flutter/material.dart';

class SimulationListDS extends StatefulWidget {
  final List<SimulationModel> simulationList;
  final Function(String) onEditSimulation;

  const SimulationListDS({
    Key key,
    this.simulationList,
    this.onEditSimulation,
  }) : super(key: key);

  @override
  SimulationListDSState createState() => SimulationListDSState();
}

class SimulationListDSState extends State<SimulationListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulações (${widget.simulationList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.simulationList.length,
        itemBuilder: (context, index) {
          final simulation = widget.simulationList[index];
          return Card(
            child: ListTile(
              title: Text('${simulation.name}'),
              subtitle: Text('${simulation.toString()}'),
              trailing: IconButton(
                tooltip: 'Editar esta situação',
                icon: Icon(Icons.edit),
                onPressed: () async {
                  widget.onEditSimulation(simulation.id);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          widget.onEditSimulation(null);
        },
      ),
    );
  }
}
