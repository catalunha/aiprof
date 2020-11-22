// // import 'dart:async';
// import 'package:aiprof/actions/classroom_action.dart';
// import 'package:aiprof/models/user_model.dart';
// import 'package:aiprof/states/app_state.dart';
// import 'package:aiprof/states/types_states.dart';
// import 'package:async_redux/async_redux.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SetUserOrderSyncUserAction extends ReduxAction<AppState> {
//   final UserOrder userOrder;

//   SetUserOrderSyncUserAction(this.userOrder);
//   @override
//   AppState reduce() {
//     List<UserModel> _userList = [];
//     _userList.addAll(state.userState.userList);
//     return state.copyWith(
//       userState: state.userState.copyWith(
//         userOrder: userOrder,
//         userList: _userList,
//       ),
//     );
//   }
// }

// class GetDocsUserListAsyncUserAction extends ReduxAction<AppState> {
//   @override
//   Future<AppState> reduce() async {
//     print('GetDocsUserListAsyncUserAction...');
//     Firestore firestore = Firestore.instance;

//     final collRef = firestore.collection(UserModel.collection);
//     final docsSnap = await collRef.getDocuments();

//     final listDocs = docsSnap.documents
//         .map((docSnap) => UserModel(docSnap.documentID).fromMap(docSnap.data))
//         .toList();
//     return state.copyWith(
//       userState: state.userState.copyWith(
//         userList: listDocs,
//       ),
//     );
//   }
// }
