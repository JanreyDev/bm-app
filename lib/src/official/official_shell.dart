part of barangaymo_app;

const _officialHeaderStart = Color(0xFF9F1A1A);
const _officialHeaderEnd = Color(0xFFC92A2A);
const _officialSurface = Color(0xFFF5F6FB);
const _officialCardBorder = Color(0xFFE4E7F1);
const _officialText = Color(0xFF252A3D);
const _officialSubtext = Color(0xFF636A82);
const _officialSoftAccent = Color(0xFFFFEAEA);
const _officialSurfaceBlend = Color(0xFFF3ECEC);
const _officialHeroSubtext = Color(0xFFFFD8D8);

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  final pages = const [
    _OfficialHomePage(),
    _SimplePage(
      'Official',
      [
        'Council Agenda: Regular session on Monday at 9:00 AM',
        'Pending Approvals: 12 permit and endorsement requests',
        'Public Notices: 4 active postings this week',
        'Scheduled Hearings: 3 mediation cases this week',
      ],
      icon: Icons.account_balance,
      subtitle: 'Governance operations and council updates',
    ),
    _SimplePage(
      'Market',
      [
        'Marketplace Vendors: 118 registered stalls',
        'Today\'s Transactions: 64 logged as of 8:00 PM',
        'Top Category: Fresh produce and dry goods',
        'Delivery Requests: 23 pending rider pickups',
      ],
      icon: Icons.storefront_rounded,
      subtitle: 'Local commerce, inventory, and transaction pulse',
    ),
    SerbilisServicesPage(),
    _SimplePage(
      'Profile',
      [
        'Account Name: Barangay Official',
        'Office: Barangay Administration',
        'Role: Records and Services',
        'Status: Active',
      ],
      icon: Icons.person,
      subtitle: 'Personal and account management overview',
    ),
  ];

  @override
  void initState() {
    super.initState();
    unawaited(_syncScopedBarangayBranding(force: true));
  }

  @override
  Widget build(BuildContext context) {
    final liveBarangay = _officialEditableProfile.value.barangay.trim();
    final barangayTitle = liveBarangay.isEmpty
        ? 'Barangay Profile'
        : '$liveBarangay Barangay Profile';
    final barangayLocation =
        '${_officialBarangaySetup.city}, ${_officialBarangaySetup.province}';

    return Scaffold(
      backgroundColor: _officialSurface,
      appBar: AppBar(
        title: const _BarangayMoLogo(width: 145),
        backgroundColor: _officialHeaderStart,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_officialHeaderStart, _officialHeaderEnd],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OfficialNotificationsPage(),
              ),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFFCFCFF),
        child: Builder(
          builder: (drawerContext) => ListView(
            padding: EdgeInsets.only(
              bottom: 12 + MediaQuery.of(drawerContext).padding.bottom,
            ),
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_officialHeaderStart, _officialHeaderEnd],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BarangayMoLogo(width: 150),
                    SizedBox(height: 10),
                    Text(
                      'Barangay Officials',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Administrative tools and governance controls',
                      style: TextStyle(
                        color: Color(0xFFFDE5E5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _officialCardBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEFEA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.location_city,
                        color: _officialHeaderStart,
                      ),
                    ),
                    title: Text(
                      barangayTitle,
                      style: TextStyle(
                        color: _officialText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      barangayLocation,
                      style: TextStyle(
                        color: _officialSubtext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OfficialBarangayProfilePage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(14, 2, 14, 6),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _m(context, 'Barangay Activation'),
              _m(context, 'Barangay Setup'),
              _m(context, 'Transaction History'),
              _m(context, 'Settings'),
              _m(context, 'RBI Records'),
              _m(context, 'FAQs'),
              _m(context, 'Notifications'),
              _m(context, 'Support'),
              _m(context, 'Bug Report'),
              _m(context, 'Terms & Policies'),
              _m(context, 'Log out'),
              _m(context, 'Delete Account', color: const Color(0xFFCD3D3D)),
            ],
          ),
        ),
      ),
      body: pages[tab],
      floatingActionButton: tab == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFBD1F1F),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const _OfficialFeedbackQuickSheet(),
              ),
              child: const Icon(Icons.rate_review_outlined, color: Colors.white),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        indicatorColor: const Color(0xFFFFE2DD),
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.shield), label: 'Official'),
          NavigationDestination(icon: Icon(Icons.store), label: 'Market'),
          NavigationDestination(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Services',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(backgroundColor: _officialHeaderStart),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !context.mounted) {
      return;
    }

    final mobile = _currentOfficialMobile;
    await _AuthApi.instance.logout();
    if (mobile != null && mobile.isNotEmpty) {
      await _OfficialAuthCacheStore.clear(mobile);
    }
    _authToken = null;
    _currentOfficialMobile = null;
    _officialActivationCompleted = false;

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleGatewayScreen()),
      (_) => false,
    );
  }

  IconData _menuIcon(String title) {
    switch (title) {
      case 'Settings':
        return Icons.settings;
      case 'Barangay Profile':
        return Icons.location_city;
      case 'Barangay Activation':
        return Icons.verified_user_outlined;
      case 'Barangay Setup':
        return Icons.location_city_outlined;
      case 'RBI Records':
        return Icons.badge_outlined;
      case 'Transaction History':
        return Icons.history_outlined;
      case 'FAQs':
        return Icons.quiz_outlined;
      case 'Notifications':
        return Icons.notifications_none;
      case 'Support':
        return Icons.support_agent;
      case 'Bug Report':
        return Icons.bug_report_outlined;
      case 'Terms & Policies':
        return Icons.gavel_outlined;
      case 'Log out':
        return Icons.logout;
      case 'Delete Account':
        return Icons.delete_outline;
      default:
        return Icons.arrow_right;
    }
  }

  Widget _m(BuildContext c, String t, {Color? color}) {
    final isDanger = color != null;
    final tileColor = isDanger ? const Color(0xFFFFF0F0) : Colors.white;
    final textColor = color ?? _officialText;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDanger ? const Color(0xFFFFD0D0) : _officialCardBorder,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          dense: true,
          leading: Icon(_menuIcon(t), color: textColor),
          title: Text(
            t,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
          ),
          trailing: Icon(Icons.chevron_right, color: textColor),
          onTap: () async {
            Navigator.pop(c);
            switch (t) {
              case 'Barangay Profile':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialBarangayProfilePage(),
                  ),
                );
                return;
              case 'Barangay Activation':
                if (_officialActivationCompleted) {
                  ScaffoldMessenger.of(c).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Barangay activation is already completed. Setup is now read-only for regular officials.',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ActivationFlow(goToHomeOnFinish: false),
                  ),
                );
                return;
              case 'Barangay Setup':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialBarangaySetupPage(),
                  ),
                );
                return;
              case 'Settings':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialSettingsPage(),
                  ),
                );
                return;
              case 'RBI Records':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialRbiRecordsPage(),
                  ),
                );
                return;
              case 'Transaction History':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const _TransactionHistoryPage(
                      role: UserRole.official,
                    ),
                  ),
                );
                return;
              case 'FAQs':
                Navigator.push(
                  c,
                  MaterialPageRoute(builder: (_) => const OfficialFaqsPage()),
                );
                return;
              case 'Notifications':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialNotificationsPage(),
                  ),
                );
                return;
              case 'Support':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialSupportPage(),
                  ),
                );
                return;
              case 'Bug Report':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialBugReportPage(),
                  ),
                );
                return;
              case 'Terms & Policies':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialTermsPoliciesPage(),
                  ),
                );
                return;
              case 'Log out':
                await _performLogout(c);
                return;
              case 'Delete Account':
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => const OfficialDeleteAccountPage(),
                  ),
                );
                return;
              default:
                Navigator.push(
                  c,
                  MaterialPageRoute(builder: (_) => DetailPage(title: t)),
                );
            }
          },
        ),
      ),
    );
  }
}

class _OfficialHomeSnapshot {
  final int totalPopulation;
  final int rbiCount;
  final int pendingRequests;
  final int totalRequests;
  final int marketProductCount;
  final int verifiedMarketProductCount;
  final int communityPostCount;
  final _CommunityPost? latestPost;
  final DateTime syncedAt;
  final String warningMessage;

  const _OfficialHomeSnapshot({
    required this.totalPopulation,
    required this.rbiCount,
    required this.pendingRequests,
    required this.totalRequests,
    required this.marketProductCount,
    required this.verifiedMarketProductCount,
    required this.communityPostCount,
    required this.latestPost,
    required this.syncedAt,
    required this.warningMessage,
  });

  factory _OfficialHomeSnapshot.initial() {
    return _OfficialHomeSnapshot(
      totalPopulation: 0,
      rbiCount: 0,
      pendingRequests: 0,
      totalRequests: 0,
      marketProductCount: 0,
      verifiedMarketProductCount: 0,
      communityPostCount: 0,
      latestPost: null,
      syncedAt: DateTime.now(),
      warningMessage: '',
    );
  }
}

class _OfficialHomePage extends StatefulWidget {
  const _OfficialHomePage();

  @override
  State<_OfficialHomePage> createState() => _OfficialHomePageState();
}

class _OfficialHomePageState extends State<_OfficialHomePage> {
  _OfficialHomeSnapshot _snapshot = _OfficialHomeSnapshot.initial();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refreshDashboard(showLoading: true);
  }

  Future<void> _refreshDashboard({bool showLoading = false}) async {
    if (showLoading && mounted) {
      setState(() => _loading = true);
    }

    final summaryFuture = _fetchOfficialSummaryFromBackend();
    final requestsFuture = _ServiceRequestApi.instance.fetchRequests();
    final productsFuture = _SellerApi.instance.fetchMarketProducts();
    final postsFuture = _CommunityApi.instance.fetchPosts();
    final populationFuture = _fetchPopulationFromBackend();

    final summary = await summaryFuture;
    final requestsResult = await requestsFuture;
    final productsResult = await productsFuture;
    final postsResult = await postsFuture;
    final population = await populationFuture;

    final summaryPopulation = _readSummaryInt(summary, [
      ['population'],
      ['summary', 'population'],
      ['population', 'estimated'],
      ['population', 'registered_residents'],
      ['metrics', 'population'],
    ]);
    final summaryPendingRequests = _readSummaryInt(summary, [
      ['pending_requests'],
      ['requests_pending'],
      ['summary', 'pending_requests'],
      ['summary', 'requests_pending'],
      ['requests', 'pending'],
      ['metrics', 'pending_requests'],
    ]);
    final summaryTotalRequests = _readSummaryInt(summary, [
      ['total_requests'],
      ['requests_total'],
      ['summary', 'total_requests'],
      ['summary', 'requests_total'],
      ['requests', 'total'],
      ['metrics', 'total_requests'],
    ]);
    final summaryMarketProducts = _readSummaryInt(summary, [
      ['market_product_count'],
      ['market_products'],
      ['summary', 'market_products'],
      ['summary', 'market_products_total'],
      ['marketplace', 'products'],
      ['metrics', 'market_products'],
    ]);
    final summaryVerifiedListings = _readSummaryInt(summary, [
      ['verified_market_product_count'],
      ['verified_market_products'],
      ['summary', 'verified_market_products'],
      ['summary', 'market_products_verified'],
      ['marketplace', 'verified_products'],
      ['metrics', 'verified_market_products'],
    ]);
    final summaryCommunityPosts = _readSummaryInt(summary, [
      ['community_post_count'],
      ['community_posts'],
      ['summary', 'community_posts'],
      ['summary', 'community_posts_total'],
      ['community', 'posts'],
      ['metrics', 'community_posts'],
    ]);
    final summaryRbiCount = _readSummaryInt(summary, [
      ['rbi_count'],
      ['verified_rbi_count'],
      ['registered_residents'],
      ['summary', 'rbi_count'],
      ['summary', 'verified_rbi_count'],
      ['summary', 'registered_residents'],
      ['metrics', 'rbi_count'],
    ]);

    final warnings = <String>[];
    final requests = requestsResult.success ? requestsResult.entries : const <_ResidentRequestEntry>[];
    if (!requestsResult.success && summaryPendingRequests == null && summaryTotalRequests == null) {
      warnings.add('Requests');
    }
    final marketProducts = productsResult.success ? productsResult.products : const <_ResidentProductData>[];
    if (!productsResult.success && summaryMarketProducts == null && summaryVerifiedListings == null) {
      warnings.add('Marketplace');
    }
    final posts = postsResult.success ? postsResult.posts : const <_CommunityPost>[];
    if (!postsResult.success && summaryCommunityPosts == null) {
      warnings.add('Community');
    }
    if (population == null && summaryPopulation == null) {
      warnings.add('Population');
    }

    final pendingRequests = summaryPendingRequests ??
        requests.where((entry) => entry.status.toLowerCase().contains('pending')).length;
    final totalRequests = summaryTotalRequests ?? requests.length;
    final marketProductCount = summaryMarketProducts ?? marketProducts.length;
    final verifiedListings =
        summaryVerifiedListings ?? marketProducts.where((item) => item.verified).length;
    final communityPostCount = summaryCommunityPosts ?? posts.length;
    final rbiCount = summaryRbiCount ?? _ResidentRbiStore.all.value.length;

    final sortedPosts = [...posts]..sort((a, b) => b.postedAt.compareTo(a.postedAt));
    final latestWithPhoto = sortedPosts.cast<_CommunityPost?>().firstWhere(
      (post) => post?.photoBytes != null,
      orElse: () => null,
    );
    final previewPost = latestWithPhoto ?? (sortedPosts.isEmpty ? null : sortedPosts.first);
    final computedPopulation =
        summaryPopulation ?? population ?? _ResidentRbiStore.all.value.length;
    final warningMessage = warnings.isEmpty
        ? ''
        : 'Partial sync: ${warnings.join(', ')} unavailable.';

    if (!mounted) {
      return;
    }
    setState(() {
      _snapshot = _OfficialHomeSnapshot(
        totalPopulation: computedPopulation,
        rbiCount: rbiCount,
        pendingRequests: pendingRequests,
        totalRequests: totalRequests,
        marketProductCount: marketProductCount,
        verifiedMarketProductCount: verifiedListings,
        communityPostCount: communityPostCount,
        latestPost: previewPost,
        syncedAt: DateTime.now(),
        warningMessage: warningMessage,
      );
      _loading = false;
    });
  }

  Widget _sectionHeader(
    BuildContext context,
    String title, {
    required VoidCallback onViewAll,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _officialText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              color: _officialHeaderEnd,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
    required String note,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _officialCardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: _officialSubtext),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF5E647C),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value.replaceAll('\n', ' '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _officialHeaderStart,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          Text(
            note,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _officialSubtext,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceShortcut(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        width: 88,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _officialCardBorder),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFEA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _officialHeaderStart),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _officialText,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime value) {
    final diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Future<int?> _fetchPopulationFromBackend() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return null;
    }
    for (final endpoint in _AuthApi.instance._endpointCandidates('official/dashboard-summary')) {
      try {
        final response = await http.get(
          endpoint,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
        ).timeout(const Duration(seconds: 7));
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode < 200 || response.statusCode >= 300) {
          return null;
        }
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        if (decoded is! Map<String, dynamic>) {
          return null;
        }
        final direct = _asInt(decoded['population']);
        if (direct != null) {
          return direct;
        }
        final summary = decoded['summary'];
        if (summary is Map<String, dynamic>) {
          final summaryPopulation = _asInt(summary['population']);
          if (summaryPopulation != null) {
            return summaryPopulation;
          }
        }
        final populationNode = decoded['population'];
        if (populationNode is Map<String, dynamic>) {
          final estimated = _asInt(populationNode['estimated']);
          if (estimated != null) {
            return estimated;
          }
          final residents = _asInt(populationNode['registered_residents']);
          if (residents != null) {
            return residents;
          }
        }
        return null;
      } on TimeoutException {
        return null;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _fetchOfficialSummaryFromBackend() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return null;
    }
    final query = _officialLocationQuery();
    final paths = <String>[
      'official/dashboard-summary$query',
      'official/dashboard$query',
      'official/summary$query',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http.get(
            endpoint,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_authToken',
            },
          ).timeout(const Duration(seconds: 7));
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode < 200 || response.statusCode >= 300) {
            return null;
          }
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          if (decoded is! Map<String, dynamic>) {
            return null;
          }
          final data = decoded['data'];
          if (data is Map<String, dynamic>) {
            return data;
          }
          return decoded;
        } on TimeoutException {
          return null;
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  String _officialLocationQuery() {
    final city = _officialBarangaySetup.city.trim();
    final province = _officialBarangaySetup.province.trim();
    final barangay = _officialEditableProfile.value.barangay.trim().isNotEmpty
        ? _officialEditableProfile.value.barangay.trim()
        : _officialBarangaySetup.barangay.trim();
    final params = <String, String>{};
    if (province.isNotEmpty) {
      params['province'] = province;
    }
    if (city.isNotEmpty) {
      params['city_municipality'] = city;
    }
    if (barangay.isNotEmpty) {
      params['barangay'] = barangay;
    }
    if (params.isEmpty) {
      return '';
    }
    final qs = params.entries
        .map((entry) => '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}')
        .join('&');
    return '?$qs';
  }

  int? _readSummaryInt(Map<String, dynamic>? summary, List<List<String>> keyPaths) {
    if (summary == null) {
      return null;
    }
    for (final path in keyPaths) {
      dynamic node = summary;
      for (final part in path) {
        if (node is! Map<String, dynamic>) {
          node = null;
          break;
        }
        node = node[part];
      }
      final value = _asInt(node);
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final liveBarangay = _officialEditableProfile.value.barangay.trim();
    final barangayName = liveBarangay.isEmpty
        ? 'Barangay Profile'
        : liveBarangay;
    final city = _officialBarangaySetup.city.trim();
    final province = _officialBarangaySetup.province.trim();
    final location = [city, province]
        .where((part) => part.isNotEmpty)
        .join(', ')
        .toUpperCase();
    final punongName = _officialBarangaySetup.punongSignatureText.trim().isEmpty
        ? 'PB -'
        : 'PB ${_officialBarangaySetup.punongSignatureText.trim().toUpperCase()}';
    final secretaryName = [
      _officialBarangaySetup.secretaryFirstName.trim(),
      _officialBarangaySetup.secretaryMiddleName.trim(),
      _officialBarangaySetup.secretaryLastName.trim(),
    ].where((part) => part.isNotEmpty).join(' ');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), _officialSurfaceBlend],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: () => _refreshDashboard(showLoading: false),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: LinearProgressIndicator(
                  color: _officialHeaderStart,
                  minHeight: 3,
                ),
              ),
            if (_snapshot.warningMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD7BA)),
                ),
                child: Text(
                  _snapshot.warningMessage,
                  style: const TextStyle(
                    color: Color(0xFF8B4A0D),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _officialCardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE0E4F2),
                      width: 2,
                    ),
                    color: const Color(0xFFF6F8FF),
                  ),
                  padding: const EdgeInsets.all(9),
                  child: ValueListenableBuilder<Uint8List?>(
                    valueListenable: _scopedBarangayLogoBytes,
                    builder: (context, logoBytes, _) {
                      if (logoBytes != null) {
                        return Image.memory(
                          logoBytes,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.location_city,
                            color: _officialHeaderStart,
                          ),
                        );
                      }
                      return Image.asset(
                        'public/barangaymo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.location_city,
                          color: _officialHeaderStart,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barangayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _officialText,
                          fontSize: 48 / 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _officialSubtext,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        punongName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF4B526D),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      if (secretaryName.isNotEmpty)
                        Text(
                          'SEC ${secretaryName.toUpperCase()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF4B526D),
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEFEA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.flag,
                    color: _officialHeaderStart,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
            const SizedBox(height: 10),
            GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.15,
            children: [
              _metricCard(
                icon: Icons.groups_2_outlined,
                label: 'Total Population',
                value: '${_snapshot.totalPopulation}',
                note: 'Live barangay dashboard count',
              ),
              _metricCard(
                icon: Icons.verified_user_outlined,
                label: 'RBI Count',
                value: '${_snapshot.rbiCount}',
                note: 'Verified resident records',
              ),
              _metricCard(
                icon: Icons.description_outlined,
                label: 'Doc Requests',
                value: '${_snapshot.pendingRequests}',
                note: '${_snapshot.totalRequests} total submitted requests',
              ),
              _metricCard(
                icon: Icons.storefront_outlined,
                label: 'Market Products',
                value: '${_snapshot.marketProductCount}',
                note: '${_snapshot.verifiedMarketProductCount} verified listing(s)',
              ),
            ],
          ),
            const SizedBox(height: 12),
            _sectionHeader(
            context,
            'Serbilis Services',
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SerbilisServicesPage()),
            ),
          ),
            const SizedBox(height: 4),
            SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _serviceShortcut(
                  context,
                  icon: Icons.local_shipping_outlined,
                  title: 'Responder',
                  page: const ResponderPage(),
                ),
                const SizedBox(width: 8),
                _serviceShortcut(
                  context,
                  icon: Icons.qr_code_scanner,
                  title: 'QR ID',
                  page: const ScanQrPage(),
                ),
                const SizedBox(width: 8),
                _serviceShortcut(
                  context,
                  icon: Icons.badge_outlined,
                  title: 'RBI',
                  page: const ResidentRbiCardPage(),
                ),
                const SizedBox(width: 8),
                _serviceShortcut(
                  context,
                  icon: Icons.local_police_outlined,
                  title: 'Police',
                  page: const OfficialRequestsInboxPage(
                    serviceCategory: 'Police',
                    pageTitle: 'Police Requests',
                  ),
                ),
              ],
            ),
          ),
            const SizedBox(height: 12),
            _sectionHeader(
            context,
            'Community',
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CommunityPage()),
            ),
          ),
            const SizedBox(height: 4),
            Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _officialCardBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: _snapshot.latestPost?.photoBytes != null
                      ? Image.memory(
                          _snapshot.latestPost!.photoBytes!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 140,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFE9EEFF), Color(0xFFF7F8FF)],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.campaign_outlined,
                              size: 44,
                              color: Color(0xFF6C74A4),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                  child: Text(
                    _snapshot.latestPost?.author ?? 'No community updates yet',
                    style: TextStyle(
                      color: _officialText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
                  child: Text(
                    _snapshot.latestPost?.message.isNotEmpty == true
                        ? _snapshot.latestPost!.message
                        : 'No posts found for this barangay yet.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _officialSubtext,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text(
                    '${_snapshot.communityPostCount} post(s) in feed - Synced ${_timeAgo(_snapshot.syncedAt)}',
                    style: const TextStyle(
                      color: _officialSubtext,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
  }
}

class _SimplePage extends StatefulWidget {
  final String title;
  final List<String> rows;
  final IconData icon;
  final String? subtitle;

  const _SimplePage(
    this.title,
    this.rows, {
    this.icon = Icons.dashboard_customize,
    this.subtitle,
  });

  @override
  State<_SimplePage> createState() => _SimplePageState();
}

class _SimplePageState extends State<_SimplePage> {
  late DateTime _lastSynced;
  int _refreshTick = 0;
  late List<String> _rows;
  List<_SimpleTimelineItem> _officialTimeline = const <_SimpleTimelineItem>[];
  List<_SimpleTimelineItem> _marketTimeline = const <_SimpleTimelineItem>[];
  List<_SimpleTimelineItem> _profileTimeline = const <_SimpleTimelineItem>[];

  static const List<String> _officialLoadingRows = <String>[
    'Council Agenda: Loading...',
    'Pending Approvals: Loading...',
    'Public Notices: Loading...',
    'Scheduled Hearings: Loading...',
  ];
  static const List<String> _marketLoadingRows = <String>[
    'Marketplace Vendors: Loading...',
    'Today\'s Transactions: Loading...',
    'Top Category: Loading...',
    'Delivery Requests: Loading...',
  ];
  static const List<String> _profileLoadingRows = <String>[
    'Account Name: Loading...',
    'Office: Loading...',
    'Role: Loading...',
    'Status: Loading...',
  ];

  @override
  void initState() {
    super.initState();
    final title = widget.title.toLowerCase();
    if (title == 'official') {
      _rows = [..._officialLoadingRows];
    } else if (title == 'market') {
      _rows = [..._marketLoadingRows];
    } else if (title == 'profile') {
      _rows = [..._profileLoadingRows];
    } else {
      _rows = [...widget.rows];
    }
    _lastSynced = DateTime.now();
    _primeOfficialAgendaCard();
  }

  Future<void> _refreshData() async {
    List<String>? refreshedRows;
    final title = widget.title.toLowerCase();
    if (title == 'official') {
      refreshedRows = await _resolveOfficialRows();
    } else if (title == 'market') {
      refreshedRows = await _resolveMarketRows();
    } else if (title == 'profile') {
      refreshedRows = await _resolveProfileRows();
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 550));
    }
    if (!mounted) return;
    setState(() {
      if (refreshedRows != null) {
        _rows = refreshedRows;
      }
      _refreshTick++;
      _lastSynced = DateTime.now();
    });
  }

  Future<void> _primeOfficialAgendaCard() async {
    final title = widget.title.toLowerCase();
    if (title != 'official' && title != 'market' && title != 'profile') {
      return;
    }
    final refreshedRows = title == 'official'
        ? await _resolveOfficialRows()
        : (title == 'market'
            ? await _resolveMarketRows()
            : await _resolveProfileRows());
    if (!mounted) {
      return;
    }
    setState(() => _rows = refreshedRows);
  }

  List<String> _profileRowsFromContext() {
    final profile = _officialEditableProfile.value;
    final name = profile.name.trim().isEmpty
        ? 'Barangay Official'
        : profile.name.trim();
    final barangay = profile.barangay.trim().isNotEmpty
        ? profile.barangay.trim()
        : _officialBarangaySetup.barangay.trim();
    final city = _officialBarangaySetup.city.trim();
    final province = _officialBarangaySetup.province.trim();
    final locationLine = [barangay, city, province]
        .where((segment) => segment.isNotEmpty)
        .join(', ');
    final office = barangay.isEmpty
        ? 'Barangay Administration'
        : '$barangay Barangay Administration';
    final roleText = _officialActivationCompleted
        ? 'Records and Services'
        : 'For Activation';
    final statusText = _officialActivationCompleted ? 'Active' : 'Pending Activation';
    return <String>[
      'Account Name: $name',
      'Office: ${locationLine.isEmpty ? office : '$office ($locationLine)'}',
      'Role: $roleText',
      'Status: $statusText',
    ];
  }

  Future<List<String>> _resolveProfileRows() async {
    final next = _profileRowsFromContext();
    final events = await _fetchOfficialRecentActivityFromBackend();
    if (events.isNotEmpty) {
      _profileTimeline = events.take(3).toList();
      return next;
    }
    _profileTimeline = const <_SimpleTimelineItem>[];
    return next;
  }

  Future<List<String>> _resolveOfficialRows() async {
    final next = [..._rows];
    final summary = await _fetchOfficialSummaryFromBackend();
    final backendTimeline = await _fetchOfficialRecentActivityFromBackend();

    final requestsResult = await _ServiceRequestApi.instance.fetchRequests();
    if (next.length < 4) {
      while (next.length < 4) {
        next.add('');
      }
    }
    final summaryPendingRequests = _readSummaryInt(summary, [
      ['pending_requests'],
      ['requests_pending'],
      ['summary', 'pending_requests'],
      ['summary', 'requests_pending'],
      ['requests', 'pending'],
    ]);
    final summaryTotalRequests = _readSummaryInt(summary, [
      ['total_requests'],
      ['requests_total'],
      ['summary', 'total_requests'],
      ['summary', 'requests_total'],
      ['requests', 'total'],
    ]);
    if (requestsResult.success) {
      final pending = requestsResult.entries
          .where((entry) => entry.status.toLowerCase().contains('pending'))
          .length;
      final hearingKeywords = <String>[
        'hearing',
        'mediation',
        'dispute',
        'complaint',
        'settlement',
      ];
      final hearingCount = requestsResult.entries.where((entry) {
        final bucket = '${entry.category} ${entry.title} ${entry.purpose}'.toLowerCase();
        return hearingKeywords.any(bucket.contains);
      }).length;
      next[1] = 'Pending Approvals: $pending request(s) pending review';
      next[3] = 'Scheduled Hearings: $hearingCount mediation case(s) this week';
    } else if (summaryPendingRequests != null || summaryTotalRequests != null) {
      final pending = summaryPendingRequests ?? 0;
      final total = summaryTotalRequests ?? pending;
      next[1] = 'Pending Approvals: $pending request(s) pending review';
      // We cannot infer hearing keywords without full request payload.
      next[3] = 'Scheduled Hearings: based on $total total request(s)';
    } else {
      next[1] = 'Pending Approvals: Queue unavailable right now';
      next[3] = 'Scheduled Hearings: Schedule unavailable right now';
    }

    final result = await _CommunityApi.instance.fetchPosts();
    final timelineEvents = <_SimpleTimelineItem>[...backendTimeline];
    if (timelineEvents.isEmpty && requestsResult.success) {
      final requestEvents = [...requestsResult.entries];
      for (var i = 0; i < requestEvents.length && i < 3; i++) {
        final entry = requestEvents[i];
        timelineEvents.add(
          _SimpleTimelineItem(
            title: 'Service request received',
            note: '${entry.title} (${entry.status})',
            time: _parseRequestDate(entry.date).add(Duration(minutes: i)),
            icon: Icons.assignment_turned_in_rounded,
          ),
        );
      }
    }
    if (timelineEvents.isEmpty && result.success) {
      final postEvents = [...result.posts]..sort((a, b) => b.postedAt.compareTo(a.postedAt));
      for (var i = 0; i < postEvents.length && i < 3; i++) {
        final post = postEvents[i];
        timelineEvents.add(
          _SimpleTimelineItem(
            title: post.isOfficial ? 'Official post published' : 'Community post published',
            note: _truncate(post.message, 64),
            time: post.postedAt,
            icon: post.isOfficial ? Icons.campaign_rounded : Icons.forum_rounded,
          ),
        );
      }
    }
    if (timelineEvents.isNotEmpty) {
      timelineEvents.sort((a, b) => b.time.compareTo(a.time));
      _officialTimeline = timelineEvents.take(3).toList();
    } else {
      _officialTimeline = const <_SimpleTimelineItem>[];
    }

    final summaryCommunityPosts = _readSummaryInt(summary, [
      ['community_post_count'],
      ['community_posts'],
      ['summary', 'community_posts'],
      ['summary', 'community_posts_total'],
      ['community', 'posts'],
    ]);
    if (!result.success || result.posts.isEmpty) {
      if (next.isEmpty) {
        next.add('Council Agenda: No council agenda published yet.');
      } else {
        next[0] = 'Council Agenda: No council agenda published yet.';
      }
      final notices = summaryCommunityPosts ?? 0;
      next[2] = 'Public Notices: $notices active posting(s) this week';
      return next;
    }
    final officialPosts = result.posts.where((entry) => entry.isOfficial).toList();
    final source = officialPosts.isNotEmpty ? officialPosts : result.posts;
    source.sort((a, b) => b.postedAt.compareTo(a.postedAt));

    final latest = source.first;
    final agendaText = latest.message.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (agendaText.isEmpty) {
      if (next.isEmpty) {
        next.add('Council Agenda: No council agenda published yet.');
      } else {
        next[0] = 'Council Agenda: No council agenda published yet.';
      }
      next[2] = 'Public Notices: ${result.posts.length} active posting(s) this week';
      return next;
    }
    final rowText = 'Council Agenda: $agendaText';
    if (next.isEmpty) {
      next.add(rowText);
    } else {
      next[0] = rowText;
    }
    next[2] = 'Public Notices: ${result.posts.length} active posting(s) this week';
    return next;
  }

  Future<List<String>> _resolveMarketRows() async {
    final next = [..._rows];
    if (next.length < 4) {
      while (next.length < 4) {
        next.add('');
      }
    }

    final productsResult = await _SellerApi.instance.fetchMarketProducts();
    final backendTimeline =
        await _fetchOfficialRecentActivityFromBackend(onlyType: 'market');

    if (!productsResult.success) {
      next[0] = 'Marketplace Vendors: Data unavailable right now';
      next[1] = 'Today\'s Transactions: Data unavailable right now';
      next[2] = 'Top Category: Data unavailable right now';
      next[3] = 'Delivery Requests: Data unavailable right now';
      _marketTimeline = backendTimeline;
      return next;
    }

    final products = productsResult.products;
    final vendorCount = products
        .map((item) => item.seller.trim().toLowerCase())
        .where((name) => name.isNotEmpty)
        .toSet()
        .length;
    final soldUnits = products.fold<int>(0, (sum, item) => sum + item.sold);

    final categoryCounts = <String, int>{};
    for (final item in products) {
      final key = item.category.trim().isEmpty ? 'Uncategorized' : item.category.trim();
      categoryCounts[key] = (categoryCounts[key] ?? 0) + 1;
    }
    var topCategory = 'No categories yet';
    var topCount = -1;
    categoryCounts.forEach((key, count) {
      if (count > topCount) {
        topCount = count;
        topCategory = key;
      }
    });

    final deliveryPending = products.where((item) {
      final eta = item.eta.toLowerCase();
      return eta.contains('deliver') ||
          eta.contains('delivery') ||
          eta.contains('pickup') ||
          eta.contains('ship');
    }).length;

    next[0] = 'Marketplace Vendors: $vendorCount registered stall(s)';
    next[1] = 'Today\'s Transactions: $soldUnits sold unit(s) logged';
    next[2] = 'Top Category: $topCategory';
    next[3] = 'Delivery Requests: $deliveryPending pending fulfillment(s)';

    _marketTimeline = backendTimeline;

    return next;
  }

  Future<Map<String, dynamic>?> _fetchOfficialSummaryFromBackend() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return null;
    }
    final query = _officialLocationQuery();
    final paths = <String>[
      'official/dashboard-summary$query',
      'official/dashboard$query',
      'official/summary$query',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http.get(
            endpoint,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_authToken',
            },
          ).timeout(const Duration(seconds: 7));
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode < 200 || response.statusCode >= 300) {
            return null;
          }
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          if (decoded is! Map<String, dynamic>) {
            return null;
          }
          final data = decoded['data'];
          if (data is Map<String, dynamic>) {
            return data;
          }
          return decoded;
        } on TimeoutException {
          return null;
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  Future<List<_SimpleTimelineItem>> _fetchOfficialRecentActivityFromBackend({
    String? onlyType,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const <_SimpleTimelineItem>[];
    }
    final query = _officialLocationQuery();
    final paths = <String>[
      'official/recent-activity$query',
      'official/activity$query',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http.get(
            endpoint,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_authToken',
            },
          ).timeout(const Duration(seconds: 7));
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode < 200 || response.statusCode >= 300) {
            return const <_SimpleTimelineItem>[];
          }
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          if (decoded is! Map<String, dynamic>) {
            return const <_SimpleTimelineItem>[];
          }
          final rawActivities = decoded['activities'] ?? decoded['data'];
          if (rawActivities is! List) {
            return const <_SimpleTimelineItem>[];
          }
          final entries = <_SimpleTimelineItem>[];
          for (final item in rawActivities) {
            if (item is! Map<String, dynamic>) {
              continue;
            }
            final title = ((item['title'] as String?) ?? '').trim();
            final note = ((item['note'] as String?) ?? '').trim();
            final rawTime = ((item['timestamp'] as String?) ??
                    (item['time'] as String?) ??
                    (item['created_at'] as String?) ??
                    '')
                .trim();
            final parsedTime = DateTime.tryParse(rawTime)?.toLocal() ?? DateTime.now();
            final type = ((item['type'] as String?) ?? '').trim().toLowerCase();
            if (onlyType != null &&
                onlyType.trim().isNotEmpty &&
                type != onlyType.trim().toLowerCase()) {
              continue;
            }
            if (title.isEmpty || note.isEmpty) {
              continue;
            }
            entries.add(
              _SimpleTimelineItem(
                title: title,
                note: note,
                time: parsedTime,
                icon: _iconForActivityType(type),
              ),
            );
          }
          entries.sort((a, b) => b.time.compareTo(a.time));
          return entries.take(3).toList();
        } on TimeoutException {
          return const <_SimpleTimelineItem>[];
        } catch (_) {
          return const <_SimpleTimelineItem>[];
        }
      }
    }
    return const <_SimpleTimelineItem>[];
  }

  IconData _iconForActivityType(String type) {
    if (type.contains('request')) {
      return Icons.assignment_turned_in_rounded;
    }
    if (type.contains('community') || type.contains('post')) {
      return Icons.campaign_rounded;
    }
    if (type.contains('market') || type.contains('product')) {
      return Icons.storefront_rounded;
    }
    return Icons.history_toggle_off_rounded;
  }

  String _officialLocationQuery() {
    final city = _officialBarangaySetup.city.trim();
    final province = _officialBarangaySetup.province.trim();
    final barangay = _officialEditableProfile.value.barangay.trim().isNotEmpty
        ? _officialEditableProfile.value.barangay.trim()
        : _officialBarangaySetup.barangay.trim();
    final params = <String, String>{};
    if (province.isNotEmpty) {
      params['province'] = province;
    }
    if (city.isNotEmpty) {
      params['city_municipality'] = city;
    }
    if (barangay.isNotEmpty) {
      params['barangay'] = barangay;
    }
    if (params.isEmpty) {
      return '';
    }
    final qs = params.entries
        .map((entry) => '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}')
        .join('&');
    return '?$qs';
  }

  int? _readSummaryInt(Map<String, dynamic>? summary, List<List<String>> keyPaths) {
    if (summary == null) {
      return null;
    }
    for (final path in keyPaths) {
      dynamic node = summary;
      for (final part in path) {
        if (node is! Map<String, dynamic>) {
          node = null;
          break;
        }
        node = node[part];
      }
      final value = _asInt(node);
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  DateTime _parseRequestDate(String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      return DateTime.now();
    }
    final direct = DateTime.tryParse(text);
    if (direct != null) {
      return direct;
    }
    final parts = text.replaceAll(',', '').split(RegExp(r'\s+'));
    if (parts.length < 3) {
      return DateTime.now();
    }
    const monthMap = <String, int>{
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    final month = monthMap[parts[0].toLowerCase().substring(0, 3)];
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (month == null || day == null || year == null) {
      return DateTime.now();
    }
    return DateTime(year, month, day);
  }

  String _truncate(String value, int maxChars) {
    final clean = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.length <= maxChars) {
      return clean;
    }
    return '${clean.substring(0, maxChars)}...';
  }

  IconData _rowIcon(String text, int index) {
    final t = text.toLowerCase();
    if (t.contains('agenda')) return Icons.event_note_outlined;
    if (t.contains('hearing')) return Icons.balance_outlined;
    if (t.contains('vendors')) return Icons.storefront_outlined;
    if (t.contains('delivery')) return Icons.local_shipping_outlined;
    if (t.contains('population')) return Icons.people_alt_outlined;
    if (t.contains('rbi')) return Icons.badge_outlined;
    if (t.contains('founded')) return Icons.history_edu_outlined;
    if (t.contains('divisions')) return Icons.hub_outlined;
    if (t.contains('transactions')) return Icons.receipt_long_outlined;
    if (t.contains('address') || t.contains('city')) {
      return Icons.location_on_outlined;
    }
    if (t.contains('pending')) return Icons.pending_actions_outlined;
    if (t.contains('status')) return Icons.verified_user_outlined;
    if (t.contains('account')) return Icons.badge_outlined;
    if (t.contains('role')) return Icons.assignment_ind_outlined;
    return [
      Icons.insights_outlined,
      Icons.checklist_rtl_outlined,
      Icons.dataset_outlined,
      Icons.analytics_outlined,
      Icons.assignment_outlined,
    ][index % 5];
  }

  String _clockStamp(DateTime value) {
    final hour12 = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour12:$minute $suffix';
  }

  String _dateStamp(DateTime value) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[value.month - 1]} ${value.day}, ${value.year}';
  }

  String _pulseValue(String raw, int index) {
    final match = RegExp(r'\d+').firstMatch(raw);
    if (match == null) return raw;
    final number = int.tryParse(match.group(0)!);
    if (number == null) return raw;
    final delta = ((_refreshTick + index) % 4) - 1;
    final nextValue = (number + delta).clamp(0, 99999);
    return raw.replaceFirst(match.group(0)!, '$nextValue');
  }

  _RowMeta _rowMeta(String key, String value) {
    final combined = '$key $value'.toLowerCase();
    final hasUnavailable = combined.contains('unavailable') ||
        combined.contains('loading') ||
        combined.contains('not available');
    if (hasUnavailable) {
      return const _RowMeta(
        badge: _RowBadge(
          label: 'API Unavailable',
          icon: Icons.cloud_off_rounded,
          bg: Color(0xFFFFF0F0),
          fg: Color(0xFFAA2E2E),
        ),
        hint: 'No backend payload for this metric yet.',
      );
    }

    final number = _firstNumber(value);
    if (number != null) {
      if (number > 0) {
        return const _RowMeta(
          badge: _RowBadge(
            label: 'Live Data',
            icon: Icons.cloud_done_rounded,
            bg: Color(0xFFEAF7EE),
            fg: Color(0xFF1F6B3D),
          ),
          hint: 'Synced from backend data source.',
        );
      }
      return const _RowMeta(
        badge: _RowBadge(
          label: 'No Records',
          icon: Icons.inbox_outlined,
          bg: Color(0xFFEEF1F7),
          fg: Color(0xFF445270),
        ),
        hint: 'No records found in backend yet.',
      );
    }

    return const _RowMeta(
      badge: _RowBadge(
        label: 'Live Text',
        icon: Icons.description_outlined,
        bg: Color(0xFFEAF0FF),
        fg: Color(0xFF2A4DA3),
      ),
      hint: 'Rendered from latest backend text value.',
    );
  }

  int? _firstNumber(String value) {
    final match = RegExp(r'-?\d+').firstMatch(value);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }

  Widget _statChip(
    IconData icon,
    String label, {
    required Color bg,
    required Color fg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBars(String seed, Color color) {
    final safeSeed = seed.isEmpty ? 'data' : seed;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (i) {
        final code = safeSeed.codeUnitAt(i % safeSeed.length);
        final baseHeight = 6 + ((code + _refreshTick + (i * 7)) % 15);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          width: 4,
          height: baseHeight.toDouble(),
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: i == 6 ? 1 : 0.7),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }

  List<_SimpleTimelineItem> _timelineItems() {
    final t = widget.title.toLowerCase();
    if (t == 'official') {
      return _officialTimeline;
    }
    if (t == 'market') {
      return _marketTimeline;
    }
    if (t == 'profile') {
      return _profileTimeline;
    }
    return const <_SimpleTimelineItem>[];
  }

  String _timeAgo(DateTime value) {
    if (value.year <= 2001) {
      return 'now';
    }
    final difference = _lastSynced.difference(value);
    final minutes = difference.inMinutes;
    if (minutes <= 0) return 'Just now';
    if (minutes < 60) return '$minutes min ago';
    final hours = difference.inHours;
    return '$hours hr ago';
  }

  @override
  Widget build(BuildContext context) {
    final palette = _SimplePalette.forTitle(widget.title);
    final subtitleText =
        widget.subtitle ?? 'Operational overview and quick summary';
    final timeline = _timelineItems();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.bgStart, palette.bgEnd],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _refreshData,
        color: palette.accent,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [palette.heroStart, palette.heroEnd],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0x30FFFFFF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(widget.icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitleText,
                              style: const TextStyle(
                                color: Color(0xFFFFEFEF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: _refreshData,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0x2AFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statChip(
                        Icons.sync_rounded,
                        'Synced ${_clockStamp(_lastSynced)}',
                        bg: const Color(0x30FFFFFF),
                        fg: Colors.white,
                      ),
                      _statChip(
                        Icons.today_rounded,
                        _dateStamp(_lastSynced),
                        bg: const Color(0x24FFFFFF),
                        fg: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ..._rows.asMap().entries.map((entry) {
              final text = entry.value;
              final parts = text.split(':');
              final hasPair = parts.length > 1;
              final key = hasPair ? parts.first.trim() : text;
              final rawValue = hasPair ? parts.sublist(1).join(':').trim() : '';
              final titleKey = widget.title.toLowerCase();
              final allowPulse = titleKey != 'official' &&
                  titleKey != 'market' &&
                  titleKey != 'profile';
              final value = hasPair
                  ? (allowPulse ? _pulseValue(rawValue, entry.key) : rawValue)
                  : rawValue;
              final isPureNumber = RegExp(r'^\d+$').hasMatch(value);
              final meta = _rowMeta(key, value);

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 220 + (entry.key * 80)),
                curve: Curves.easeOutCubic,
                builder: (context, anim, child) {
                  return Opacity(
                    opacity: anim,
                    child: Transform.translate(
                      offset: Offset(0, (1 - anim) * 14),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: _officialCardBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: palette.softAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _rowIcon(text, entry.key),
                          color: palette.accent,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              key,
                              style: const TextStyle(
                                color: _officialSubtext,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              value,
                              maxLines: isPureNumber ? 1 : 2,
                              overflow: isPureNumber
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _officialText,
                                fontWeight: FontWeight.w900,
                                fontSize: hasPair
                                    ? (isPureNumber ? 34 : 17)
                                    : 18,
                                height: hasPair
                                    ? (isPureNumber ? 1.04 : 1.2)
                                    : 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: meta.badge.bg,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                        meta.badge.icon,
                                          size: 14,
                                        color: meta.badge.fg,
                                        ),
                                      const SizedBox(width: 5),
                                      Text(
                                        meta.badge.label,
                                        style: TextStyle(
                                          color: meta.badge.fg,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                _miniBars('$key$value', palette.accent),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              meta.hint,
                              style: const TextStyle(
                                color: _officialSubtext,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
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
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _officialCardBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: palette.accent,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (timeline.isEmpty)
                    const Text(
                      'No recent activity from backend yet.',
                      style: TextStyle(
                        color: _officialSubtext,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else
                    ...timeline.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: palette.softAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                item.icon,
                                size: 17,
                                color: palette.accent,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: _officialText,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    item.note,
                                    style: const TextStyle(
                                      color: _officialSubtext,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _timeAgo(item.time),
                              style: const TextStyle(
                                color: _officialSubtext,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowBadge {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;

  const _RowBadge({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
  });
}

class _RowMeta {
  final _RowBadge badge;
  final String hint;

  const _RowMeta({
    required this.badge,
    required this.hint,
  });
}

class _SimpleTimelineItem {
  final String title;
  final String note;
  final DateTime time;
  final IconData icon;

  const _SimpleTimelineItem({
    required this.title,
    required this.note,
    required this.time,
    required this.icon,
  });
}

class _SimplePalette {
  final Color heroStart;
  final Color heroEnd;
  final Color bgStart;
  final Color bgEnd;
  final Color accent;
  final Color softAccent;

  const _SimplePalette({
    required this.heroStart,
    required this.heroEnd,
    required this.bgStart,
    required this.bgEnd,
    required this.accent,
    required this.softAccent,
  });

  static _SimplePalette forTitle(String title) {
    final t = title.toLowerCase();
    if (t == 'market') {
      return const _SimplePalette(
        heroStart: Color(0xFF9F1A1A),
        heroEnd: Color(0xFFD73B3B),
        bgStart: Color(0xFFFFF7F7),
        bgEnd: Color(0xFFF7ECEC),
        accent: Color(0xFFC92A2A),
        softAccent: Color(0xFFFFEAEA),
      );
    }
    if (t == 'profile') {
      return const _SimplePalette(
        heroStart: Color(0xFF8E1717),
        heroEnd: Color(0xFFC92A2A),
        bgStart: Color(0xFFFFF8F8),
        bgEnd: Color(0xFFF5ECEC),
        accent: Color(0xFFB82323),
        softAccent: Color(0xFFFFEEEE),
      );
    }
    return const _SimplePalette(
      heroStart: _officialHeaderStart,
      heroEnd: _officialHeaderEnd,
      bgStart: Color(0xFFF7F8FC),
      bgEnd: _officialSurfaceBlend,
      accent: _officialHeaderStart,
      softAccent: _officialSoftAccent,
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  const DetailPage({super.key, required this.title});

  IconData _detailIcon(String text, int index) {
    final t = text.toLowerCase();
    if (t.contains('privacy') || t.contains('terms')) {
      return Icons.policy_outlined;
    }
    if (t.contains('notify') || t.contains('history')) {
      return Icons.notifications_active_outlined;
    }
    if (t.contains('support') || t.contains('faq')) {
      return Icons.support_agent_outlined;
    }
    if (t.contains('search')) return Icons.search;
    if (t.contains('delete')) return Icons.delete_forever_outlined;
    if (t.contains('log out') || t.contains('back')) return Icons.logout;
    if (t.contains('upload')) return Icons.cloud_upload_outlined;
    if (t.contains('submit')) return Icons.task_alt_outlined;
    return [
      Icons.info_outline,
      Icons.tune_outlined,
      Icons.task_outlined,
      Icons.inventory_2_outlined,
    ][index % 4];
  }

  @override
  Widget build(BuildContext context) {
    final items = {
      'Barangay Profile': [
        'Barangay Name: West Tapinac',
        'Municipality/City: Olongapo City',
        'Province: Zambales',
        'Population: 22,365',
        'Households: 5,420',
        'Captain: Manuel Dalanan',
      ],
      'Settings': ['Notifications', 'Profile', 'Account Settings'],
      'RBI Records': [
        'Search name...',
        'Verified/Unverified tabs',
        'Records list',
      ],
      'FAQs': ['Common questions list', 'Search by keywords'],
      'Notifications': ['Notifications', 'History', 'Transactions'],
      'Support': ['support@barangaymo.online', '000 123 4567', 'FAQ button'],
      'Bug Report': [
        'Bug Name',
        'Description',
        'Upload Screenshot',
        'Submit Ticket',
      ],
      'Terms & Policies': ['Privacy Policy', 'Terms and Conditions'],
      'Log out': ['Are you sure you want to log out?', 'Go Back', 'Log Out'],
      'Delete Account': ['Type DELETE to confirm', 'Delete Account button'],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF7F8FF),
        foregroundColor: _officialText,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FC), Color(0xFFF4EEEE)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _officialCardBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_officialHeaderStart, _officialHeaderEnd],
                      ),
                    ),
                    child: const Icon(
                      Icons.dashboard_customize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$title Module',
                      style: const TextStyle(
                        color: _officialText,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...?items[title]?.asMap().entries.map((entry) {
              final value = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _officialCardBorder),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFEA),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      _detailIcon(value, entry.key),
                      color: _officialHeaderStart,
                    ),
                  ),
                  title: Text(
                    value,
                    style: const TextStyle(
                      color: _officialText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

