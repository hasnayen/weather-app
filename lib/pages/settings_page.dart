import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class SettingsPage extends StatelessWidget {
  static String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings',style: TextStyle(color: Colors.deepOrangeAccent),),

      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) => ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            SwitchListTile(
              title: const Text('Show temperature in Fahrenheit', style: TextStyle(color: Colors.deepOrangeAccent),),
              subtitle: const Text('Default is Celcius',style: TextStyle(color: Colors.deepOrangeAccent)),
              value: provider.isFahrenheit,
              onChanged: (value) async {
                provider.setTempUnit(value);
                await provider.setTempUnitPreferenceValue(value);
                provider.getWeatherData();
              },
            ),
            SwitchListTile(
              title: const Text('Set current city as Default',style: TextStyle(color: Colors.deepOrangeAccent)),
              value: provider.isFahrenheit,
              onChanged: (value) async {

              },
            ),
          ],
        ),
      ),
    );
  }
}
