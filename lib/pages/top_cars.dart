import 'package:flutter/material.dart';
import '../data/cars_data.dart';
import '../models/car.dart';

class TopCarsPage extends StatelessWidget {
  const TopCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sort cars by rating descending
    List<Car> topCars = List.from(cars)..sort((a, b) => b.rating.compareTo(a.rating));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Cars'),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topCars.length,
          itemBuilder: (context, index) {
            Car car = topCars[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    car.imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                      );
                    },
                  ),
                ),
                title: Text(
                  car.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${car.brand} - \$${car.price.toStringAsFixed(0)}'),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(
                            i < car.rating.floor() ? Icons.star : Icons.star_border,
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
                onTap: () {
                  Navigator.pushNamed(context, '/details', arguments: car);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}