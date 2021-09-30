import 'package:trip_planner/src/models/place.dart';

import 'api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<List<Place>> getBaggageList() {
    return _provider.getBaggageList();
  }
}

class NetworkError extends Error {}