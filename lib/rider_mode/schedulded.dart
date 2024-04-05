import 'package:flutter/material.dart';
import 'car_info.dart';
import 'home_screen.dart';
import 'userprofile.dart';
import 'original_map.dart';

// import 'package:fluttertoast/fluttertoast.dart';

class Scheduleded extends StatefulWidget {
  const Scheduleded({super.key});

  @override
  State<Scheduleded> createState() => _SchedulededState();
}

class _SchedulededState extends State<Scheduleded> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TextEditingController faresController = TextEditingController();
  bool? isDaily;
  List<String> carTypeList = ["CAR AC", "Car Non-AC"];
  String? selectedCarType;
  List<String> availableList = ["1", "2", "3"];
  String? selectedavailableseats;
  TabController? tabController;
  int selectedIndex = 0;
  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text(
          "My Schedule",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
            width: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDaily = true;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDaily != null && isDaily == true
                            ? Colors.green[300]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Daily",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDaily != null && isDaily == true
                                ? Colors.white
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isDaily = false;
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isDaily != null && isDaily == false
                              ? Colors.green[300]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Once",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDaily != null && isDaily == false
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            height: 720,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Car Type:',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 120),
                        child: Container(
                          width: 120, // Adjust the width as needed
                          height: 50, // Adjust the height as needed
                          child: DropdownButton(
                            iconSize: 30,
                            dropdownColor: Colors.white,
                            hint: const Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                "Select",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            value: selectedCarType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCarType = newValue.toString();
                              });
                            },
                            items: carTypeList.map((car) {
                              return DropdownMenuItem(
                                child: Text(
                                  car,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                value: car,
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Available Seats:',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      //   width: 88,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 52),
                        child: Container(
                          width: 120, // Adjust the width as needed
                          height: 50, // Adjust the height as needed
                          child: DropdownButton(
                            iconSize: 30,
                            dropdownColor: Colors.white,
                            hint: const Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                "Select",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            value: selectedavailableseats,
                            onChanged: (newValue) {
                              setState(() {
                                selectedavailableseats = newValue.toString();
                              });
                            },
                            items: availableList.map((available) {
                              return DropdownMenuItem(
                                child: Text(
                                  available,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                value: available,
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      const Center(
                          child: Text(
                        "Select Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      )),
                      // _selectedDate == null
                      // ? "Select Date"
                      // : DateFormat.yMMMd()
                      // .format(_selectedDate!)
                      // .toString(),
                      // style: const TextStyle(
                      // fontSize: 20,
                      // fontWeight: FontWeight.bold,
                      // ),
                      // textAlign: TextAlign.center,

                      // const Spacer(),
                      const SizedBox(
                        width: 160,
                      ),
                      GestureDetector(
                          onTap: () async {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100))
                                .then((value) => setState(() {
                                      _selectedDate = value!;
                                    }));
                          },
                          child: const Icon(Icons.calendar_today_outlined))
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      Text(
                        _selectedTime == null
                            ? "Select Time"
                            : TimeOfDay(
                                    hour: _selectedTime!.hour,
                                    minute: _selectedTime!.minute)
                                .format(context)
                                .toString(),
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // const Spacer(),
                      const SizedBox(
                        width: 155,
                      ),
                      GestureDetector(
                          onTap: () async {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: DateTime.now().hour,
                                        minute: DateTime.now().minute))
                                .then((value) => setState(() {
                                      _selectedTime = value!;
                                    }));
                          },
                          child: const Icon(Icons.timer_outlined))
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Enter Amount",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: TextFormField(
                          controller: faresController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            labelText: "Add Fares",
                            // hintText: "Select From Location",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 21,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              // Define the route you want to navigate to here.
                              // For example, you can navigate to a new screen.
                              return CarInfoScreen();
                            }),
                          );
                        },
                        child: Text('Delete Schedule'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          backgroundColor: Colors.green[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Set the border radius
                          ),
                          fixedSize: Size(400, 50.0),
                        ), //
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          // Define the route you want to navigate to here.
                          // For example, you can navigate to a new screen.
                          return CarInfoScreen();
                        }),
                      );
                    },
                    // onPressed: _updateUserProfile,
                    child: Text('Requests'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10), // Adjust the padding for width
                      backgroundColor: Colors.green[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      fixedSize: Size(400.0, 50.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          // Define the route you want to navigate to here.
                          // For example, you can navigate to a new screen.
                          return CarInfoScreen();
                        }),
                      );
                    },
                    // onPressed: _updateUserProfile,
                    child: Text('Passengers'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10), // Adjust the padding for width
                      backgroundColor: Colors.green[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      fixedSize: Size(400.0, 50.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          // Define the route you want to navigate to here.
                          // For example, you can navigate to a new screen.
                          return CarInfoScreen();
                        }),
                      );
                    },
                    // onPressed: _updateUserProfile,
                    child: Text('Start Ride'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10), // Adjust the padding for width
                      backgroundColor: Colors.green[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      fixedSize: Size(400.0, 50.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "location",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
        onTap: (int index) {
          // Handle navigation based on the tapped item
          if (index == 3) {
            // Navigate to the next page (AccountPage in this example)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileManagement()),
            );
          }
          if (index == 0) {
            // Navigate to the next page (AccountPage in this example)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreene()),
            );
          }
          if (index == 1) {
            // Navigate to the next page (AccountPage in this example)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OriginalMap()),
            );
          }
          if (index == 2) {
            // Navigate to the next page (AccountPage in this example)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Scheduleded()),
            );
          }
        },

        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green[300],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,

        // onTap: onItemClicked,
      ),
    );
  }
}
