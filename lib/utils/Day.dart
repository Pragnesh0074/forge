
import 'package:Forge/utils/Habit.dart';
import 'package:flutter/material.dart';

class Day {
  DateTime day;
  List<Habit> habits;

  Day(this.day) : habits = [];

  void addHabit(Habit habit) {
    if (!habits.contains(habit)) {
      habits.add(habit);
    }
  }

  void updateHabitState(Habit habit) {
    Habit existingHabit = habits.firstWhere(
      (h) => h.getHabit() == habit.getHabit(), 
      orElse: () => habit
    );
    existingHabit.isDone = habit.isDone;
  }

  DateTime getDay() => day;
  List<Habit> getHabits() => habits;

  Color getColor() {
    if (habits.isEmpty) return Colors.grey;

    // Create color gradient based on completed habits
    int completedHabits = habits.where((habit) => habit.isDone).length;
    
    // More completed habits = darker green
    switch (completedHabits) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.green[300]!;
      case 2:
        return Colors.green[500]!;
      case 3:
        return Colors.green[700]!;
      default:
        return Colors.green[900]!;
    }
  }
}