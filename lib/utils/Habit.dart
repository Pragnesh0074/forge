class Habit {
  String habit;
  bool isDone;

  Habit(this.habit) : isDone = false;

  void toggleDone() {
    isDone = !isDone;
  }

  bool getIsDone() => isDone;
  String getHabit() => habit;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit && other.habit == habit;
  }

  @override
  int get hashCode => habit.hashCode;
}