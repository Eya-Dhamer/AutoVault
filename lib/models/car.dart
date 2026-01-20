class Car {
  final String name;
  final String brand;
  final String description;
  final String imagePath;
  final double price;
  final int year;
  final String engine;
  final int horsepower;
  final String fuelType;
  final double rating; // New field for rating

  Car({
    required this.name,
    required this.brand,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.year,
    required this.engine,
    required this.horsepower,
    required this.fuelType,
    required this.rating, // Add to constructor
  });
}