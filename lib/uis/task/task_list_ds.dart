import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/models/task_model.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskListDS extends StatefulWidget {
  final List<TaskModel> taskList;
  final int nota;
  final String csv;
  final Function(String) onEditTaskCurrent;
  final Function(String, String, bool) onUpdateOutput;

  const TaskListDS({
    Key key,
    this.taskList,
    this.onEditTaskCurrent,
    this.nota,
    this.csv,
    this.onUpdateOutput,
  }) : super(key: key);

  @override
  _TaskListDSState createState() => _TaskListDSState();
}

class _TaskListDSState extends State<TaskListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas ${widget.taskList.length}. Nota: ${widget.nota}'),
        actions: [
          IconButton(
            tooltip: 'Cópia dados para csv',
            icon: Icon(Icons.file_copy),
            // https://materialdesignicons.com/
            onPressed: () {
              FlutterClipboard.copy(widget.csv).then((value) {
                print('copied');
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.taskList.length,
        itemBuilder: (context, index) {
          final task = widget.taskList[index];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: ListTile(
                        selected: task?.isOpen != null ? task.isOpen : false,
                        title: Text('${task.id}'),
                        subtitle: Text('${task.toString()}'),
                        // trailing: IconButton(
                        //   tooltip: 'Editar esta tarefa',
                        //   icon: Icon(Icons.edit),
                        //   onPressed: () async {
                        //     widget.onEditTaskCurrent(task.id);
                        //   },
                        // ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          IconButton(
                            tooltip: 'Editar esta tarefa',
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              widget.onEditTaskCurrent(task.id);
                            },
                          ),
                          IconButton(
                            tooltip: 'Editar esta tarefa',
                            icon: Icon(Icons.local_library),
                            onPressed: () async {
                              if (task?.situationRef?.url != null) {
                                if (await canLaunch(task?.situationRef?.url)) {
                                  await launch(task?.situationRef?.url);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // ListTile(
                //   selected: task?.isOpen != null ? task.isOpen : false,
                //   title: Text('${task.id}'),
                //   subtitle: Text('${task.toString()}'),
                //   trailing: IconButton(
                //     tooltip: 'Editar esta tarefa',
                //     icon: Icon(Icons.edit),
                //     onPressed: () async {
                //       widget.onEditTaskCurrent(task.id);
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 17.0),
                  child: Text(
                      'Saídas do desenvolvimento: ${task.simulationOutput.length}'),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 17.0),
                    child: Column(
                      children: [
                        ...simulationOutputBuilder(context, task.id,
                            task.simulationOutput.values.toList()),
                      ],
                    )),
              ],
            ),
          );

          // return Card(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         flex: 10,
          //         child: ListTile(
          //           selected: task?.isOpen != null ? task.isOpen : false,
          //           title: Text('${task.id}'),
          //           subtitle: Text('${task.toString()}'),
          //           // trailing: IconButton(
          //           //   tooltip: 'Editar esta tarefa',
          //           //   icon: Icon(Icons.edit),
          //           //   onPressed: () async {
          //           //     widget.onEditTaskCurrent(task.id);
          //           //   },
          //           // ),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 2,
          //         child: Column(
          //           children: [
          //             IconButton(
          //               tooltip: 'Editar esta tarefa',
          //               icon: Icon(Icons.edit),
          //               onPressed: () {
          //                 widget.onEditTaskCurrent(task.id);
          //               },
          //             ),
          //             IconButton(
          //               tooltip: 'Editar esta tarefa',
          //               icon: Icon(Icons.local_library),
          //               onPressed: () async {
          //                 if (task?.situationRef?.url != null) {
          //                   if (await canLaunch(task?.situationRef?.url)) {
          //                     await launch(task?.situationRef?.url);
          //                   }
          //                 }
          //               },
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // );
        },
      ),
    );
  }

  List<Widget> simulationOutputBuilder(
      BuildContext context, String taskId, List<Output> simulationOutputList) {
    simulationOutputList.sort((a, b) => a.name.compareTo(b.name));

    List<Widget> itemList = [];
    for (Output simulationOutput in simulationOutputList) {
      Widget icone = Icon(Icons.question_answer);
      if (simulationOutput.type == 'numero') {
        icone = Icon(Icons.looks_one);
      } else if (simulationOutput.type == 'palavra') {
        icone = Icon(Icons.text_format);
      } else if (simulationOutput.type == 'texto') {
        icone = IconButton(
          tooltip: 'ver textos desta tarefa',
          icon: Icon(Icons.text_fields),
          onPressed: () {
            // widget.onSeeTextTask();
          },
        );
      } else if (simulationOutput.type == 'url' ||
          simulationOutput.type == 'urlimagem') {
        icone = IconButton(
          tooltip: 'Um link ou URL ao um site ou arquivo',
          icon: Icon(Icons.link),
          onPressed: () async {
            if (simulationOutput.answer != null) {
              if (await canLaunch(simulationOutput.answer)) {
                await launch(simulationOutput.answer);
              }
            }
          },
        );
      } else if (simulationOutput.type == 'arquivo' ||
          simulationOutput.type == 'imagem') {
        icone = IconButton(
          tooltip: 'Upload de arquivo ou imagem',
          icon: Icon(Icons.description),
          onPressed: () async {
            if (simulationOutput.value != null) {
              if (await canLaunch(simulationOutput.value)) {
                await launch(simulationOutput.value);
              }
            }
          },
        );
      }
      // itemList.add(ListTile(
      //   leading: Icon(Icons.nature),
      //   title: Text('a'),
      //   subtitle: Text('b'),
      //   trailing: Icon(Icons.nature),
      //   onTap: null,
      // ));
      // itemList.add(ListTile(
      //   leading: Icon(Icons.nature),
      //   title: Text('a'),
      //   subtitle: Text('b'),
      //   trailing: Icon(Icons.nature),
      //   onTap: null,
      // ));
      itemList.add(Row(
        children: [
          Text('${simulationOutput.name}'),
          Text(' = '),
          // simulationOutput.type == 'texto' || simulationOutput.type == 'url'
          //     ? Text('(${simulationOutput.value.length}c)')
          //     :
          Text(
              '${simulationOutput.value} == ${simulationOutput.answer} (${simulationOutput.id.substring(0, 4)})'),
          Container(
            width: 10,
          ),
          icone,
          IconButton(
            color: simulationOutput?.right != null
                ? simulationOutput.right
                    ? Colors.green
                    : Colors.red
                : Colors.black,
            icon: simulationOutput?.right != null
                ? simulationOutput.right
                    ? Icon(Icons.thumb_up)
                    : Icon(Icons.thumb_down)
                : Icon(
                    Icons.thumbs_up_down,
                    color: Colors.yellow,
                  ),
            // icon: Icon(Icons.thumb_up),
            onPressed: () {
              bool _right;
              _right = simulationOutput?.right != null
                  ? simulationOutput.right
                      ? true
                      : false
                  : false;
              widget.onUpdateOutput(taskId, simulationOutput.id, !_right);
            },
          ),
          // IconButton(
          //   color: simulationOutput?.right != null
          //       ? simulationOutput.right ? Colors.green : Colors.red
          //       : Colors.black,
          //   icon: Icon(Icons.thumb_down),
          //   onPressed: () {
          //     widget.onUpdateOutput(simulationOutput.id, false);
          //   },
          // ),
        ],
      ));
    }
    return itemList;
  }
}
