import 'package:http/http.dart' as http;

class Scenario {
  final String title;
  final String description;
  final http.Response response;
  final String scenarioCode;

  Scenario(
      {required this.title,
      required this.description,
      required this.response,
      required this.scenarioCode});
}
