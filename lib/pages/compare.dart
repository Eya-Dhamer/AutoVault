import 'package:flutter/material.dart';
import '../models/car.dart';

class ComparePage extends StatelessWidget {
  final Car car1;
  final Car car2;

  const ComparePage({super.key, required this.car1, required this.car2});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Cars'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildCarCard(car1),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCarCard(car2),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildComparisonTable(car1, car2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            car.imagePath,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            car.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            car.brand,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < car.rating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
              const SizedBox(width: 4),
              Text('${car.rating}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(Car car1, Car car2) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparison',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSpecComparison('Price', '\$${car1.price.toStringAsFixed(0)}', '\$${car2.price.toStringAsFixed(0)}'),
          _buildSpecComparison('Year', '${car1.year}', '${car2.year}'),
          _buildSpecComparison('Engine', car1.engine, car2.engine),
          _buildSpecComparison('Horsepower', '${car1.horsepower} HP', '${car2.horsepower} HP'),
          _buildSpecComparison('Fuel Type', car1.fuelType, car2.fuelType),
          _buildSpecComparison('Rating', '${car1.rating}', '${car2.rating}'),
        ],
      ),
    );
  }

  Widget _buildSpecComparison(String label, String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value1, textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text(value2, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}