import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:flutter/material.dart';

class SituationSelectToFolderDS extends StatefulWidget {
  final List<SituationModel> situationList;
  final Folder folderCurrent;
  final Function(SituationModel, bool) onSetSituationInKnow;
  final Function(SituationOrder) onSelectOrder;

  const SituationSelectToFolderDS({
    Key key,
    this.onSetSituationInKnow,
    this.situationList,
    this.folderCurrent,
    this.onSelectOrder,
  }) : super(key: key);
  @override
  _SituationSelectToFolderDSState createState() =>
      _SituationSelectToFolderDSState();
}

class _SituationSelectToFolderDSState extends State<SituationSelectToFolderDS> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here

      child: Container(
        height: 700.0,
        width: 800.0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Lista situações para incluir em folder'),
                IconButton(
                  tooltip: 'Ordenar itens por Ordem alfabética',
                  icon: Icon(Icons.sort_by_alpha),
                  onPressed: () {
                    widget.onSelectOrder(SituationOrder.name);
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.situationList.length,
                itemBuilder: (context, index) {
                  final situation = widget.situationList[index];

                  return ListTile(
                    selected: widget.folderCurrent.situationRefMap != null
                        ? widget.folderCurrent.situationRefMap
                            .containsKey(situation.id)
                        : false,
                    title: Text('${situation.name}'),
                    // subtitle: Text(
                    //     '${situation.name}\nUnidade: ${situation.unit}\nOrganizador: ${situation.infoIndOwnerRef.name}'),
                    onTap: () {
                      widget.onSetSituationInKnow(
                          situation,
                          !(widget.folderCurrent.situationRefMap != null
                              ? widget.folderCurrent.situationRefMap
                                  .containsKey(situation.id)
                              : false));
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
