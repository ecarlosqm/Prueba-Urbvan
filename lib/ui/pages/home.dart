import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urbvan/core/position_tacker/domain/position_provider.dart';
import 'package:urbvan/core/position_tacker/position_tracker.dart';
import 'package:urbvan/core/route_generator/domain/path_provider.dart';
import 'package:urbvan/core/route_generator/route_generator.dart';
import 'package:urbvan/ui/controllers/position_tracker_controller.dart';
import 'package:urbvan/ui/pages/position_track_page.dart';
import 'package:urbvan/ui/controllers/route_generator_controller.dart';
import 'package:urbvan/ui/pages/route_generator_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;

  void changeTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return BlocProvider<PositionTrackerController>(
            create: (context) => PositionTrackerController(
                  PositionTraker(
                    context.read<PositionProvider>(),
                    Duration(seconds: 10),
                  ),
                )..init(),
            child: PositionTackerPage());
      case 1:
        return BlocProvider<RouteGeneratorController>(
          create: (context) => RouteGeneratorController(
            RouteGenerator(
              context.read<PathProvider>(),
            ),
          ),
          child: RouteGeneratorPage(),
        );
      default:
        throw Exception("Out of range");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prueba"),
      ),
      body: getPage(currentTab),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/iss.png",
              height: 20,
              width: 20,
            ),
            label: "ISS Tracker",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/route.png",
              height: 20,
              width: 20,
            ),
            label: "Route generator",
          ),
        ],
        onTap: changeTab,
        currentIndex: currentTab,
      ),
    );
  }
}
