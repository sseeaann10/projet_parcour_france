import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class Spots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  RealColumn get rating => real()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get image => text()();
  RealColumn get distance => real()();
  TextColumn get category => text().references(Categories, #name)();
  TextColumn get city => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
}

@DriftDatabase(tables: [Users, Categories, Spots])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<User>> get allUsers => select(users).get();
  Future<List<Category>> get allCategories => select(categories).get();
  Future<List<Spot>> get allSpots => select(spots).get();

  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  Future<int> updateUser(UsersCompanion user) async {
    await (update(users)..where((u) => u.id.equals(user.id.value)))
        .write(UsersCompanion(
      name: user.name,
      email: user.email,
      password: user.password,
    ));
    return user.id.value;
  }

  Future<int> deleteUser(int id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }

  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<int> insertSpot(SpotsCompanion spot) {
    return into(spots).insert(spot);
  }

  Future<int> updateSpot(SpotsCompanion spot) async {
    await (update(spots)..where((s) => s.id.equals(spot.id.value))).write(spot);
    return spot.id.value;
  }

  Future<int> deleteSpot(int id) {
    return (delete(spots)..where((s) => s.id.equals(id))).go();
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
