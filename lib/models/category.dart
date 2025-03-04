class Category {
  final String id;
  final String name;
  final String icon;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

// Données statiques des catégories
final List<Category> staticCategories = [
  Category(
    id: '1',
    name: 'Monuments',
    icon: 'assets/icons/monument.png',
    description: 'Sites historiques et monuments remarquables',
  ),
  Category(
    id: '2',
    name: 'Nature',
    icon: 'assets/icons/nature.png',
    description: 'Parcs naturels et paysages exceptionnels',
  ),
  Category(
    id: '3',
    name: 'Châteaux',
    icon: 'assets/icons/chateau.png',
    description: 'Châteaux et demeures historiques',
  ),
  Category(
    id: '4',
    name: 'Plages',
    icon: 'assets/icons/plage.png',
    description: 'Les plus belles plages de France',
  ),
  Category(
    id: '5',
    name: 'Musées',
    icon: 'assets/icons/musee.png',
    description: 'Musées et galeries d\'art',
  ),
  Category(
    id: '6',
    name: 'Gastronomie',
    icon: 'assets/icons/gastronomie.png',
    description: 'Restaurants et spécialités locales',
  ),
];
