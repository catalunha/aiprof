import 'package:aiprof/know/know_model.dart';
import 'package:aiprof/situation/situation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class FolderSelectToQuestionUI extends StatefulWidget {
  final Map<String, Folder> folderMap;
  final KnowModel knowModel;
  final Function(SituationModel) onSetSituationInQuestionCurrent;

  const FolderSelectToQuestionUI({
    Key key,
    this.folderMap,
    this.onSetSituationInQuestionCurrent,
    this.knowModel,
  }) : super(key: key);

  @override
  _FolderSelectToQuestionUIState createState() =>
      _FolderSelectToQuestionUIState();
}

class _FolderSelectToQuestionUIState extends State<FolderSelectToQuestionUI> {
  final TreeController _controller = TreeController(allNodesExpanded: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pasta de situações para ${widget.knowModel.name}'),
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
    );
  }

  Widget folderContent(Folder folder) {
    return Row(
      children: [
        Text('${folder.name}  ${folder.id.substring(0, 3)}'),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget infoCodeContent(SituationModel situationRef, Folder folder) {
    // bool containSituation = false;

    return Row(
      children: [
        InkWell(
          child: Tooltip(
            message: 'Click para selecionar esta situação',
            child: Icon(
              Icons.check,
              size: 15,
            ),
          ),
          onTap: () {
            widget.onSetSituationInQuestionCurrent(situationRef);
          },
        ),
        Text(' ${situationRef.name} - ${situationRef.id.substring(0, 3)}'),
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
