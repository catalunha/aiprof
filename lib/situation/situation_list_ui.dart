import 'package:aiprof/situation/situation_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SituationListUI extends StatefulWidget {
  final List<SituationModel> situationList;
  final Function(String) onEditSituationCurrent;
  final Function(String) onSimulationList;
  final Function(String) onSearchSituation;

  const SituationListUI({
    Key key,
    this.situationList,
    this.onEditSituationCurrent,
    this.onSimulationList,
    this.onSearchSituation,
  }) : super(key: key);

  @override
  _SituationListUIState createState() => _SituationListUIState();
}

class _SituationListUIState extends State<SituationListUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Situações (${widget.situationList.length})'),
      ),
      body: Center(
        child: Container(
          width: 600,
          child: Column(
            children: [
              searchName(),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.situationList.length,
                  itemBuilder: (context, index) {
                    final situation = widget.situationList[index];
                    return buildCard(situation, context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          widget.onEditSituationCurrent(null);
        },
      ),
    );
  }

  Widget buildCard(SituationModel situation, BuildContext context) {
    return Card(
      color: !situation.isActive ? Colors.brown : Theme.of(context).cardColor,
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Container(
            width: 400,
            child: buildListTile(situation),
          ),
          ...icones(situation),
        ],
      ),
    );
  }

  Widget buildListTile(SituationModel situation) {
    return ListTile(
      selected: situation?.isSimulationConsistent != null
          ? !situation.isSimulationConsistent
          : true,
      title: Text('${situation.name}'),
      subtitle: Text('${situation.toString()}'),
    );
  }

  Widget searchName() {
    return TextField(
      onChanged: (value) {
        widget.onSearchSituation(value);
      },
      decoration: InputDecoration(
        hintText: "buscar por nome na situação",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    );
  }

  List<Widget> icones(SituationModel situation) {
    List<Widget> icones = [];
    icones.add(IconButton(
      tooltip: 'Editar esta situação',
      icon: Icon(Icons.edit),
      onPressed: () async {
        widget.onEditSituationCurrent(situation.id);
      },
    ));
    icones.add(IconButton(
      tooltip: 'URL para a situação',
      icon: Icon(Icons.link),
      onPressed: () async {
        if (situation?.url != null) {
          if (await canLaunch(situation.url)) {
            await launch(situation.url);
          }
        }
      },
    ));
    icones.add(IconButton(
      tooltip: 'Lista de simulações',
      icon: Icon(Icons.format_list_numbered),
      onPressed: () {
        widget.onSimulationList(situation.id);
      },
    ));

    return icones;
  }
}
