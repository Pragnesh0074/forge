import 'package:Forge/utils/CustomDrawer.dart';
import 'package:Forge/utils/Day.dart';
import 'package:Forge/utils/AuthService.dart';
import 'package:flutter/material.dart';
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
  List<Habit> habits = [];
  TextEditingController habitController = TextEditingController();
  final AuthService auth = AuthService();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    selectedDate = now;
  }

  List<Day> getDaysInMonth() {
    final DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    final DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final int daysBeforeMonth = firstDayOfMonth.weekday - 1;
    final List<Day> days = [];

    for (int i = -daysBeforeMonth; i < lastDayOfMonth.day; i++) {
      final DateTime date = DateTime(now.year, now.month, 1 + i);
      days.add(Day(date));
      // days.add(DateTime(now.year, now.month, 1 + i));
    }
    return days;
  }

  Widget buildCalendarDay(DateTime date, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
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
            ),
          ),
        ),
      ),
    );
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
                SizedBox(height: 20),
                TextField(
                  controller: habitController,
                  decoration: InputDecoration(
                    hintText: 'Enter your habit',
                    prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        habitController.clear();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (habitController.text.isNotEmpty) {
                          setState(() {
                            habits.add(Habit(habitController.text));
                          });
                          Navigator.pop(context);
                          habitController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
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
                      child: Text(
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
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final days = getDaysInMonth();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[350],
      drawer: CustomDrawer(
        onLogout: auth.signOut,
        size: size,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
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
                  SizedBox(height: size.width * 0.05),
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
                  SizedBox(height: size.width * 0.05),
                  for (int i = 0; i < days.length; i += 7)
                    Row(
                      children: days
                          .sublist(i, i + 7 > days.length ? days.length : i + 7)
                          .map((date) =>
                              buildCalendarDay(date.day, date.getColor()))
                          .toList()
                        ..addAll(List.generate(
                          i + 7 > days.length ? i + 7 - days.length : 0,
                          (_) => Expanded(child: Container()),
                        )),
                    ),
                ],
              ),
            ),
            SizedBox(height: size.width * 0.05),
            Container(
              height: size.height * 0.3,
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
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
                  SizedBox(height: 10),
                  Expanded(
                    child: habits.isEmpty
                        ? Center(
                            child: Text(
                              'No habits added yet',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                        value: habits[index].isDone,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            habits[index].toggleDone();
                                          });
                                        }),
                                    Expanded(
                                      child: Text(
                                        habits[index].getHabit(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          habits.removeAt(index);
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
