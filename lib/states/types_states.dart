enum AuthenticationStatusLogged {
  unInitialized,
  authenticated,
  authenticating,
  unAuthenticated,
  sendPasswordReset,
}

//+++ UserOrder
enum UserOrder {
  name,
}

extension UserOrderExtension on UserOrder {
  static const names = {
    UserOrder.name: 'Nome',
  };
  String get label => names[this];
}
//--- UserOrder

enum ClassroomFilter {
  isactive,
  isNotActive,
}
enum ClassroomOrder {
  name,
}

enum StudentFilter {
  isActive,
  isNotActive,
}
enum StudentOrder {
  name,
}

enum SituationFilter {
  isActive,
  isNotActive,
}
enum SituationOrder {
  name,
}

enum KnowFilter {
  isActive,
  isNotActive,
}
enum KnowOrder {
  name,
}

enum SimulationFilter {
  isActive,
  isNotActive,
}
enum SimulationOrder {
  name,
}
// enum SimulationType {
//   number,
//   word,
//   text,
//   url,
//   file,
// }

// extension SimulationTypeExtension on SimulationType {
//   static const names = {
//     SimulationType.number: 'Número',
//     SimulationType.word: 'Palavra',
//     SimulationType.text: 'Texto',
//     SimulationType.url: 'URL ou Link',
//     SimulationType.file: 'Upload de Arquivo',
//   };
//   String get label => names[this];
// }

enum ExameFilter {
  isActive,
  isNotActive,
}
enum ExameOrder {
  name,
}
enum QuestionFilter {
  isActive,
  isNotActive,
}
enum QuestionOrder {
  name,
}
enum TaskFilter {
  forSolve,
  forView,
  isActive,
  isNotActive,
  whereClassroomAndStudent,
  whereQuestionAndStudent,
}
enum TaskOrder {
  name,
}
