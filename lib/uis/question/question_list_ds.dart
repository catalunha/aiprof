import 'package:aiprof/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuestionListDS extends StatefulWidget {
  final List<QuestionModel> questionList;
  final Function(String) onEditQuestionCurrent;
  final Function(String) onSituationSelect;

  const QuestionListDS({
    Key key,
    this.questionList,
    this.onEditQuestionCurrent,
    this.onSituationSelect,
  }) : super(key: key);

  @override
  _QuestionListDSState createState() => _QuestionListDSState();
}

class _QuestionListDSState extends State<QuestionListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#Question Questões (${widget.questionList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.questionList.length,
        itemBuilder: (context, index) {
          final question = widget.questionList[index];
          return Card(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 500,
                  child: ListTile(
                    selected: question.isDelivered ? true : false,
                    title: Text('${question.name}'),
                    subtitle: Text('${question.toString()}'),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar esta questão',
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    widget.onEditQuestionCurrent(question.id);
                  },
                ),
                IconButton(
                  tooltip: 'URL para a situação',
                  icon: Icon(Icons.local_library),
                  onPressed: () async {
                    if (question.situationRef?.url != null) {
                      if (await canLaunch(question.situationRef.url)) {
                        await launch(question.situationRef.url);
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
          widget.onEditQuestionCurrent(null);
        },
      ),
    );
  }
}
