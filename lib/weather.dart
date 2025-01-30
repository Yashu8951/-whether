import 'dart:convert';
import 'dart:ui';
import 'weathericon.dart';
import 'package:flutter/material.dart';
import 'additioninfoiteam.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<Map<String, dynamic>> getData() async {
    try {
      print('api called');
      String cityname = 'Mysore';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityname,IN&appid=fc10709cf7738bb35b403fbc28f3d7d9'));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentwedata = data['list'][0];
          final currenttemp = currentwedata['main']['temp'];
          final currentsky = currentwedata['weather'][0]["main"];
          final currentpressure = currentwedata['main']["pressure"];
          final currenthumidity = currentwedata['main']["humidity"];
          final currentwindspeed = currentwedata['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    '$currenttemp k',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Icon(
                                    currentsky == 'Clouds' ||
                                            currentsky == 'Rain'
                                        ? Icons.cloud
                                        : (currentsky == 'Night'
                                            ? Icons.nightlight
                                            : Icons.nightlight_outlined),
                                    size: 42,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    currentsky,
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'Weather ForeCast',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 1; i < 6; i++)
                          SecondForecast(
                            icon: data['list'][i + 1]['weather'][0]["main"] ==
                                        'Clouds' ||
                                    data['list'][i + 1]['weather'][0]["main"] ==
                                        'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            firsttext:
                                DateTime.parse(data['list'][i + 1]['dt_txt'])
                                    .toLocal()
                                    .toString()
                                    .split(' ')[1]
                                    .substring(0, 5),
                            value:
                                data['list'][i + 1]['main']['temp'].toString(),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Addition Information',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionInfoIteam(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currenthumidity.toString(),
                      ),
                      AdditionInfoIteam(
                          icon: Icons.air,
                          label: 'Wind Speed',
                          value: currentwindspeed.toString()),
                      AdditionInfoIteam(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentpressure.toString(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
