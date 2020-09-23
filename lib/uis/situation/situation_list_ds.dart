import 'package:aiprof/models/situation_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SituationListDS extends StatefulWidget {
  final List<SituationModel> situationList;
  final Function(String) onEditSituationCurrent;
  final Function(String) onSimulationList;

  const SituationListDS({
    Key key,
    this.situationList,
    this.onEditSituationCurrent,
    this.onSimulationList,
  }) : super(key: key);

  @override
  _SituationListDSState createState() => _SituationListDSState();
}

class _SituationListDSState extends State<SituationListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Situações (${widget.situationList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.situationList.length,
        itemBuilder: (context, index) {
          final situation = widget.situationList[index];
          return Card(
            color: !situation.isActive
                ? Colors.brown
                : Theme.of(context).cardColor,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 500,
                  child: ListTile(
                    title: Text('${situation.name}'),
                    subtitle: Text('${situation.toString()}'),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar esta situação',
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    widget.onEditSituationCurrent(situation.id);
                  },
                ),
                IconButton(
                  tooltip: 'URL para a situação',
                  icon: Icon(Icons.link),
                  onPressed: () async {
                    if (situation?.url != null) {
                      if (await canLaunch(situation.url)) {
                        await launch(situation.url);
                      }
                    }
                  },
                ),
                IconButton(
                  tooltip: 'Lista de simulações',
                  icon: Icon(Icons.format_list_numbered),
                  onPressed: () async {
                    widget.onSimulationList(situation.id);
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
          widget.onEditSituationCurrent(null);
        },
      ),
    );
  }
}
