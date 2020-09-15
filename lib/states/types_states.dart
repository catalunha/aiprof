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

// extension UserOrderExtension on UserOrder {
//   static const names = {
//     UserOrder.name: 'Nome',
//   };
//   String get label => names[this];
// }
//--- UserOrder
