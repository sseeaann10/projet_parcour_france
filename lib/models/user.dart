import 'package:crypto/crypto.dart';
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String hashedPassword;
  final String? phone;
  final String? address;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.hashedPassword,
    this.phone,
    this.address,
    this.photoUrl,
  });

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  factory User.create({
    required String id,
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    String? photoUrl,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      hashedPassword: hashPassword(password),
      phone: phone,
      address: address,
      photoUrl: photoUrl,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      hashedPassword: map['hashedPassword'] ?? '',
      phone: map['phone'],
      address: map['address'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'hashedPassword': hashedPassword,
      'phone': phone,
      'address': address,
      'photoUrl': photoUrl,
    };
  }

  bool checkPassword(String password) {
    return hashedPassword == hashPassword(password);
  }
}

// Liste des utilisateurs statiques pour le développement
List<User> staticUsers = [
  User.create(
    id: 'user1',
    name: 'Jean Dupont',
    email: 'jean@example.com',
    password: 'password123',
    phone: '+33 6 12 34 56 78',
    address: '123 Avenue des Champs-Élysées, Paris',
    photoUrl: 'https://picsum.photos/200',
  ),
  User.create(
    id: 'user2',
    name: 'Marie Martin',
    email: 'marie@example.com',
    password: 'password456',
    phone: '+33 6 98 76 54 32',
    address: '45 Rue de la République, Lyon',
    photoUrl: 'https://picsum.photos/201',
  ),
  User.create(
    id: 'user3',
    name: 'Pierre Bernard',
    email: 'pierre@example.com',
    password: 'password789',
    phone: '+33 6 11 22 33 44',
    address: '78 Boulevard de la Plage, Bordeaux',
    photoUrl: 'https://picsum.photos/202',
  ),
  User.create(
    id: 'user4',
    name: 'Sophie Petit',
    email: 'sophie@example.com',
    password: 'password321',
    phone: '+33 6 55 44 33 22',
    address: '15 Rue des Fleurs, Strasbourg',
    photoUrl: 'https://picsum.photos/203',
  ),
  User.create(
    id: 'user5',
    name: 'Lucas Dubois',
    email: 'lucas@example.com',
    password: 'password654',
    phone: '+33 6 99 88 77 66',
    address: '92 Avenue de la Mer, Nice',
    photoUrl: 'https://picsum.photos/204',
  ),
];
