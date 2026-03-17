part of barangaymo_app;

const _residentMarketplaceProducts = [
  _ResidentProductData(
    title: 'Lenovo IdeaPad 15.6"',
    seller: 'L. Nadong Electronics',
    price: 14999,
    originalPrice: 16999,
    icon: Icons.laptop_mac,
    imageAsset: 'public/item-laptop.jpg',
    description:
        'Reliable laptop for school, online work, and barangay office tasks. Includes charger and 6-month local warranty.',
    category: 'Electronics',
    rating: 4.8,
    reviews: 214,
    sold: 430,
    stock: 7,
    eta: 'Same-day in Old Cabalan',
    verified: true,
  ),
  _ResidentProductData(
    title: 'Epson EcoTank L3210',
    seller: 'Cabalan Office Depot',
    price: 8290,
    originalPrice: 8990,
    icon: Icons.print,
    imageAsset: 'public/item-printer.jpg',
    description:
        'High-yield printer ideal for document printing and certificate forms. Compatible with refill ink bottles.',
    category: 'Electronics',
    rating: 4.7,
    reviews: 168,
    sold: 292,
    stock: 12,
    eta: 'Ships within 24 hours',
    verified: true,
  ),
  _ResidentProductData(
    title: 'Foldable Study Table',
    seller: 'R. Dela Cruz Furnitures',
    price: 2499,
    originalPrice: 2999,
    icon: Icons.table_restaurant,
    imageAsset: 'public/item-table.jpg',
    description:
        'Space-saving foldable table for home study and small work areas with powder-coated steel frame.',
    category: 'Furniture',
    rating: 4.6,
    reviews: 96,
    sold: 205,
    stock: 18,
    eta: 'Pickup or 1-2 days delivery',
  ),
  _ResidentProductData(
    title: 'Emergency Go Bag',
    seller: 'Barangay Safety Co-op',
    price: 1250,
    originalPrice: 1450,
    icon: Icons.backpack,
    imageAsset: 'public/item-gobag.jpg',
    description:
        'Preparedness bag with first aid basics, flashlight, whistle, and waterproof storage pouches.',
    category: 'Emergency',
    rating: 4.9,
    reviews: 302,
    sold: 920,
    stock: 30,
    eta: 'Ready to deliver today',
  ),
];

class ResidentMarketPage extends StatefulWidget {
  const ResidentMarketPage({super.key});

  @override
  State<ResidentMarketPage> createState() => _ResidentMarketPageState();
}

class _ResidentMarketPageState extends State<ResidentMarketPage> {
  static const _sortOptions = [
    'Popular',
    'Top Rated',
    'Price: Low to High',
    'Price: High to Low',
  ];

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedSort = _sortOptions.first;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  List<String> get _categories {
    final values = <String>{'All'};
    values.addAll(_ResidentCommercialSellerHub.managedCategories);
    for (final item in _marketplaceCatalog) {
      values.add(item.category);
    }
    return values.toList();
  }

  List<_ResidentProductData> get _marketplaceCatalog => [
    ..._ResidentCommercialSellerHub.inventoryProducts,
    ..._residentMarketplaceProducts,
  ];

  List<_ResidentProductData> get _visibleProducts {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _marketplaceCatalog.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final haystack =
          '${item.title} ${item.seller} ${item.description} ${item.category}'
              .toLowerCase();
      final matchesQuery = query.isEmpty || haystack.contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    filtered.sort((a, b) {
      if (_selectedSort == 'Top Rated') {
        return b.rating.compareTo(a.rating);
      }
      if (_selectedSort == 'Price: Low to High') {
        return a.price.compareTo(b.price);
      }
      if (_selectedSort == 'Price: High to Low') {
        return b.price.compareTo(a.price);
      }
      return b.sold.compareTo(a.sold);
    });
    return filtered;
  }

  List<String> get _searchSuggestions {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return const <String>[];
    }
    final values = <String>{};
    for (final item in _marketplaceCatalog) {
      final candidates = <String>[
        item.title,
        item.seller,
        item.category,
      ];
      for (final candidate in candidates) {
        if (candidate.toLowerCase().contains(query)) {
          values.add(candidate);
        }
      }
    }
    return values.take(6).toList();
  }

  String _currency(double amount) => 'PHP ${amount.toStringAsFixed(2)}';

  double _merchantRating(_ResidentProductData item) =>
      _ResidentCommercialSellerHub.ratingForSeller(
        item.seller,
        fallback: item.rating,
      );

  int _merchantReviewCount(_ResidentProductData item) =>
      _ResidentCommercialSellerHub.feedbackCountForSeller(
        item.seller,
        fallback: item.reviews,
      );

  bool _merchantVerified(_ResidentProductData item) {
    final registration = _ResidentCommercialSellerHub.registration;
    if (registration != null && registration.businessName == item.seller) {
      return registration.merchantVerified;
    }
    return item.verified;
  }

  String _compactCount(int value) {
    if (value >= 1000) {
      final formatted = value >= 10000
          ? (value / 1000).toStringAsFixed(0)
          : (value / 1000).toStringAsFixed(1);
      return '${formatted}k';
    }
    return '$value';
  }

  int _discountPercent(_ResidentProductData item) {
    final original = item.originalPrice;
    if (original == null || original <= item.price) {
      return 0;
    }
    final discount = ((original - item.price) / original * 100).round();
    return discount < 1 ? 1 : discount;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _ResidentCommercialSellerHub.refresh,
      builder: (_, __, ___) {
        final products = _visibleProducts;
        final suggestions = _searchSuggestions;
        final banners = _ResidentCommercialSellerHub.banners;
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF3F7FF), Color(0xFFF8F2EE)],
                  ),
                ),
              ),
              Positioned(
                top: -64,
                right: -38,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFE6EEFF), Color(0x00E6EEFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 210,
                left: -58,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFE8DE), Color(0x00FFE8DE)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marketplace',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2A2E44),
                          ),
                        ),
                        Text(
                          'Trusted local products and services',
                          style: TextStyle(
                            color: Color(0xFF646A86),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _topIconButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResidentNotificationsPage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ValueListenableBuilder<int>(
                    valueListenable: _ResidentCartHub.refresh,
                    builder: (_, __, ___) {
                      return _topIconButton(
                        icon: Icons.shopping_cart_rounded,
                        badgeCount: _ResidentCartHub.items.length,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResidentCartPage(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE6E9F5)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
               child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () => _searchController.clear(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                    hintText: 'Search products, sellers, or categories',
                  ),
                ),
              ),
              if (suggestions.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: suggestions
                      .map(
                        (suggestion) => ActionChip(
                          label: Text(suggestion),
                          avatar: const Icon(Icons.search_rounded, size: 16),
                          onPressed: () {
                            _searchController.text = suggestion;
                            _searchController.selection = TextSelection.collapsed(
                              offset: suggestion.length,
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                height: 148,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: banners.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) {
                    final banner = banners[index];
                    return Container(
                      width: math
                          .max(MediaQuery.sizeOf(context).width - 24, 260)
                          .toDouble(),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [banner.start, banner.end],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x2B2E35D3),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -20,
                            right: -16,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      banner.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      banner.subtitle,
                                      style: const TextStyle(
                                        color: Color(0xFFDDE3FF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (banner.attachmentName != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        'Asset: ${banner.attachmentName}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              FilledButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ResidentSellHubPage(),
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: banner.start,
                                ),
                                child: const Text('Start Selling'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = category),
                    side: BorderSide(
                      color: _selectedCategory == category
                          ? const Color(0xFF4257D3)
                          : const Color(0xFFD8DEEF),
                    ),
                    selectedColor: const Color(0xFFE8EEFF),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _selectedCategory == category
                          ? const Color(0xFF2E3A8B)
                          : const Color(0xFF585E79),
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${products.length} item(s) found',
                    style: const TextStyle(
                      color: Color(0xFF5F6582),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    initialValue: _selectedSort,
                    onSelected: (value) =>
                        setState(() => _selectedSort = value),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    itemBuilder: (_) => _sortOptions
                        .map(
                          (option) => PopupMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDDE2F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sort_rounded,
                            size: 17,
                            color: Color(0xFF4F5675),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _selectedSort,
                            style: const TextStyle(
                              color: Color(0xFF4F5675),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (products.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E6F2)),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 42,
                        color: Color(0xFF7A809B),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No products matched your filters.',
                        style: TextStyle(
                          color: Color(0xFF505670),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (_, i) => _marketTile(context, products[i]),
                ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _topIconButton({
    required IconData icon,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE4E7F2)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF48507A)),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE3483A),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 1.2),
              ),
              child: Text(
                badgeCount > 99 ? '99+' : '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _statPill({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketTile(BuildContext context, _ResidentProductData item) {
    final merchantRating = _merchantRating(item);
    final merchantReviews = _merchantReviewCount(item);
    final merchantVerified = _merchantVerified(item);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _ResidentProductPreviewPage(item: item),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6E7F1)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 9,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 112,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE8EAFF), Color(0xFFF3F4FF)],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      item.imageAsset,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          item.icon,
                          size: 48,
                          color: const Color(0xFF4650B4),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.44),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.eta,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (_discountPercent(item) > 0)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3483A),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '-${_discountPercent(item)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F3146),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.seller,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF676B84),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (merchantVerified)
                        const Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: Color(0xFF3C78E3),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currency(item.price),
                    style: const TextStyle(
                      color: Color(0xFF3340B6),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  if (item.originalPrice != null)
                    Text(
                      _currency(item.originalPrice!),
                      style: const TextStyle(
                        color: Color(0xFF8B90A8),
                        decoration: TextDecoration.lineThrough,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _statPill(
                        icon: Icons.star_rounded,
                        text: merchantRating.toStringAsFixed(1),
                        color: const Color(0xFFF2A93B),
                      ),
                      const SizedBox(width: 6),
                      _statPill(
                        icon: Icons.local_fire_department_rounded,
                        text: '${_compactCount(item.sold)} sold',
                        color: const Color(0xFF3A63CC),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$merchantReviews feedback entr${merchantReviews == 1 ? 'y' : 'ies'}',
                    style: const TextStyle(
                      color: Color(0xFF8087A0),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Stock ${item.stock}',
                          style: const TextStyle(
                            color: Color(0xFF666E8A),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          _ResidentCartHub.addProduct(
                            item,
                            qty: 1,
                            deliveryZone: item.sellerZone,
                            deliveryPurok: item.sellerPurok,
                          );
                          _showFeature(context, '${item.title} added to cart.');
                          setState(() {});
                        },
                        child: Ink(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 17,
                            color: Color(0xFF3C54C5),
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
      ),
    );
  }
}

class _ResidentProductPreviewPage extends StatefulWidget {
  final _ResidentProductData item;
  const _ResidentProductPreviewPage({required this.item});

  @override
  State<_ResidentProductPreviewPage> createState() =>
      _ResidentProductPreviewPageState();
}

class _ResidentProductPreviewPageState
    extends State<_ResidentProductPreviewPage> {
  int _quantity = 1;
  String _selectedFulfillment = 'Pickup at Brgy Hall';
  String _selectedZone = _marketDeliveryZones.first;
  String _selectedPurok = _marketDeliveryPuroks.first;

  String _currency(double amount) => 'PHP ${amount.toStringAsFixed(2)}';

  double get _deliveryFee => _marketDeliveryFeeFor(
    _selectedFulfillment,
    _selectedZone,
    _selectedPurok,
  );

  void _addToCart({bool openCart = false}) {
    _ResidentCartHub.addProduct(
      widget.item,
      qty: _quantity,
      fulfillment: _selectedFulfillment,
      deliveryZone: _selectedZone,
      deliveryPurok: _selectedPurok,
    );
    _showFeature(
      context,
      '$_quantity x ${widget.item.title} added to cart via $_selectedFulfillment.',
    );
    if (openCart) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResidentCartPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final subtotal = item.price * _quantity;
    final merchantRating = _ResidentCommercialSellerHub.ratingForSeller(
      item.seller,
      fallback: item.rating,
    );
    final merchantReviews = _ResidentCommercialSellerHub.feedbackCountForSeller(
      item.seller,
      fallback: item.reviews,
    );
    final registration = _ResidentCommercialSellerHub.registration;
    final merchantVerified =
        registration != null && registration.businessName == item.seller
            ? registration.merchantVerified
            : item.verified;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResidentCartPage()),
            ),
            icon: const Icon(Icons.shopping_cart_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 230,
                  child: Image.asset(
                    item.imageAsset,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: Icon(
                        item.icon,
                        size: 72,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.eta,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4E8F3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D3046),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _currency(item.price),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2E35D3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (item.originalPrice != null)
                      Text(
                        _currency(item.originalPrice!),
                        style: const TextStyle(
                          color: Color(0xFF8187A1),
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _previewTag(
                      icon: Icons.star_rounded,
                      text: '${merchantRating.toStringAsFixed(1)} ($merchantReviews reviews)',
                      color: const Color(0xFFF2A93B),
                    ),
                    _previewTag(
                      icon: Icons.inventory_2_rounded,
                      text: '${item.stock} in stock',
                      color: const Color(0xFF3E66C7),
                    ),
                    _previewTag(
                      icon: Icons.local_fire_department_rounded,
                      text: '${item.sold} sold',
                      color: const Color(0xFF4A54B8),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Color(0xFF5A607D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDDE3F3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        color: Color(0xFF4C57BB),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sold by ${item.seller}',
                          style: const TextStyle(
                            color: Color(0xFF2F344E),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (merchantVerified)
                        const Icon(
                          Icons.verified_rounded,
                          size: 18,
                          color: Color(0xFF3A7BE5),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _selectedFulfillment,
                  decoration: InputDecoration(
                    labelText: 'Fulfillment option',
                    filled: true,
                    fillColor: const Color(0xFFF7F9FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDDE3F3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDDE3F3)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Pickup at Brgy Hall',
                      child: Text('Pickup at Brgy Hall'),
                    ),
                    DropdownMenuItem(
                      value: 'Seller Meetup',
                      child: Text('Seller Meetup'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() => _selectedFulfillment = value);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedZone,
                        decoration: const InputDecoration(
                          labelText: 'Delivery zone',
                        ),
                        items: _marketDeliveryZones
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: _selectedFulfillment == 'Pickup at Brgy Hall'
                            ? null
                            : (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() => _selectedZone = value);
                              },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedPurok,
                        decoration: const InputDecoration(
                          labelText: 'Purok',
                        ),
                        items: _marketDeliveryPuroks
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: _selectedFulfillment == 'Pickup at Brgy Hall'
                            ? null
                            : (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() => _selectedPurok = value);
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDDE2F2)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        visualDensity: VisualDensity.compact,
                      ),
                      Expanded(
                        child: Text(
                          '$_quantity',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _quantity < item.stock
                            ? () => setState(() => _quantity++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResidentChatSellerPage(
                        sellerName: item.seller,
                        productTitle: item.title,
                      ),
                    ),
                  ),
                  child: const Text('Chat'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showMerchantRatingSheet(context, item.seller),
                  icon: const Icon(Icons.star_rate_rounded),
                  label: const Text('Rate Merchant'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: item.allowBarangayBid
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResidentMerchantBidPage(item: item),
                            ),
                          )
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEF6B3E),
                  ),
                  icon: const Icon(Icons.gavel_rounded),
                  label: const Text('Bid / Quote'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _previewBillRow('Item price', _currency(item.price)),
          _previewBillRow('Quantity', 'x$_quantity'),
          _previewBillRow('Fulfillment', _selectedFulfillment),
          _previewBillRow('Delivery Fee', _currency(_deliveryFee)),
          _previewBillRow(
            'Subtotal',
            _currency(subtotal + _deliveryFee),
            bold: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addToCart(),
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: const Text('Add to Cart'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () => _addToCart(openCart: true),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                  ),
                  child: const Text('Buy Now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewTag({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewBillRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: bold ? const Color(0xFF2E3046) : const Color(0xFF666D88),
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: bold ? const Color(0xFF2E35D3) : const Color(0xFF4C5370),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

}

Future<void> _showMerchantRatingSheet(
  BuildContext context,
  String sellerName,
) async {
  final commentController = TextEditingController();
  var stars = 5;
  final submitted = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(sheetContext).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate $sellerName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (index) {
                    final active = index < stars;
                    return IconButton(
                      onPressed: () => setSheetState(() => stars = index + 1),
                      icon: Icon(
                        active ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFF2A93B),
                      ),
                    );
                  }),
                ),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Feedback',
                    hintText: 'Share your experience with the merchant',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext, true),
                    child: const Text('Submit Rating'),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
  if (submitted != true) {
    commentController.dispose();
    return;
  }
  _ResidentCommercialSellerHub.addFeedback(
    _ResidentMerchantFeedbackData(
      sellerName: sellerName,
      authorName: 'Resident Buyer',
      stars: stars,
      comment: commentController.text.trim().isEmpty
          ? 'Merchant rating submitted.'
          : commentController.text.trim(),
      createdAt: DateTime.now(),
    ),
  );
  commentController.dispose();
  _showFeature(context, 'Merchant rating submitted.');
}

class ResidentChatSellerPage extends StatelessWidget {
  final String sellerName;
  final String productTitle;
  const ResidentChatSellerPage({
    super.key,
    this.sellerName = 'Seller',
    this.productTitle = 'Marketplace item',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $sellerName')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE3E7F4)),
                    ),
                    child: Text(
                      'Hello, I am interested in "$productTitle". Is it still available for pickup at Brgy Hall?',
                      style: const TextStyle(
                        color: Color(0xFF4E5673),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7ECFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Yes, this is available. We can arrange pickup or meetup.',
                      style: const TextStyle(
                        color: Color(0xFF31419F),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message to $sellerName...',
                suffixIcon: IconButton(
                  onPressed: () =>
                      _showFeature(context, 'Message sent to $sellerName.'),
                  icon: const Icon(Icons.send_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class ResidentAddToCartDonePage extends StatelessWidget {
  const ResidentAddToCartDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.check_circle, color: Color(0xFF2E35D3), size: 86),
            const SizedBox(height: 10),
            const Text(
              'Success!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const Text('Your order has been added to cart.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ResidentCartPage()),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E35D3),
                ),
                child: const Text('Go to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
