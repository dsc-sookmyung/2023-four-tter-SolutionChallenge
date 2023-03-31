import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherModel {
  Icon getWeatherIcon(int? condition) {
    if (condition != null && condition < 300) {
      return Icon(WeatherIcons.sleet, color: Colors.teal.shade700, size: 68);
    } else if (condition != null && condition < 400) {
      return Icon(WeatherIcons.rain_mix, color: Colors.teal.shade700, size: 68);
    } else if (condition != null && condition < 600) {
      return Icon(WeatherIcons.rain, color: Colors.teal.shade700, size: 68);
    } else if (condition != null && condition < 700) {
      return Icon(WeatherIcons.snow, color: Colors.teal.shade700, size: 68);
    } else if (condition != null && condition < 800) {
      return const Icon(WeatherIcons.cloudy_gusts,
          color: Colors.white, size: 68);
    } else if (condition != null && condition == 800) {
      return Icon(WeatherIcons.day_sunny,
          color: Colors.teal.shade700, size: 68);
    } else if (condition != null && condition <= 804) {
      return Icon(WeatherIcons.cloud, color: Colors.teal.shade700, size: 68);
    } else {
      return Icon(WeatherIcons.na, color: Colors.teal.shade700, size: 68);
    }
  }

  String getMessage(int? condition) {
    if (condition != null && condition < 600) {
      //비
      return '빗길 조심하세요';
    } else if (condition != null && condition < 700) {
      //눈
      return '눈길 조심하세요';
    } else if (condition != null && condition <= 800) {
      // 날씨 좋음
      return '가볍게 산책어떠세요';
    } else if (condition != null && condition <= 804) {
      //구름
      return '따뜻하게 챙겨입으세요';
    } else {
      return '실내에서 쉬는걸 추천드려요';
    }
  }
}
