import 'dart:convert';

import 'package:urbvan/core/route_generator/domain/path.dart';
import 'package:urbvan/core/route_generator/domain/path_provider.dart';
import 'package:urbvan/core/shared/domain/position.dart';
import 'package:urbvan/core/shared/domain/response.dart';
import 'package:http/http.dart' as http;

enum TravelMode { driving, bicycling, transit, walking }

class GooglePathProvider implements PathProvider {
  final String apiKey;

  GooglePathProvider(this.apiKey);

  @override
  Future<Response<List<Path>>> getPaths({required Position from, required  Position to,}) async {
    var params = {
      "origin": "${from.latitude},${from.longitude}",
      "destination": "${to.latitude},${to.longitude}",
      "alternatives": "true",
      "key": apiKey
    };
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/directions/json", params);
    try {
      var response = await http.get(uri);
      if (response.statusCode != 200)
        return Response.fail("No fue posible obtener la ruta");
      final body = json.decode(response.body);
      if (body["status"].toLowerCase() != "ok")
        Response.fail("No fue posible obtener la ruta");

      final paths = (body["routes"] as List)
          .map(
            (routeMap) => Path(
              polyline: _decodeEncodedPolyline(routeMap["overview_polyline"]["points"]),
              bounds: _getBoundsFromJson(routeMap["bounds"]),
              distance: routeMap["legs"][0]["distance"]["text"],
              duration: routeMap["legs"][0]["duration"]["text"],
            ),
          )
          .toList();
      return Response.success(paths);
    } catch (e) {
      return Response.fail("No fue posible obtener la ruta");
    }
  }

  PathBounds _getBoundsFromJson(Map<String, dynamic> map) {
    final northeastPosition = Position(
      map["northeast"]["lat"],
      map["northeast"]["lng"],
    );
    final southwestPosition = Position(
      map["southwest"]["lat"],
      map["southwest"]["lng"],
    );
    return PathBounds(northeastPosition, southwestPosition);
  }

  List<Position> _decodeEncodedPolyline(String encoded) {
    List<Position> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      Position p =
          new Position((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}
