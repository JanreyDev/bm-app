part of barangaymo_app;

class SerbilisServicesPage extends StatelessWidget {
  const SerbilisServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Serbilis Services'),
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
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: _officialHeroSubtext,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            tabs: [
              Tab(text: 'Brgy Services'),
              Tab(text: 'SK Services'),
            ],
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF7F8FC), _officialSurfaceBlend],
              ),
            ),
          child: TabBarView(
            children: [
              _serviceGrid(context, _brgyServices),
              _serviceGrid(context, _skServices),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceGrid(BuildContext context, List<_ServiceAction> data) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_officialHeaderStart, _officialHeaderEnd],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(
                  Icons.miscellaneous_services_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Official Service Console',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Run barangay workflows and track resident-facing service modules.',
                      style: TextStyle(
                        color: _officialHeroSubtext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth < 360 ? 2 : 3;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.92,
              ),
              itemCount: data.length,
              itemBuilder: (_, index) {
                final item = data[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.page),
                  ),
                  child: Container(
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
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEFEA),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: _officialHeaderStart,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: _officialText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _OfficialFeedbackQuickSheet extends StatelessWidget {
  const _OfficialFeedbackQuickSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback and Reports',
              style: TextStyle(
                color: _officialText,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Send in-app feedback, report bugs, or contact support without leaving the official dashboard.',
              style: TextStyle(
                color: _officialSubtext,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            _quickSheetTile(
              context,
              icon: Icons.bug_report_outlined,
              title: 'Bug Report',
              subtitle: 'Report app issues and broken flows',
              page: const OfficialBugReportPage(),
            ),
            _quickSheetTile(
              context,
              icon: Icons.feedback_outlined,
              title: 'Quick Feedback',
              subtitle: 'Send suggestions to the product team',
              page: const OfficialSupportPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickSheetTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _officialCardBorder),
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _officialSoftAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _officialHeaderStart),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: _officialText,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: _officialSubtext,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}

class OfficialGovAgenciesPage extends StatelessWidget {
  const OfficialGovAgenciesPage({super.key});

  static const _agencies = [
    _OfficialAgencyInfo(
      label: 'DFA',
      displayName: 'Department of Foreign Affairs',
      website: 'https://dfa.gov.ph',
      accent: Color(0xFF154A99),
      icon: Icons.public_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'DILG',
      displayName: 'Department of the Interior and Local Government',
      website: 'https://dilg.gov.ph',
      accent: Color(0xFFC68B0D),
      icon: Icons.account_balance_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'DOLE',
      displayName: 'Department of Labor and Employment',
      website: 'https://www.dole.gov.ph',
      accent: Color(0xFF2659B8),
      icon: Icons.work_outline_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'DPWH',
      displayName: 'Department of Public Works and Highways',
      website: 'https://www.dpwh.gov.ph',
      accent: Color(0xFF324D93),
      icon: Icons.foundation_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'DSWD',
      displayName: 'Department of Social Welfare and Development',
      website: 'https://www.dswd.gov.ph',
      accent: Color(0xFF6B6E77),
      icon: Icons.volunteer_activism_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'LTO',
      displayName: 'Land Transportation Office',
      website: 'https://lto.gov.ph',
      accent: Color(0xFF1F4FA2),
      icon: Icons.directions_car_filled_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'OP',
      displayName: 'Office of the President',
      website: 'https://op-proper.gov.ph',
      accent: Color(0xFF4F7FB1),
      icon: Icons.flag_circle_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'OLG',
      displayName: 'City Government of Olongapo',
      website: 'https://www.olongapocity.gov.ph',
      accent: Color(0xFF5B8872),
      icon: Icons.location_city_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'PNP',
      displayName: 'Philippine National Police',
      website: 'https://pnp.gov.ph',
      accent: Color(0xFFB43434),
      icon: Icons.local_police_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'SEN',
      displayName: 'Senate of the Philippines',
      website: 'https://legacy.senate.gov.ph',
      accent: Color(0xFFC39B2C),
      icon: Icons.how_to_vote_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'CSC',
      displayName: 'Civil Service Commission',
      website: 'https://csc.gov.ph',
      accent: Color(0xFF4A59A8),
      icon: Icons.badge_rounded,
    ),
    _OfficialAgencyInfo(
      label: 'TESDA',
      displayName: 'Technical Education and Skills Development Authority',
      website: 'https://www.tesda.gov.ph',
      accent: Color(0xFF3E7C86),
      icon: Icons.school_rounded,
    ),
  ];

  Future<void> _showLeaveDialog(
    BuildContext context,
    _OfficialAgencyInfo agency,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 68,
                    color: Color(0xFFBEBEBE),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'You are leaving BarangayMo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2B2D3A),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to visit ${agency.displayName}\'s website?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF666B82),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE7E7E7),
                          foregroundColor: const Color(0xFF353535),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Stay here'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _showFeature(
                            context,
                            'Open this website in your browser: ${agency.website}',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD70000),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _agencyTile(BuildContext context, _OfficialAgencyInfo agency) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showLeaveDialog(context, agency),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: agency.accent.withValues(alpha: 0.12),
                  border: Border.all(
                    color: agency.accent.withValues(alpha: 0.28),
                    width: 2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(agency.icon, color: agency.accent, size: 24),
                    Positioned(
                      bottom: 9,
                      child: Text(
                        agency.label,
                        style: TextStyle(
                          color: agency.accent,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            agency.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2F3248),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Government\nAgencies'),
        backgroundColor: const Color(0xFFD70000),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 82,
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _agencies.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (_, index) =>
                      _agencyTile(context, _agencies[index]),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFB80F0F), Color(0xFFD73232)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22B11212),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REGISTRY OF BARANGAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'INHABITANTS (RBI)',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Avail services by registering your barangay.',
                              style: TextStyle(
                                color: Color(0xFFFFE5E5),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 76,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: const Icon(
                          Icons.badge_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ],
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

class _OfficialAgencyInfo {
  final String label;
  final String displayName;
  final String website;
  final Color accent;
  final IconData icon;

  const _OfficialAgencyInfo({
    required this.label,
    required this.displayName,
    required this.website,
    required this.accent,
    required this.icon,
  });
}

class _ServiceAction {
  final String name;
  final IconData icon;
  final Widget page;
  const _ServiceAction(this.name, this.icon, this.page);
}

const _brgyServices = [
  _ServiceAction('Assistance', Icons.volunteer_activism, AssistancePage()),
  _ServiceAction('BPAT', Icons.shield, BpatPage()),
  _ServiceAction('Clearance', Icons.description, ClearancePage()),
  _ServiceAction(
    'Council',
    Icons.groups,
    OfficialBarangayProfilePage(initialTabIndex: 2),
  ),
  _ServiceAction('Disclosure', Icons.table_chart, DisclosureBoardPage()),
  _ServiceAction(
    'Education',
    Icons.menu_book,
    SimpleSerbilisPage(title: 'Education', isOfficial: true),
  ),
  _ServiceAction(
    'Provincial Govt',
    Icons.apartment_rounded,
    GovAgenciesPage(),
  ),
  _ServiceAction(
    'Gov Agencies',
    Icons.account_balance,
    const OfficialGovAgenciesPage(),
  ),
  _ServiceAction('Health', Icons.health_and_safety, HealthPage()),
  _ServiceAction('Lupon', Icons.gavel_rounded, KatarungangPambarangayPage()),
  _ServiceAction(
    'Other Barangay',
    Icons.travel_explore,
    SimpleSerbilisPage(title: 'Other Barangay', isOfficial: true),
  ),
  _ServiceAction(
    'Police',
    Icons.local_police,
    SimpleSerbilisPage(title: 'Police', isOfficial: true),
  ),
  _ServiceAction('QR ID', Icons.qr_code_scanner, ScanQrPage()),
  _ServiceAction('RBI', Icons.badge, ResidentRbiCardPage()),
  _ServiceAction('Responder', Icons.local_shipping, ResponderPage()),
  _ServiceAction(
    'Special Docs',
    Icons.stars,
    SimpleSerbilisPage(title: 'Special Docs', isOfficial: true),
  ),
  _ServiceAction('Community', Icons.forum, CommunityPage()),
];

const _skServices = [
  _ServiceAction('Community', Icons.hub, CommunityPage()),
  _ServiceAction(
    'Education',
    Icons.school,
    SimpleSerbilisPage(title: 'SK Education', isOfficial: true),
  ),
  _ServiceAction(
    'Officials',
    Icons.groups_2,
    OfficialBarangayProfilePage(initialTabIndex: 2),
  ),
  _ServiceAction(
    'Programs',
    Icons.assignment,
    SimpleSerbilisPage(title: 'Programs', isOfficial: true),
  ),
  _ServiceAction('Scholarship', Icons.card_giftcard, AssistancePage()),
  _ServiceAction(
    'Sports',
    Icons.sports_basketball,
    SimpleSerbilisPage(title: 'Sports', isOfficial: true),
  ),
];

class SimpleSerbilisPage extends StatelessWidget {
  final String title;
  final bool isOfficial;
  const SimpleSerbilisPage({
    super.key,
    required this.title,
    this.isOfficial = false,
  });

  void _openModule(
    BuildContext context,
    _SerbilisPortalItem item,
    Color heroStart,
    Color heroEnd,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _SerbilisModuleScreen(
          portalTitle: title,
          item: item,
          heroStart: heroStart,
          heroEnd: heroEnd,
          isOfficial: isOfficial,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _SerbilisPortalData.fromTitle(title);
    const residentAppBarBg = Color(0xFFF5F7FF);
    const residentFg = Color(0xFF2B3353);
    const residentBgStart = Color(0xFFF5F7FF);
    const residentBgEnd = Color(0xFFF0F3FF);
    const residentHeroStart = Color(0xFF3E4CC7);
    const residentHeroEnd = Color(0xFF6775E6);
    final appBarBg = isOfficial ? const Color(0xFFF7F8FC) : residentAppBarBg;
    final fg = isOfficial ? const Color(0xFF2F3248) : residentFg;
    final bgStart = isOfficial ? const Color(0xFFF7F8FC) : residentBgStart;
    final bgEnd = isOfficial ? _officialSurfaceBlend : residentBgEnd;
    final heroStart = isOfficial ? _officialHeaderStart : residentHeroStart;
    final heroEnd = isOfficial ? _officialHeaderEnd : residentHeroEnd;
    final heroSubtext = isOfficial
        ? _officialHeroSubtext
        : const Color(0xFFDDE3FF);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: appBarBg,
        foregroundColor: fg,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgStart, bgEnd],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [heroStart, heroEnd],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x30FFFFFF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isOfficial
                                ? 'Official Workflow'
                                : 'Resident Self-Service',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cfg.headline,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          cfg.description,
                          style: TextStyle(
                            color: heroSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: const Color(0x34FFFFFF),
                    child: Icon(cfg.icon, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...cfg.modules.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E8F2)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: heroStart),
                  ),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F3248),
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF676D86),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF636A85),
                  ),
                  onTap: () =>
                      _openModule(context, item, heroStart, heroEnd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SerbilisPortalData {
  final String headline;
  final String description;
  final Color heroStart;
  final Color heroEnd;
  final IconData icon;
  final List<_SerbilisPortalItem> modules;

  const _SerbilisPortalData({
    required this.headline,
    required this.description,
    required this.heroStart,
    required this.heroEnd,
    required this.icon,
    required this.modules,
  });

  static _SerbilisPortalData fromTitle(String title) {
    switch (title) {
      case 'Education':
      case 'SK Education':
        return const _SerbilisPortalData(
          headline: 'Barangay Education Hub',
          description:
              'Scholarships, training, and learning support for residents and youth.',
          heroStart: Color(0xFF4759C8),
          heroEnd: Color(0xFF6D7CE7),
          icon: Icons.menu_book,
          modules: [
            _SerbilisPortalItem(
              title: 'Scholarship Registry',
              subtitle: 'Apply and track scholarship assistance',
              icon: Icons.school,
              bg: Color(0xFFE3E9FF),
            ),
            _SerbilisPortalItem(
              title: 'TESDA Referral',
              subtitle: 'Skills training and employment readiness',
              icon: Icons.engineering,
              bg: Color(0xFFE8F2FF),
            ),
            _SerbilisPortalItem(
              title: 'ALS Enrollment',
              subtitle: 'Alternative learning support schedules',
              icon: Icons.groups,
              bg: Color(0xFFEAF5E8),
            ),
            _SerbilisPortalItem(
              title: 'Youth Programs',
              subtitle: 'Workshops, mentoring, and campus outreach',
              icon: Icons.workspace_premium,
              bg: Color(0xFFFFEFE1),
            ),
          ],
        );
      case 'Police':
        return const _SerbilisPortalData(
          headline: 'Police Coordination',
          description:
              'Incident reporting, blotter tracking, and safety coordination with PNP.',
          heroStart: Color(0xFF274F93),
          heroEnd: Color(0xFF4D72B3),
          icon: Icons.local_police,
          modules: [
            _SerbilisPortalItem(
              title: 'Report Incident',
              subtitle: 'Submit details for police and barangay response',
              icon: Icons.report_problem,
              bg: Color(0xFFE4ECFF),
            ),
            _SerbilisPortalItem(
              title: 'Blotter Verification',
              subtitle: 'Check report status and case reference',
              icon: Icons.receipt_long,
              bg: Color(0xFFE9F0FF),
            ),
            _SerbilisPortalItem(
              title: 'Patrol Request',
              subtitle: 'Request presence in high-risk areas',
              icon: Icons.directions_walk,
              bg: Color(0xFFEAF6EF),
            ),
            _SerbilisPortalItem(
              title: 'Emergency Contacts',
              subtitle: 'Quick access to hotline and precinct channels',
              icon: Icons.call,
              bg: Color(0xFFFFEFE4),
            ),
          ],
        );
      case 'Other Barangay':
        return const _SerbilisPortalData(
          headline: 'Inter-Barangay Services',
          description:
              'Coordinate requests and verification across neighboring barangays.',
          heroStart: Color(0xFF8E4E44),
          heroEnd: Color(0xFFB46B5A),
          icon: Icons.travel_explore,
          modules: [
            _SerbilisPortalItem(
              title: 'Transfer Request',
              subtitle: 'Start resident transfer and endorsement documents',
              icon: Icons.swap_horiz,
              bg: Color(0xFFFFE9E4),
            ),
            _SerbilisPortalItem(
              title: 'Cross-Barangay Clearance',
              subtitle: 'Coordinate clearance with destination barangay',
              icon: Icons.assignment_turned_in,
              bg: Color(0xFFFFEFE6),
            ),
            _SerbilisPortalItem(
              title: 'Referral Letter',
              subtitle: 'Generate referral for health and social support',
              icon: Icons.mail_outline,
              bg: Color(0xFFEAF0FF),
            ),
            _SerbilisPortalItem(
              title: 'Barangay Directory',
              subtitle: 'Contacts and office hours of nearby barangays',
              icon: Icons.location_city,
              bg: Color(0xFFEAF6EF),
            ),
          ],
        );
      default:
        return _SerbilisPortalData(
          headline: '$title Services',
          description: 'Access community services and support requests.',
          heroStart: const Color(0xFF3E4CC7),
          heroEnd: const Color(0xFF6978E1),
          icon: Icons.miscellaneous_services,
          modules: [
            const _SerbilisPortalItem(
              title: 'Open Services',
              subtitle: 'Access service request forms',
              icon: Icons.open_in_new,
              bg: Color(0xFFE4E9FF),
            ),
            const _SerbilisPortalItem(
              title: 'Status Tracking',
              subtitle: 'Monitor progress and updates',
              icon: Icons.timeline,
              bg: Color(0xFFE9F5EE),
            ),
          ],
        );
    }
  }
}

class _SerbilisPortalItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;

  const _SerbilisPortalItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bg,
  });
}

class _SerbilisModuleScreen extends StatefulWidget {
  final String portalTitle;
  final _SerbilisPortalItem item;
  final Color heroStart;
  final Color heroEnd;
  final bool isOfficial;

  const _SerbilisModuleScreen({
    required this.portalTitle,
    required this.item,
    required this.heroStart,
    required this.heroEnd,
    required this.isOfficial,
  });

  @override
  State<_SerbilisModuleScreen> createState() => _SerbilisModuleScreenState();
}

class _SerbilisModuleScreenState extends State<_SerbilisModuleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _requesterController = TextEditingController();
  final _mobileController = TextEditingController();
  final _detailsController = TextEditingController();
  String _priority = 'Normal';
  bool _submitting = false;
  String? _reference;
  DateTime? _submittedAt;

  @override
  void dispose() {
    _requesterController.dispose();
    _mobileController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  String _formatStamp(DateTime value) {
    final hh = value.hour.toString().padLeft(2, '0');
    final mm = value.minute.toString().padLeft(2, '0');
    return '${value.month}/${value.day}/${value.year} $hh:$mm';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();
    setState(() {
      _submitting = false;
      _submittedAt = now;
      _reference = 'SRV-${now.millisecondsSinceEpoch % 1000000}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSubmission = _reference != null && _submittedAt != null;
    final appBarBg = widget.isOfficial
        ? const Color(0xFFF7F8FC)
        : const Color(0xFFF5F7FF);
    final fg = widget.isOfficial
        ? const Color(0xFF2F3248)
        : const Color(0xFF2B3353);
    final bgStart = widget.isOfficial
        ? const Color(0xFFF7F8FC)
        : const Color(0xFFF5F7FF);
    final bgEnd = widget.isOfficial
        ? _officialSurfaceBlend
        : const Color(0xFFF0F3FF);
    final heroSubtext = widget.isOfficial
        ? _officialHeroSubtext
        : const Color(0xFFDDE3FF);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        backgroundColor: appBarBg,
        foregroundColor: fg,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgStart, bgEnd],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.heroStart, widget.heroEnd],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0x2EFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.item.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x2EFFFFFF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.isOfficial
                                ? 'Official Processing'
                                : 'Resident Request',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.item.subtitle,
                          style: TextStyle(
                            color: heroSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4E8F2)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Intake',
                      style: TextStyle(
                        color: Color(0xFF2F3248),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _requesterController,
                      decoration: const InputDecoration(
                        labelText: 'Requester Name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Mobile number is required.';
                        }
                        if (value.replaceAll(RegExp(r'\D'), '').length < 10) {
                          return 'Enter a valid mobile number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: const [
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                        DropdownMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(
                          value: 'Urgent',
                          child: Text('Urgent'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _priority = value ?? 'Normal');
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _detailsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Request Details',
                        hintText:
                            'Describe your ${widget.item.title.toLowerCase()} request.',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 10) {
                          return 'Please enter at least 10 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _submitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: widget.heroStart,
                        ),
                        icon: const Icon(Icons.send_rounded),
                        label: Text(
                          _submitting ? 'Submitting...' : 'Submit Request',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasSubmission) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2FAF6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCAE9D8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Submitted',
                      style: TextStyle(
                        color: Color(0xFF2E4D3F),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reference: $_reference',
                      style: const TextStyle(
                        color: Color(0xFF2F5E47),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Time: ${_formatStamp(_submittedAt!)}',
                      style: const TextStyle(
                        color: Color(0xFF4D6E5E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _SerbilisProgressRow(
                      icon: Icons.check_circle,
                      title: 'Received by Barangay Desk',
                      subtitle: 'Digital ticket has been queued.',
                    ),
                    const SizedBox(height: 6),
                    _SerbilisProgressRow(
                      icon: Icons.tune,
                      title: 'Screening and Routing',
                      subtitle: 'Assigned based on priority: $_priority',
                    ),
                    const SizedBox(height: 6),
                    _SerbilisProgressRow(
                      icon: Icons.schedule,
                      title: 'Expected update window',
                      subtitle: _priority == 'Urgent'
                          ? 'Within 2-4 hours'
                          : 'Within 24 hours',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SerbilisProgressRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SerbilisProgressRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F3EC),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: const Color(0xFF2E5A46), size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2F3248),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF5E657D),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
