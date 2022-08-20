abstract class DatabaseState {}

class DatabaseOpened extends DatabaseState {}
class DatabaseClosed extends DatabaseState {}
class DatabaseInitial extends DatabaseClosed {}