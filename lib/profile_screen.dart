import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _notificationsOn = true;
  bool _locationOn = true;
  bool _darkMode = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: false,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
                tabs: const [
                  Tab(text: 'Orders'),
                  Tab(text: 'Addresses'),
                  Tab(text: 'Payments'),
                  Tab(text: 'Settings'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOrderHistory(),
            _buildAddresses(),
            _buildPayments(context),
            _buildSettings(context),
          ],
        ),
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.25), const Color(0xFF0D0D0D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Profile', style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primary, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sarah Connor', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('sarah.connor@sky.net', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primary.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded, color: primary, size: 13),
                              const SizedBox(width: 4),
                              Text('Premium Member', style: GoogleFonts.poppins(color: primary, fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _StatChip(value: '24', label: 'Orders', icon: Icons.shopping_bag_rounded),
                  const SizedBox(width: 12),
                  _StatChip(value: '₹8,450', label: 'Spent', icon: Icons.currency_rupee_rounded),
                  const SizedBox(width: 12),
                  _StatChip(value: '4.8', label: 'Avg Rating', icon: Icons.star_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── ORDER HISTORY ─────────────────────────────────────────
  Widget _buildOrderHistory() {
    final orders = [
      _Order(restaurant: 'Pizza Romano', items: 'Pepperoni Passion × 2', amount: 547, status: 'Delivered', date: 'Today, 7:30 PM', icon: '🍕'),
      _Order(restaurant: 'Burger House', items: 'Cheesy Double Stack × 1', amount: 179, status: 'Delivered', date: 'Yesterday', icon: '🍔'),
      _Order(restaurant: 'Sushi Zen', items: 'Salmon Nigiri, Dragon Roll', amount: 728, status: 'Delivered', date: '2 days ago', icon: '🍣'),
      _Order(restaurant: 'Green Eat Cafe', items: 'Avocado Power Salad × 2', amount: 398, status: 'Cancelled', date: '5 days ago', icon: '🥗'),
      _Order(restaurant: 'Sweet Treats Bakery', items: 'Lava Cake, Smoothie', amount: 228, status: 'Delivered', date: '1 week ago', icon: '🎂'),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, i) => _OrderCard(order: orders[i], primaryColor: Theme.of(context).colorScheme.primary),
    );
  }

  // ── ADDRESSES ─────────────────────────────────────────────
  Widget _buildAddresses() {
    final addresses = [
      _Address(label: 'Home', address: '42, Poes Garden, Anna Nagar, Chennai – 600040', icon: Icons.home_rounded, isPrimary: true),
      _Address(label: 'Work', address: 'InfoPark, Kakkanad, Kochi, Kerala – 682030', icon: Icons.work_rounded, isPrimary: false),
      _Address(label: "Mom's Place", address: '12/A, T. Nagar, Chennai – 600017', icon: Icons.favorite_rounded, isPrimary: false),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ...addresses.map((a) => _AddressCard(address: a, primaryColor: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 12),
        _AddNewButton(
          label: 'Add New Address',
          icon: Icons.add_location_alt_rounded,
          onTap: () {},
          primaryColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  // ── PAYMENTS ──────────────────────────────────────────────
  Widget _buildPayments(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Saved Cards', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _PaymentCard(
          label: 'HDFC Credit Card',
          sublabel: '•••• •••• •••• 4521',
          icon: Icons.credit_card_rounded,
          badge: 'VISA',
          primaryColor: primary,
          isDefault: true,
        ),
        _PaymentCard(
          label: 'SBI Debit Card',
          sublabel: '•••• •••• •••• 8834',
          icon: Icons.credit_card_rounded,
          badge: 'MC',
          primaryColor: primary,
          isDefault: false,
        ),
        const SizedBox(height: 20),
        Text('UPI & Wallets', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _PaymentCard(label: 'PhonePe', sublabel: 'sarah@ybl', icon: Icons.account_balance_wallet_rounded, badge: 'UPI', primaryColor: primary, isDefault: false),
        _PaymentCard(label: 'Paytm Wallet', sublabel: '₹2,400 available', icon: Icons.account_balance_wallet_rounded, badge: 'Wallet', primaryColor: primary, isDefault: false),
        const SizedBox(height: 12),
        _AddNewButton(label: 'Add Payment Method', icon: Icons.add_card_rounded, onTap: () {}, primaryColor: primary),
      ],
    );
  }

  // ── SETTINGS ──────────────────────────────────────────────
  Widget _buildSettings(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SettingsSection(title: 'Preferences', children: [
          _SettingsToggle(icon: Icons.notifications_rounded, label: 'Push Notifications', value: _notificationsOn, onChanged: (v) => setState(() => _notificationsOn = v), primaryColor: primary),
          _SettingsToggle(icon: Icons.location_on_rounded, label: 'Location Services', value: _locationOn, onChanged: (v) => setState(() => _locationOn = v), primaryColor: primary),
          _SettingsToggle(icon: Icons.dark_mode_rounded, label: 'Dark Mode', value: _darkMode, onChanged: (v) => setState(() => _darkMode = v), primaryColor: primary),
        ]),
        const SizedBox(height: 20),
        _SettingsSection(title: 'Account', children: [
          _SettingsTile(icon: Icons.lock_rounded, label: 'Change Password', onTap: () {}),
          _SettingsTile(icon: Icons.language_rounded, label: 'Language', trailing: 'English', onTap: () {}),
          _SettingsTile(icon: Icons.support_agent_rounded, label: 'Help & Support', onTap: () {}),
          _SettingsTile(icon: Icons.privacy_tip_rounded, label: 'Privacy Policy', onTap: () {}),
          _SettingsTile(icon: Icons.info_rounded, label: 'App Version', trailing: 'v1.0.0', onTap: () {}),
        ]),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Text('Log Out', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ─── DATA MODELS ──────────────────────────────────────────────

class _Order {
  final String restaurant, items, status, date, icon;
  final int amount;
  const _Order({required this.restaurant, required this.items, required this.amount, required this.status, required this.date, required this.icon});
}

class _Address {
  final String label, address;
  final IconData icon;
  final bool isPrimary;
  const _Address({required this.label, required this.address, required this.icon, required this.isPrimary});
}

// ─── WIDGETS ──────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _StatChip({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white08,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            Text(label, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _Order order;
  final Color primaryColor;
  const _OrderCard({required this.order, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == 'Delivered';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white08),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(order.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.restaurant, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(order.items, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${order.amount}', style: GoogleFonts.poppins(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDelivered ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status,
                      style: GoogleFonts.poppins(
                        color: isDelivered ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: Colors.white24, size: 12),
              const SizedBox(width: 4),
              Text(order.date, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11)),
              const Spacer(),
              if (isDelivered)
                GestureDetector(
                  onTap: () {},
                  child: Text('Reorder', style: GoogleFonts.poppins(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final _Address address;
  final Color primaryColor;
  const _AddressCard({required this.address, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: address.isPrimary ? primaryColor.withOpacity(0.08) : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: address.isPrimary ? primaryColor.withOpacity(0.4) : Colors.white08),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: address.isPrimary ? primaryColor.withOpacity(0.15) : Colors.white08,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(address.icon, color: address.isPrimary ? primaryColor : Colors.white38, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    if (address.isPrimary) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                        child: Text('Default', style: GoogleFonts.poppins(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(address.address, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12), maxLines: 2),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white38, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final String label, sublabel, badge;
  final IconData icon;
  final Color primaryColor;
  final bool isDefault;
  const _PaymentCard({required this.label, required this.sublabel, required this.icon, required this.badge, required this.primaryColor, required this.isDefault});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDefault ? primaryColor.withOpacity(0.08) : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDefault ? primaryColor.withOpacity(0.4) : Colors.white08),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDefault ? primaryColor : Colors.white38, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(sublabel, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
            child: Text(badge, style: GoogleFonts.poppins(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _AddNewButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color primaryColor;
  const _AddNewButton({required this.label, required this.icon, required this.onTap, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.3), style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor, size: 18),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.poppins(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white08)),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color primaryColor;
  const _SettingsToggle({required this.icon, required this.label, required this.value, required this.onChanged, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: value ? primaryColor : Colors.white38, size: 20),
      title: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
        inactiveThumbColor: Colors.white38,
        inactiveTrackColor: Colors.white12,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  const _SettingsTile({required this.icon, required this.label, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white38, size: 20),
      title: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
      trailing: trailing != null
          ? Text(trailing!, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13))
          : const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
    );
  }
}

// ── Tab Bar Delegate ─────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
