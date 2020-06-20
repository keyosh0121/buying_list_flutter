import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_stroll/models/buyListItem.dart';
import 'package:tokyo_stroll/models/user.dart';
import 'package:tokyo_stroll/screens/authenticate.dart';
import 'package:tokyo_stroll/screens/buyList.dart';
import 'package:tokyo_stroll/services/database.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return AuthenticatePage();
    } else {
      return StreamProvider<List<BuyListItem>>.value(
        value: DatabaseService(user.uid).buylist,
        child: BuyList()
      );
    }
  }
}