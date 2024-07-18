import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather/models/Weather_response.dart';
import 'package:weather/secrets/api.dart';
import 'package:http/http.dart' as http;

class WeatherServicesProvider extends ChangeNotifier {
  WeatherModel? _weather;
  WeatherModel? get Weather => _weather;

  bool _isloading = false;
  bool get isloading => _isloading;

  String _error = "";
  String get error => _error;

  Future<void> fetchWeatherDataByCity(String city) async {
    _isloading = true;
    _error = "";

    //https://api.openweathermap.org/data/2.5/weather?q=dubai&appid=8e49b4ad8a28cc03204f9b46dc50febe&units=metric

    try {
      final apiUrl =
          "${APIEndpoints().cityUrl}${city}&appid=${APIEndpoints().apiKey}${APIEndpoints().unit}";
          print(apiUrl);

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
       
       

        _weather = WeatherModel.fromJson(data);
        notifyListeners();
      } else {
        _error = "Failed to load date";
      }
    } catch (e) {
      _error = "Failed to load data $e";
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
  
}
