import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'login_screen.dart';
import 'restaurant_details_screen.dart';
import 'order_tracking_screen.dart';
import 'profile_screen.dart';

// --- DATA MODELS ---
class FoodCategory {
  final String id;
  final String name;
  final IconData icon;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class OfferBanner {
  final String id;
  final String title;
  final String subtitle;
  final String discountText;
  final String imageUrl;
  final List<Color> gradientColors;

  const OfferBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.discountText,
    required this.imageUrl,
    required this.gradientColors,
  });
}

class Restaurant {
  final String id;
  final String name;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final String distance;
  final String category;
  final String imageUrl;
  final String offers;
  final bool isFreeDelivery;

  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.distance,
    required this.category,
    required this.imageUrl,
    required this.offers,
    required this.isFreeDelivery,
  });
}

class PopularDish {
  final String id;
  final String name;
  final String restaurantName;
  final double price;
  final double rating;
  final String calories;
  final String category;
  final String imageUrl;

  const PopularDish({
    required this.id,
    required this.name,
    required this.restaurantName,
    required this.price,
    required this.rating,
    required this.calories,
    required this.category,
    required this.imageUrl,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation State
  int _currentIndex = 0;

  // App States
  String _currentAddress = "Anna Nagar, Chennai";
  String _selectedCategory = "All";
  final Set<String> _favoriteRestaurantIds = {"r1", "r3"};
  final Map<String, int> _cartItems = {}; // Map of dishId -> quantity
  final List<String> _notifications = [
    "Your order from Pizza Romano is on the way!",
    "Get 20% discount on healthy meals using code HEALTH20",
    "Sushi Zen has a special Buy 1 Get 1 free offer today."
  ];

  // Carousel Controller
  final PageController _bannerController = PageController();

  // Search Filter State
  String _activeSort = "Popularity";
  bool _filterVeg = false;
  bool _filterFreeDelivery = false;
  String _searchQuery = "";

  // Promo and Checkout State
  final TextEditingController _promoTextController = TextEditingController();
  String _appliedPromoCode = '';
  String _promoErrorMessage = '';

  // Mock Data
  final List<FoodCategory> _categories = const [
    FoodCategory(id: "all", name: "All", icon: Icons.restaurant_rounded),
    FoodCategory(id: "pizza", name: "Pizza", icon: Icons.local_pizza_rounded),
    FoodCategory(id: "burger", name: "Burger", icon: Icons.lunch_dining_rounded),
    FoodCategory(id: "sushi", name: "Sushi", icon: Icons.rice_bowl_rounded),
    FoodCategory(id: "desserts", name: "Desserts", icon: Icons.cake_rounded),
    FoodCategory(id: "beverages", name: "Beverages", icon: Icons.local_drink_rounded),
    FoodCategory(id: "salads", name: "Salads", icon: Icons.eco_rounded),
  ];

  final List<OfferBanner> _banners = const [
    OfferBanner(
      id: "b1",
      title: "Pepperoni Pizza Special",
      subtitle: "On your first Italian order",
      discountText: "50% OFF",
      imageUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&q=80&w=600",
      gradientColors: [Color(0xFFFF5722), Color(0xFFFF9800)],
    ),
    OfferBanner(
      id: "b2",
      title: "Chef's Salmon Combo",
      subtitle: "Get fresh Japanese rolls",
      discountText: "FREE DELIVERY",
      imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&q=80&w=600",
      gradientColors: [Color(0xFF673AB7), Color(0xFFE91E63)],
    ),
    OfferBanner(
      id: "b3",
      title: "Crunchy Veggie Salads",
      subtitle: "Fresh greens and organic diet",
      discountText: "25% OFF",
      imageUrl: "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&q=80&w=600",
      gradientColors: [Color(0xFF4CAF50), Color(0xFF009688)],
    ),
  ];

  final List<Restaurant> _restaurants = const [
    Restaurant(
      id: "r1",
      name: "Pizza Romano",
      rating: 4.8,
      reviewsCount: 128,
      deliveryTime: "15-20 min",
      distance: "1.2 km",
      category: "Pizza",
      imageUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&q=80&w=600",
      offers: "Free Delivery",
      isFreeDelivery: true,
    ),
    Restaurant(
      id: "r2",
      name: "Burger House",
      rating: 4.6,
      reviewsCount: 84,
      deliveryTime: "20-25 min",
      distance: "2.5 km",
      category: "Burger",
      imageUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=600",
      offers: "10% OFF",
      isFreeDelivery: false,
    ),
    Restaurant(
      id: "r3",
      name: "Sushi Zen",
      rating: 4.9,
      reviewsCount: 215,
      deliveryTime: "25-30 min",
      distance: "3.1 km",
      category: "Sushi",
      imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&q=80&w=600",
      offers: "Buy 1 Get 1",
      isFreeDelivery: true,
    ),
    Restaurant(
      id: "r4",
      name: "Sweet Treats Bakery",
      rating: 4.7,
      reviewsCount: 96,
      deliveryTime: "10-15 min",
      distance: "0.8 km",
      category: "Desserts",
      imageUrl: "https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&q=80&w=600",
      offers: "Free Muffin",
      isFreeDelivery: false,
    ),
  ];

  final List<PopularDish> _dishes = const [
    PopularDish(
      id: "d1",
      name: "Pepperoni Passion",
      restaurantName: "Pizza Romano",
      price: 249.0,
      rating: 4.8,
      calories: "320 kcal",
      category: "Pizza",
      imageUrl: "https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&q=80&w=400",
    ),
    PopularDish(
      id: "d2",
      name: "Cheesy Double Stack",
      restaurantName: "Burger House",
      price: 179.0,
      rating: 4.7,
      calories: "550 kcal",
      category: "Burger",
      imageUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=400",
    ),
    PopularDish(
      id: "d3",
      name: "Salmon Nigiri Plate",
      restaurantName: "Sushi Zen",
      price: 399.0,
      rating: 4.9,
      calories: "280 kcal",
      category: "Sushi",
      imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&q=80&w=400",
    ),
    PopularDish(
      id: "d4",
      name: "Chocolate Lava Cake",
      restaurantName: "Sweet Treats Bakery",
      price: 129.0,
      rating: 4.9,
      calories: "420 kcal",
      category: "Desserts",
      imageUrl: "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&q=80&w=400",
    ),
    PopularDish(
      id: "d5",
      name: "Avocado Power Salad",
      restaurantName: "Green Eat Cafe",
      price: 199.0,
      rating: 4.5,
      calories: "180 kcal",
      category: "Salads",
      imageUrl: "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&q=80&w=400",
    ),
    PopularDish(
      id: "d6",
      name: "Berry Blast Smoothie",
      restaurantName: "Sweet Treats Bakery",
      price: 99.0,
      rating: 4.6,
      calories: "150 kcal",
      category: "Beverages",
      imageUrl: "https://images.unsplash.com/photo-1553530979-7ee52a2670c4?auto=format&fit=crop&q=80&w=400",
    ),
  ];

  // Helper getters
  int get _totalCartCount {
    return _cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get _cartTotalAmount {
    double total = 0.0;
    _cartItems.forEach((dishId, qty) {
      final dish = _dishes.firstWhere((d) => d.id == dishId);
      total += (dish.price * qty);
    });
    return total;
  }

  double get _promoDiscountAmount {
    if (_appliedPromoCode == 'HEALTH20') {
      return _cartTotalAmount * 0.20;
    } else if (_appliedPromoCode == 'CRAVE50') {
      final discount = _cartTotalAmount * 0.50;
      return discount > 800.0 ? 800.0 : discount;
    } else if (_appliedPromoCode == 'FREESHIP') {
      return 49.0; // Value of free delivery
    }
    return 0.0;
  }

  // --- WIDGET CYCLES ---
  @override
  void dispose() {
    _bannerController.dispose();
    _promoTextController.dispose();
    super.dispose();
  }

  // --- ACTIONS ---
  void _addToCart(PopularDish dish) {
    setState(() {
      _cartItems[dish.id] = (_cartItems[dish.id] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            const SizedBox(width: 8),
            Text('${dish.name} added to cart!'),
          ],
        ),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _currentIndex = 2; // Navigate to Cart view
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _toggleFavorite(String restaurantId) {
    setState(() {
      if (_favoriteRestaurantIds.contains(restaurantId)) {
        _favoriteRestaurantIds.remove(restaurantId);
      } else {
        _favoriteRestaurantIds.add(restaurantId);
      }
    });
  }

  void _navigateToRestaurantDetails(BuildContext context, Restaurant restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RestaurantDetailsScreen(
          restaurant: restaurant,
          initialCart: _cartItems,
          favoriteRestaurantIds: _favoriteRestaurantIds,
          onCartChanged: (dish, quantity) {
            setState(() {
              if (quantity <= 0) {
                _cartItems.remove(dish.id);
              } else {
                _cartItems[dish.id] = quantity;
              }
            });
          },
          onToggleFavorite: _toggleFavorite,
        ),
      ),
    ).then((result) {
      if (result == 'go_to_cart') {
        setState(() {
          _currentIndex = 2; // Index of CartView in bottom navigation
        });
      }
    });
  }

  void _showLocationSelector() {
    final List<String> locations = [
      "Anna Nagar, Chennai",
      "T. Nagar, Chennai",
      "Koramangala, Bengaluru",
      "Bandra West, Mumbai",
      "Connaught Place, Delhi"
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Location',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              ...locations.map((loc) {
                final isSelected = _currentAddress == loc;
                return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                  ),
                  title: Text(
                    loc,
                    style: GoogleFonts.poppins(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _currentAddress = loc;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationPanel() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _notifications.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const Divider(),
              if (_notifications.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none_rounded, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications yet!',
                        style: GoogleFonts.poppins(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              else
                ..._notifications.map(
                  (note) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.local_offer_outlined, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(
                      note,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Options',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Sort section
                  Text(
                    'Sort By',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: ["Popularity", "Rating", "Delivery Time", "Cost: Low to High"].map((sort) {
                      final isSel = _activeSort == sort;
                      return ChoiceChip(
                        label: Text(sort),
                        selected: isSel,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => _activeSort = sort);
                            setState(() => _activeSort = sort);
                          }
                        },
                        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                        labelStyle: GoogleFonts.poppins(
                          color: isSel ? Theme.of(context).colorScheme.primary : Colors.black87,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Dietary section
                  Text(
                    'Dietary & Services',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: Text('Veg Only', style: GoogleFonts.poppins()),
                    value: _filterVeg,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) {
                      setModalState(() => _filterVeg = val);
                      setState(() => _filterVeg = val);
                    },
                  ),
                  SwitchListTile(
                    title: Text('Free Delivery', style: GoogleFonts.poppins()),
                    value: _filterFreeDelivery,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) {
                      setModalState(() => _filterFreeDelivery = val);
                      setState(() => _filterFreeDelivery = val);
                    },
                  ),
                  const SizedBox(height: 32),

                  // Apply button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Filters applied successfully!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- VIEWS ---

  // 1. Home View
  Widget _buildHomeView() {
    // Filter dishes based on category
    final List<PopularDish> filteredDishes = _selectedCategory == "All"
        ? _dishes
        : _dishes.where((dish) => dish.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GREETING & LOCATION SECTION
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            key: const Key('greeting_section'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            "DELIVER TO",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: _showLocationSelector,
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                _currentAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Accessories (Notifications & Profile Avatar)
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: _showNotificationPanel,
                          icon: const Icon(Icons.notifications_outlined, size: 28, color: Colors.black87),
                        ),
                        if (_notifications.isNotEmpty)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 3; // Switch to Profile View
                        });
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: const DecorationImage(
                            image: NetworkImage("https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // User Greeting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, Sarah! 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Find your favorite meal",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),

          // SEARCH BAR WITH FILTERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            key: const Key('search_bar'),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      onTap: () {
                        setState(() {
                          _currentIndex = 1; // Direct user to Search view
                        });
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Search dishes, restaurants...",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: _showFilterSheet,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // OFFER BANNERS CAROUSEL
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _banners.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: banner.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: banner.gradientColors[0].withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        // Background Food Photo opacity overlay
                        Positioned(
                          right: -30,
                          top: -20,
                          bottom: -20,
                          width: 200,
                          child: Opacity(
                            opacity: 0.35,
                            child: Image.network(
                              banner.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Content overlay
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  banner.discountText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                banner.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                banner.subtitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Banner Indicators
          Center(
            child: SmoothPageIndicator(
              controller: _bannerController,
              count: _banners.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Theme.of(context).colorScheme.primary,
                dotColor: Colors.grey.shade300,
                dotHeight: 6,
                dotWidth: 6,
                spacing: 6,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // FOOD CATEGORIES WITH ICONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 95,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 24, right: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat.name;
                return Padding(
                  padding: const EdgeInsets.only(right: 12, bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat.name;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 75,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                                : Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              cat.icon,
                              color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.name,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // TRENDING RESTAURANTS CAROUSEL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trending Restaurants",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1; // Route to search/explore page
                    });
                  },
                  child: Text(
                    "See All",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 24, right: 12),
              itemCount: _restaurants.length,
              itemBuilder: (context, index) {
                final res = _restaurants[index];
                final isFav = _favoriteRestaurantIds.contains(res.id);
                return GestureDetector(
                  onTap: () => _navigateToRestaurantDetails(context, res),
                  child: Builder(
                    builder: (ctx) {
                      final cardWidth = MediaQuery.of(ctx).size.width * 0.65;
                      return Container(
                    width: cardWidth,
                    margin: const EdgeInsets.only(right: 16, bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Restaurant Photo
                        Stack(
                          children: [
                            Image.network(
                              res.imageUrl,
                              height: 148,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            // Heart Icon (Favorite)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: InkWell(
                                onTap: () => _toggleFavorite(res.id),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            // Offer Badge
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  res.offers,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Details
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      res.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                      const SizedBox(width: 2),
                                      Text(
                                        res.rating.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                                  const SizedBox(width: 4),
                                  Text(
                                    res.deliveryTime,
                                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("•", style: TextStyle(color: Colors.grey.shade400)),
                                  const SizedBox(width: 8),
                                  Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                                  const SizedBox(width: 4),
                                  Text(
                                    res.distance,
                                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // POPULAR DISHES SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Dishes",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "$_selectedCategory Items",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),

          if (filteredDishes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Icon(Icons.no_meals_rounded, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text(
                      "No dishes found in $_selectedCategory",
                      style: GoogleFonts.poppins(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDishes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final dish = filteredDishes[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dish Photo
                        Expanded(
                          child: Stack(
                            children: [
                              Image.network(
                                dish.imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              // Rating Badge
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                        dish.rating.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Details
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dish.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                dish.restaurantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dish.calories,
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "₹${dish.price.toStringAsFixed(0)}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  // Add button
                                  InkWell(
                                    onTap: () => _addToCart(dish),
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // 2. Search View
  Widget _buildSearchView() {
    final searchInput = _searchQuery.toLowerCase();
    
    // Filters application
    var filtered = _restaurants.where((res) {
      final matchesSearch = res.name.toLowerCase().contains(searchInput) ||
          res.category.toLowerCase().contains(searchInput);
      final matchesFreeDel = !_filterFreeDelivery || res.isFreeDelivery;
      return matchesSearch && matchesFreeDel;
    }).toList();

    // Sort sorting
    if (_activeSort == "Rating") {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_activeSort == "Delivery Time") {
      filtered.sort((a, b) => a.deliveryTime.compareTo(b.deliveryTime));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Restaurants',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Interactive Input
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              autofocus: false,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Type name, food type...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Chips
          Row(
            children: [
              FilterChip(
                label: const Text('Free Delivery'),
                selected: _filterFreeDelivery,
                onSelected: (val) {
                  setState(() {
                    _filterFreeDelivery = val;
                  });
                },
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                checkmarkColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              ActionChip(
                avatar: const Icon(Icons.tune, size: 16),
                label: Text('Filters ($_activeSort)'),
                onPressed: _showFilterSheet,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No restaurants matched your search.',
                          style: GoogleFonts.poppins(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final res = filtered[idx];
                      final isFav = _favoriteRestaurantIds.contains(res.id);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () => _navigateToRestaurantDetails(context, res),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(res.imageUrl, height: 130, width: double.infinity, fit: BoxFit.cover),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(res.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text('${res.category} • ${res.deliveryTime} • ${res.distance}', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
                                          onPressed: () => _toggleFavorite(res.id),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 16),
                                              const SizedBox(width: 4),
                                              Text(res.rating.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 3. Cart View
  Widget _buildCartView() {
    if (_cartItems.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Beautiful animated-looking glassmorphic bag icon
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 96,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Your Cart is Empty',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Add items from your favorite restaurants and start enjoying delicious food delivered to your doorstep.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 0; // Go Home
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                ),
                child: Text(
                  'Explore Restaurants',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final double subtotal = _cartTotalAmount;
    const double deliveryFee = 49.0;
    const double serviceTax = 25.0;
    final double discount = _promoDiscountAmount;
    final double total = (subtotal + deliveryFee + serviceTax - discount).clamp(0.0, double.infinity);

    return Column(
      children: [
        // Custom App Bar / Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Your Cart',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_totalCartCount',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  // Show clear cart confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        'Clear Cart?',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'Are you sure you want to remove all items from your cart?',
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(color: Colors.grey.shade600),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _cartItems.clear();
                              _appliedPromoCode = '';
                              _promoTextController.clear();
                              _promoErrorMessage = '';
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                label: Text(
                  'Clear All',
                  style: GoogleFonts.poppins(
                    color: Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // List of items
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              ..._cartItems.keys.map((dishId) {
                final dish = _dishes.firstWhere((d) => d.id == dishId);
                final quantity = _cartItems[dishId]!;

                return Dismissible(
                  key: Key('cart_item_$dishId'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _cartItems.remove(dishId);
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${dish.name} removed from cart'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        action: SnackBarAction(
                          label: 'UNDO',
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              _cartItems[dishId] = quantity;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_sweep_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Dish Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Image.network(
                                dish.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    dish.category,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Item Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dish.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dish.restaurantName,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${(dish.price * quantity).toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Custom Quantity Selector Capsule
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (quantity > 1) {
                                        _cartItems[dishId] = quantity - 1;
                                      } else {
                                        _cartItems.remove(dishId);
                                      }
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return ScaleTransition(scale: animation, child: child);
                                  },
                                  child: Text(
                                    quantity.toString(),
                                    key: ValueKey<int>(quantity),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _cartItems[dishId] = quantity + 1;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Promo Code Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey.shade100,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Promo Code',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoTextController,
                            decoration: InputDecoration(
                              hintText: 'Enter coupon code',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            final code = _promoTextController.text.trim().toUpperCase();
                            if (code.isEmpty) return;

                            setState(() {
                              if (code == 'HEALTH20' || code == 'CRAVE50' || code == 'FREESHIP') {
                                _appliedPromoCode = code;
                                _promoErrorMessage = '';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Promo code "$code" applied!'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              } else {
                                _promoErrorMessage = 'Invalid promo code';
                                _appliedPromoCode = '';
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            elevation: 0,
                          ),
                          child: Text(
                            'Apply',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_promoErrorMessage.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          _promoErrorMessage,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    if (_appliedPromoCode.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Applied: $_appliedPromoCode',
                                  style: GoogleFonts.poppins(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _appliedPromoCode = '';
                                  _promoTextController.clear();
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                color: Colors.green.shade700,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    // Quick Promo Chips
                    Text(
                      'Available Coupons (Tap to Apply):',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        ActionChip(
                          label: Text(
                            'HEALTH20 (20% OFF)',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: _appliedPromoCode == 'HEALTH20' ? FontWeight.bold : FontWeight.normal,
                              color: _appliedPromoCode == 'HEALTH20' ? Colors.green.shade700 : Colors.black87,
                            ),
                          ),
                          backgroundColor: _appliedPromoCode == 'HEALTH20' ? Colors.green.shade50 : Colors.grey.shade100,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              _appliedPromoCode = 'HEALTH20';
                              _promoTextController.text = 'HEALTH20';
                              _promoErrorMessage = '';
                            });
                          },
                        ),
                        ActionChip(
                          label: Text(
                            'CRAVE50 (50% OFF)',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: _appliedPromoCode == 'CRAVE50' ? FontWeight.bold : FontWeight.normal,
                              color: _appliedPromoCode == 'CRAVE50' ? Colors.green.shade700 : Colors.black87,
                            ),
                          ),
                          backgroundColor: _appliedPromoCode == 'CRAVE50' ? Colors.green.shade50 : Colors.grey.shade100,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              _appliedPromoCode = 'CRAVE50';
                              _promoTextController.text = 'CRAVE50';
                              _promoErrorMessage = '';
                            });
                          },
                        ),
                        ActionChip(
                          label: Text(
                            'FREESHIP (Free Delivery)',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: _appliedPromoCode == 'FREESHIP' ? FontWeight.bold : FontWeight.normal,
                              color: _appliedPromoCode == 'FREESHIP' ? Colors.green.shade700 : Colors.black87,
                            ),
                          ),
                          backgroundColor: _appliedPromoCode == 'FREESHIP' ? Colors.green.shade50 : Colors.grey.shade100,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              _appliedPromoCode = 'FREESHIP';
                              _promoTextController.text = 'FREESHIP';
                              _promoErrorMessage = '';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Price Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bill Details',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Items Subtotal',
                          style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        Text(
                          '₹${subtotal.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Fee',
                          style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        Text(
                          '₹${deliveryFee.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'GST & Restaurant Charges',
                          style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        Text(
                          '₹${serviceTax.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 13),
                        ),
                      ],
                    ),
                    if (discount > 0) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Promo Discount',
                                style: GoogleFonts.poppins(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _appliedPromoCode,
                                  style: GoogleFonts.poppins(color: Colors.green.shade700, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '-₹${discount.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(height: 1, thickness: 1, color: Colors.black12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Pay',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                        ),
                        Text(
                          '₹${total.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),

        // Checkout Button Section at the bottom
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: AnimatedCheckoutButton(
              totalAmount: total,
              onCheckoutSuccess: () {
                // Show a beautiful full checkout success page or overlay!
                _showCheckoutSuccessDialog(total);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showCheckoutSuccessDialog(double totalAmount) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink(); // not used, handled in transitionBuilder
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeInOutBack);
        return ScaleTransition(
          scale: curve,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top animation header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      // Pulsing/scaling green circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green.shade100, width: 2),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 56,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Order Placed!',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Preparing your food...',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Details Section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Mode', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                          Text('Cash on Delivery', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Paid', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                          Text('₹${totalAmount.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Est. Delivery Time', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                          Text('25 - 35 mins', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 24),
                      
                      // Track Order CTA
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final restaurantName = _cartItems.isNotEmpty
                                ? (_dishes.firstWhere(
                                    (d) => _cartItems.containsKey(d.id),
                                    orElse: () => _dishes.first,
                                  ).restaurantName)
                                : 'Your Restaurant';
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderTrackingScreen(
                                  restaurantName: restaurantName,
                                  totalAmount: totalAmount,
                                  estimatedMinutes: 30,
                                ),
                              ),
                            );
                            setState(() {
                              _cartItems.clear();
                              _appliedPromoCode = '';
                              _promoTextController.clear();
                              _promoErrorMessage = '';
                              _currentIndex = 0;
                            });
                          },
                          icon: const Icon(Icons.delivery_dining_rounded),
                          label: Text(
                            'Track Your Order',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _cartItems.clear();
                              _appliedPromoCode = '';
                              _promoTextController.clear();
                              _promoErrorMessage = '';
                              _currentIndex = 0;
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Back to Home', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 4. Profile View — delegates to full-screen ProfileScreen
  Widget _buildProfileView() {
    return const ProfileScreen();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which view to render based on navigation index
    Widget bodyWidget;
    switch (_currentIndex) {
      case 0:
        bodyWidget = _buildHomeView();
        break;
      case 1:
        bodyWidget = _buildSearchView();
        break;
      case 2:
        bodyWidget = _buildCartView();
        break;
      case 3:
        bodyWidget = _buildProfileView();
        break;
      default:
        bodyWidget = _buildHomeView();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: bodyWidget,
      ),
      
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.normal),
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  if (_totalCartCount > 0)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            _totalCartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag),
                  if (_totalCartCount > 0)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            _totalCartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCheckoutButton extends StatefulWidget {
  final double totalAmount;
  final VoidCallback onCheckoutSuccess;

  const AnimatedCheckoutButton({
    super.key,
    required this.totalAmount,
    required this.onCheckoutSuccess,
  });

  @override
  State<AnimatedCheckoutButton> createState() => _AnimatedCheckoutButtonState();
}

enum ButtonState { idle, loading, success }

class _AnimatedCheckoutButtonState extends State<AnimatedCheckoutButton> with SingleTickerProviderStateMixin {
  ButtonState _state = ButtonState.idle;
  
  void _startCheckout() async {
    if (_state != ButtonState.idle) return;
    
    setState(() {
      _state = ButtonState.loading;
    });
    
    // Wait for the loading animation (simulate payment processing)
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    setState(() {
      _state = ButtonState.success;
    });
    
    // Wait for success checkmark animation to be visible
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (!mounted) return;
    widget.onCheckoutSuccess();
    
    // Reset state after redirection/dialog
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _state = ButtonState.idle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isIdle = _state == ButtonState.idle;
    final isLoading = _state == ButtonState.loading;
    final isSuccess = _state == ButtonState.success;
    
    // Calculate layout width dynamically
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = isIdle ? (screenWidth - 48) : 56.0; // Shrink to circle when loading or success

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: buttonWidth,
        height: 56.0,
        child: Material(
          elevation: isIdle ? 4.0 : 0.0,
          shadowColor: primaryColor.withOpacity(0.4),
          color: isSuccess ? Colors.green : primaryColor,
          borderRadius: BorderRadius.circular(isIdle ? 16.0 : 28.0),
          child: InkWell(
            onTap: _startCheckout,
            borderRadius: BorderRadius.circular(isIdle ? 16.0 : 28.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildButtonContent(isIdle, isLoading, isSuccess),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(bool isIdle, bool isLoading, bool isSuccess) {
    if (isIdle) {
      return Row(
        key: const ValueKey('idle'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Text(
            'Checkout ₹${widget.totalAmount.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 20,
          ),
        ],
      );
    } else if (isLoading) {
      return const SizedBox(
        key: ValueKey('loading'),
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3.0,
        ),
      );
    } else {
      return TweenAnimationBuilder<double>(
        key: const ValueKey('success'),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 32,
            ),
          );
        },
      );
    }
  }
}

