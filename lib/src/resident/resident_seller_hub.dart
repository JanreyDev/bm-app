part of barangaymo_app;

class _MerchantRegistrationFetchResult {
  final bool success;
  final String message;
  final _ResidentCommercialRegistrationData? registration;

  const _MerchantRegistrationFetchResult({
    required this.success,
    required this.message,
    this.registration,
  });
}

class _MerchantRegistrationSubmitResult {
  final bool success;
  final String message;
  final _ResidentCommercialRegistrationData? registration;

  const _MerchantRegistrationSubmitResult({
    required this.success,
    required this.message,
    this.registration,
  });
}

class _MarketProductsFetchResult {
  final bool success;
  final String message;
  final List<_ResidentProductData> products;

  const _MarketProductsFetchResult({
    required this.success,
    required this.message,
    this.products = const <_ResidentProductData>[],
  });
}

class _MarketProductSubmitResult {
  final bool success;
  final String message;
  final _ResidentProductData? product;

  const _MarketProductSubmitResult({
    required this.success,
    required this.message,
    this.product,
  });
}

class _SellerApi {
  _SellerApi._();
  static final _SellerApi instance = _SellerApi._();
  static const Duration _requestTimeout = Duration(seconds: 8);

  String _normalizedProductImageSource(String rawSource, String category) {
    final source = rawSource.trim();
    if (source.isEmpty) {
      return _merchantProductAsset(category);
    }
    if (source.startsWith('data:image')) {
      return source;
    }
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return source;
    }
    if (source.startsWith('public/')) {
      return source;
    }

    final bases = _AuthApi.instance._baseUrlCandidates();
    final base = bases.isNotEmpty ? bases.first : _configuredApiBaseUrl;
    final trimmedBase = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final trimmedPath = source.startsWith('/') ? source.substring(1) : source;
    return '$trimmedBase/$trimmedPath';
  }

  Future<_MerchantRegistrationFetchResult> fetchMerchantRegistration() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _MerchantRegistrationFetchResult(
        success: false,
        message: 'Please log in again to load merchant registration.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>[
      'market/merchant-registration',
      'merchant-registration',
      'market/merchant',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http
              .get(
                endpoint,
                headers: {
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $_authToken',
                },
              )
              .timeout(_requestTimeout);
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          final body = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final raw = body['registration'];
            _ResidentCommercialRegistrationData? registration;
            if (raw is Map<String, dynamic>) {
              registration = mapRegistration(raw);
            }
            return _MerchantRegistrationFetchResult(
              success: true,
              message: _extractApiMessage(body, fallback: 'Merchant registration loaded.'),
              registration: registration,
            );
          }
          return _MerchantRegistrationFetchResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to load merchant registration.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }
    if (sawTimeout) {
      return const _MerchantRegistrationFetchResult(
        success: false,
        message: 'Loading merchant registration timed out.',
      );
    }
    if (sawConnectionError) {
      return const _MerchantRegistrationFetchResult(
        success: false,
        message: 'Cannot connect to server to load merchant registration.',
      );
    }
    return const _MerchantRegistrationFetchResult(
      success: false,
      message: 'Merchant registration endpoint is not available yet.',
    );
  }

  Future<_MerchantRegistrationSubmitResult> submitMerchantRegistration({
    required String businessName,
    required String ownerName,
    required String businessType,
    required String contactNumber,
    required String address,
    required String meetupSpot,
    required String businessPermitNumber,
    required String businessPermitFileName,
    String permitImageBase64 = '',
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _MerchantRegistrationSubmitResult(
        success: false,
        message: 'Please log in again before merchant registration.',
      );
    }

    final payload = jsonEncode({
      'business_name': businessName.trim(),
      'owner_name': ownerName.trim(),
      'business_type': businessType.trim(),
      'contact_number': contactNumber.trim(),
      'address': address.trim(),
      'meetup_spot': meetupSpot.trim(),
      'business_permit_number': businessPermitNumber.trim(),
      'business_permit_file_name': businessPermitFileName.trim(),
      if (permitImageBase64.trim().isNotEmpty)
        'business_permit_image_base64': permitImageBase64.trim(),
    });

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>[
      'market/merchant-registration',
      'merchant-registration',
      'market/merchant',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
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
              .timeout(_requestTimeout);
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          final body = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final raw = body['registration'];
            _ResidentCommercialRegistrationData? registration;
            if (raw is Map<String, dynamic>) {
              registration = mapRegistration(raw);
            }
            return _MerchantRegistrationSubmitResult(
              success: true,
              message: _extractApiMessage(
                body,
                fallback: 'Commercial seller registration submitted.',
              ),
              registration: registration,
            );
          }
          return _MerchantRegistrationSubmitResult(
            success: false,
            message: _extractApiMessage(
              body,
              fallback: 'Unable to submit merchant registration.',
            ),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _MerchantRegistrationSubmitResult(
        success: false,
        message: 'Submitting registration timed out.',
      );
    }
    if (sawConnectionError) {
      return const _MerchantRegistrationSubmitResult(
        success: false,
        message: 'Cannot connect to server to submit registration.',
      );
    }
    return const _MerchantRegistrationSubmitResult(
      success: false,
      message: 'Merchant registration endpoint is not available yet.',
    );
  }

  Future<_MarketProductsFetchResult> fetchMarketProducts() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _MarketProductsFetchResult(
        success: false,
        message: 'Please log in again to load market products.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>['market/products', 'products'];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http
              .get(
                endpoint,
                headers: {
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $_authToken',
                },
              )
              .timeout(_requestTimeout);
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          final body = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final rawList = body['products'] ?? body['data'];
            if (rawList is! List) {
              return const _MarketProductsFetchResult(
                success: false,
                message: 'Market products payload is invalid.',
              );
            }
            final out = <_ResidentProductData>[];
            for (final item in rawList) {
              if (item is! Map<String, dynamic>) {
                continue;
              }
              final mapped = _mapProduct(item);
              if (mapped != null) {
                out.add(mapped);
              }
            }
            return _MarketProductsFetchResult(
              success: true,
              message: _extractApiMessage(body, fallback: 'Market products loaded.'),
              products: out,
            );
          }
          return _MarketProductsFetchResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to load market products.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _MarketProductsFetchResult(
        success: false,
        message: 'Loading market products timed out.',
      );
    }
    if (sawConnectionError) {
      return const _MarketProductsFetchResult(
        success: false,
        message: 'Cannot connect to server to load market products.',
      );
    }
    return const _MarketProductsFetchResult(
      success: false,
      message: 'Market products endpoint is not available yet.',
    );
  }

  Future<_MarketProductSubmitResult> submitMarketProduct({
    required String title,
    required String category,
    required String description,
    required double price,
    double? originalPrice,
    required int stock,
    required String eta,
    required String sellerZone,
    required String sellerPurok,
    String thumbnailBase64 = '',
    String thumbnailFileName = '',
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _MarketProductSubmitResult(
        success: false,
        message: 'Please log in again before adding a product.',
      );
    }

    final payload = jsonEncode({
      'title': title.trim(),
      'category': category.trim(),
      'description': description.trim(),
      'price': price,
      if (originalPrice != null) 'original_price': originalPrice,
      'stock': stock,
      'eta': eta.trim(),
      'seller_zone': sellerZone.trim(),
      'seller_purok': sellerPurok.trim(),
      if (thumbnailBase64.trim().isNotEmpty)
        'thumbnail_base64': thumbnailBase64.trim(),
      if (thumbnailFileName.trim().isNotEmpty)
        'thumbnail_file_name': thumbnailFileName.trim(),
    });

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>['market/products', 'products'];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
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
              .timeout(_requestTimeout);
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          final body = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final raw = body['product'] ?? body['data'];
            _ResidentProductData? product;
            if (raw is Map<String, dynamic>) {
              product = _mapProduct(raw);
            }
            return _MarketProductSubmitResult(
              success: true,
              message: _extractApiMessage(body, fallback: 'Product saved successfully.'),
              product: product,
            );
          }
          return _MarketProductSubmitResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to save product.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _MarketProductSubmitResult(
        success: false,
        message: 'Saving product timed out.',
      );
    }
    if (sawConnectionError) {
      return const _MarketProductSubmitResult(
        success: false,
        message: 'Cannot connect to server to save product.',
      );
    }
    return const _MarketProductSubmitResult(
      success: false,
      message: 'Market products endpoint is not available yet.',
    );
  }

  _ResidentProductData? _mapProduct(Map<String, dynamic> raw) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value == null) {
        return fallback;
      }
      if (value is String) {
        final trimmed = value.trim();
        return trimmed.isEmpty ? fallback : trimmed;
      }
      final text = value.toString().trim();
      return text.isEmpty ? fallback : text;
    }

    double readDouble(String key, {double fallback = 0}) {
      final value = raw[key];
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value.trim()) ?? fallback;
      }
      return fallback;
    }

    int readInt(String key, {int fallback = 0}) {
      final value = raw[key];
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        return int.tryParse(value.trim()) ?? fallback;
      }
      return fallback;
    }

    final title = read('title');
    if (title.isEmpty) {
      return null;
    }
    final category = read('category', fallback: 'Retail');
    final originalPriceRaw = readDouble('original_price', fallback: 0);
    final originalPrice = originalPriceRaw > 0 ? originalPriceRaw : null;
    final imageCandidate = read(
      'thumbnail_url',
      fallback: read(
        'thumbnail_base64',
        fallback: read(
        'thumbnail_path',
        fallback: read(
          'thumbnail',
          fallback: read(
            'image_url',
            fallback: read('image_asset', fallback: _merchantProductAsset(category)),
          ),
        ),
        ),
      ),
    );
    final imageAsset = _normalizedProductImageSource(imageCandidate, category);
    return _ResidentProductData(
      title: title,
      seller: read('seller', fallback: read('seller_name', fallback: 'Commercial Seller')),
      price: readDouble('price', fallback: 0),
      originalPrice: originalPrice,
      icon: _merchantProductIcon(category),
      imageAsset: imageAsset,
      description: read('description', fallback: 'Marketplace product'),
      category: category,
      rating: readDouble('rating', fallback: 4.8),
      reviews: readInt('reviews', fallback: 0),
      sold: readInt('sold', fallback: 0),
      stock: readInt('stock', fallback: 0),
      eta: read('eta', fallback: 'Available soon'),
      verified: raw['verified'] == true || raw['verified'] == 1 || raw['verified'] == '1',
      sellerZone: read('seller_zone', fallback: _marketDeliveryZones.first),
      sellerPurok: read('seller_purok', fallback: _marketDeliveryPuroks.first),
    );
  }

  _ResidentCommercialRegistrationData mapRegistration(Map<String, dynamic> raw) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value == null) {
        return fallback;
      }
      if (value is String) {
        final trimmed = value.trim();
        return trimmed.isEmpty ? fallback : trimmed;
      }
      final text = value.toString().trim();
      return text.isEmpty ? fallback : text;
    }

    final verifiedRaw = raw['merchant_verified'];
    final verified =
        verifiedRaw == true ||
        verifiedRaw == 1 ||
        verifiedRaw == '1' ||
        (verifiedRaw is String && verifiedRaw.toLowerCase() == 'true');

    return _ResidentCommercialRegistrationData(
      id: read('id'),
      businessName: read('business_name'),
      ownerName: read('owner_name'),
      businessType: read('business_type'),
      contactNumber: read('contact_number'),
      address: read('address'),
      meetupSpot: read('meetup_spot'),
      businessPermitNumber: read('business_permit_number'),
      businessPermitFileName: read('business_permit_file_name'),
      merchantVerified: verified,
      verificationStatus: read(
        'verification_status',
        fallback: verified ? 'Verified' : 'Pending Review',
      ),
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

class ResidentSellHubPage extends StatefulWidget {
  final int initialTab;
  const ResidentSellHubPage({super.key, this.initialTab = 0});

  @override
  State<ResidentSellHubPage> createState() => _ResidentSellHubPageState();
}

class _ResidentSellHubPageState extends State<ResidentSellHubPage> {
  int selected = 0;

  @override
  void initState() {
    super.initState();
    selected = widget.initialTab;
    unawaited(_syncMerchantRegistrationFromApi());
  }

  Future<void> _syncMerchantRegistrationFromApi() async {
    final result = await _SellerApi.instance.fetchMerchantRegistration();
    if (!mounted || !result.success) {
      return;
    }
    _ResidentCommercialSellerHub.replaceBusinessRegistration(result.registration);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = const ['Commercial', 'Government'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Your Products'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6F8FF), Color(0xFFF8F1F1)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: selected == 1
                      ? const [Color(0xFF3444B9), Color(0xFF6272E4)]
                      : const [Color(0xFF3650D3), Color(0xFF5E7CF7)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x262E35D3),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white.withValues(alpha: 0.24),
                    ),
                    child: Icon(
                      selected == 1
                          ? Icons.account_balance_rounded
                          : Icons.storefront_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected == 1
                              ? 'Government Selling Portal'
                              : 'Commercial Seller Workspace',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          selected == 1
                              ? 'Register and manage GovProcure submissions.'
                              : 'Manage inventory, products, and local buyers.',
                          style: const TextStyle(
                            color: Color(0xFFDDE2FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCDD6F6)),
              ),
              child: SegmentedButton<int>(
                showSelectedIcon: true,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFFE7ECFF);
                    }
                    return Colors.white;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFF3243B5);
                    }
                    return const Color(0xFF5C637F);
                  }),
                  side: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const BorderSide(color: Color(0xFFBDC9F8));
                    }
                    return const BorderSide(color: Color(0xFFD8DDF1));
                  }),
                  textStyle: WidgetStateProperty.all(
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ),
                segments: List.generate(
                  tabs.length,
                  (i) => ButtonSegment<int>(value: i, label: Text(tabs[i])),
                ),
                selected: {selected},
                onSelectionChanged: (v) => setState(() => selected = v.first),
              ),
            ),
            const SizedBox(height: 12),
            if (selected == 0) const ResidentCommercialPage(),
            if (selected == 1) const ResidentGovSellPage(),
          ],
        ),
      ),
    );
  }
}

class ResidentCommercialPage extends StatelessWidget {
  const ResidentCommercialPage({super.key});

  @override
  Widget build(BuildContext context) {
    _ResidentProfileVerificationHub.ensureLoaded();
    return ValueListenableBuilder<bool>(
      valueListenable: _ResidentProfileVerificationHub.refresh,
      builder: (_, verified, __) {
        return ValueListenableBuilder<int>(
          valueListenable: _ResidentCommercialSellerHub.refresh,
          builder: (_, ___, ____) {
            final registration = _ResidentCommercialSellerHub.registration;
            final canAccessCommercial = verified || registration?.merchantVerified == true;
            final inventory = _ResidentCommercialSellerHub.inventoryProducts;
            final sellerName = registration?.businessName ?? 'Commercial Seller';
            final salesCount = _ResidentCommercialSellerHub.salesCountForSeller(
              sellerName,
            );
            final salesValue = _ResidentCommercialSellerHub.salesValueForSeller(
              sellerName,
            );
            final orderCount = _ResidentCommercialSellerHub.orderCountForSeller(
              sellerName,
            );
            final sellerRating = _ResidentCommercialSellerHub.ratingForSeller(
              sellerName,
            );
            final quoteCount = _ResidentCommercialSellerHub.bidRequests
                .where((item) => item.sellerName == sellerName)
                .length;
            return Column(
              children: [
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        registration?.merchantVerified == true
                            ? Icons.verified_user_rounded
                            : Icons.person,
                      ),
                    ),
                    title: Text(registration?.ownerName ?? 'Shamira Balandra'),
                    subtitle: Text(
                      registration == null ? 'Commercial Seller' : sellerName,
                    ),
                    trailing: registration == null
                        ? null
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: registration.merchantVerified
                                  ? const Color(0xFFE6F7EE)
                                  : const Color(0xFFFFF1E1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              registration.merchantVerified
                                  ? 'Verified Merchant'
                                  : registration.verificationStatus,
                              style: TextStyle(
                                color: registration.merchantVerified
                                    ? const Color(0xFF197A46)
                                    : const Color(0xFFB86919),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ),
                ),
                if (!canAccessCommercial)
                  _CommercialGateCard(
                    icon: Icons.verified_user,
                    title: 'RBI Verification Required',
                    subtitle:
                        'To sell commercially, complete RBI/profile verification first.',
                    buttonLabel: 'Get Verified Now',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResidentVerifyProfilePage(),
                      ),
                    ),
                  )
                else if (registration == null)
                  _CommercialGateCard(
                    icon: Icons.store_mall_directory_outlined,
                    title: 'Business Registration Portal',
                    subtitle:
                        'Register your store before listing products in the marketplace.',
                    buttonLabel: 'Register Business',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResidentCommercialRegistrationPage(),
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE1E5F5)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _CommercialMetric(
                                icon: Icons.inventory_2_rounded,
                                label: 'Products',
                                value: '${inventory.length}',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _CommercialMetric(
                                icon: Icons.payments_outlined,
                                label: 'Sales',
                                value: 'PHP ${salesValue.toStringAsFixed(0)}',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _CommercialMetric(
                                icon: Icons.fact_check_outlined,
                                label: 'Orders',
                                value: '$orderCount',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE1E5F5)),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _summaryChip(
                              icon: Icons.storefront_rounded,
                              label: registration.businessType,
                            ),
                            _summaryChip(
                              icon: Icons.pin_drop_outlined,
                              label: registration.meetupSpot,
                            ),
                            _summaryChip(
                              icon: Icons.shopping_bag_outlined,
                              label: 'Units Sold: $salesCount',
                            ),
                            _summaryChip(
                              icon: Icons.star_rounded,
                              label:
                                  'Rating: ${sellerRating.toStringAsFixed(1)}',
                            ),
                            _summaryChip(
                              icon: Icons.gavel_rounded,
                              label: 'Barangay Quotes: $quoteCount',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text('My Products'),
                        subtitle: Text(
                          inventory.isEmpty
                              ? 'Your marketplace inventory is still empty.'
                              : '${inventory.length} active product listing(s)',
                        ),
                        trailing: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ResidentMerchantInventoryPage(),
                            ),
                          ),
                          child: const Text('View All'),
                        ),
                      ),
                      if (inventory.isEmpty)
                        const Card(
                          child: SizedBox(
                            height: 120,
                            child: Center(child: Text('No Products Yet')),
                          ),
                        )
                      else
                        ...inventory.take(2).map(
                          (item) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE4E7F3)),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8ECFF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildMarketProductImage(
                                    source: item.imageAsset,
                                    fallbackIcon: item.icon,
                                    fit: BoxFit.cover,
                                    fallbackBuilder: () => Icon(
                                      item.icon,
                                      color: const Color(0xFF4254C8),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2F344A),
                                ),
                              ),
                              subtitle: Text(
                                'PHP ${item.price.toStringAsFixed(2)} | Stock ${item.stock}',
                                style: const TextStyle(
                                  color: Color(0xFF66708A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _openMerchantCategoryManager(context),
                              icon: const Icon(Icons.category_outlined),
                              label: const Text('Categories'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _openMerchantBannerManager(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF2E35D3),
                              ),
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Banners'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ResidentMerchantInventoryPage(),
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2E35D3),
                          ),
                          child: const Text('Open Merchant Inventory'),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget _summaryChip({
  required IconData icon,
  required String label,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFF6F8FF),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: const Color(0xFFDDE3F3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4051C8)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF45506E),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

Future<void> _openMerchantCategoryManager(BuildContext context) async {
  final controller = TextEditingController();
  await showModalBottomSheet<void>(
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
            final categories = _ResidentCommercialSellerHub.managedCategories;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smarketplace Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories
                      .map(
                        (category) => InputChip(
                          label: Text(category),
                          onDeleted: _merchantDefaultCategories.contains(category)
                              ? null
                              : () {
                                  _ResidentCommercialSellerHub.removeCategory(
                                    category,
                                  );
                                  setSheetState(() {});
                                },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Add product type',
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      _ResidentCommercialSellerHub.addCategory(
                        controller.text,
                      );
                      controller.clear();
                      setSheetState(() {});
                    },
                    child: const Text('Add Category'),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
  unawaited(
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      controller.dispose();
    }),
  );
}

Future<void> _openMerchantBannerManager(BuildContext context) async {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  XFile? attachment;
  await showModalBottomSheet<void>(
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
            final banners = _ResidentCommercialSellerHub.banners;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Promotional Banners',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                ...List.generate(banners.length, (index) {
                  final banner = banners[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.campaign_rounded),
                    title: Text(banner.title),
                    subtitle: Text(banner.subtitle),
                    trailing: IconButton(
                      onPressed: banners.length == 1
                          ? null
                          : () {
                              _ResidentCommercialSellerHub.removeBanner(index);
                              setSheetState(() {});
                            },
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Banner title'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: subtitleController,
                  decoration: const InputDecoration(labelText: 'Banner subtitle'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked == null) {
                      return;
                    }
                    attachment = picked;
                    setSheetState(() {});
                  },
                  icon: const Icon(Icons.image_outlined),
                  label: Text(
                    attachment == null
                        ? 'Upload Banner Asset'
                        : attachment!.name,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (titleController.text.trim().isEmpty ||
                          subtitleController.text.trim().isEmpty) {
                        return;
                      }
                      _ResidentCommercialSellerHub.addBanner(
                        _ResidentMarketplaceBannerData(
                          title: titleController.text.trim(),
                          subtitle: subtitleController.text.trim(),
                          start: const Color(0xFF3650D3),
                          end: const Color(0xFF5E7CF7),
                          attachmentName: attachment?.name,
                        ),
                      );
                      titleController.clear();
                      subtitleController.clear();
                      attachment = null;
                      setSheetState(() {});
                    },
                    child: const Text('Save Banner'),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
  unawaited(
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      titleController.dispose();
      subtitleController.dispose();
    }),
  );
}

class _CommercialGateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  const _CommercialGateCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF2F1FF),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2E35D3), size: 64),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E35D3),
                ),
                child: Text(buttonLabel.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _CommercialMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CommercialMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E6F4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4051C8), size: 20),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2D3350),
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF66708A),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

}

class ResidentCommercialRegistrationPage extends StatefulWidget {
  const ResidentCommercialRegistrationPage({super.key});

  @override
  State<ResidentCommercialRegistrationPage> createState() =>
      _ResidentCommercialRegistrationPageState();
}

class _ResidentCommercialRegistrationPageState
    extends State<ResidentCommercialRegistrationPage> {
  static const int _maxPermitBase64Chars = 1800000;
  final _businessController = TextEditingController();
  final _ownerController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _meetupController = TextEditingController(text: 'Barangay Hall Gate');
  final _permitNumberController = TextEditingController();
  String _businessType = 'Retail Store';
  XFile? _permitAttachment;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _ownerController.text = _currentResidentProfile?.displayName ?? '';
    _contactController.text = _currentResidentProfile?.mobile ?? '';
  }

  @override
  void dispose() {
    _businessController.dispose();
    _ownerController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _meetupController.dispose();
    _permitNumberController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) {
      return;
    }
    if (!_ResidentProfileVerificationHub.isVerified) {
      _showFeature(context, 'RBI verification is required before registration.');
      return;
    }
    final business = _businessController.text.trim();
    final owner = _ownerController.text.trim();
    final contact = _contactController.text.trim();
    final address = _addressController.text.trim();
    final meetup = _meetupController.text.trim();
    final permitNumber = _permitNumberController.text.trim();
    if (business.isEmpty ||
        owner.isEmpty ||
        contact.length < 11 ||
        address.length < 8 ||
        meetup.isEmpty ||
        permitNumber.length < 6 ||
        _permitAttachment == null) {
      _showFeature(context, 'Complete all business registration fields.');
      return;
    }
    setState(() => _submitting = true);
    String permitImageBase64 = '';
    try {
      final bytes = await _permitAttachment!.readAsBytes();
      if (bytes.isNotEmpty) {
        permitImageBase64 = base64Encode(bytes);
        if (permitImageBase64.length > _maxPermitBase64Chars) {
          if (!mounted) {
            return;
          }
          setState(() => _submitting = false);
          _showFeature(
            context,
            'Permit image is too large. Please choose a smaller image.',
            tone: _ToastTone.warning,
          );
          return;
        }
      }
    } catch (_) {}

    final apiResult = await _SellerApi.instance.submitMerchantRegistration(
      businessName: business,
      ownerName: owner,
      businessType: _businessType,
      contactNumber: contact,
      address: address,
      meetupSpot: meetup,
      businessPermitNumber: permitNumber,
      businessPermitFileName: _permitAttachment!.name,
      permitImageBase64: permitImageBase64,
    );
    if (!mounted) {
      return;
    }

    if (apiResult.success && apiResult.registration != null) {
      _ResidentCommercialSellerHub.replaceBusinessRegistration(apiResult.registration);
      final parentContext = Navigator.of(context).context;
      Navigator.pop(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (parentContext.mounted) {
          _showFeature(parentContext, apiResult.message);
        }
      });
      return;
    }

    final verified = permitNumber.toUpperCase().startsWith('BP-') ||
        permitNumber.length >= 10;
    _ResidentCommercialSellerHub.registerBusiness(
      _ResidentCommercialRegistrationData(
        businessName: business,
        ownerName: owner,
        businessType: _businessType,
        contactNumber: contact,
        address: address,
        meetupSpot: meetup,
        businessPermitNumber: permitNumber,
        businessPermitFileName: _permitAttachment!.name,
        merchantVerified: verified,
        verificationStatus: verified ? 'Verified' : 'Pending Review',
      ),
    );
    final parentContext = Navigator.of(context).context;
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (parentContext.mounted) {
        _showFeature(
          parentContext,
          'Saved locally only: ${apiResult.message}',
          tone: _ToastTone.warning,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Registration'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: _businessController,
            decoration: const InputDecoration(labelText: 'Business / store name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ownerController,
            decoration: const InputDecoration(labelText: 'Owner name'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _businessType,
            decoration: const InputDecoration(labelText: 'Business type'),
            items: const [
              DropdownMenuItem(value: 'Retail Store', child: Text('Retail Store')),
              DropdownMenuItem(
                value: 'Food Seller',
                child: Text('Food Seller'),
              ),
              DropdownMenuItem(
                value: 'Service Provider',
                child: Text('Service Provider'),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _businessType = value);
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contactController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Contact number'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Business address'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _meetupController,
            decoration: const InputDecoration(labelText: 'Seller meetup spot'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _permitNumberController,
            decoration: const InputDecoration(
              labelText: 'Barangay business permit number',
              hintText: 'Example: BP-2026-00041',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                maxWidth: 1600,
                maxHeight: 1600,
                imageQuality: 70,
              );
              if (picked == null) {
                return;
              }
              setState(() => _permitAttachment = picked);
            },
            icon: const Icon(Icons.badge_outlined),
            label: Text(
              _permitAttachment == null
                  ? 'Upload Business Permit'
                  : _permitAttachment!.name,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E6F4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user_rounded, color: Color(0xFF3B63C7)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Merchant verification requires a valid barangay business permit upload.',
                    style: TextStyle(
                      color: Color(0xFF5D6580),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: FilledButton(
            onPressed: _submitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E35D3),
            ),
            child: Text(_submitting ? 'Submitting...' : 'Submit Registration'),
          ),
        ),
      ),
    );
  }
}

class ResidentMerchantInventoryPage extends StatelessWidget {
  const ResidentMerchantInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Inventory'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _ResidentCommercialSellerHub.refresh,
        builder: (_, __, ___) {
          final items = _ResidentCommercialSellerHub.inventoryProducts;
          final registration = _ResidentCommercialSellerHub.registration;
          final sellerName = registration?.businessName ?? 'Commercial Seller';
          final salesValue = _ResidentCommercialSellerHub.salesValueForSeller(
            sellerName,
          );
          final salesCount = _ResidentCommercialSellerHub.salesCountForSeller(
            sellerName,
          );
          final orderCount = _ResidentCommercialSellerHub.orderCountForSeller(
            sellerName,
          );
          final quoteCount = _ResidentCommercialSellerHub.bidRequests
              .where((item) => item.sellerName == sellerName)
              .length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE4E7F3)),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _summaryChip(
                      icon: Icons.payments_outlined,
                      label: 'Sales PHP ${salesValue.toStringAsFixed(0)}',
                    ),
                    _summaryChip(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Units $salesCount',
                    ),
                    _summaryChip(
                      icon: Icons.fact_check_outlined,
                      label: 'Orders $orderCount',
                    ),
                    _summaryChip(
                      icon: Icons.gavel_rounded,
                      label: 'Quotes $quoteCount',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (items.isEmpty)
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.inventory_2_outlined),
                    title: Text('No inventory yet'),
                    subtitle: Text('Add your first product listing.'),
                  ),
                )
              else
                ...List.generate(items.length, (i) {
                  final item = items[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E7F3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8ECFF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: _buildMarketProductImage(
                              source: item.imageAsset,
                              fallbackIcon: item.icon,
                              fit: BoxFit.cover,
                              fallbackBuilder: () => Icon(
                                item.icon,
                                color: const Color(0xFF4254C8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2F344A),
                                ),
                              ),
                              Text(
                                'PHP ${item.price.toStringAsFixed(2)} | Stock ${item.stock}',
                                style: const TextStyle(
                                  color: Color(0xFF66708A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (registration?.merchantVerified == true)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.verified_rounded,
                                        size: 14,
                                        color: Color(0xFF3C78E3),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Verified merchant listing',
                                        style: TextStyle(
                                          color: Color(0xFF3C78E3),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResidentCommercialAddProductPage(
                                editIndex: i,
                                existingProduct: item,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            _ResidentCommercialSellerHub.deleteInventoryProduct(i);
                            _showFeature(
                              context,
                              '${item.title} removed from inventory.',
                            );
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ResidentCommercialAddProductPage(),
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E35D3),
            ),
            icon: const Icon(Icons.add_business_rounded),
            label: const Text('Add Product'),
          ),
        ),
      ),
    );
  }
}

class ResidentCommercialAddProductPage extends StatefulWidget {
  final int? editIndex;
  final _ResidentProductData? existingProduct;

  const ResidentCommercialAddProductPage({
    super.key,
    this.editIndex,
    this.existingProduct,
  });

  @override
  State<ResidentCommercialAddProductPage> createState() =>
      _ResidentCommercialAddProductPageState();
}

class _ResidentCommercialAddProductPageState
    extends State<ResidentCommercialAddProductPage> {
  static const int _maxThumbnailBytes = 2 * 1024 * 1024;
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _originalPriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _etaController;
  XFile? _thumbnailAttachment;
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingProduct;
    _nameController = TextEditingController(text: existing?.title ?? '');
    _categoryController = TextEditingController(
      text: existing?.category ?? 'Retail',
    );
    _descriptionController = TextEditingController(
      text: existing?.description ?? '',
    );
    _priceController = TextEditingController(
      text: existing == null ? '' : existing.price.toStringAsFixed(0),
    );
    _originalPriceController = TextEditingController(
      text: existing?.originalPrice?.toStringAsFixed(0) ?? '',
    );
    _stockController = TextEditingController(
      text: existing == null ? '' : '${existing.stock}',
    );
    _etaController = TextEditingController(
      text: existing?.eta ?? 'Pickup at Brgy Hall today',
    );
    if (existing != null && existing.imageAsset.startsWith('data:image')) {
      try {
        final comma = existing.imageAsset.indexOf(',');
        if (comma > -1 && comma < existing.imageAsset.length - 1) {
          _thumbnailBytes = base64Decode(existing.imageAsset.substring(comma + 1));
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _stockController.dispose();
    _etaController.dispose();
    super.dispose();
  }

  String _thumbnailMimeType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) {
      return 'image/png';
    }
    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }
    if (lower.endsWith('.gif')) {
      return 'image/gif';
    }
    return 'image/jpeg';
  }

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1400,
      maxHeight: 1400,
    );
    if (picked == null || !mounted) {
      return;
    }
    try {
      final bytes = await picked.readAsBytes();
      if (bytes.isEmpty) {
        _showFeature(context, 'Selected image is empty.', tone: _ToastTone.warning);
        return;
      }
      if (bytes.length > _maxThumbnailBytes) {
        _showFeature(
          context,
          'Thumbnail is too large. Please use an image below 2 MB.',
          tone: _ToastTone.warning,
        );
        return;
      }
      setState(() {
        _thumbnailAttachment = picked;
        _thumbnailBytes = bytes;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showFeature(
        context,
        'Unable to read thumbnail image.',
        tone: _ToastTone.warning,
      );
    }
  }

  Future<void> _save() async {
    final registration = _ResidentCommercialSellerHub.registration;
    final title = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final original = double.tryParse(_originalPriceController.text.trim());
    final stock = int.tryParse(_stockController.text.trim());
    final eta = _etaController.text.trim();
    if (registration == null) {
      _showFeature(context, 'Register your business first.');
      return;
    }
    if (title.isEmpty ||
        category.isEmpty ||
        description.length < 8 ||
        price == null ||
        stock == null ||
        stock < 1 ||
        eta.isEmpty) {
      _showFeature(
        context,
        'Please complete all fields. Product description must be at least 8 characters.',
      );
      return;
    }
    if (widget.editIndex == null && _thumbnailBytes == null) {
      _showFeature(
        context,
        'Please choose a product thumbnail.',
        tone: _ToastTone.warning,
      );
      return;
    }
    final sellerZone = widget.existingProduct?.sellerZone ?? _marketDeliveryZones.first;
    final sellerPurok = widget.existingProduct?.sellerPurok ?? _marketDeliveryPuroks.first;
    final thumbnailBase64 = _thumbnailBytes == null
        ? ''
        : base64Encode(_thumbnailBytes!);
    final thumbnailFileName = _thumbnailAttachment?.name ?? '';

    final apiResult = await _SellerApi.instance.submitMarketProduct(
      title: title,
      category: category,
      description: description,
      price: price,
      originalPrice: original,
      stock: stock,
      eta: eta,
      sellerZone: sellerZone,
      sellerPurok: sellerPurok,
      thumbnailBase64: thumbnailBase64,
      thumbnailFileName: thumbnailFileName,
    );

    if (!mounted) {
      return;
    }
    if (apiResult.success) {
      final refreshed = await _SellerApi.instance.fetchMarketProducts();
      if (refreshed.success) {
        _ResidentCommercialSellerHub.replaceInventoryProducts(refreshed.products);
      } else if (apiResult.product != null) {
        _ResidentCommercialSellerHub.saveInventoryProduct(
          apiResult.product!,
          editIndex: widget.editIndex,
        );
      }
      if (!mounted) {
        return;
      }
      final parentContext = Navigator.of(context).context;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResidentCommercialSavedPage()),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (parentContext.mounted) {
          _showFeature(parentContext, apiResult.message, tone: _ToastTone.success);
        }
      });
      return;
    }

    final localImageAsset = _thumbnailBytes == null
        ? _merchantProductAsset(category)
        : 'data:${_thumbnailMimeType(thumbnailFileName)};base64,$thumbnailBase64';

    _ResidentCommercialSellerHub.saveInventoryProduct(
      _ResidentProductData(
        title: title,
        seller: registration.businessName,
        price: price,
        originalPrice: original,
        icon: _merchantProductIcon(category),
        imageAsset: localImageAsset,
        description: description,
        category: category,
        rating: widget.existingProduct?.rating ?? 4.8,
        reviews: widget.existingProduct?.reviews ?? 0,
        sold: widget.existingProduct?.sold ?? 0,
        stock: stock,
        eta: eta,
        verified: registration.merchantVerified,
        sellerZone: sellerZone,
        sellerPurok: sellerPurok,
      ),
      editIndex: widget.editIndex,
    );
    final parentContext = Navigator.of(context).context;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ResidentCommercialSavedPage()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (parentContext.mounted) {
        _showFeature(
          parentContext,
          'Saved locally only: ${apiResult.message}',
          tone: _ToastTone.warning,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editIndex == null ? 'Add New Product' : 'Edit Product'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Product name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _categoryController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Product category',
              suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
            ),
            onTap: () async {
              final selected = await showModalBottomSheet<String>(
                context: context,
                builder: (sheetContext) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      ..._ResidentCommercialSellerHub.managedCategories.map(
                        (category) => ListTile(
                          title: Text(category),
                          onTap: () => Navigator.pop(sheetContext, category),
                        ),
                      ),
                    ],
                  );
                },
              );
              if (selected == null) {
                return;
              }
              setState(() => _categoryController.text = selected);
            },
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _openMerchantCategoryManager(context),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Manage Categories'),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E6F4)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: _thumbnailBytes != null
                        ? Image.memory(_thumbnailBytes!, fit: BoxFit.cover)
                        : const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFE8EAFF), Color(0xFFF4F5FF)],
                              ),
                            ),
                            child: Icon(
                              Icons.photo_size_select_actual_rounded,
                              color: Color(0xFF4A55C8),
                              size: 28,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product thumbnail',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C3552),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _thumbnailAttachment?.name ?? 'No image selected',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF69728D),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: _pickThumbnail,
                  child: const Text('Choose'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Product description'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Selling price'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _originalPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Original price'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Product stock'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _etaController,
            decoration: const InputDecoration(
              labelText: 'Availability / fulfillment note',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E6F4)),
            ),
            child: Row(
              children: [
                Icon(
                  _ResidentCommercialSellerHub.registration?.merchantVerified == true
                      ? Icons.verified_rounded
                      : Icons.schedule_rounded,
                  color: _ResidentCommercialSellerHub.registration?.merchantVerified ==
                          true
                      ? const Color(0xFF3C78E3)
                      : const Color(0xFFB86919),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _ResidentCommercialSellerHub.registration?.merchantVerified ==
                            true
                        ? 'This product will display the verified merchant badge.'
                        : 'This product will stay unverified until the business permit is approved.',
                    style: const TextStyle(
                      color: Color(0xFF5D6580),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E35D3),
            ),
            child: Text(
              widget.editIndex == null ? 'Save Product' : 'Update Product',
            ),
          ),
        ),
      ),
    );
  }
}

class ResidentCommercialSavedPage extends StatelessWidget {
  const ResidentCommercialSavedPage({super.key});

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
              'Success',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const Text('Your product has been saved to your inventory.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ResidentMerchantInventoryPage(),
                  ),
                  (route) => route.isFirst,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E35D3),
                ),
                child: const Text('View My Inventory'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResidentMerchantBidPage extends StatefulWidget {
  final _ResidentProductData item;

  const ResidentMerchantBidPage({
    super.key,
    required this.item,
  });

  @override
  State<ResidentMerchantBidPage> createState() => _ResidentMerchantBidPageState();
}

class _ResidentMerchantBidPageState extends State<ResidentMerchantBidPage> {
  late final TextEditingController _contactController;
  late final TextEditingController _offerController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _contactController = TextEditingController(text: '09123456789');
    _offerController = TextEditingController(
      text: widget.item.price.toStringAsFixed(0),
    );
    _noteController = TextEditingController(
      text: 'Available for barangay procurement and local delivery coordination.',
    );
  }

  @override
  void dispose() {
    _contactController.dispose();
    _offerController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_offerController.text.trim());
    if (_contactController.text.trim().length < 11 ||
        amount == null ||
        amount <= 0 ||
        _noteController.text.trim().length < 8) {
      _showFeature(context, 'Complete the quote amount, contact, and note.');
      return;
    }
    _ResidentCommercialSellerHub.addBidRequest(
      _ResidentBarangayQuoteData(
        id: 'BID-${DateTime.now().millisecondsSinceEpoch % 100000}',
        productTitle: widget.item.title,
        sellerName: widget.item.seller,
        contactNumber: _contactController.text.trim(),
        offerAmount: amount,
        note: _noteController.text.trim(),
        createdAt: DateTime.now(),
      ),
    );
    Navigator.pop(context);
    _showFeature(context, 'Bid / quote submitted to the barangay procurement desk.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barangay Bid / Quote'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE8ECFF),
              child: Icon(widget.item.icon, color: const Color(0xFF4254C8)),
            ),
            title: Text(
              widget.item.title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('Seller: ${widget.item.seller}'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contactController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Contact number'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _offerController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Quoted amount',
              prefixText: 'PHP ',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Bid note',
              hintText: 'Availability, lead time, inclusions, and delivery notes',
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: FilledButton.icon(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF6B3E),
            ),
            icon: const Icon(Icons.gavel_rounded),
            label: const Text('Submit Quote'),
          ),
        ),
      ),
    );
  }
}

class ResidentGovSellPage extends StatelessWidget {
  const ResidentGovSellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _ResidentGovProcureHub.refresh,
      builder: (_, __, ___) {
        final count = _ResidentGovProcureHub.submissions.length;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE1E5F5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _govMetric(
                      icon: Icons.folder_copy_rounded,
                      label: 'Required Docs',
                      value: '5',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _govMetric(
                      icon: Icons.pending_actions_rounded,
                      label: 'Submitted',
                      value: '$count',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _govMetric(
                      icon: Icons.schedule_rounded,
                      label: 'Review Time',
                      value: '2-5 days',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _govActionCard(
              context,
              icon: Icons.notifications_active_rounded,
              title: 'Eligibility Requirements',
              subtitle:
                  'Review document checklist and compliance before registration.',
              stepLabel: 'Step 1',
              accent: const Color(0xFF3B4EC1),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ResidentGovRegistrationNoticePage(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _govActionCard(
              context,
              icon: Icons.assignment_rounded,
              title: 'Business Registration',
              subtitle: count == 0
                  ? 'My Submissions and GovProcure form'
                  : '$count submission(s) tracked in My Submissions',
              stepLabel: 'Step 2',
              accent: const Color(0xFF3B4EC1),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ResidentGovRegistrationPage(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _govMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF8FAFF),
        border: Border.all(color: const Color(0xFFE2E6F4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4051C8), size: 20),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2D3350),
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF66708A),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _govActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String stepLabel,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E5F3)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: accent.withValues(alpha: 0.12),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF2E334A),
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF0FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            stepLabel,
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF65708A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF6D7694)),
            ],
          ),
        ),
      ),
    );
  }
}

class ResidentGovRegistrationPage extends StatelessWidget {
  const ResidentGovRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Submissions'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _ResidentGovProcureHub.refresh,
        builder: (_, __, ___) {
          final items = _ResidentGovProcureHub.submissions;
          return Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.hourglass_empty_rounded,
                              size: 44,
                              color: Color(0xFF4252C7),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No Applications yet',
                              style: TextStyle(
                                color: Color(0xFF2F344B),
                                fontWeight: FontWeight.w700,
                                fontSize: 19,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final item = items[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE4E7F3),
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFE8ECFF),
                                ),
                                child: const Icon(
                                  Icons.assignment_turned_in_rounded,
                                  color: Color(0xFF3F50C5),
                                ),
                              ),
                              title: Text(
                                item.companyName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2F344A),
                                ),
                              ),
                              subtitle: Text(
                                '${item.referenceNo} | ${item.submittedDate} | ${item.status}',
                                style: const TextStyle(
                                  color: Color(0xFF66708A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: () => _showFeature(
                                context,
                                'Opening ${item.referenceNo} details',
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResidentGovFormPage(),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2E35D3),
                        ),
                        child: const Text('Submit application'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResidentHomeShell(),
                          ),
                          (route) => false,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2E35D3),
                        ),
                        child: const Text('Return to Home'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: items.isEmpty
                            ? null
                            : () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ResidentSellHubPage(initialTab: 0),
                                ),
                              ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2E35D3),
                        ),
                        child: const Text('Go to Seller Dashboard'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ResidentGovFormPage extends StatefulWidget {
  const ResidentGovFormPage({super.key});

  @override
  State<ResidentGovFormPage> createState() => _ResidentGovFormPageState();
}

class _ResidentGovFormPageState extends State<ResidentGovFormPage> {
  final _companyController = TextEditingController(text: 'Apple Inc.');
  final _emailController = TextEditingController(text: 'apple@email.com');
  final _mobileController = TextEditingController(text: '91200011234');
  final _landlineController = TextEditingController(text: '02-1234-5678');
  final _addressController = TextEditingController();
  final _ownerController = TextEditingController(text: 'Shamira Balandra');
  final _tinController = TextEditingController(text: '123-456-789-000');
  bool _logoAttached = false;

  @override
  void dispose() {
    _companyController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _landlineController.dispose();
    _addressController.dispose();
    _ownerController.dispose();
    _tinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GovProcure - Registration'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Company Details',
            style: TextStyle(
              color: Color(0xFF2E334A),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _companyController,
            decoration: const InputDecoration(labelText: 'Company Name'),
          ),
          SizedBox(height: 8),
          const Text(
            'Logo',
            style: TextStyle(
              color: Color(0xFF2F344A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _logoAttached = !_logoAttached),
            child: Container(
              height: 112,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC7CFF5)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _logoAttached
                          ? Icons.check_circle_rounded
                          : Icons.add_photo_alternate_rounded,
                      color: _logoAttached
                          ? const Color(0xFF35A46E)
                          : const Color(0xFF7A83A7),
                      size: 34,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _logoAttached
                          ? 'Logo attached successfully'
                          : 'Upload an image (Max file size: 50 MB)',
                      style: const TextStyle(
                        color: Color(0xFF6A718B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email Address'),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _mobileController,
            decoration: const InputDecoration(
              labelText: 'Contact Number (Mobile)',
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _landlineController,
            decoration: const InputDecoration(
              labelText: 'Contact Number (Landline)',
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Business Address'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _ownerController,
            decoration: const InputDecoration(
              labelText: 'Authorized Representative',
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _tinController,
            decoration: const InputDecoration(labelText: 'TIN Number'),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE3E6F3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Requirements Checklist',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2F334A),
                  ),
                ),
                SizedBox(height: 6),
                _GovRegistrationChecklist(text: 'SEC / DTI Registration'),
                _GovRegistrationChecklist(text: 'Mayor\'s Permit'),
                _GovRegistrationChecklist(text: 'Tax Clearance (BIR)'),
                _GovRegistrationChecklist(text: 'PhilGEPS Registration'),
                _GovRegistrationChecklist(text: 'Omnibus Sworn Statement'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton(
          onPressed: () {
            final company = _companyController.text.trim();
            final email = _emailController.text.trim();
            final mobile = _mobileController.text.trim();
            final address = _addressController.text.trim();
            if (company.isEmpty ||
                email.isEmpty ||
                mobile.length < 10 ||
                address.length < 8) {
              _showFeature(
                context,
                'Please complete company, contact, and address details.',
              );
              return;
            }
            _ResidentGovProcureHub.addSubmission(
              companyName: company,
              email: email,
              mobile: mobile,
              landline: _landlineController.text.trim(),
              address: address,
            );
            Navigator.pop(context);
            _showFeature(context, 'Gov registration submitted for review.');
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2E35D3),
          ),
          child: const Text('Submit Registration'),
        ),
      ),
    );
  }
}

class ResidentGovRegistrationNoticePage extends StatelessWidget {
  const ResidentGovRegistrationNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchants Profile'),
        backgroundColor: const Color(0xFF2D36A8),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF4F6FF), Color(0xFFF0ECFF)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE0E4F5)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 106,
                    height: 106,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFDCE2FF), Color(0xFFEEF1FF)],
                      ),
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Color(0xFF3C4DC1),
                      size: 62,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Eligibility Requirements',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3350),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'To sell to the government, submit required business documents for compliance checking. Approval is required before bidding.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF666F8B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResidentGovRegistrationPage(),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E35D3),
                      ),
                      child: const Text('Go to Registration Page'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResidentSellGovInfoPage(),
                        ),
                      ),
                      child: const Text('View Sell to Government Info'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResidentGovProcureHub {
  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  static final List<_GovRegistrationSubmission> submissions = [];

  static void addSubmission({
    required String companyName,
    required String email,
    required String mobile,
    required String landline,
    required String address,
  }) {
    final ref = 'GOV-${DateTime.now().millisecondsSinceEpoch % 1000000}';
    submissions.insert(
      0,
      _GovRegistrationSubmission(
        referenceNo: ref,
        companyName: companyName,
        email: email,
        mobile: mobile,
        landline: landline,
        address: address,
        status: 'Under Review',
        submittedDate:
            '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
      ),
    );
    refresh.value++;
  }
}

class _GovRegistrationSubmission {
  final String referenceNo;
  final String companyName;
  final String email;
  final String mobile;
  final String landline;
  final String address;
  final String status;
  final String submittedDate;

  const _GovRegistrationSubmission({
    required this.referenceNo,
    required this.companyName,
    required this.email,
    required this.mobile,
    required this.landline,
    required this.address,
    required this.status,
    required this.submittedDate,
  });
}

class _GovRegistrationChecklist extends StatelessWidget {
  final String text;
  const _GovRegistrationChecklist({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 17,
            color: Color(0xFF3C4EC1),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF4A516D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResidentSellGovInfoPage extends StatelessWidget {
  const ResidentSellGovInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell to Gov Information'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FF), Color(0xFFF8F0EE)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3343B2), Color(0xFF6574E2)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x262E35D3),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sell your products to the government',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'BarangayMo helps local entrepreneurs enter government procurement opportunities.',
                          style: TextStyle(color: Color(0xFFDCE1FF)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.account_balance, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5E8F5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.folder_copy, color: Color(0xFF3E4CC4)),
                      SizedBox(width: 8),
                      Text(
                        'Required Documents',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3044),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _GovBullet(text: 'PhilGEPS Registration'),
                  _GovBullet(text: 'Valid Business Permit'),
                  _GovBullet(text: 'NFCC / Financial Capacity'),
                  _GovBullet(text: 'Latest Tax Clearance'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5E8F5)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.alt_route, color: Color(0xFF3E4CC4)),
                      SizedBox(width: 8),
                      Text(
                        'Application Process',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3044),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _GovStep(
                    number: 1,
                    title: 'Registration',
                    subtitle: 'Create and verify your seller account.',
                  ),
                  _GovStep(
                    number: 2,
                    title: 'Submission',
                    subtitle: 'Submit required documents and product details.',
                  ),
                  _GovStep(
                    number: 3,
                    title: 'Verification',
                    subtitle: 'Compliance and eligibility checks by LGU.',
                  ),
                  _GovStep(
                    number: 4,
                    title: 'Approval',
                    subtitle: 'Receive notice and start bid participation.',
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

class _GovBullet extends StatelessWidget {
  final String text;
  const _GovBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF3FA96D), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF3A3D54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GovStep extends StatelessWidget {
  final int number;
  final String title;
  final String subtitle;
  const _GovStep({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: const Color(0xFFE4E8FF),
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF3946B3),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E3146),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF646A86),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
