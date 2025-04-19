import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:file_saver/file_saver.dart';
import 'package:http/http.dart' as http;
import 'package:stm_schedules/models.dart';

//const String apiAddress = "https://good-shoes-smash.loca.lt";
//const String apiAddress = "http://localhost:5211";
const String apiAddress =
    "https://stm-api-ewbmfaabc5b3ehc4.canadaeast-01.azurewebsites.net";

Future<List<StmRoute>> fetchRoutes() async {
  final response = await http.get(Uri.parse('$apiAddress/routes'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var routeList = jsonDecode(response.body) as List;
    List<StmRoute> routes = routeList.map((i) => StmRoute.fromJson(i)).toList();
    return routes;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load routes');
  }
}

Future<List<Trip>> fetchTrips(
    String route, String day, String direction, bool allTrips) async {
  final onlyExtremes = allTrips ? "false" : "true";

  final response = await http.get(Uri.parse(
      '$apiAddress/trips/$route?day=$day&dir=$direction&lim=$onlyExtremes'));

  if (response.statusCode == 200) {
    var tripList = jsonDecode(response.body) as List;
    List<Trip> trips = tripList.map((i) => Trip.fromJson(i)).toList();
    return trips;
  } else {
    throw Exception('Failed to load trips');
  }
}

void getRoutePdf(String route, String day, String direction) async {
  try {
    if (!kIsWeb) {
      // Android/iOS
      await FileSaver.instance.saveAs(
          name: "STM-$route-$day-$direction",
          link: LinkDetails(
            link: "$apiAddress/pdf/$route?day=$day&dir=$direction",
            method: "GET",
            headers: {
              "Accept": "application/pdf",
              "Content-Type": "application/pdf",
            },
          ),
          ext: "pdf",
          mimeType: MimeType.pdf);
    } else {
      // For web
      await FileSaver.instance.saveFile(
          name: "STM-$route-$day-$direction",
          link: LinkDetails(
            link: "$apiAddress/pdf/$route?day=$day&dir=$direction",
            method: "GET",
            headers: {
              "Accept": "application/pdf",
              "Content-Type": "application/pdf",
            },
          ),
          ext: "pdf",
          mimeType: MimeType.pdf);
    }
  } catch (e) {
    throw Exception('Failed to download PDF: $e');
  }
}
