import 'package:Forge/utils/Habit.dart';
import 'package:flutter/material.dart';

class Day {
  late DateTime day;
  late final List<Habit> habits;

  Day(this.day) : habits = [];

  void updateHabit(Habit habit) {
    if (habits.contains(habit)) {
      habits.remove(habit);
    } else {
      habits.add(habit);
      habit.toggleDone();
    }
  }

  Color getColor() {
    int shade = 300;
    if (habits.isEmpty) {
      return Colors.grey;
    } else {
      for (int i = 0; i < habits.length; i++) {
        if (habits[i].isDone) {
          shade = 300 + (i * 100);
        }
      }
      if (shade > 900) shade = 900;
      return Colors.green[shade]!;
    }
  }
}
