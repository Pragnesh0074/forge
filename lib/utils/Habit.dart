class Habit {
  String? habit;
  bool isDone;

  Habit(this.habit) : isDone = false;

  void toggleDone() {
    isDone = !isDone;
  }

  bool getIsDone() => isDone;
  String getHabit() => habit!;
}
