import 'package:aiprof/situation/simulation/simulation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskAnswerTextUI extends StatefulWidget {
  final String id;

  final List<Input> simulationInput;
  final List<Output> simulationOutput;

  const TaskAnswerTextUI({
    Key key,
    this.simulationInput,
    this.simulationOutput,
    this.id,
  }) : super(key: key);
  @override
  _TaskAnswerTextUIState createState() => _TaskAnswerTextUIState();
}

class _TaskAnswerTextUIState extends State<TaskAnswerTextUI> {
  final formKey = GlobalKey<FormState>();
  bool isInvisibilityDelete = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver texto da tarefa ${widget.id.substring(0, 4)}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: reporty(),
      ),
    );
  }

  Widget reporty() {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          Row(children: [
            Text('Textos da entrada'),
          ]),
          ...simulationInputBuilderReporty(context, widget.simulationInput),
          Row(children: [
            Text('Textos da saída'),
          ]),
          ...simulationOutputBuilderReporty(context, widget.simulationOutput),
          Container(
            height: 50,
          ),
        ],
      ),
    );
  }

  List<Widget> simulationInputBuilderReporty(
      BuildContext context, List<Input> simulationInputList) {
    List<Widget> itemList = [];
    for (Input simulationInput in simulationInputList) {
      if (simulationInput.type == 'texto') {
        itemList.add(ListTile(
          title: Text('${simulationInput.name}'),
          subtitle: Text('${simulationInput.value}'),
          trailing: Icon(Icons.text_fields),
        ));
      }
    }
    return itemList;
  }

  List<Widget> simulationOutputBuilderReporty(
      BuildContext context, List<Output> simulationOutputList) {
    List<Widget> itemList = [];
    for (Output simulationOutput in simulationOutputList) {
      if (simulationOutput.type == 'texto') {
        itemList.add(ListTile(
          title: Text('${simulationOutput.name}'),
          subtitle: Text('${simulationOutput.value}'),
          trailing: Icon(Icons.text_fields),
        ));
      }
    }
    return itemList;
  }
}
