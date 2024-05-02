import 'package:flutter/material.dart';

import '../../shared/shared.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Account'),
      body: Center(
        child: Text(
          'Coming soon...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
