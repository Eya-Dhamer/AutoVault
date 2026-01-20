import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car.dart';
import '../data/cars_data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Car> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteNames = prefs.getStringList('favorites');
    print('Loaded favorites from prefs: $favoriteNames');
    if (favoriteNames != null) {
      setState(() {
        favorites = cars.where((car) => favoriteNames.contains(car.name)).toList();
        print('Filtered favorites: ${favorites.map((c) => c.name).toList()}');
      });
    }
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteNames = favorites.map((car) => car.name).toList();
    await prefs.setStringList('favorites', favoriteNames);
  }

  void _toggleFavorite(Car car) {
    setState(() {
      if (favorites.contains(car)) {
        favorites.remove(car);
      } else {
        favorites.add(car);
      }
      _saveFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: _loadFavorites,
        child: favorites.isEmpty
            ? const Center(child: Text('No favorites yet! Pull down to refresh.'))
            : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  Car car = favorites[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.asset(
                        car.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                          );
                        },
                      ),
                      title: Text(car.name),
                      subtitle: Text('\$${car.price.toStringAsFixed(0)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _toggleFavorite(car),
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