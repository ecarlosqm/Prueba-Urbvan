import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urbvan/config/config.dart';
import 'package:urbvan/core/position_tacker/domain/position_provider.dart';
import 'package:urbvan/core/position_tacker/infrastructure/iss_position_provider.dart';
import 'package:urbvan/core/route_generator/domain/path_provider.dart';
import 'package:urbvan/core/route_generator/infrastructure/google_path_provider.dart';
import 'package:urbvan/ui/pages/home.dart';

class Urbvan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PathProvider>(
          create: (context) => GooglePathProvider(
            Configurations.getGoogleMapsApiKey(),
          ),
        ),
        RepositoryProvider<PositionProvider>(
          create: (context) => IssPositionProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Prueba Urbvan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
