class StmRoute {
  final int id;
  final String agencyId;
  final String shortName;
  final String longName;
  final String type;

  const StmRoute(
      {required this.id,
      required this.agencyId,
      required this.shortName,
      required this.longName,
      required this.type});

  factory StmRoute.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'agencyId': String agencyId,
        'shortName': String shortName,
        'longName': String longName,
        'type': String type,
      } =>
        StmRoute(
            id: id,
            agencyId: agencyId,
            shortName: shortName,
            longName: longName,
            type: type),
      _ => throw const FormatException('Failed to load route.'),
    };
  }
}

class Trip {
  final int routeId;
  final String serviceId;
  final int tripId;
  final String tripHeadsign;
  final String direction;
  final String routeShortName = "";
  final String routeLongName = "";
  final String routeType = "";
  final String departureTime;
  final String stopId = "";
  final int stopSequence;
  final String stopName;

  const Trip({
    required this.routeId,
    required this.serviceId,
    required this.tripId,
    required this.direction,
    required this.tripHeadsign,
    required this.departureTime,
    required this.stopSequence,
    required this.stopName,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'routeId': int routeId,
        'serviceId': String serviceId,
        'tripId': int tripId,
        'direction': String direction,
        'tripHeadsign': String tripHeadsign,
        'departureTime': String departureTime,
        'stopSequence': int stopSequence,
        'stopName': String stopName,
      } =>
        Trip(
            routeId: routeId,
            serviceId: serviceId,
            tripId: tripId,
            direction: direction,
            tripHeadsign: tripHeadsign,
            departureTime: departureTime,
            stopSequence: stopSequence,
            stopName: stopName),
      _ => throw const FormatException('Failed to load trip.'),
    };
  }
}
