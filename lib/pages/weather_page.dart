import 'dart:async';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/model/current_response_model.dart';
import 'package:weather_app/model/forecast_respose_model.dart';
import 'package:weather_app/pages/settings_page.dart';

import '../providers/weather_provider.dart';
import '../utils/constants.dart';
import '../utils/location_service.dart';
import '../utils/text_styles.dart';
import '../utils/helper_functions.dart';
import 'package:weather_app/utils/location_service.dart';



class WeatherPage extends StatefulWidget {
  static String routeName = '/';

  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with WidgetsBindingObserver{
  late WeatherProvider provider;
  bool isFirst = true;
  String loadingMsg = 'Please wait';
  late StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        setState(() {
          loadingMsg = 'Please wait';
        });
        _detectLocation();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isFirst) {
      provider = Provider.of<WeatherProvider>(context);
      isConnectedToInternet().then((value) {
        if(value) {
          _detectLocation();
        } else {
          setState(() {
            loadingMsg = 'No internet connection detected. Please turn on your wifi or mobile data';
          });
        }
      });
      isFirst = false;
    }
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        _detectLocation();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Weather',style: TextStyle(color: Colors.redAccent),),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _detectLocation();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                  context: context, delegate: _CitySearchDelegate());
              if (result != null && result.isNotEmpty) {
                provider.convertCityToLatLng(
                    result: result,
                    onError: (msg) {
                      showMsg(context, msg);
                    });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsPage.routeName),
          ),
        ],
      ),
      body: Center(
        child: provider.hasDataLoaded
            ? ListView(
          padding:
          const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          children: [
            _currentWeatherSection(),
            _forecastWeatherSection(),
          ],
        )
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            loadingMsg,
            style: txtNormal16,
          ),
        ),
      ),
    );
  }

  void _detectLocation() async {
    final isLocationEnabled = await isLocationServiceEnabled;
    if (isLocationEnabled) {
      try {
        final position = await determinePosition();
        provider.setNewLocation(position.latitude, position.longitude);
        provider.setTempUnit(await provider.getTempUnitPreferenceValue());
        provider.getWeatherData();
      } catch (error) {
        showMsg(context, 'error');
      }
    } else {
      showMsgWithAction(
        context: context,
        msg: 'Please turn on your location',
        actionButtonTitle: 'Go to Settings',
        onPressedSettings: () async {
          await openLocationSettings;
        },
      );
    }
  }

  Widget _currentWeatherSection() {

    final current = provider.currentResponseModel;
    return Column(
      children: [
        Text(
          getFormattedDateTime(
            current!.dt!,
            'MMM dd, yyyyy',
          ),
          style: txtDateBig18,
        ),
        Text(
          '${current.name}, ${current.sys!.country}',
          style: txtAddress25,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                '$iconPrefix${current.weather![0].icon}$iconSuffix',
                fit: BoxFit.cover,
              ),
              Text(
                '${current.main!.temp!.round()}$degree${provider.unitSymbol}',
                style: txtTempBig80,
              ),
            ],
          ),
        ),
        Text(
          'feels like ${current.main!.feelsLike}$degree${provider.unitSymbol}',
          style: txtNormal16White54,
        ),
        Text(
          '${current.weather![0].main} ${current.weather![0].description}',
          style: txtNormal16White54,
        ),
        const SizedBox(
          height: 10,
        ),
        Image.asset("images/200w.webp",width: 150,
          height: 100,),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Card(

            elevation: 10,


            child: InkWell(
              onTap: (){
                _bottomSheet2(current!);
              },

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 75),
                  child: Row(
                    children: [
                      Text('Weather Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.redAccent)),
                      Icon(Icons.details, color: Colors.redAccent,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          children: [
            Text(
              'Sunrise: ${getFormattedDateTime(current.sys!.sunrise!, 'hh:mm a')}',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Sunset: ${getFormattedDateTime(current.sys!.sunset!, 'hh:mm a')}',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          ],
        )
      ],
    );

  }

  Widget _forecastWeatherSection() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(
          width: 10,
        ),
        Text('Weather Forecast', style: txtDateBig24,),
    const SizedBox(
    width: 8,
    ),
        Container(
          height: 400,
          width: double.infinity,
          child: ListView.builder(

            itemCount: provider.forecastResponseModel!.list!.length,
            itemBuilder: (context, index) {
              final forecastData = provider.forecastResponseModel;
              return InkWell(
                child: Card(

                    elevation: 10,
                    color: Colors.redAccent,
                    child: InkWell(
                      onTap: () {
                        _bottomSheet(forecastData!, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: size.width / 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(getFormattedDateTime(
                                    forecastData!.list![index].dt!, 'E, MMM dd'), style: txtNormal16,),
                              ),
                            ),
                            SizedBox(
                              width: (size.width / 5) * 2,
                              child: Row(
                                children: [
                                  Image.network(
                                    '$iconPrefix${forecastData.list![index].weather![0].icon}$iconSuffix',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Text(
                                    '${forecastData.list![index].main!.humidity}/${forecastData.list![index].main!.temp!.round()}$degree', style: txtNormal16,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                  width: (size.width / 5 * 2),
                                  child: Text(
                                    '${forecastData.list![index].weather![0].description}', style: txtNormal16,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )),
              );
            },
          ),
        ),
      ],
    );
  }
  void _bottomSheet(ForecastResposeModel forecastResponseModel, int index) {
    showFlexibleBottomSheet(
      isExpand: true,
      minHeight: 0,
      initHeight: 0.4,
      maxHeight: 1,
      context: context,
      builder: (context, scrollController, bottomSheetOffset) {
        return Container(
          padding: EdgeInsets.all(16),
          color: Colors.blueGrey,
          child: ListView(

            controller: scrollController,
            children: [
              Center(
                child: Text('${forecastResponseModel.city!.name}, ${forecastResponseModel.city!.country}', style: txtAddress25,),
              ),
              Center(
                child: Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          '$iconPrefix${forecastResponseModel.list![index].weather![0].icon}$iconSuffix',
                          height: 50,
                          width: 50,
                        ),
                        Text(
                          '${forecastResponseModel.list![index].weather![0].main},  ${forecastResponseModel.list![index].weather![0].description}',
                          style: txtNormal16,
                        ),
                      ],
                    ),
                  ],

                ),
              ),

              Center(
                child: Text(
                  'The high will be ${forecastResponseModel.list![index].main!.tempMax} and the low will be ${forecastResponseModel.list![index].main!.tempMin}',
                  style: txtAddress25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(height: 10,color: Colors.black,),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Pressure : ${forecastResponseModel.list![index].main!.pressure}, Humidity : ${forecastResponseModel.list![index].main!.humidity}', style: txtNormal16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                    'Speed : ${forecastResponseModel.list![index].wind!.speed}, Degree : ${forecastResponseModel.list![index].wind!.deg},  UV : ${forecastResponseModel.list![index].wind!.gust}', style: txtNormal16
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Sunrise: ${getFormattedDateTime(forecastResponseModel.city!.sunrise!, 'hh : mm a')} | Sunset: ${getFormattedDateTime(forecastResponseModel.city!.sunset!, 'hh : mm a')}', style: txtNormal16,

                ),
              ),
            ],
          ),

        );
      },
      anchors: [0, 0.4, 1],
      isSafeArea: true,
    );
  }

  void _bottomSheet2(CurrentResposeModel currentResposeModel) {
    showFlexibleBottomSheet(
      isExpand: true,
      minHeight: 0,
      initHeight: 0.4,
      maxHeight: 1,
      context: context,
      builder: (context, scrollController, bottomSheetOffset) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5)),
              color: Colors.redAccent,
             boxShadow: [BoxShadow(color: Colors.orangeAccent, spreadRadius: 3,blurRadius: 10)]
          ),
          //padding: EdgeInsets.all(16),

          child: ListView(

            controller: scrollController,
            children: [

              const Divider(height: 10,color: Colors.black,),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Humidity =  ${currentResposeModel.main!.humidity}% ',
                  style: txtDateDesign,
                ),
              ),
              const Divider(height: 10,color: Colors.black,),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text('Pressure ${currentResposeModel.main!.pressure}hPa', style: txtNormal16White54,)
              ),
              const Divider(height: 10,color: Colors.black,),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Visibility = ${currentResposeModel.visibility}meter ',
                  style: txtDateDesign,
                ),
              ),
              Center(
                child: Text(
                  'Wind Speed = ${currentResposeModel.wind!.speed}meter/sec ',
                  style: txtDateDesign,
                ),

              ),
          Center(
            child: Text(
              'Wind Temparature= ${currentResposeModel.wind!.deg}$degree',
              style: txtDateDesign,
            ),
          )],
          ),

        );
      },
      anchors: [0, 0.4, 1],
      isSafeArea: true,
    );
  }

}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {},
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: Text(query),
      onTap: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty
        ? cities
        : cities
        .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(filteredList[index]),
        onTap: () {
          query = filteredList[index];
          close(context, query);
        },
      ),
    );
  }
}
