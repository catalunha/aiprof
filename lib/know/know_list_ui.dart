import 'package:aiprof/know/know_model.dart';
import 'package:aiprof/routes.dart';
import 'package:flutter/material.dart';

class KnowListUI extends StatelessWidget {
  final List<KnowModel> knowList;
  final Function(String) onEditKnowCurrent;
  final Function(String) onFolderList;

  const KnowListUI({
    Key key,
    this.knowList,
    this.onEditKnowCurrent,
    this.onFolderList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conhecimento (${knowList?.length})'),
        actions: [
          IconButton(
              icon: Icon(Icons.fact_check_outlined),
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.situationList))
        ],
      ),
      body: Center(
        child: Container(
          width: 600,
          child: ListView.builder(
            itemCount: knowList.length,
            itemBuilder: (context, index) {
              final know = knowList[index];
              return Card(
                child: Wrap(
                  // alignment: WrapAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 400,
                      child: ListTile(
                        title: Text('${know.name}'),
                        subtitle: Text('${know.toString()}'),
                      ),
                    ),
                    // SelectableText(json.encode(know.toMap()).toString()),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        onEditKnowCurrent(know.id);
                      },
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          onEditKnowCurrent(null);
        },
      ),
    );
  }
}
