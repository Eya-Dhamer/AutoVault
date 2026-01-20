import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cars_data.dart';
import '../models/car.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  String selectedBrand = 'All';
  TextEditingController searchController = TextEditingController();
  List<Car> filteredCars = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String sortBy = 'Name';
  Set<String> favoriteCarNames = {};
  double minPrice = 0;
  double maxPrice = 10000000; // High number for max

  @override
  void initState() {
    super.initState();
    filteredCars = cars;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    _loadFavorites();
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteCarNames = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  Future<void> _toggleFavorite(String carName) async {
    print('Toggling favorite for: $carName');
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteCarNames.contains(carName)) {
        favoriteCarNames.remove(carName);
        print('Removed $carName from favorites');
      } else {
        favoriteCarNames.add(carName);
        print('Added $carName to favorites');
      }
    });
    await prefs.setStringList('favorites', favoriteCarNames.toList());
    print('Saved favorites: ${favoriteCarNames.toList()}');
  }

  void filterAndSortCars() {
    String query = searchController.text.trim().toLowerCase();
    setState(() {
      filteredCars = cars.where((car) {
        bool matchesBrand = selectedBrand == 'All' || car.brand == selectedBrand;
        bool matchesSearch = car.name.toLowerCase().contains(query) ||
                             car.brand.toLowerCase().contains(query);
        bool matchesPrice = car.price >= minPrice && car.price <= maxPrice;
        return matchesBrand && matchesSearch && matchesPrice;
      }).toList();

      filteredCars.sort((a, b) {
        switch (sortBy) {
          case 'Price':
            return a.price.compareTo(b.price);
          case 'Year':
            return b.year.compareTo(a.year);
          case 'Rating':
            return b.rating.compareTo(a.rating);
          default:
            return a.name.compareTo(b.name);
        }
      });
    });
  }

  List<String> getBrands() {
    Set<String> brands = {'All'};
    brands.addAll(cars.map((car) => car.brand));
    return brands.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dream Car Finder'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Favorites'),
                      content: Text('${favoriteCarNames.length} cars favorited'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              favoriteCarNames.isNotEmpty
                  ? Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${favoriteCarNames.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Find Your",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Dream Car There!",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          'images/car.png',
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: searchController,
                onChanged: (value) => filterAndSortCars(),
                decoration: InputDecoration(
                  hintText: 'Search your dream car',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Sort by: ', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: sortBy,
                    items: ['Name', 'Price', 'Year', 'Rating'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sortBy = value!;
                        filterAndSortCars();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Price Range:', style: TextStyle(fontSize: 16)),
              RangeSlider(
                values: RangeValues(minPrice, maxPrice),
                min: 0,
                max: 10000000,
                divisions: 100,
                labels: RangeLabels('\$${minPrice.toInt()}', '\$${maxPrice.toInt()}'),
                onChanged: (RangeValues values) {
                  setState(() {
                    minPrice = values.start;
                    maxPrice = values.end;
                    filterAndSortCars();
                  });
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: getBrands().length,
                  itemBuilder: (context, index) {
                    String brand = getBrands()[index];
                    bool isSelected = selectedBrand == brand;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBrand = brand;
                          filterAndSortCars();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Center(
                          child: Text(
                            brand,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredCars.isEmpty
                    ? const Center(
                        child: Text(
                          'No cars found. Try adjusting your search or filters.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: ListView.builder(
                          key: const PageStorageKey('carsList'),
                          itemCount: filteredCars.length,
                          itemBuilder: (context, index) {
                            Car car = filteredCars[index];
                            bool isFavorite = favoriteCarNames.contains(car.name);
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/details', arguments: car);
                                  },
                                  child: Hero(
                                    tag: car.name,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        car.imagePath,
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        car.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () => _toggleFavorite(car.name),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  car.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${car.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    ...List.generate(5, (index) {
                                      return Icon(
                                        index < car.rating.floor() ? Icons.star : Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    }),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${car.rating}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.share, color: Colors.blue),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Share feature coming soon!')),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.info, color: Colors.green),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(car.name),
                                            content: Text(car.description),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}