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
