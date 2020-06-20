// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tokyo_stroll/screens/authenticate.dart';
import 'package:tokyo_stroll/screens/register.dart';
import 'package:tokyo_stroll/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_stroll/services/auth.dart';
import 'package:tokyo_stroll/models/user.dart';
import 'screens/authenticate.dart';
import 'screens/buyList.dart';

void main() => runApp(TokyoStrollApp());

class TokyoStrollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp( 
        routes: {
          '/': (context) => Wrapper(),
          '/register': (context) => RegisterPage()
        },
      )
    );
  }
}



