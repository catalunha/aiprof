import 'package:aiprof/conectors/situation/situation_select_tofolder.dart';
import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class FolderListDS extends StatefulWidget {
  final Map<String, Folder> folderMap;
  final KnowModel knowModel;
  final Function(String, bool) onEditFolderCurrent;
  final Function(String, bool) onSetFolderCurrent;
  final Function(SituationModel) onSetSituationInFolderSyncKnowAction;

  const FolderListDS({
    Key key,
    this.folderMap,
    this.onEditFolderCurrent,
    this.onSetFolderCurrent,
    this.onSetSituationInFolderSyncKnowAction,
    this.knowModel,
  }) : super(key: key);

  @override
  _FolderListDSState createState() => _FolderListDSState();
}

class _FolderListDSState extends State<FolderListDS> {
  final TreeController _controller = TreeController(allNodesExpanded: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#folder Pasta de situações para ${widget.knowModel.name}'),
        actions: [
          // widget.knowModel.setorRef != null
          //     ? IconButton(
          //         icon: Icon(Icons.book),
          //         onPressed: () =>
          //             Navigator.pushNamed(context, Routes.infoSetorSourceList),
          //       )
          //     : Container()
        ],
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: buildTree(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Acrescentar folder',
        onPressed: () {
          widget.onEditFolderCurrent(null, true);
        },
      ),
    );
  }

  Widget folderContent(Folder folder) {
    return Row(
      children: [
        Text('${folder.name}  ${folder.id.substring(0, 3)}'),
        SizedBox(
          height: 5,
        ),
        IconButton(
          tooltip: 'Editar este folder',
          icon: Icon(
            Icons.edit,
            size: 15,
          ),
          onPressed: () {
            widget.onEditFolderCurrent(folder.id, false);
          },
        ),
        IconButton(
          tooltip: 'Acrescentar subfolder',
          icon: Icon(
            Icons.add,
            size: 15,
          ),
          onPressed: () {
            widget.onEditFolderCurrent(folder.id, true);
          },
        ),
        IconButton(
          tooltip: 'Acrescentar situação',
          icon: Icon(
            Icons.add_comment,
            size: 15,
          ),
          onPressed: () {
            widget.onSetFolderCurrent(folder.id, false);
            showDialog(
              context: context,
              builder: (context) => SituationSelectToFolder(),
            );
          },
        ),
      ],
    );
  }

  Widget infoCodeContent(SituationModel situationModel, Folder folder) {
    // bool containSituation = false;

    return Row(
      children: [
        InkWell(
          child: Tooltip(
            message: 'Duplo click para remover esta situação',
            child: Icon(
              Icons.delete,
              size: 15,
            ),
          ),
          onDoubleTap: () {
            widget.onSetFolderCurrent(folder.id, false);
            widget.onSetSituationInFolderSyncKnowAction(situationModel);
          },
        ),
        Text(' ${situationModel.name}'),
        // containSituation
        //     ? IconButton(
        //         tooltip: 'Editar situação',
        //         icon: Icon(
        //           Icons.assignment,
        //           size: 15,
        //         ),
        //         onPressed: () {
        //           // widget.onInfoSetorValueDataList(situationModel.id);
        //         },
        //       )
        //     : Container(),
      ],
    );
  }

  TreeNode _treeNode(Folder folder) {
    Iterable<Folder> folderParent = widget.folderMap.values
        .where((element) => element.idParent == folder.id);
    if (folderParent.isNotEmpty) {
      TreeNode treeNode =
          TreeNode(content: folderContent(folder), children: []);
      List<TreeNode> _itensTree = [];
      folder.situationRefMap.forEach((key, value) {
        _itensTree.add(TreeNode(content: infoCodeContent(value, folder)));
      });
      for (var folderParentItem in folderParent) {
        treeNode.children.add(_treeNode(folderParentItem));
      }
      treeNode.children.addAll(_itensTree);
      return treeNode;
    } else {
      List<TreeNode> _itensTree = [];
      folder.situationRefMap.forEach((key, value) {
        _itensTree.add(TreeNode(content: infoCodeContent(value, folder)));
      });
      return TreeNode(content: folderContent(folder), children: _itensTree);
    }
  }

  Widget buildTree() {
    List<TreeNode> _nodes = [];
    Iterable<Folder> folderidParentNull =
        widget.folderMap.values.where((element) => element.idParent == null);
    for (var folderKV in folderidParentNull) {
      _nodes.add(_treeNode(folderKV));
    }
    return TreeView(
      treeController: _controller,
      nodes: _nodes,
    );
  }
}
