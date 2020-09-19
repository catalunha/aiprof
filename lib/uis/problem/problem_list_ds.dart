import 'package:aiprof/models/problem_model.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/conectors/components/logout_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ProblemListDS extends StatefulWidget {
  final List<ProblemModel> problemList;
  final Function(String) onEditProblemCurrent;

  const ProblemListDS({
    Key key,
    this.problemList,
    this.onEditProblemCurrent,
  }) : super(key: key);

  @override
  _ProblemListDSState createState() => _ProblemListDSState();
}

class _ProblemListDSState extends State<ProblemListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Problemas (${widget.problemList.length})'),
        actions: [
          LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.problemList.length,
        itemBuilder: (context, index) {
          final problem = widget.problemList[index];
          return Card(
            color:
                !problem.isActive ? Colors.brown : Theme.of(context).cardColor,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 500,
                  child: ListTile(
                    title: Text('${problem.name}'),
                    subtitle: Text('${problem.toString()}'),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar este problema',
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    widget.onEditProblemCurrent(problem.id);
                  },
                ),
                IconButton(
                  tooltip: 'URL para o problema',
                  icon: Icon(Icons.link),
                  onPressed: () async {
                    if (problem?.url != null) {
                      if (await canLaunch(problem.url)) {
                        await launch(problem.url);
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          widget.onEditProblemCurrent(null);
        },
      ),
    );
  }
}
