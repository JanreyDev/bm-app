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

bool _isHttpImageSource(String source) {
  return source.startsWith('http://') || source.startsWith('https://');
}

Uint8List? _decodeDataImageSource(String source) {
  if (!source.startsWith('data:image')) {
    return null;
  }
  final comma = source.indexOf(',');
  if (comma < 0 || comma >= source.length - 1) {
    return null;
  }
  try {
    return base64Decode(source.substring(comma + 1));
  } catch (_) {
    return null;
  }
}

Widget _buildMarketProductImage({
  required String source,
  required IconData fallbackIcon,
  required BoxFit fit,
  Widget Function()? fallbackBuilder,
}) {
  final fallback =
      fallbackBuilder?.call() ??
      Center(
        child: Icon(
          fallbackIcon,
          size: 48,
          color: const Color(0xFF4650B4),
        ),
      );
  if (source.trim().isEmpty) {
    return fallback;
  }
  if (_isHttpImageSource(source)) {
    return Image.network(
      source,
      width: double.infinity,
      fit: fit,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
  final dataBytes = _decodeDataImageSource(source);
  if (dataBytes != null) {
    return Image.memory(
      dataBytes,
      width: double.infinity,
      fit: fit,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
  return Image.asset(
    source,
    width: double.infinity,
    fit: fit,
    errorBuilder: (_, __, ___) => fallback,
  );
}

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
  bool _apiCatalogReady = false;
  bool _apiSyncWarned = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    unawaited(_syncMarketProductsFromApi());
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  Future<void> _syncMarketProductsFromApi() async {
    final result = await _SellerApi.instance.fetchMarketProducts();
    if (!mounted) {
      return;
    }
    if (!result.success) {
      if (!_apiSyncWarned) {
        _apiSyncWarned = true;
        _showFeature(
          context,
          'Marketplace backend sync unavailable: ${result.message}',
          tone: _ToastTone.warning,
        );
      }
      return;
    }
    _ResidentCommercialSellerHub.replaceInventoryProducts(result.products);
    if (mounted) {
      setState(() => _apiCatalogReady = true);
    }
  }

  List<String> get _categories {
    final values = <String>{'All'};
    values.addAll(_ResidentCommercialSellerHub.managedCategories);
    for (final item in _marketplaceCatalog) {
      values.add(item.category);
    }
    return values.toList();
  }

  List<_ResidentProductData> get _marketplaceCatalog {
    final dynamicProducts = _ResidentCommercialSellerHub.inventoryProducts;
    return dynamicProducts;
  }

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
                Builder(
                  builder: (context) {
                    final textScale = MediaQuery.textScalerOf(context).scale(1);
                    final itemHeight = textScale > 1.05 ? 360.0 : 340.0;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: itemHeight,
                        crossAxisSpacing: 9,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (_, i) => _marketTile(context, products[i]),
                    );
                  },
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
                    child: _buildMarketProductImage(
                      source: item.imageAsset,
                      fallbackIcon: item.icon,
                      fit: BoxFit.cover,
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
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _statPill(
                        icon: Icons.star_rounded,
                        text: merchantRating.toStringAsFixed(1),
                        color: const Color(0xFFF2A93B),
                      ),
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
                  child: _buildMarketProductImage(
                    source: item.imageAsset,
                    fallbackIcon: item.icon,
                    fit: BoxFit.cover,
                    fallbackBuilder: () => Container(
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

class _MarketChatFetchResult {
  final bool success;
  final String message;
  final List<_ResidentMarketChatMessage> messages;

  const _MarketChatFetchResult({
    required this.success,
    required this.message,
    this.messages = const <_ResidentMarketChatMessage>[],
  });
}

class _MarketChatSendResult {
  final bool success;
  final String message;
  final _ResidentMarketChatMessage? chatMessage;

  const _MarketChatSendResult({
    required this.success,
    required this.message,
    this.chatMessage,
  });
}

class _MarketChatApi {
  _MarketChatApi._();
  static final _MarketChatApi instance = _MarketChatApi._();
  static const Duration _timeout = Duration(seconds: 8);

  Future<_MarketChatFetchResult> fetchMessages({
    required String sellerName,
    required String productTitle,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _MarketChatFetchResult(
        success: false,
        message: 'Please log in again to load marketplace chat.',
      );
    }

    final cleanSeller = sellerName.trim();
    final cleanProduct = productTitle.trim();
    if (cleanSeller.isEmpty || cleanProduct.isEmpty) {
      return const _MarketChatFetchResult(
        success: false,
        message: 'Missing chat thread identity.',
      );
    }

    var sawTimeout = false;
    var sawConnection = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('market/chat/messages')) {
      final uri = endpoint.replace(queryParameters: {
        'seller_name': cleanSeller,
        'product_title': cleanProduct,
      });
      try {
        final response = await http
            .get(
              uri,
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
            )
            .timeout(_timeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawList = body['messages'];
          if (rawList is! List) {
            return const _MarketChatFetchResult(
              success: false,
              message: 'Marketplace chat payload is invalid.',
            );
          }
          final out = <_ResidentMarketChatMessage>[];
          for (final item in rawList) {
            if (item is! Map<String, dynamic>) continue;
            final mapped = _mapChatMessage(item);
            if (mapped != null) out.add(mapped);
          }
          return _MarketChatFetchResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Marketplace chat loaded.'),
            messages: out,
          );
        }
        return _MarketChatFetchResult(
          success: false,
          message: _extractApiMessage(body, fallback: 'Unable to load marketplace chat.'),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnection = true;
      }
    }

    if (sawTimeout) {
      return const _MarketChatFetchResult(
        success: false,
        message: 'Loading marketplace chat timed out.',
      );
    }
    if (sawConnection) {
      return const _MarketChatFetchResult(
        success: false,
        message: 'Cannot connect to server to load marketplace chat.',
      );
    }
    return const _MarketChatFetchResult(
      success: false,
      message: 'Marketplace chat endpoint is not available yet.',
    );
  }

  Future<_MarketChatSendResult> sendMessage({
    required String sellerName,
    required String productTitle,
    required String buyerMobile,
    required String buyerName,
    required String message,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _MarketChatSendResult(
        success: false,
        message: 'Please log in again before sending a marketplace message.',
      );
    }

    final payload = jsonEncode({
      'seller_name': sellerName.trim(),
      'product_title': productTitle.trim(),
      'buyer_mobile': buyerMobile.trim(),
      'buyer_name': buyerName.trim(),
      'message': message.trim(),
    });

    var sawTimeout = false;
    var sawConnection = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('market/chat/messages')) {
      try {
        final response = await http
            .post(
              endpoint,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
              body: payload,
            )
            .timeout(_timeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final raw = body['chat_message'];
          final mapped = raw is Map<String, dynamic> ? _mapChatMessage(raw) : null;
          return _MarketChatSendResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Marketplace message sent.'),
            chatMessage: mapped,
          );
        }
        return _MarketChatSendResult(
          success: false,
          message: _extractApiMessage(body, fallback: 'Unable to send marketplace message.'),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnection = true;
      }
    }

    if (sawTimeout) {
      return const _MarketChatSendResult(
        success: false,
        message: 'Sending marketplace message timed out.',
      );
    }
    if (sawConnection) {
      return const _MarketChatSendResult(
        success: false,
        message: 'Cannot connect to server to send marketplace message.',
      );
    }
    return const _MarketChatSendResult(
      success: false,
      message: 'Marketplace chat endpoint is not available yet.',
    );
  }

  _ResidentMarketChatMessage? _mapChatMessage(Map<String, dynamic> raw) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value == null) return fallback;
      if (value is String) {
        final trimmed = value.trim();
        return trimmed.isEmpty ? fallback : trimmed;
      }
      final text = value.toString().trim();
      return text.isEmpty ? fallback : text;
    }

    final text = read('message');
    if (text.isEmpty) return null;
    final senderId = read(
      'buyer_mobile',
      fallback: read('user_id', fallback: read('sender_name', fallback: 'unknown')),
    );
    final senderName = read('sender_name', fallback: 'Resident');
    final timestamp =
        DateTime.tryParse(read('created_at')) ?? DateTime.now();
    return _ResidentMarketChatMessage(
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: timestamp,
    );
  }

  String _extractApiMessage(
    Map<String, dynamic> body, {
    required String fallback,
  }) {
    final message = body['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
    final errors = body['errors'];
    if (errors is Map<String, dynamic>) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) {
          final first = value.first;
          if (first is String && first.trim().isNotEmpty) {
            return first.trim();
          }
        }
      }
    }
    return fallback;
  }
}

class ResidentChatSellerPage extends StatefulWidget {
  final String sellerName;
  final String productTitle;

  const ResidentChatSellerPage({
    super.key,
    this.sellerName = 'Seller',
    this.productTitle = 'Marketplace item',
  });

  @override
  State<ResidentChatSellerPage> createState() => _ResidentChatSellerPageState();
}

class _ResidentChatSellerPageState extends State<ResidentChatSellerPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final String _buyerId;
  late final String _buyerName;
  List<_ResidentMarketChatMessage> _apiMessages = const <_ResidentMarketChatMessage>[];
  bool _apiLoaded = false;
  int _lastMessageCount = -1;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _buyerId = _resolveBuyerId();
    _buyerName = _resolveBuyerName();
    unawaited(_initializeChat());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _resolveBuyerId() {
    final mobile = (_currentResidentProfile?.mobile ?? '').trim();
    if (mobile.isNotEmpty) return mobile;

    final name = (_currentResidentProfile?.displayName ?? '').trim();
    if (name.isNotEmpty) {
      return name.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    }
    return 'guest';
  }

  String _resolveBuyerName() {
    final name = (_currentResidentProfile?.displayName ?? '').trim();
    return name.isEmpty ? 'Resident Buyer' : name;
  }

  Future<void> _initializeChat() async {
    try {
      await _ResidentMarketChatHub.ensureLoaded();
    } catch (_) {}
    await _syncMessagesFromApi();
    if (!mounted) {
      return;
    }
    setState(() => _ready = true);
  }

  Future<void> _syncMessagesFromApi() async {
    final result = await _MarketChatApi.instance.fetchMessages(
      sellerName: widget.sellerName,
      productTitle: widget.productTitle,
    );
    if (!mounted || !result.success) {
      return;
    }
    setState(() {
      _apiMessages = result.messages;
      _apiLoaded = true;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String threadId) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _ResidentMarketChatHub.sendMessage(
      threadId: threadId,
      senderId: _buyerId,
      senderName: _buyerName,
      text: text,
    );
    if (_apiLoaded) {
      setState(() {
        _apiMessages = [
          ..._apiMessages,
          _ResidentMarketChatMessage(
            senderId: _buyerId,
            senderName: _buyerName,
            text: text,
            timestamp: DateTime.now(),
          ),
        ];
      });
    }
    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    unawaited(_sendMessageToApi(text));
  }

  Future<void> _sendMessageToApi(String text) async {
    final result = await _MarketChatApi.instance.sendMessage(
      sellerName: widget.sellerName,
      productTitle: widget.productTitle,
      buyerMobile: _buyerId,
      buyerName: _buyerName,
      message: text,
    );
    if (!mounted) {
      return;
    }
    if (result.success) {
      if (!_apiLoaded) {
        setState(() {
          _apiLoaded = true;
        });
      }
      unawaited(_syncMessagesFromApi());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2E3E5C),
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sellerName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.productTitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7C8DB5)),
            ),
          ],
        ),
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<int>(
              valueListenable: _ResidentMarketChatHub.refresh,
              builder: (context, _, __) {
                final thread = _ResidentMarketChatHub.getOrCreateThread(
                  buyerId: _buyerId,
                  buyerName: _buyerName,
                  sellerName: widget.sellerName,
                  productTitle: widget.productTitle,
                );
                final visibleMessages = _apiLoaded
                    ? _apiMessages
                    : thread.messages;
                if (_lastMessageCount != visibleMessages.length) {
                  _lastMessageCount = visibleMessages.length;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _scrollToBottom(),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: visibleMessages.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              itemCount: visibleMessages.length,
                              itemBuilder: (context, index) {
                                final msg = visibleMessages[index];
                                final isMe = msg.senderId == _buyerId;
                                return _buildChatBubble(msg, isMe);
                              },
                            ),
                    ),
                    _buildInputArea(thread.id),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE8EEFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: Color(0xFF4A64FF),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Start a conversation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Inquire about "${widget.productTitle}" from ${widget.sellerName}.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF7C8DB5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(_ResidentMarketChatMessage msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4, top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF4A64FF) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF2E3E5C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            _formatTime(msg.timestamp),
            style: const TextStyle(fontSize: 10, color: Color(0xFF7C8DB5)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInputArea(String threadId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FB),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(threadId),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF4A64FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _sendMessage(threadId),
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
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
