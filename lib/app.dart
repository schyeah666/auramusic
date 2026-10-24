import 'package:flutter/cupertino.dart';

import 'core/theme.dart';
import 'shell/root_shell.dart';

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Aura',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: RootShell(),
    );
  }
}
