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
  isntactive,
}
enum ClassroomOrder {
  name,
}

enum StudentFilter {
  isactive,
  isntactive,
}
enum StudentOrder {
  name,
}

enum SituationFilter {
  isactive,
  isntactive,
}
enum SituationOrder {
  name,
}
