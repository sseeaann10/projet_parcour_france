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

class Spots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  RealColumn get rating => real()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get image => text()();
  RealColumn get distance => real()();
  TextColumn get category => text()();
  TextColumn get city => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
}

@DriftDatabase(tables: [Users, Spots])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<User>> get allUsers => select(users).get();

  Future<List<Spot>> get allSpots => select(spots).get();

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

  Future<void> insertInitialSpots() async {
    final initialSpots = [
      SpotsCompanion(
        userId: const Value('1'),
        rating: const Value(4.5),
        title: const Value('Parc Astérix'),
        description: const Value(
            'Un parc d\'attractions sur le thème d\'Astérix et Obélix'),
        image: const Value(
            'https://cdn.sortiraparis.com/images/80/102768/925084-l-ete-gaulois-au-parc-asterix-img-9028.jpg'),
        distance: const Value(0.0),
        category: const Value('Loisirs'),
        city: const Value('Plailly'),
        latitude: const Value(49.1341),
        longitude: const Value(2.5707),
      ),
      SpotsCompanion(
        userId: const Value('2'),
        rating: const Value(4.2),
        title: const Value('Mont Saint-Michel'),
        description: const Value('Une île fortifiée avec une abbaye médiévale'),
        image: const Value(
            'https://www.france-voyage.com/visuals/photos/mont-saint-michel-1_w1000.jpg'),
        distance: const Value(0.0),
        category: const Value('Histoire'),
        city: const Value('Le Mont-Saint-Michel'),
        latitude: const Value(48.6361),
        longitude: const Value(-1.5115),
      ),
    ];

    for (final spot in initialSpots) {
      await into(spots).insert(spot);
    }
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
