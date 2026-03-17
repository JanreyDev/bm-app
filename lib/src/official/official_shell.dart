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
  Widget build(BuildContext context) {
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
                    title: const Text(
                      'West Tapinac Barangay Profile',
                      style: TextStyle(
                        color: _officialText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: const Text(
                      'City of Olongapo, Zambales',
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

  IconData _menuIcon(String title) {
    switch (title) {
      case 'Settings':
        return Icons.settings;
      case 'Barangay Profile':
        return Icons.location_city;
      case 'Barangay Activation':
        return Icons.verified_user_outlined;
      case 'RBI Records':
        return Icons.badge_outlined;
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
          onTap: () {
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
                Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ActivationFlow(goToHomeOnFinish: false),
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
                Navigator.push(
                  c,
                  MaterialPageRoute(builder: (_) => const OfficialLogoutPage()),
                );
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

class _OfficialHomePage extends StatelessWidget {
  const _OfficialHomePage();

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
            value,
            style: const TextStyle(
              color: _officialHeaderStart,
              fontWeight: FontWeight.w900,
              fontSize: 34,
            ),
          ),
          Text(
            note,
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

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FC), _officialSurfaceBlend],
          ),
        ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
        children: [
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
                  child: Image.asset(
                    'public/barangaymo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.location_city,
                      color: _officialHeaderStart,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Old Cabalan',
                        style: TextStyle(
                          color: _officialText,
                          fontSize: 29,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'CITY OF OLONGAPO, ZAMBALES',
                        style: TextStyle(
                          color: _officialSubtext,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'PB REINARD NADONG',
                        style: TextStyle(
                          color: Color(0xFF4B526D),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'SK ANGEL VICTORIA BIBANCO',
                        style: TextStyle(
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
            childAspectRatio: 1.35,
            children: [
              _metricCard(
                icon: Icons.groups_2_outlined,
                label: 'Total Population',
                value: '${_officialPopulationForYear()}',
                note: 'PSA ${DateTime.now().year} refresh',
              ),
              _metricCard(
                icon: Icons.verified_user_outlined,
                label: 'RBI Count',
                value: '5,420',
                note: 'Verified resident records',
              ),
              _metricCard(
                icon: Icons.description_outlined,
                label: 'Doc Requests',
                value: '12',
                note: 'Queued for council action',
              ),
              ValueListenableBuilder<String>(
                valueListenable: _treasurerRemainingBalanceHome,
                builder: (context, value, _) => _metricCard(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Remaining Balance',
                  value: value,
                  note: 'Treasurer live available fund widget',
                ),
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
                  page: const SimpleSerbilisPage(
                    title: 'Police',
                    isOfficial: true,
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
                  child: Image.asset(
                    'public/item-table.jpg',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: const Color(0xFFE9EEFF),
                      child: const Center(
                        child: Icon(
                          Icons.image_rounded,
                          size: 44,
                          color: Color(0xFF6C74A4),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Text(
                    'Lester Nadong',
                    style: TextStyle(
                      color: _officialText,
                      fontWeight: FontWeight.w700,
                    ),
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

  @override
  void initState() {
    super.initState();
    _lastSynced = DateTime.now();
  }

  Future<void> _refreshData() async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() {
      _refreshTick++;
      _lastSynced = DateTime.now();
    });
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

  _RowBadge _badgeForRow(String key, String value) {
    final combined = '$key $value'.toLowerCase();
    if (combined.contains('pending') ||
        combined.contains('delivery') ||
        combined.contains('hearing')) {
      return const _RowBadge(
        label: 'Needs Attention',
        icon: Icons.warning_amber_rounded,
        bg: Color(0xFFFFF3E8),
        fg: Color(0xFFB45309),
      );
    }
    if (combined.contains('status') ||
        combined.contains('active') ||
        combined.contains('account')) {
      return const _RowBadge(
        label: 'Stable',
        icon: Icons.verified_rounded,
        bg: Color(0xFFEAF7EE),
        fg: Color(0xFF1F6B3D),
      );
    }
    if (combined.contains('transactions') ||
        combined.contains('vendors') ||
        combined.contains('category')) {
      return const _RowBadge(
        label: 'Trending',
        icon: Icons.trending_up_rounded,
        bg: Color(0xFFEAF0FF),
        fg: Color(0xFF2A4DA3),
      );
    }
    if (combined.contains('agenda')) {
      return const _RowBadge(
        label: 'Upcoming',
        icon: Icons.calendar_month_rounded,
        bg: Color(0xFFFFEFE8),
        fg: Color(0xFFA13A1D),
      );
    }
    return const _RowBadge(
      label: 'Monitored',
      icon: Icons.visibility_rounded,
      bg: Color(0xFFEEF1F7),
      fg: Color(0xFF445270),
    );
  }

  String _hintForRow(String key, String value) {
    final combined = '$key $value'.toLowerCase();
    if (combined.contains('pending')) return 'Queue requires same-day review';
    if (combined.contains('transaction')) return 'Compared with latest sync';
    if (combined.contains('status')) return 'Identity and access validated';
    if (combined.contains('account')) return 'Verified account profile';
    if (combined.contains('delivery')) return 'Dispatch route updated';
    if (combined.contains('agenda')) return 'Published to council feed';
    return 'Monitored by operations desk';
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
      return [
        _SimpleTimelineItem(
          title: 'Permit endorsement reviewed',
          note: 'Treasury desk completed pre-check.',
          time: _lastSynced.subtract(const Duration(minutes: 8)),
          icon: Icons.assignment_turned_in_rounded,
        ),
        _SimpleTimelineItem(
          title: 'Council memo published',
          note: 'Session reminders pushed to committee members.',
          time: _lastSynced.subtract(const Duration(minutes: 22)),
          icon: Icons.campaign_rounded,
        ),
        _SimpleTimelineItem(
          title: 'Hearing reminder sent',
          note: 'Mediation participants confirmed attendance.',
          time: _lastSynced.subtract(const Duration(minutes: 41)),
          icon: Icons.notifications_active_rounded,
        ),
      ];
    }
    if (t == 'market') {
      return [
        _SimpleTimelineItem(
          title: 'Vendor check-in completed',
          note: 'Morning inventory validated for 32 stalls.',
          time: _lastSynced.subtract(const Duration(minutes: 6)),
          icon: Icons.store_mall_directory_rounded,
        ),
        _SimpleTimelineItem(
          title: 'Payment batch posted',
          note: 'Receipts reconciled with marketplace ledger.',
          time: _lastSynced.subtract(const Duration(minutes: 18)),
          icon: Icons.receipt_long_rounded,
        ),
        _SimpleTimelineItem(
          title: 'Delivery route assigned',
          note: 'Rider dispatch aligned with zone priorities.',
          time: _lastSynced.subtract(const Duration(minutes: 37)),
          icon: Icons.local_shipping_rounded,
        ),
      ];
    }
    return [
      _SimpleTimelineItem(
        title: 'Security audit passed',
        note: 'No suspicious sign-in attempts detected.',
        time: _lastSynced.subtract(const Duration(minutes: 5)),
        icon: Icons.shield_rounded,
      ),
      _SimpleTimelineItem(
        title: 'Office profile updated',
        note: 'Directory contact details synchronized.',
        time: _lastSynced.subtract(const Duration(minutes: 29)),
        icon: Icons.contact_phone_rounded,
      ),
      _SimpleTimelineItem(
        title: 'Role permissions verified',
        note: 'Records and services module remains active.',
        time: _lastSynced.subtract(const Duration(minutes: 53)),
        icon: Icons.verified_user_rounded,
      ),
    ];
  }

  String _timeAgo(DateTime value) {
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
            ...widget.rows.asMap().entries.map((entry) {
              final text = entry.value;
              final parts = text.split(':');
              final hasPair = parts.length > 1;
              final key = hasPair ? parts.first.trim() : text;
              final rawValue = hasPair ? parts.sublist(1).join(':').trim() : '';
              final value = hasPair
                  ? _pulseValue(rawValue, entry.key)
                  : rawValue;
              final isPureNumber = RegExp(r'^\d+$').hasMatch(value);
              final badge = _badgeForRow(key, value);

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
                                    color: badge.bg,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        badge.icon,
                                        size: 14,
                                        color: badge.fg,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        badge.label,
                                        style: TextStyle(
                                          color: badge.fg,
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
                              _hintForRow(key, value),
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

