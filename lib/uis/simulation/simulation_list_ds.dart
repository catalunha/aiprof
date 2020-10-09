import 'package:flutter/material.dart';
import 'package:aiprof/models/simulation_model.dart';

class SimulationListDS extends StatefulWidget {
  final List<SimulationModel> simulationList;
  final List<String> simulationIncosistent;
  final Function(String) onEditSimulation;

  const SimulationListDS({
    Key key,
    this.simulationList,
    this.onEditSimulation,
    this.simulationIncosistent,
  }) : super(key: key);

  @override
  SimulationListDSState createState() => SimulationListDSState();
}

class SimulationListDSState extends State<SimulationListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#simulation Simulações (${widget.simulationList.length})'),
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
              selected: widget.simulationIncosistent.contains(simulation.id),
              title: widget.simulationIncosistent.contains(simulation.id)
                  ? Text(
                      '${simulation.name} - (${simulation.id.substring(0, 4)}) - ERRO na entrada ou saída')
                  : Text(
                      '${simulation.name} - (${simulation.id.substring(0, 4)})'),
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
