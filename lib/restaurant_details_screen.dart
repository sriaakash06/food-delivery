import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart'; // Import Restaurant and PopularDish models

class FadeInSlide extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const FadeInSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: FractionalTranslation(
            translation: _slide.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  final Map<String, int> initialCart;
  final Set<String> favoriteRestaurantIds;
  final Function(PopularDish, int) onCartChanged;
  final Function(String) onToggleFavorite;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
    required this.initialCart,
    required this.favoriteRestaurantIds,
    required this.onCartChanged,
    required this.onToggleFavorite,
  });

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> with SingleTickerProviderStateMixin {
  late Map<String, int> _localCart;
  late bool _isFavorite;
  int _activeTab = 0; // 0 = Menu, 1 = Reviews
  String _selectedCategory = "All";

  // Menu Category Filter Options
  final List<String> _menuCategories = ["All", "Main Course", "Sides", "Beverages", "Desserts"];

  @override
  void initState() {
    super.initState();
    _localCart = Map<String, int>.from(widget.initialCart);
    _isFavorite = widget.favoriteRestaurantIds.contains(widget.restaurant.id);
  }

  // Retrieve full menu of dishes matching the restaurant
  List<PopularDish> _getRestaurantMenu() {
    final allMenuDishes = [
      // Pizza Romano
      const PopularDish(
        id: "d1",
        name: "Pepperoni Passion",
        restaurantName: "Pizza Romano",
        price: 249.0,
        rating: 4.8,
        calories: "320 kcal",
        category: "Main Course",
        imageUrl: "https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d7",
        name: "Margherita Supreme",
        restaurantName: "Pizza Romano",
        price: 199.0,
        rating: 4.7,
        calories: "280 kcal",
        category: "Main Course",
        imageUrl: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d8",
        name: "BBQ Chicken Feast",
        restaurantName: "Pizza Romano",
        price: 279.0,
        rating: 4.9,
        calories: "380 kcal",
        category: "Main Course",
        imageUrl: "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d9",
        name: "Garlic Bread Sticks",
        restaurantName: "Pizza Romano",
        price: 99.0,
        rating: 4.6,
        calories: "190 kcal",
        category: "Sides",
        imageUrl: "https://images.unsplash.com/photo-1544982503-9f984c14501a?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d10",
        name: "Italian Tiramisu",
        restaurantName: "Pizza Romano",
        price: 139.0,
        rating: 4.9,
        calories: "250 kcal",
        category: "Desserts",
        imageUrl: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?auto=format&fit=crop&q=80&w=400",
      ),

      // Burger House
      const PopularDish(
        id: "d2",
        name: "Cheesy Double Stack",
        restaurantName: "Burger House",
        price: 179.0,
        rating: 4.7,
        calories: "550 kcal",
        category: "Main Course",
        imageUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d11",
        name: "Spicy Jalapeno Burger",
        restaurantName: "Burger House",
        price: 199.0,
        rating: 4.6,
        calories: "580 kcal",
        category: "Main Course",
        imageUrl: "https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d12",
        name: "Crispy Onion Rings",
        restaurantName: "Burger House",
        price: 79.0,
        rating: 4.5,
        calories: "210 kcal",
        category: "Sides",
        imageUrl: "https://images.unsplash.com/photo-1623653387945-2fd25214f8fc?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d13",
        name: "Classic Vanilla Shake",
        restaurantName: "Burger House",
        price: 89.0,
        rating: 4.8,
        calories: "300 kcal",
        category: "Beverages",
        imageUrl: "https://images.unsplash.com/photo-1579954115545-a95591f28bfc?auto=format&fit=crop&q=80&w=400",
      ),

      // Sushi Zen
      const PopularDish(
        id: "d3",
        name: "Salmon Nigiri Plate",
        restaurantName: "Sushi Zen",
        price: 399.0,
        rating: 4.9,
        calories: "280 kcal",
        category: "Main Course",
        imageUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d14",
        name: "Dragon Roll Special",
        restaurantName: "Sushi Zen",
        price: 329.0,
        rating: 4.8,
        calories: "340 kcal",
        category: "Main Course",
        imageUrl: "https://images.unsplash.com/photo-1611143669185-af224c5e3252?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d15",
        name: "Steamed Edamame Bowl",
        restaurantName: "Sushi Zen",
        price: 89.0,
        rating: 4.7,
        calories: "90 kcal",
        category: "Sides",
        imageUrl: "https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d16",
        name: "Premium Matcha Ice Cream",
        restaurantName: "Sushi Zen",
        price: 109.0,
        rating: 4.8,
        calories: "160 kcal",
        category: "Desserts",
        imageUrl: "https://images.unsplash.com/photo-1505394033343-e94c7c2764b0?auto=format&fit=crop&q=80&w=400",
      ),

      // Sweet Treats Bakery
      const PopularDish(
        id: "d4",
        name: "Chocolate Lava Cake",
        restaurantName: "Sweet Treats Bakery",
        price: 129.0,
        rating: 4.9,
        calories: "420 kcal",
        category: "Desserts",
        imageUrl: "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d6",
        name: "Berry Blast Smoothie",
        restaurantName: "Sweet Treats Bakery",
        price: 99.0,
        rating: 4.6,
        calories: "150 kcal",
        category: "Beverages",
        imageUrl: "https://images.unsplash.com/photo-1553530979-7ee52a2670c4?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d17",
        name: "Red Velvet Cupcake",
        restaurantName: "Sweet Treats Bakery",
        price: 69.0,
        rating: 4.8,
        calories: "210 kcal",
        category: "Desserts",
        imageUrl: "https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&q=80&w=400",
      ),
      const PopularDish(
        id: "d18",
        name: "Glazed Donuts Duo",
        restaurantName: "Sweet Treats Bakery",
        price: 109.0,
        rating: 4.7,
        calories: "350 kcal",
        category: "Desserts",
        imageUrl: "https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&q=80&w=400",
      ),
    ];

    // Filter by restaurant name
    final filteredByRestaurant = allMenuDishes
        .where((dish) => dish.restaurantName.toLowerCase() == widget.restaurant.name.toLowerCase())
        .toList();

    // Filter by selected category
    if (_selectedCategory == "All") {
      return filteredByRestaurant;
    } else {
      return filteredByRestaurant
          .where((dish) => dish.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }
  }

  // Get description for food card details
  String _getDishDescription(String dishId) {
    switch (dishId) {
      case "d1": return "Loaded with spicy pepperoni, fresh mozzarella, and our signature slow-cooked marinara sauce.";
      case "d2": return "Two flame-grilled beef patties, double cheddar cheese, lettuce, tomato, and house burger sauce.";
      case "d3": return "Five pieces of fresh, hand-cut Atlantic salmon nigiri served with wasabi, pickled ginger, and soy sauce.";
      case "d4": return "Warm, rich chocolate cake with a molten lava center. Served with powdered sugar and fresh mint.";
      case "d6": return "A refreshing blend of fresh strawberries, blueberries, raspberries, greek yogurt, and honey.";
      case "d7": return "Classic Italian style pizza with fresh Roma tomatoes, buffalo mozzarella cheese, fresh basil leaves, and olive oil.";
      case "d8": return "Grilled chicken breast chunks, smoky BBQ sauce, red onions, cilantro, and smoked gouda cheese.";
      case "d9": return "Toasted garlic bread sticks brushed with butter and herbs, served with a side of marinara dip.";
      case "d10": return "Espresso-soaked ladyfingers layered with whipped mascarpone cream, flavored with cocoa powder.";
      case "d11": return "Spicy seasoned beef patty topped with grilled jalapenos, pepper jack cheese, and chipotle mayo.";
      case "d12": return "Crispy, deep-fried beer-battered onion rings seasoned with sea salt and black pepper.";
      case "d13": return "Creamy milk shake blended with premium Madagascar vanilla beans, topped with whipped cream.";
      case "d14": return "Eel and cucumber inside, topped with avocado slices, spicy mayo, eel sauce, and toasted sesame seeds.";
      case "d15": return "Freshly steamed edamame pods tossed in coarse sea salt and sesame oil. Perfect healthy appetizer.";
      case "d16": return "Smooth and creamy Japanese green tea ice cream made with premium ceremonial grade matcha.";
      case "d17": return "Classic soft red velvet cupcake topped with a smooth, sweet cream cheese frosting and sprinkles.";
      case "d18": return "Two fresh yeast-raised donuts dipped in a sweet sugar glaze. Perfect dessert option.";
      default: return "Made fresh with premium ingredients, prepared daily by our expert chefs to satisfy your cravings.";
    }
  }

  // Helper getters to calculate total cart size and sum of this restaurant
  int get _localCartCount {
    return _localCart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get _localCartTotalAmount {
    // Collect all unique dishes list
    final allDishes = _getRestaurantMenu();
    double total = 0.0;
    _localCart.forEach((dishId, qty) {
      try {
        final dish = allDishes.firstWhere((d) => d.id == dishId);
        total += (dish.price * qty);
      } catch (_) {
        // we fallback or search in home screen data. For mockup, use average price ₹200
        total += (200.0 * qty);
      }
    });
    return total;
  }

  // Modify cart item quantity
  void _updateQuantity(PopularDish dish, int delta) {
    final currentQty = _localCart[dish.id] ?? 0;
    final newQty = currentQty + delta;

    setState(() {
      if (newQty <= 0) {
        _localCart.remove(dish.id);
      } else {
        _localCart[dish.id] = newQty;
      }
    });

    // Notify parent widget
    widget.onCartChanged(dish, newQty <= 0 ? 0 : newQty);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final restaurant = widget.restaurant;
    final menuItems = _getRestaurantMenu();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: innerBoxIsScrolled ? Colors.white : Colors.transparent,
                  iconTheme: IconThemeData(
                    color: innerBoxIsScrolled ? Colors.black87 : Colors.white,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: innerBoxIsScrolled 
                          ? Colors.grey.shade100 
                          : Colors.black.withOpacity(0.4),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        color: innerBoxIsScrolled ? Colors.black87 : Colors.white,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: innerBoxIsScrolled 
                            ? Colors.grey.shade100 
                            : Colors.black.withOpacity(0.4),
                        child: IconButton(
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                            size: 20,
                            color: _isFavorite ? Colors.red : (innerBoxIsScrolled ? Colors.black87 : Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                            widget.onToggleFavorite(restaurant.id);
                          },
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Hero restaurant image
                        Hero(
                          tag: 'restaurant-image-${restaurant.id}',
                          child: Image.network(
                            restaurant.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Dark overlay gradient for text visibility
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                        // Collapsed/Expanded layout info
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  restaurant.offers,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                restaurant.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "${restaurant.category} • Italian • Fresh Cuisine",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.85),
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
                ),
              ];
            },
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Meta stats row (Rating, Distance, Time)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Rating Info
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _activeTab = 1; // Switch to Reviews tab
                                  });
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                                        const SizedBox(width: 4),
                                        Text(
                                          restaurant.rating.toString(),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${restaurant.reviewsCount} reviews",
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Vertical divider
                              Container(height: 30, width: 1, color: Colors.grey.shade200),
                              // Distance info
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_rounded, color: theme.colorScheme.primary, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        restaurant.distance,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Distance",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              // Vertical divider
                              Container(height: 30, width: 1, color: Colors.grey.shade200),
                              // Delivery time
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_filled_rounded, color: Colors.blue, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        restaurant.deliveryTime,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Delivery Time",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tabs selector (Menu / Reviews)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            _buildTabButton("Menu", 0),
                            const SizedBox(width: 16),
                            _buildTabButton("Reviews & Ratings", 1),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tab View Render
                      _activeTab == 0
                          ? _buildMenuView(menuItems, theme)
                          : _buildReviewsView(theme),

                      // Extra spacing for floating bottom bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Floating Cart Bottom Banner
          _buildCartStickyBanner(theme),
        ],
      ),
    );
  }

  // Tab button generator
  Widget _buildTabButton(String title, int index) {
    final isSelected = _activeTab == index;
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected ? [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- MENU VIEW TAB ---
  Widget _buildMenuView(List<PopularDish> items, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menu categories horizontal filter
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 24, right: 12),
            itemCount: _menuCategories.length,
            itemBuilder: (context, idx) {
              final cat = _menuCategories[idx];
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    }
                  },
                  selectedColor: theme.colorScheme.primary.withOpacity(0.15),
                  checkmarkColor: theme.colorScheme.primary,
                  backgroundColor: Colors.grey.shade100,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.primary : Colors.grey.shade700,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // List of Menu Items
        items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.no_meals_rounded, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        "No items found in this category.",
                        style: GoogleFonts.poppins(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: items.length,
                itemBuilder: (context, idx) {
                  final dish = items[idx];
                  final qty = _localCart[dish.id] ?? 0;

                  return FadeInSlide(
                    delay: Duration(milliseconds: idx * 100),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Food picture
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              dish.imageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dish.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getDishDescription(dish.id),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "₹${dish.price.toStringAsFixed(0)}",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    
                                    // Add to cart adjustments
                                    qty == 0
                                        ? InkWell(
                                            onTap: () => _updateQuantity(dish, 1),
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: theme.colorScheme.primary,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.add, color: Colors.white, size: 14),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "ADD",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove, size: 14),
                                                  color: theme.colorScheme.primary,
                                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () => _updateQuantity(dish, -1),
                                                ),
                                                Text(
                                                  qty.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: theme.colorScheme.primary,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add, size: 14),
                                                  color: theme.colorScheme.primary,
                                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () => _updateQuantity(dish, 1),
                                                ),
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
      ],
    );
  }

  // --- REVIEWS & RATINGS VIEW ---
  Widget _buildReviewsView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ratings Breakdown panel
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                // Aggregate score
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.restaurant.rating.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < widget.restaurant.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "out of 5 stars",
                      style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                
                const SizedBox(width: 24),
                
                // Progress lines
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.85),
                      _buildRatingBar(4, 0.10),
                      _buildRatingBar(3, 0.03),
                      _buildRatingBar(2, 0.01),
                      _buildRatingBar(1, 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // User reviews list header
          Text(
            "Customer Reviews",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),

          // Mock Review 1
          _buildReviewCard(
            name: "Liam O'Connor",
            avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=150",
            rating: 5,
            comment: "Absolutely delicious! The food was warm, portions were huge, and delivery was exceptionally fast. Best experience ever.",
            date: "Today",
          ),

          // Mock Review 2
          _buildReviewCard(
            name: "Elena Rostova",
            avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150",
            rating: 4.5,
            comment: "Very clean packaging. The dish tasted extremely fresh, though I wish there was slightly more seasoning in the sauce. Still, 4.5/5 stars.",
            date: "2 days ago",
          ),

          // Mock Review 3
          _buildReviewCard(
            name: "Marcus Vance",
            avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150",
            rating: 5,
            comment: "Crave did a great job delivering this hot. Pizza Romano has never disappointed me, definitely ordering their pepperoni again!",
            date: "1 week ago",
          ),
        ],
      ),
    );
  }

  // Rating progress bar helper
  Widget _buildRatingBar(int stars, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            stars.toString(),
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, color: Colors.grey, size: 10),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: pct,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${(pct * 100).toInt()}%",
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Review card widget helper
  Widget _buildReviewCard({
    required String name,
    required String avatarUrl,
    required double rating,
    required String comment,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating.floor()
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 12,
                            );
                          }),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- STICKY FLOATING CART SUMMARY BANNER ---
  Widget _buildCartStickyBanner(ThemeData theme) {
    if (_localCartCount == 0) return const SizedBox.shrink();

    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: FadeInSlide(
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$_localCartCount items in cart",
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "₹${_localCartTotalAmount.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  // Pop back to home screen with decision to jump to cart view
                  Navigator.pop(context, 'go_to_cart');
                },
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    Text(
                      "VIEW CART",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
