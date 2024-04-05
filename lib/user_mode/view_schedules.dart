import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'view_travel_route.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewSchedulesScreen extends StatefulWidget {
  @override
  _ViewSchedulesScreenState createState() => _ViewSchedulesScreenState();
}

class _ViewSchedulesScreenState extends State<ViewSchedulesScreen> {
  final DatabaseReference scheduleRef =
      FirebaseDatabase.instance.reference().child('schedules');
  List<Map<dynamic, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();

    // Use the database event stream to fetch schedules
    scheduleRef.onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      final Map<dynamic, dynamic>? values = snapshot.value as Map?;

      if (values != null) {
        schedules = values.entries
            .map<Map<dynamic, dynamic>>((e) => Map.from(e.value))
            .toList();
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carpool Schedules'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[300],
      ),
      body: schedules.isNotEmpty
          ? ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                Map<dynamic, dynamic> schedule = schedules[index];
                String routeName = 'Route ${index + 1}';
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    // title: Text('Car Type: ${schedule['carType']}'),
                    title: Text(routeName),
                    subtitle:
                        // Text('Available Seats: ${schedule['availableSeats']}'),
                        // Text('Vehicle Type: ${schedule['carType']}'),
                        //fares
                        Text('Fares: ${schedule['fares']}'),
                    trailing:
                        Text('Available Seats: ${schedule['availableSeats']}'),

                    onTap: () {
                      // Navigate to a detailed view of the schedule
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ScheduleDetailsScreen(schedule: schedule),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : Center(
              child: Text('No schedules available.'),
            ),
    );
  }
}

class ScheduleDetailsScreen extends StatelessWidget {
  final Map<dynamic, dynamic> schedule;

  ScheduleDetailsScreen({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Details'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Route: ${schedule['routeId']}'),
                    SizedBox(height: 8),
                    Text('Vehicle Type: ${schedule['carType']}'),
                    SizedBox(height: 8),
                    Text('Available Seats: ${schedule['availableSeats']}'),
                    SizedBox(height: 8),
                    Text('Date: ${schedule['date']}'),
                    SizedBox(height: 8),
                    Text('Time: ${schedule['time']}'),
                    SizedBox(height: 8),
                    Text('Schedule Type: ${schedule['scheduleType']}'),
                    SizedBox(height: 8),
                    Text('Fares: ${schedule['fares']}'),
                  ],
                ),
              ),
            ),

            // Add other details as needed
            ElevatedButton(
              onPressed: () {
                // Navigate to the map view for the selected schedule
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // ViewTravelRouteScreen(scheduleId: '-NliXfP1uOa4t3xYJiIS'),
                        ViewTravelRouteScreen(scheduleId: schedule['routeId']),
                  ),
                );
              },
              child: Text('View Travel Route'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Change this to the desired background color
                foregroundColor: Colors
                    .white, // Change this to the desired foreground (text) color
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the booking screen for the selected schedule
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(schedule: schedule),
                  ),
                );
              },
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Change this to the desired background color
                foregroundColor: Colors
                    .white, // Change this to the desired foreground (text) color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  final Map<dynamic, dynamic> schedule;

  BookingScreen({required this.schedule});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Define variables to store user selections
  int selectedPassengers = 1;
  String selectedStop = 'Origin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Car Type: ${widget.schedule['carType']}'),
                    SizedBox(height: 8),
                    Text(
                        'Available Seats: ${widget.schedule['availableSeats']}'),
                    SizedBox(height: 8),
                    Text('Date: ${widget.schedule['date']}'),
                    SizedBox(height: 8),
                    Text('Time: ${widget.schedule['time']}'),
                    SizedBox(height: 8),
                    Text('Schedule Type: ${widget.schedule['scheduleType']}'),
                    SizedBox(height: 8),
                    Text('Fares: ${widget.schedule['fares']}'),
                  ],
                ),
              ),
            ),

            // Add other details as needed
            // Add dropdowns for passengers and stops selection
            // Add a button to book the schedule
            SizedBox(height: 16),

            DropdownButton<int>(
              value: selectedPassengers,
              onChanged: (int? value) {
                setState(() {
                  selectedPassengers = value!;
                });
              },
              items: [1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value Passenger(s)'),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            DropdownButton<String>(
              value: selectedStop,
              onChanged: (String? value) {
                setState(() {
                  selectedStop = value!;
                });
              },
              items: [
                'Origin',
                'Destination',
                'Stop 1',
                'Stop 2',
                'Stop 3',
                'Stop 4'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "Booking Successful",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green[300],
                    textColor: Colors.white,
                    fontSize: 16.0);

                // Implement booking logic here

                // You may want to update the schedule in the database to mark it as booked
                // Show a success message and navigate back to the schedules screen
              },
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Change this to the desired background color
                foregroundColor: Colors
                    .white, // Change this to the desired foreground (text) color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ViewSchedulesScreen(),
  ));
}
