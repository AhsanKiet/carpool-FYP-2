import 'package:flutter/material.dart';
import 'schedule_map.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TextEditingController faresController = TextEditingController();
  String? selectedScheduleType;
  List<String> carTypeList = ["Car AC", "Car Non-AC"];
  String? selectedCarType;
  List<String> availableList = ["1", "2", "3"];
  String? selectedavailableseats;
  
  final DatabaseReference _scheduleRef =
      FirebaseDatabase.instance.reference().child('schedules');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text(
          "Add Schedule",
          style: TextStyle(color: Colors.white),
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
                        selectedScheduleType='daily';
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: selectedScheduleType == 'daily'
                            ? Colors.green[200]
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
                            color: selectedScheduleType == 'daily'
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
                          selectedScheduleType = "once";
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedScheduleType == 'once'
                              ? Colors.green[200]
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
                              color: selectedScheduleType == "once"
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
            height: 570,
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
                      Text(
                        'Car Type:',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
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
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 30),
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
                  SizedBox(
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
                      Center(
                          child: Text(
                            _selectedDate == null
                            ? "Select Date"
                            : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        // "Select Date",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      )),
                      

        
                      const SizedBox(
                        width: 160,
                      ),
                     GestureDetector(
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );

                          if (selectedDate != null) {
                            setState(() {
                              _selectedDate = selectedDate;
                            });
                          }
                        },
                        child: Icon(Icons.calendar_today_outlined),
                      ),
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
                        width: 160,
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
                    height: 35,
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
                        height: 70,
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
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Select Route:",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () {
                          saveSchedule();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SetTravelRouteScreen(scheduleId: _scheduleRef.push().key)),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.green[
                                  200]), // Set the background color to orange.
                          minimumSize: MaterialStateProperty.all(
                              Size(115, 45)), // Set the width and height.
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Set the border radius.
                          )),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(color:Colors.white,fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
   void saveSchedule() {
    // Check if all required fields are filled
    if (_selectedDate == null ||
        _selectedTime == null ||
        selectedCarType == null ||
        selectedavailableseats == null ||
        faresController.text.isEmpty ||  selectedScheduleType == null ) {
      // Show an error message or toast to inform the user to fill in all details.
      Fluttertoast.showToast(msg: "Please fill in all details.");
      return;
    }
    // Create a unique scheduleId
    String? scheduleId = _scheduleRef.push().key;

    // Create a schedule object with the selected values
    Map<String, dynamic> scheduleData = {
      'date': _selectedDate!.toIso8601String(),
      'time': _selectedTime!.format(context),
      'carType': selectedCarType,
      'availableSeats': selectedavailableseats,
      'fares': faresController.text,
      'scheduleType': selectedScheduleType,
      'scheduleId': scheduleId,
      // Add other properties as needed
    };

    // Save the schedule to Firebase
    // _scheduleRef.push().set(scheduleData).then((value) {



      // Schedule saved successfully, navigate to the next screen or perform any other actions.
      _scheduleRef.child(scheduleId!).set(scheduleData).then((value) {
      // Schedule saved successfully, navigate to the next screen or perform any other actions.
      Fluttertoast.showToast(
                  msg: 'Schedule saved successfully!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SetTravelRouteScreen(scheduleId: scheduleId)),
      );
    }).catchError((error) {
      // Handle the error, e.g., show an error message to the user.
      print('Failed to save schedule: $error');
      Fluttertoast.showToast(msg: "Failed to save schedule.");
    });
  }
}

 
 

 