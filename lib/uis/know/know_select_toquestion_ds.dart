import 'package:flutter/material.dart';
import 'package:aiprof/models/know_model.dart';

class KnowSelectToQuestionDS extends StatelessWidget {
  final List<KnowModel> knowList;
  final Function(String) onFolderList;

  const KnowSelectToQuestionDS({
    Key key,
    this.knowList,
    this.onFolderList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conhecimentos (${knowList.length})'),
      ),
      body: ListView.builder(
        itemCount: knowList.length,
        itemBuilder: (context, index) {
          final know = knowList[index];
          return Card(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 500,
                  child: ListTile(
                    title: Text('${know.name}'),
                    subtitle: Text('${know.toString()}'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.line_style),
                  onPressed: () async {
                    onFolderList(know.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
