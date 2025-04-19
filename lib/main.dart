import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stm_schedules/models.dart';
import 'package:stm_schedules/connection.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<StmRoute>> futureRoutes;
  List<Trip> routeTrips = List.empty();

  final TextEditingController routeController = TextEditingController();
  final TextEditingController weekDayController = TextEditingController();
  final TextEditingController directionController = TextEditingController();
  Text? selectedRoute;
  String? selectedDay;
  String? selectedDirection;
  final days = {"S": "Weekday", "A": "Saturday", "I": "Sunday"};
  final direction = {"0": "To", "1": "From"};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureRoutes = fetchRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STM Schedules',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('STM Schedules'),
          backgroundColor: Colors.green,
        ),
        body: ListView(children: [
          const Padding(padding: EdgeInsets.all(5)),
          FutureBuilder<List<StmRoute>>(
            future: futureRoutes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var routes = snapshot.data!;
                return Center(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: DropdownMenu<Text>(
                          controller: routeController,
                          enableFilter: false,
                          requestFocusOnTap: true,
                          leadingIcon: const Icon(Icons.search),
                          label: const Text('Route'),
                          inputDecorationTheme: const InputDecorationTheme(
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          onSelected: (Text? route) {
                            setState(() {
                              selectedRoute = route;
                            });
                          },
                          dropdownMenuEntries:
                              routes.map<DropdownMenuEntry<Text>>(
                            (StmRoute route) {
                              return DropdownMenuEntry<Text>(
                                value: Text(route.id.toString()),
                                label: "${route.shortName} - ${route.longName}",
                                leadingIcon: const Icon(Icons.bus_alert),
                              );
                            },
                          ).toList(),
                          menuHeight: 500,
                        )));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Center(
              child: DropdownMenu<String>(
            width: 200,
            controller: weekDayController,
            enableFilter: false,
            requestFocusOnTap: true,
            leadingIcon: const Icon(Icons.search),
            label: const Text('Day of week'),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5.0),
            ),
            onSelected: (String? day) {
              setState(() {
                selectedDay = day;
              });
            },
            dropdownMenuEntries: days.keys.map<DropdownMenuEntry<String>>(
              (String day) {
                return DropdownMenuEntry<String>(
                  value: day,
                  label: days[day] ?? "",
                );
              },
            ).toList(),
          )),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Center(
              child: DropdownMenu<String>(
            width: 200,
            controller: directionController,
            enableFilter: false,
            requestFocusOnTap: true,
            leadingIcon: const Icon(Icons.search),
            label: const Text('Direction'),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5.0),
            ),
            onSelected: (String? dir) {
              setState(() {
                selectedDirection = dir;
              });
            },
            dropdownMenuEntries: direction.keys.map<DropdownMenuEntry<String>>(
              (String dir) {
                return DropdownMenuEntry<String>(
                  value: dir,
                  label: direction[dir] ?? "",
                );
              },
            ).toList(),
          )),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: (selectedRoute != null &&
                          selectedDay != null &&
                          selectedDirection != null)
                      ? () async {
                          routeTrips = List.empty();
                          setState(() => isLoading = true);
                          routeTrips = await fetchTrips(
                              selectedRoute!.data.toString(),
                              selectedDay!,
                              selectedDirection!,
                              false);
                          setState(() => isLoading = false);
                        }
                      : null,
                  child: const Text('Get route info'))),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Center(
            child: routeTrips.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        "Route: ${selectedRoute!.data}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Direction: ${routeTrips.first.tripHeadsign}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Center(
                          child: SizedBox(
                              height: 150,
                              child: ListView.builder(
                                  itemCount: routeTrips.length,
                                  itemBuilder: (context, index) {
                                    String iniText =
                                        index == 0 ? "First stop" : "Last stop";
                                    return ListTile(
                                      title: Text(
                                          "$iniText: ${routeTrips[index].departureTime} at ${routeTrips[index].stopName}"),
                                    );
                                  }))),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 20)),
                              onPressed: () async {
                                getRoutePdf(selectedRoute!.data.toString(),
                                    selectedDay!, selectedDirection!);
                              },
                              child: const Text('Get route PDF'))),
                    ],
                  )
                : isLoading
                    ? const CircularProgressIndicator()
                    : const Padding(padding: EdgeInsets.all(5)),
          ),
        ]),
      ),
    );
  }
}
