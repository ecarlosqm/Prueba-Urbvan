import 'package:flutter/material.dart';
import 'package:urbvan/config/config.dart';

import 'ui/main.dart';

void main([env]) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Configurations.initialize(env);
  runApp(Urbvan());
}
