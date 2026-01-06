import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import 'components.dart';

final viewModel = ChangeNotifierProvider.autoDispose<ViewModel>(
  (ref) => ViewModel(),
);

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  CollectionReference userCollection = FirebaseFirestore.instance.collection(
    'users',
  );
  bool isSignedIn = false;
  bool isObscure = true;
  var logger = Logger();
  final GoogleSignIn _google = GoogleSignIn.instance; // v 7+ singleton
  List expensesName = [];
  List expensesAmount = [];
  List incomesName = [];
  List incomesAmount = [];

  //Check if Signed In
  Future<void> isLoggedIn() async {
    await _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignedIn = false;
      } else {
        isSignedIn = true;
      }
    });
    notifyListeners();
  }

  //--------------------------------------------------------------------
  ///  GOOGLE-SIGN-IN  – MOBILE  (Android / iOS)  – v 7 API
  //--------------------------------------------------------------------
  Future<void> signInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount account = await _google
        .authenticate(scopeHint: const ['email']) // replaces signIn()
        .onError((error, stackTrace) {
          logger.d(error);
          DialogBox(
            context,
            error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
          );
          throw error!;
        });

    // authentication is now *synchronous* and returns only idToken
    final String? idToken = account.authentication.idToken;

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    await _auth
        .signInWithCredential(credential)
        .then((value) => logger.e('Signed in successfully $value'))
        .onError((error, stackTrace) {
          DialogBox(
            context,
            error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
          );
          logger.d(error);
        });
  }

  // --------------------------------------------------------------------
  ///  GOOGLE-SIGN-IN — WEB
  //--------------------------------------------------------------------
  Future<void> signInWithGoogleWeb(BuildContext context) async {
    final googleProvider = GoogleAuthProvider();

    await _auth
        .signInWithPopup(googleProvider) // Firebase Web flow
        .then(
          (_) => logger.d(
            'Current user UID present? '
            '${_auth.currentUser?.uid.isNotEmpty ?? false}',
          ),
        )
        .onError((error, stackTrace) {
          logger.d(error);
          return DialogBox(
            context,
            error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
          );
        });
  }

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  // Authentication
  Future<void> createUserWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.e('Signed in successfully $value'))
        .onError((error, stackTrace) {
          DialogBox(
            context,
            error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
          );
          logger.d(error);
        });
  }

  Future<void> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d('Signed in successfully $value'))
        .onError((error, stackTrace) {
          DialogBox(
            context,
            error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
          );
          logger.d(error);
        });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // Database
  Future<void> addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();

    return await showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.all(32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextForm(
                    text: "Name",
                    containerWidth: 130.0,
                    hintText: "name",
                    controller: controllerName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(width: 10.0),
                  TextForm(
                    text: "Amount",
                    containerWidth: 100.0,
                    hintText: "amount",
                    controller: controllerAmount,
                    digitsOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await userCollection
                        .doc(_auth.currentUser!.uid)
                        .collection("expenses")
                        .add({
                          "name": controllerName.text,
                          "amount": controllerAmount.text,
                        })
                        .onError((error, stackTrace) {
                          logger.d(error);
                          return DialogBox(
                            context,
                            error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
                          );
                        });
                    Navigator.pop(context);
                  }
                },
                child: OpenSans(text: "Save", size: 15.0, color: Colors.white),
                splashColor: Colors.grey,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ],
          ),
    );
  }

  // Add Income
  Future<void> addIncome(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();

    return await showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.all(32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.black, width: 1.0),
            ),
            title: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextForm(
                    text: "Name",
                    containerWidth: 130.0,
                    hintText: "name",
                    controller: controllerName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(width: 10.0),
                  TextForm(
                    text: "Amount",
                    containerWidth: 100.0,
                    hintText: "amount",
                    controller: controllerAmount,
                    digitsOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await userCollection
                        .doc(_auth.currentUser!.uid)
                        .collection("incomes")
                        .add({
                          "name": controllerName.text,
                          "amount": controllerAmount.text,
                        })
                        .then(
                          (value) =>
                              logger.d('Income added successfully $value'),
                        )
                        .onError((error, stackTrace) {
                          logger.d(error);
                          return DialogBox(
                            context,
                            error.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
                          );
                        });
                    Navigator.pop(context);
                  }
                },
                child: OpenSans(text: "Save", size: 15.0, color: Colors.white),
                splashColor: Colors.grey,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ],
          ),
    );
  }

  // expences stream
  void expensesStream() async {
    await for (var snapshot
        in userCollection
            .doc(_auth.currentUser!.uid)
            .collection("expenses")
            .snapshots()) {
      expensesAmount = [];
      expensesName = [];
      for (var expense in snapshot.docs) {
        expensesAmount.add(expense.data()["amount"]);
        expensesName.add(expense.data()["name"]);
        notifyListeners();
      }
    }
  }

  void incomeStream() async {
    await for (var snapshot
        in userCollection
            .doc(_auth.currentUser!.uid)
            .collection("incomes")
            .snapshots()) {
      incomesAmount = [];
      incomesName = [];
      for (var income in snapshot.docs) {
        incomesAmount.add(income.data()["amount"]);
        incomesName.add(income.data()["name"]);
        notifyListeners();
      }
    }
  }

  Future<void> reset() async {
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection("expenses")
        .get()
        .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection("incomes")
        .get()
        .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });
    // notifyListeners();
  }
}
