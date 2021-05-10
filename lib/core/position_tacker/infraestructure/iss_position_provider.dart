import 'dart:convert';

import 'package:urbvan/core/position_tacker/domain/position_provider.dart';
import 'package:http/http.dart' as http;
import 'package:urbvan/core/shared/domain/position.dart';
import 'package:urbvan/core/shared/domain/response.dart';

class IssPositionProvider implements PositionProvider {
  @override
  Future<Response<Position>> getPosition() async {
    final response =
        await http.get(Uri.http("api.open-notify.org", "/iss-now.json"));
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody["message"] == "success") {
      return Response.success(Position(
        jsonDecode(responseBody["iss_position"]["latitude"]),
        jsonDecode(responseBody["iss_position"]["longitude"]),
      ));
    }
    return Response.fail(responseBody["message"]);
  }
}
