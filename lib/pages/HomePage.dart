import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:Forge/utils/CustomDrawer.dart';
import 'package:Forge/utils/Day.dart';
import 'package:Forge/utils/AuthService.dart';
import 'package:Forge/utils/Habit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();
  late Size size;
  late DateTime selectedDate;
  List<Habit> globalHabitList = [];
  Map<DateTime, Day> daysMap = HashMap();
  TextEditingController habitController = TextEditingController();
  final AuthService auth = AuthService();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void initializeDaysInMonth() {
    final DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    final DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final int daysBeforeMonth = firstDayOfMonth.weekday - 1;

    for (int i = -daysBeforeMonth; i < lastDayOfMonth.day; i++) {
      final DateTime date = DateTime(now.year, now.month, 1 + i);
      daysMap[date] = Day(date);
    }
  }

  List<DateTime> getAllMonthDays() {
    return daysMap.keys.toList()
      ..sort((a, b) => a.compareTo(b))
      ..removeWhere((date) => date.month != now.month);
  }

  Widget buildCalendarDay(DateTime date, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: 1,
          ),
        ),
        height: size.width * 0.12,
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: date == selectedDate ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void addHabit(String habitName) {
    setState(() {
      // Create new habit
      Habit newHabit = Habit(habitName);
      globalHabitList.add(newHabit);

      // Add habit to all days in the month
      daysMap.forEach((date, day) {
        if (date.month == now.month) {
          day.addHabit(newHabit);
        }
      });
    });
  }

  void showAddHabitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Habit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: habitController,
                  decoration: InputDecoration(
                    hintText: 'Enter your habit',
                    prefixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        habitController.clear();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (habitController.text.isNotEmpty) {
                          addHabit(habitController.text);
                          Navigator.pop(context);
                          habitController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Habit added successfully!'),
                              backgroundColor: Colors.lightGreen,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    selectedDate = now;
    initializeDaysInMonth();
  }

  @override
  Widget build(BuildContext context) {
    
    size = MediaQuery.of(context).size;
    List<DateTime> monthDays = getAllMonthDays();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[350],
      drawer: CustomDrawer(
        onLogout: auth.signOut,
        size: size,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Existing top app bar code remains the same
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.08,
                  left: size.width * 0.08,
                  right: size.width * 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (scaffoldKey.currentState?.isDrawerOpen == true) {
                          scaffoldKey.currentState?.closeDrawer();
                        } else {
                          scaffoldKey.currentState?.openDrawer();
                        }
                      },
                      icon: Icon(Icons.menu)),
                  Text(
                      "${now.day.toString()}/${now.month.toString()}/${now.year.toString()}",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        showAddHabitDialog();
                      },
                      icon: Icon(Icons.add))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(size.width * 0.05),
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.lightGreen[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  // Calendar Grid
                  for (int i = 0; i < monthDays.length; i += 7)
                    Row(
                      children: monthDays
                          .sublist(
                              i, 
                              i + 7 > monthDays.length ? monthDays.length : i + 7
                          )
                          .map((date) => buildCalendarDay(
                              date, 
                              daysMap[date]?.getColor() ?? Colors.grey
                          ))
                          .toList()
                        ..addAll(List.generate(
                          i + 7 > monthDays.length ? 7 - (monthDays.length - i) : 0,
                          (_) => const Expanded(child: SizedBox()),
                        )),
                    ),
                ],
              ),
            ),
            // Habits List (existing code)
            Container(
              height: size.height * 0.3,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightGreen[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Habits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: globalHabitList.isEmpty
                        ? Center(
                            child: Text(
                              'No habits added yet',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: globalHabitList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                        value: globalHabitList[index].isDone,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            globalHabitList[index].toggleDone();                                            
                                            // Update habit state in all days
                                            daysMap.forEach((date, day) {
                                              if (date.month == now.month) {
                                                day.updateHabitState(globalHabitList[index]);
                                              }
                                            });
                                          });
                                        }),
                                    Expanded(
                                      child: Text(
                                        globalHabitList[index].getHabit(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon:
                                          const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          globalHabitList.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}