# aiprof

Avaliador Individual de Conhecimento 
TIK
## Detalhes

* User
* classroom
* know
    >
* situation
    > .
* simulation
    > .
* exame
  > a function se encarrega gerar task quando exame.isDelivery=true
  * question
    >: Add: atualiza em exame.questionMap[questionId]=false. pede para reaplicar exame
    >: Update: Se question.isDelivered=true a function atualiza as tasks relacionadas a ela.
    >: Delete: Se question.isDelivered=true apaga todas as tasks relacionados a ela. atualiza exame.questionMap.
  * student
    > Add: atualiza em exame.studentMap[studentId]=false. pede para reaplicar exame.
    > delete: Se exame.studentMap=true apaga todas as tasks relacionados a ela. atualiza exame.studentMap.
* task
    > é juntar as questões de um exame com os estudantes e gerar uma task

calnum
infoeng
modmat

