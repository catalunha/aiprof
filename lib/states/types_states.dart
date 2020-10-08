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
  isNotactive,
}
enum ClassroomOrder {
  name,
}

enum StudentFilter {
  isactive,
  isNotactive,
}
enum StudentOrder {
  name,
}

enum SituationFilter {
  isactive,
  isNotactive,
}
enum SituationOrder {
  name,
}

enum KnowFilter {
  isactive,
  isNotactive,
}
enum KnowOrder {
  name,
}

enum SimulationFilter {
  isactive,
  isNotactive,
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
  isactive,
  isNotactive,
}
enum ExameOrder {
  name,
}
enum QuestionFilter {
  isactive,
  isNotactive,
}
enum QuestionOrder {
  name,
}
enum TaskFilter {
  isActive,
  isNotActive,
}
enum TaskOrder {
  name,
}
