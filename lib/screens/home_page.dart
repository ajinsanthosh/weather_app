import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/data/image_path.dart';
import 'package:weather/services/location_provider.dart';
import 'package:weather/services/weather_services_provider.dart';
import 'package:weather/utils/apptext.dart';
import 'package:weather/utils/custom_divider_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServicesProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });

    // Provider.of<LocationProvider>(context, listen: false).determinePosition();
    // Provider.of<WeatherServicesProvider>(context,listen: false).fetchWeatherDataByCity("dubai");

    super.initState();
  }

  TextEditingController _cityController = TextEditingController();
  var city;

  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  bool _clicked = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);
    final weatherprovider = Provider.of<WeatherServicesProvider>(context);

    int sunriseTimestamp = weatherprovider.Weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherprovider.Weather?.sys?.sunset ?? 0;

    DateTime sunriseDate =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDate =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

    // Format DateTime to a readable time string with AM/PM
    String formattedSunrise = DateFormat('hh:mm a').format(sunriseDate);
    String formattedSunset = DateFormat('hh:mm a').format(sunsetDate);

     String timenow = DateFormat("hh:mm a").format(DateTime.now());
     DateTime time = DateFormat("hh:mm a").parse(timenow);
     String greetings = getGreetings(time);

     
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 70, bottom: 20, right: 20, left: 30),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(backgrounde[
                      weatherprovider.Weather?.weather![0].main ?? "N/A"] ??
                  "assets/img/clouds.jpg")),
        ),
        child: Stack(children: [
          _clicked == true
              ? Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            weatherprovider
                                .fetchWeatherDataByCity(_cityController.text);
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Container(
              height: 50,
              child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                var locationCity;
                if (locationProvider.currentLocationName != null) {
                  locationCity = locationProvider.currentLocationName!.locality;
                } else {
                  locationCity = "Unkown Locaton";
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: locationCity,
                                color: Colors.white,
                                fw: FontWeight.w700,
                                size: 18,
                              ),
                              AppText(
                                data: greetings ,
                                color: Colors.white,
                                fw: FontWeight.w400,
                                size: 14,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _clicked = !_clicked;
                          });
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 32,
                          color: Colors.white,
                        ))
                  ],
                );
              })),
          Align(
              alignment: const Alignment(0, -0.7),
              child: Image.asset(imagePathe[
                      weatherprovider.Weather?.weather![0].main ?? "N/A"] ??
                  "assets/img/mist.png")),
          Align(
            alignment: const Alignment(0.0, -0.1),
            child: Container(
              height: 150,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    data:
                        "${weatherprovider.Weather?.main?.temp!.toStringAsFixed(0)}\u00B0 C",
                    color: Colors.white,
                    fw: FontWeight.bold,
                    size: 31,
                  ),
                  AppText(
                    data: weatherprovider.Weather?.weather![0].main ?? "N/A",
                    color: Colors.white,
                    fw: FontWeight.w600,
                    size: 26,
                  ),
                  AppText(
                    data: weatherprovider.Weather?.name ?? "N/A",
                    color: Colors.white,
                    fw: FontWeight.w600,
                    size: 21,
                  ),
                  AppText(
                    data: DateFormat("hh:mm  a").format(DateTime.now()),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, 0.50),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/img/temperature-high.png',
                            height: 55,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: "Temp Max",
                                color: Colors.white,
                                size: 15,
                                fw: FontWeight.w600,
                              ),
                              AppText(
                                data:
                                    "${weatherprovider.Weather?.main!.tempMax!.toStringAsFixed(0) ?? "N/A"}\u00B0 C",
                                color: Colors.white,
                                size: 15,
                                fw: FontWeight.w600,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/img/temperature-low.png',
                            height: 55,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: "Temp Min",
                                color: Colors.white,
                                size: 15,
                                fw: FontWeight.w600,
                              ),
                              AppText(
                                data:
                                    "${weatherprovider.Weather?.main!.tempMin!.toStringAsFixed(0) ?? "N/A"}\u00B0 C",
                                color: Colors.white,
                                size: 15,
                                fw: FontWeight.w600,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  CustomDivider(
                    startIndent: 20,
                    endIndent: 20,
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/img/sun.png',
                            height: 55,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: "sunrice",
                                color: Colors.white,
                                size: 15,
                                fw: FontWeight.w600,
                              ),
                              AppText(
                                data: formattedSunrise,
                                color: Colors.white,
                                size: 15,
                                fw: FontWeight.w600,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                        width: 40,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/img/moon.png',
                            height: 55,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: "Sunset",
                                color: Colors.white,
                                size: 15,
                                fw: FontWeight.w600,
                              ),
                              AppText(
                                data: formattedSunset,
                                color: Colors.white,
                                size: 15,
                                fw: FontWeight.w600,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}


String getGreetings(DateTime time) {
  int hour = time.hour;
  
  if (hour >= 5 && hour < 12) {
    return "Good morning!";
  } else if (hour >= 12 && hour < 17) {
    return "Good afternoon!";
  } else if (hour >= 17 && hour < 21) {
    return "Good evening!";
  } else {
    return "Good night!";
  }
}
