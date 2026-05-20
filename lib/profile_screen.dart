import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _orange = Color(0xFFFF6B35);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Avatar card ──────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sarah Connor',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'sarah.connor@sky.net',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            '+91 98765 43210',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Menu items ───────────────────────────────────
              _menuGroup([
                _MenuItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'My Orders',
                  onTap: () => _showOrders(context),
                ),
                _MenuItem(
                  icon: Icons.location_on_outlined,
                  label: 'My Addresses',
                  onTap: () => _showAddresses(context),
                ),
                _MenuItem(
                  icon: Icons.edit_outlined,
                  label: 'Edit Profile',
                  onTap: () => _showEditProfile(context),
                ),
              ]),

              const SizedBox(height: 12),

              // ── Logout ───────────────────────────────────────
              _menuGroup([
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: 'Log Out',
                  isDestructive: true,
                  onTap: () => Navigator.pop(context),
                ),
              ]),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Grouped menu section ────────────────────────────────────
  static Widget _menuGroup(List<_MenuItem> items) {
    return Container(
      color: Colors.white,
      child: Column(
        children: List.generate(items.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Divider(height: 1, indent: 56, endIndent: 0, color: Colors.grey.shade100);
          }
          return items[i ~/ 2];
        }),
      ),
    );
  }

  // ── Bottom sheet: Orders ────────────────────────────────────
  static void _showOrders(BuildContext context) {
    final orders = [
      _Order('Pizza Romano',       '🍕', 'Pepperoni Passion × 2',    547, 'Delivered', 'Today, 7:30 PM'),
      _Order('Burger House',        '🍔', 'Cheesy Double Stack × 1',   179, 'Delivered', 'Yesterday'),
      _Order('Sushi Zen',           '🍣', 'Salmon Nigiri, Dragon Roll', 728, 'Delivered', '2 days ago'),
      _Order('Green Eat Cafe',      '🥗', 'Avocado Power Salad × 2',   398, 'Cancelled', '5 days ago'),
      _Order('Sweet Treats Bakery', '🎂', 'Lava Cake, Smoothie',       228, 'Delivered', '1 week ago'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, scrollCtrl) => Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('My Orders', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const Spacer(),
                  Text('${orders.length} orders', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                controller: scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final o = orders[i];
                  final delivered = o.status == 'Delivered';
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Text(o.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.name,  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                              Text(o.items, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 2),
                              Text(o.date,  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade400)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${o.amount}', style: GoogleFonts.poppins(color: _orange, fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: delivered ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(o.status, style: GoogleFonts.poppins(color: delivered ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom sheet: Addresses ─────────────────────────────────
  static void _showAddresses(BuildContext context) {
    final addrs = [
      (Icons.home_rounded,     'Home',        '42, Poes Garden, Anna Nagar, Chennai – 600040', true),
      (Icons.work_rounded,     'Work',        'InfoPark, Kakkanad, Kochi, Kerala – 682030',    false),
      (Icons.favorite_rounded, "Mom's Place", '12/A, T. Nagar, Chennai – 600017',              false),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('My Addresses', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            ...addrs.map((a) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: a.$4 ? _orange.withOpacity(0.06) : const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: a.$4 ? _orange.withOpacity(0.3) : Colors.transparent),
              ),
              child: Row(
                children: [
                  Icon(a.$1, color: a.$4 ? _orange : Colors.grey.shade500, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(a.$2, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                            if (a.$4) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: _orange.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                                child: Text('Default', style: GoogleFonts.poppins(color: _orange, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                        Text(a.$3, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: _orange.withOpacity(0.35)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_rounded, color: _orange, size: 18),
                    const SizedBox(width: 6),
                    Text('Add New Address', style: GoogleFonts.poppins(color: _orange, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom sheet: Edit Profile ──────────────────────────────
  static void _showEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Edit Profile', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 20),
            _inputField('Full Name', 'Sarah Connor', Icons.person_outline),
            const SizedBox(height: 12),
            _inputField('Email', 'sarah.connor@sky.net', Icons.email_outlined),
            const SizedBox(height: 12),
            _inputField('Phone', '+91 98765 43210', Icons.phone_outlined),
            const SizedBox(height: 24),
            Builder(
              builder: (ctx) => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Save Changes', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _inputField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: hint,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// ── Data ─────────────────────────────────────────────────────
class _Order {
  final String name;
  final String emoji;
  final String items;
  final int amount;
  final String status;
  final String date;
  const _Order(this.name, this.emoji, this.items, this.amount, this.status, this.date);
}

// ── Menu item tile ────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : Colors.black87;
    final iconColor = isDestructive ? Colors.red : Colors.grey.shade500;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(label, style: GoogleFonts.poppins(fontSize: 15, color: color, fontWeight: FontWeight.w500)),
      trailing: isDestructive
          ? null
          : Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 22),
    );
  }
}
