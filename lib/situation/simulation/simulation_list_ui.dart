import 'package:aiprof/situation/simulation/simulation_model.dart';
import 'package:flutter/material.dart';

class SimulationListUI extends StatefulWidget {
  final List<SimulationModel> simulationList;
  final List<String> simulationIncosistent;
  final Function(String) onEditSimulation;

  const SimulationListUI({
    Key key,
    this.simulationList,
    this.onEditSimulation,
    this.simulationIncosistent,
  }) : super(key: key);

  @override
  SimulationListUIState createState() => SimulationListUIState();
}

class SimulationListUIState extends State<SimulationListUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulações (${widget.simulationList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: Center(
        child: Container(
          width: 600,
          child: ListView.builder(
            itemCount: widget.simulationList.length,
            itemBuilder: (context, index) {
              final simulation = widget.simulationList[index];
              return Card(
                child: ListTile(
                  selected:
                      widget.simulationIncosistent.contains(simulation.id),
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
        ),
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
