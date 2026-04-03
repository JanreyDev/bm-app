part of barangaymo_app;

class ResidentAnnouncementPage extends StatelessWidget {
  const ResidentAnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search announcement...',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _AnnouncementChip(label: 'Civic Engagement'),
                _AnnouncementChip(label: 'Community Events'),
                _AnnouncementChip(label: 'Education & Training'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: const [
              _AnnouncementTile(
                title: 'Tree Planting Day',
                category: 'Environmental Announcements',
                dateRange: 'Nov 17 to Nov 17',
              ),
              _AnnouncementTile(
                title: 'Year-End Celebration',
                category: 'Civic Engagement & Outreach',
                dateRange: 'Dec 21 to Dec 21',
              ),
              _AnnouncementTile(
                title: 'Monthly Meeting',
                category: 'Meetings & Schedules',
                dateRange: 'Dec 1 to Dec 1',
              ),
              _AnnouncementTile(
                title: 'Power Outage Alert',
                category: 'Public Announcements',
                dateRange: 'Nov 15 to Nov 15',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnnouncementChip extends StatelessWidget {
  final String label;
  const _AnnouncementChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(label: Text(label, style: const TextStyle(fontSize: 12))),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  final String title;
  final String category;
  final String dateRange;
  const _AnnouncementTile({
    required this.title,
    required this.category,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.attachment, color: Color(0xFF2E35D3)),
            ),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(category),
            const SizedBox(height: 4),
            Text(
              dateRange,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => _showFeature(context, '$title details'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2E35D3),
              ),
              child: const Text('More Info'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResidentSpecialDocsPage extends StatelessWidget {
  const ResidentSpecialDocsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Docs'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6F8FF), Color(0xFFF9F2EE)],
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
                  colors: [Color(0xFF3F4EC8), Color(0xFF7181F2)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x223A48C2),
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
                          'Digital Identity & Priority Docs',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Access RBI, QR verification, and responder tools in one secure place.',
                          style: TextStyle(
                            color: Color(0xFFDDE3FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.security_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _docActionCard(
              context: context,
              title: 'QR ID Scanner',
              subtitle: 'Validate resident identity and scan barangay IDs.',
              icon: Icons.qr_code_scanner_rounded,
              accent: const Color(0xFFD83D3D),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanQrPage()),
              ),
            ),
            const SizedBox(height: 10),
            _docActionCard(
              context: context,
              title: 'RBI Card',
              subtitle: 'Open your profile, card details, and transactions.',
              icon: Icons.badge_rounded,
              accent: const Color(0xFF4557CA),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResidentRbiCardPage()),
              ),
            ),
            const SizedBox(height: 10),
            _docActionCard(
              context: context,
              title: 'Responder',
              subtitle:
                  'Fast access to emergency contacts and location sharing.',
              icon: Icons.emergency_rounded,
              accent: const Color(0xFF8A5A44),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResponderPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _docActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE3E7F4)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 9,
                offset: Offset(0, 4),
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
                  color: accent.withValues(alpha: 0.14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF2F334A),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF646C88),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: accent, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ResidentRequestsPage extends StatefulWidget {
  const ResidentRequestsPage({super.key});

  @override
  State<ResidentRequestsPage> createState() => _ResidentRequestsPageState();
}

class _ResidentRequestsPageState extends State<ResidentRequestsPage> {
  String _query = '';
  String _selectedStatus = 'All';
  bool _loading = true;
  final List<_ResidentRequestEntry> _history = [];

  static const _statusFilters = [
    'All',
    'Pending',
    'Approved',
    'Rejected',
    'Completed',
  ];

  static const _seedHistory = [
    _ResidentRequestEntry(
      category: 'Clearance',
      title: 'Barangay Clearance',
      requestId: 'BC-26-0220',
      status: 'Approved',
      purpose: 'Residency requirement',
      date: 'Feb 20, 2026',
    ),
    _ResidentRequestEntry(
      category: 'Assistance',
      title: 'Medical Assistance Form',
      requestId: 'MA-26-0218',
      status: 'Pending',
      purpose: 'Hospital bill support',
      date: 'Feb 18, 2026',
    ),
    _ResidentRequestEntry(
      category: 'Clearance',
      title: 'Certificate of Indigency',
      requestId: 'CI-26-0217',
      status: 'Rejected',
      purpose: 'Scholarship document',
      date: 'Feb 17, 2026',
    ),
    _ResidentRequestEntry(
      category: 'Business',
      title: 'Business Endorsement',
      requestId: 'BE-26-0210',
      status: 'Approved',
      purpose: 'Market stall permit',
      date: 'Feb 10, 2026',
    ),
    _ResidentRequestEntry(
      category: 'Clearance',
      title: 'Barangay Clearance',
      requestId: 'BC-26-0204',
      status: 'Completed',
      purpose: 'Claimed and downloaded copy',
      date: 'Feb 04, 2026',
    ),
  ];

  static final _availableRequests = [
    _ResidentRequestActionEntry(
      title: 'Clearance Requests',
      subtitle:
          'Generate and track barangay clearance and residency certificates.',
      icon: Icons.description_outlined,
      buttonLabel: 'Request Clearance',
      color: Color(0xFF4A66CB),
      leadTime: '2-3 days',
      serviceCategory: 'Clearance',
    ),
    _ResidentRequestActionEntry(
      title: 'Assistance Requests',
      subtitle:
          'Submit social, financial, educational, and medical support applications.',
      icon: Icons.volunteer_activism,
      buttonLabel: 'Request Assistance',
      color: Color(0xFFAE5A4E),
      leadTime: '2-3 days',
      serviceCategory: 'Assistance',
    ),
    _ResidentRequestActionEntry(
      title: 'BPAT Patrol Requests',
      subtitle:
          'File patrol checks, incident support, and neighborhood safety requests.',
      icon: Icons.shield_outlined,
      buttonLabel: 'Request BPAT',
      color: Color(0xFF3C5EA0),
      leadTime: 'Same day',
      serviceCategory: 'BPAT',
    ),
    _ResidentRequestActionEntry(
      title: 'Council Coordination',
      subtitle:
          'Request meeting, endorsement, or barangay council follow-up support.',
      icon: Icons.groups_rounded,
      buttonLabel: 'Request Council',
      color: Color(0xFF6A57BE),
      leadTime: '1-2 days',
      serviceCategory: 'Council',
    ),
    _ResidentRequestActionEntry(
      title: 'Health Service Requests',
      subtitle:
          'Open health assistance, checkup coordination, and medical referrals.',
      icon: Icons.health_and_safety_outlined,
      buttonLabel: 'Request Health',
      color: Color(0xFF2E8A79),
      leadTime: '1-3 days',
      serviceCategory: 'Health',
    ),
    _ResidentRequestActionEntry(
      title: 'Community Service Requests',
      subtitle:
          'Submit local announcements, support concerns, and community needs.',
      icon: Icons.forum_outlined,
      buttonLabel: 'Request Community',
      color: Color(0xFF8A5A44),
      leadTime: '1-2 days',
      serviceCategory: 'Community',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _history.addAll(_seedHistory);
    unawaited(_loadRequestsFromApi());
  }

  String _formatRequestDate(DateTime value) {
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

  Future<void> _loadRequestsFromApi() async {
    final result = await _ServiceRequestApi.instance.fetchRequests();
    if (!mounted) {
      return;
    }
    if (result.success) {
      _history
        ..clear()
        ..addAll(result.entries);
    }
    setState(() => _loading = false);
    if (!result.success) {
      _showFeature(
        context,
        'Using local request history for now: ${result.message}',
        tone: _ToastTone.warning,
      );
    }
  }

  Future<void> _openRequestComposer(_ResidentRequestActionEntry entry) async {
    final parentContext = context;
    final purposeController = TextEditingController();
    final detailsController = TextEditingController();
    var submitting = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (modalContext, setModal) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFF),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE0E4F2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: const TextStyle(
                        color: Color(0xFF2D334C),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF69708A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: purposeController,
                      decoration: const InputDecoration(
                        labelText: 'Purpose',
                        hintText: 'Why do you need this request?',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: detailsController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Details (optional)',
                        hintText: 'Add supporting details',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: submitting
                            ? null
                            : () async {
                                final purpose = purposeController.text.trim();
                                if (purpose.length < 4) {
                                  _showFeature(
                                    modalContext,
                                    'Please enter a clear purpose (at least 4 characters).',
                                    tone: _ToastTone.warning,
                                  );
                                  return;
                                }
                                setModal(() => submitting = true);
                                final result = await _ServiceRequestApi.instance
                                    .submitRequest(
                                      serviceCategory: entry.serviceCategory,
                                      serviceTitle: entry.title,
                                      purpose: purpose,
                                      details: detailsController.text.trim(),
                                    );
                                if (!mounted) {
                                  return;
                                }
                                if (sheetContext.mounted) {
                                  Navigator.pop(sheetContext);
                                }
                                if (result.success && result.entry != null) {
                                  _history.insert(0, result.entry!);
                                  setState(() {});
                                  _showFeature(
                                    parentContext,
                                    result.message,
                                    tone: _ToastTone.success,
                                  );
                                  return;
                                }
                                final local = _ResidentRequestEntry(
                                  category: entry.serviceCategory,
                                  title: entry.title,
                                  requestId:
                                      '${entry.serviceCategory.substring(0, math.min(2, entry.serviceCategory.length)).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                                  status: 'Pending',
                                  purpose: purpose,
                                  date: _formatRequestDate(DateTime.now()),
                                );
                                _history.insert(0, local);
                                setState(() {});
                                _showFeature(
                                  parentContext,
                                  'Saved locally: ${result.message}',
                                  tone: _ToastTone.warning,
                                );
                              },
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: Text(
                          submitting ? 'Submitting...' : 'Submit Request',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        purposeController.dispose();
        detailsController.dispose();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final rows = _history.where((item) {
      final matchesStatus =
          _selectedStatus == 'All' || item.status == _selectedStatus;
      final bag =
          '${item.title} ${item.requestId} ${item.purpose} ${item.category}'
              .toLowerCase();
      final matchesQuery = q.isEmpty || bag.contains(q);
      return matchesStatus && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF4F8FF), Color(0xFFF9F1ED)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3B4CC7), Color(0xFF6F80F1)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29424FC2),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -18,
                    top: -16,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Track Your Requests',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Monitor clearances and assistance applications in one place.',
                              style: TextStyle(
                                color: Color(0xFFE4E8FF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: Color(0x34FFFFFF),
                        child: Icon(
                          Icons.assignment_turned_in_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE3E7F4)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: 'Search requests, ID, purpose...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: LinearProgressIndicator(minHeight: 3),
              )
            else
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _statusFilters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (_, i) {
                    final label = _statusFilters[i];
                    final active = label == _selectedStatus;
                    final count = label == 'All'
                        ? _history.length
                        : _history.where((item) => item.status == label).length;
                    return ChoiceChip(
                      label: Text('$label ($count)'),
                      selected: active,
                      onSelected: (_) => setState(() => _selectedStatus = label),
                      selectedColor: const Color(0xFFDCE4FF),
                      side: BorderSide(
                        color: active
                            ? const Color(0xFF576DD8)
                            : const Color(0xFFD9DFEF),
                      ),
                      labelStyle: TextStyle(
                        color: active
                            ? const Color(0xFF32419A)
                            : const Color(0xFF626983),
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Available Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2F334A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${_availableRequests.length} service request type(s) available',
              style: const TextStyle(
                color: Color(0xFF6A7089),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ..._availableRequests.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _requestActionCard(
                  context: context,
                  title: entry.title,
                  subtitle: entry.subtitle,
                  icon: entry.icon,
                  buttonLabel: entry.buttonLabel,
                  color: entry.color,
                  leadTime: entry.leadTime,
                  onTap: () => _openRequestComposer(entry),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Request History (${rows.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2F334A),
              ),
            ),
            const SizedBox(height: 8),
            if (rows.isEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E6F2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_off_rounded, color: Color(0xFF7A829D)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No request records found',
                        style: TextStyle(
                          color: Color(0xFF565D79),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...rows.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4E6F3)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _statusIcon(item.status),
                            color: _statusColor(item.status),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D3148),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(
                                item.status,
                              ).withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                color: _statusColor(item.status),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${item.requestId} | ${item.date}',
                        style: const TextStyle(
                          color: Color(0xFF676D88),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Purpose: ${item.purpose}',
                        style: const TextStyle(
                          color: Color(0xFF5D627D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(
                                item.status,
                              ).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              item.category,
                              style: TextStyle(
                                color: _statusColor(item.status),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => _openRequestDetails(context, item),
                            icon: const Icon(
                              Icons.visibility_rounded,
                              size: 18,
                            ),
                            label: const Text('Details'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF3F4FC8),
                  side: const BorderSide(color: Color(0xFFC4CEEE)),
                ),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Return Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonLabel,
    required Color color,
    String leadTime = '2-3 days',
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7F4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2F334A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  leadTime,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF656B85),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.withValues(alpha: 0.4)),
                foregroundColor: color,
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF2F965D);
      case 'Completed':
        return const Color(0xFF3B56C8);
      case 'Rejected':
        return const Color(0xFFD34F42);
      case 'Pending':
      default:
        return const Color(0xFFB77A2F);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Approved':
        return Icons.verified_rounded;
      case 'Completed':
        return Icons.download_done_rounded;
      case 'Rejected':
        return Icons.cancel_rounded;
      case 'Pending':
      default:
        return Icons.schedule_rounded;
    }
  }

  IconData _entryIcon(_ResidentRequestEntry item) {
    final title = item.title.toLowerCase();
    if (title.contains('medical')) return Icons.local_hospital_rounded;
    if (title.contains('business')) return Icons.store_rounded;
    if (title.contains('residency')) return Icons.home_rounded;
    if (title.contains('indigency')) return Icons.assignment_ind_rounded;
    return Icons.description_rounded;
  }

  void _openRequestDetails(BuildContext context, _ResidentRequestEntry item) {
    final accent = _statusColor(item.status);
    final subtitle = switch (item.status) {
      'Approved' => 'Approved on ${item.date}',
      'Rejected' => 'Rejected on ${item.date}',
      'Completed' => 'Completed and downloaded',
      _ => 'Pending review and verification',
    };
    final detail = switch (item.status) {
      'Rejected' => 'Reason: ${item.purpose}',
      'Completed' => 'Released to resident on ${item.date}',
      _ => 'Purpose: ${item.purpose}',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DocumentStatusDetailPage(
          status: item.status,
          accent: accent,
          entry: _LegacyDocEntry(
            title: item.title,
            subtitle: subtitle,
            detail: detail,
            reference: item.requestId,
            icon: _entryIcon(item),
          ),
        ),
      ),
    );
  }
}

class _ResidentRequestActionEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final String buttonLabel;
  final Color color;
  final String leadTime;
  final String serviceCategory;

  const _ResidentRequestActionEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttonLabel,
    required this.color,
    required this.leadTime,
    required this.serviceCategory,
  });
}

class _ServiceRequestFetchResult {
  final bool success;
  final String message;
  final List<_ResidentRequestEntry> entries;

  const _ServiceRequestFetchResult({
    required this.success,
    required this.message,
    this.entries = const <_ResidentRequestEntry>[],
  });
}

class _ServiceRequestSubmitResult {
  final bool success;
  final String message;
  final _ResidentRequestEntry? entry;

  const _ServiceRequestSubmitResult({
    required this.success,
    required this.message,
    this.entry,
  });
}

class _ServiceRequestStatusUpdateResult {
  final bool success;
  final String message;
  final _ResidentRequestEntry? entry;

  const _ServiceRequestStatusUpdateResult({
    required this.success,
    required this.message,
    this.entry,
  });
}

class _ServiceRequestAttachmentPayload {
  final String fileName;
  final String imageBase64;

  const _ServiceRequestAttachmentPayload({
    required this.fileName,
    required this.imageBase64,
  });
}

class _ServiceRequestApi {
  _ServiceRequestApi._();
  static final _ServiceRequestApi instance = _ServiceRequestApi._();
  static const Duration _requestTimeout = Duration(seconds: 8);

  Future<_ServiceRequestFetchResult> fetchRequests() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ServiceRequestFetchResult(
        success: false,
        message: 'Please log in again to load requests.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>['services/requests', 'requests'];
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
            final rawList = body['requests'] ?? body['data'];
            if (rawList is! List) {
              return const _ServiceRequestFetchResult(
                success: false,
                message: 'Service requests payload is invalid.',
              );
            }
            final entries = <_ResidentRequestEntry>[];
            for (final item in rawList) {
              if (item is! Map<String, dynamic>) {
                continue;
              }
              final mapped = _mapRequest(item);
              if (mapped != null) {
                entries.add(mapped);
              }
            }
            return _ServiceRequestFetchResult(
              success: true,
              message: _extractApiMessage(body, fallback: 'Requests loaded.'),
              entries: entries,
            );
          }
          return _ServiceRequestFetchResult(
            success: false,
            message: _extractApiMessage(
              body,
              fallback: 'Unable to load requests.',
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
      return const _ServiceRequestFetchResult(
        success: false,
        message: 'Loading requests timed out.',
      );
    }
    if (sawConnectionError) {
      return const _ServiceRequestFetchResult(
        success: false,
        message: 'Cannot connect to server to load requests.',
      );
    }
    return const _ServiceRequestFetchResult(
      success: false,
      message: 'Requests endpoint is not available yet.',
    );
  }

  Future<_ServiceRequestSubmitResult> submitRequest({
    required String serviceCategory,
    required String serviceTitle,
    required String purpose,
    String details = '',
    List<_ServiceRequestAttachmentPayload> attachments = const [],
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ServiceRequestSubmitResult(
        success: false,
        message: 'Please log in again before requesting.',
      );
    }

    final payload = jsonEncode({
      'service_category': serviceCategory.trim(),
      'service_title': serviceTitle.trim(),
      'purpose': purpose.trim(),
      if (details.trim().isNotEmpty) 'details': details.trim(),
      if (attachments.isNotEmpty)
        'attachments': attachments
            .where(
              (item) =>
                  item.fileName.trim().isNotEmpty &&
                  item.imageBase64.trim().isNotEmpty,
            )
            .map(
              (item) => {
                'file_name': item.fileName.trim(),
                'image_base64': item.imageBase64.trim(),
              },
            )
            .toList(),
    });

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>['services/requests', 'requests'];
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
            final raw = body['request'] ?? body['data'];
            final mapped = raw is Map<String, dynamic> ? _mapRequest(raw) : null;
            return _ServiceRequestSubmitResult(
              success: true,
              message: _extractApiMessage(
                body,
                fallback: 'Service request submitted.',
              ),
              entry: mapped,
            );
          }
          return _ServiceRequestSubmitResult(
            success: false,
            message: _extractApiMessage(
              body,
              fallback: 'Unable to submit request.',
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
      return const _ServiceRequestSubmitResult(
        success: false,
        message: 'Submitting request timed out.',
      );
    }
    if (sawConnectionError) {
      return const _ServiceRequestSubmitResult(
        success: false,
        message: 'Cannot connect to server to submit request.',
      );
    }
    return const _ServiceRequestSubmitResult(
      success: false,
      message: 'Requests endpoint is not available yet.',
    );
  }

  Future<_ServiceRequestStatusUpdateResult> updateRequestStatus({
    required int serviceRequestId,
    required String status,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ServiceRequestStatusUpdateResult(
        success: false,
        message: 'Please log in again before updating request status.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final payload = jsonEncode({'status': status.trim()});
    final paths = <String>[
      'services/requests/$serviceRequestId/status',
      'requests/$serviceRequestId/status',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http
              .patch(
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
            final raw = body['request'] ?? body['data'];
            final mapped = raw is Map<String, dynamic> ? _mapRequest(raw) : null;
            return _ServiceRequestStatusUpdateResult(
              success: true,
              message: _extractApiMessage(
                body,
                fallback: 'Service request status updated.',
              ),
              entry: mapped,
            );
          }
          return _ServiceRequestStatusUpdateResult(
            success: false,
            message: _extractApiMessage(
              body,
              fallback: 'Unable to update request status.',
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
      return const _ServiceRequestStatusUpdateResult(
        success: false,
        message: 'Updating request status timed out.',
      );
    }
    if (sawConnectionError) {
      return const _ServiceRequestStatusUpdateResult(
        success: false,
        message: 'Cannot connect to server to update request status.',
      );
    }
    return const _ServiceRequestStatusUpdateResult(
      success: false,
      message: 'Request status endpoint is not available yet.',
    );
  }

  _ResidentRequestEntry? _mapRequest(Map<String, dynamic> raw) {
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

    final title = read('service_title', fallback: read('title'));
    if (title.isEmpty) {
      return null;
    }
    final submittedAtRaw = read('submitted_at', fallback: read('created_at'));
    DateTime submittedAt = DateTime.now();
    if (submittedAtRaw.isNotEmpty) {
      submittedAt =
          DateTime.tryParse(submittedAtRaw)?.toLocal() ?? submittedAt;
    }
    final monthNames = const [
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
    final dateText =
        '${monthNames[submittedAt.month - 1]} ${submittedAt.day}, ${submittedAt.year}';
    return _ResidentRequestEntry(
      id: int.tryParse(read('id')) ?? 0,
      category: read('service_category', fallback: 'General'),
      title: title,
      requestId: read('request_id', fallback: read('id', fallback: 'REQ')),
      status: read('status', fallback: 'Pending'),
      purpose: read('purpose', fallback: read('details')),
      date: dateText,
      requesterName: read('requester_name'),
      requesterMobile: read('requester_mobile'),
      submittedAt: submittedAt,
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
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return fallback;
  }
}

class _ResidentRequestEntry {
  final int id;
  final String category;
  final String title;
  final String requestId;
  final String status;
  final String purpose;
  final String date;
  final String requesterName;
  final String requesterMobile;
  final DateTime? submittedAt;
  const _ResidentRequestEntry({
    this.id = 0,
    required this.category,
    required this.title,
    required this.requestId,
    required this.status,
    required this.purpose,
    required this.date,
    this.requesterName = '',
    this.requesterMobile = '',
    this.submittedAt,
  });
}

class ResidentServiceCategoryRequestPage extends StatefulWidget {
  final String serviceCategory;
  final String serviceTitle;
  final IconData icon;
  final Color accentColor;

  const ResidentServiceCategoryRequestPage({
    super.key,
    required this.serviceCategory,
    required this.serviceTitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  State<ResidentServiceCategoryRequestPage> createState() =>
      _ResidentServiceCategoryRequestPageState();
}

class _ResidentServiceCategoryRequestPageState
    extends State<ResidentServiceCategoryRequestPage> {
  final _purposeController = TextEditingController();
  final _detailsController = TextEditingController();
  final _history = <_ResidentRequestEntry>[];
  final _attachments = <_ResidentServiceAttachmentValue>[];
  bool _loading = true;
  bool _submitting = false;

  bool get _isResponderService =>
      widget.serviceCategory.trim().toLowerCase() == 'responder';

  @override
  void initState() {
    super.initState();
    unawaited(_loadHistory());
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 72,
    );
    if (image == null || !mounted) {
      return;
    }
    final bytes = await image.readAsBytes();
    if (bytes.isEmpty) {
      _showFeature(
        context,
        'Selected image is invalid.',
        tone: _ToastTone.warning,
      );
      return;
    }
    setState(() {
      _attachments.add(
        _ResidentServiceAttachmentValue(fileName: image.name, bytes: bytes),
      );
    });
  }

  Future<void> _loadHistory() async {
    final result = await _ServiceRequestApi.instance.fetchRequests();
    if (!mounted) {
      return;
    }
    if (result.success) {
      _history
        ..clear()
        ..addAll(
          result.entries.where(
            (item) =>
                item.category.trim().toLowerCase() ==
                widget.serviceCategory.trim().toLowerCase(),
          ),
        );
    }
    setState(() => _loading = false);
    if (!result.success) {
      _showFeature(
        context,
        'Unable to sync ${widget.serviceCategory} requests: ${result.message}',
        tone: _ToastTone.warning,
      );
    }
  }

  Future<void> _submit() async {
    if (_submitting) {
      return;
    }
    final purpose = _purposeController.text.trim();
    if (purpose.length < 4) {
      _showFeature(
        context,
        'Please enter a clear purpose (at least 4 characters).',
        tone: _ToastTone.warning,
      );
      return;
    }

    setState(() => _submitting = true);
    final attachmentPayload = _attachments
        .map(
          (item) => _ServiceRequestAttachmentPayload(
            fileName: item.fileName,
            imageBase64: base64Encode(item.bytes),
          ),
        )
        .toList();
    final detailsText = _detailsController.text.trim();
    final detailsWithAttachments = [
      if (detailsText.isNotEmpty) detailsText,
      if (_attachments.isNotEmpty) 'Attachments:',
      ..._attachments.map((item) => '- ${item.fileName}'),
    ].join('\n');

    final result = await _ServiceRequestApi.instance.submitRequest(
      serviceCategory: widget.serviceCategory,
      serviceTitle: widget.serviceTitle,
      purpose: purpose,
      details: detailsWithAttachments,
      attachments: attachmentPayload,
    );
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    if (result.success) {
      if (result.entry != null) {
        _history.insert(0, result.entry!);
      }
      _purposeController.clear();
      _detailsController.clear();
      _attachments.clear();
      _showFeature(context, result.message, tone: _ToastTone.success);
      setState(() {});
      return;
    }
    _showFeature(
      context,
      'Unable to submit right now: ${result.message}',
      tone: _ToastTone.warning,
    );
  }

  Color _statusColor(String status) {
    final value = status.trim().toLowerCase();
    if (value == 'approved') {
      return const Color(0xFF2F965D);
    }
    if (value == 'completed') {
      return const Color(0xFF3B56C8);
    }
    if (value == 'rejected') {
      return const Color(0xFFD34F42);
    }
    return const Color(0xFFB77A2F);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceCategory),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF4F8FF), Color(0xFFF9F1ED)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4E7F4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.accentColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Submit and track your ${widget.serviceCategory.toLowerCase()} request.',
                      style: const TextStyle(
                        color: Color(0xFF5C6280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isResponderService) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const EmergencyLocationSharePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.my_location_rounded),
                label: const Text('Open Share Live Location'),
              ),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: _purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _detailsController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Details',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE4E7F4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_file_rounded,
                        size: 18,
                        color: Color(0xFF4D59BF),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Attachments',
                          style: TextStyle(
                            color: Color(0xFF2F334A),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _pickAttachment,
                        icon: const Icon(Icons.image_outlined, size: 18),
                        label: const Text('Upload'),
                      ),
                    ],
                  ),
                  if (_attachments.isEmpty)
                    const Text(
                      'No image attached yet.',
                      style: TextStyle(
                        color: Color(0xFF676D88),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(_attachments.length, (index) {
                        final item = _attachments[index];
                        return Chip(
                          label: Text(item.fileName),
                          onDeleted: () {
                            setState(() => _attachments.removeAt(index));
                          },
                        );
                      }),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(backgroundColor: widget.accentColor),
              icon: const Icon(Icons.send_rounded),
              label: Text(_submitting ? 'Submitting...' : 'Submit Request'),
            ),
            const SizedBox(height: 14),
            Text(
              'Request History (${_history.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2F334A),
              ),
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: LinearProgressIndicator(minHeight: 3),
              )
            else if (_history.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E7F4)),
                ),
                child: const Text(
                  'No request records yet for this service.',
                  style: TextStyle(
                    color: Color(0xFF666D86),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              ..._history.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4E7F4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                color: Color(0xFF2F334A),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(item.status).withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(
                                color: _statusColor(item.status),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${item.requestId} | ${item.date}',
                        style: const TextStyle(
                          color: Color(0xFF666D86),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Purpose: ${item.purpose}',
                        style: const TextStyle(
                          color: Color(0xFF606781),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResidentServiceAttachmentValue {
  final String fileName;
  final Uint8List bytes;

  const _ResidentServiceAttachmentValue({
    required this.fileName,
    required this.bytes,
  });
}

class ResidentServicesPage extends StatelessWidget {
  const ResidentServicesPage({super.key});

  static const _commonServices = [
    _ServiceAction('Assistance', Icons.volunteer_activism, AssistancePage()),
    _ServiceAction(
      'BPAT',
      Icons.shield,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'BPAT',
        serviceTitle: 'BPAT Assistance',
        icon: Icons.shield,
        accentColor: Color(0xFF3C5EA0),
      ),
    ),
    _ServiceAction(
      'Clearance',
      Icons.description,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Clearance',
        serviceTitle: 'Barangay Clearance',
        icon: Icons.description,
        accentColor: Color(0xFF4A66CB),
      ),
    ),
    _ServiceAction(
      'Council',
      Icons.groups,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Council',
        serviceTitle: 'Council Coordination',
        icon: Icons.groups,
        accentColor: Color(0xFF6A57BE),
      ),
    ),
    _ServiceAction(
      'Health',
      Icons.health_and_safety,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Health',
        serviceTitle: 'Health Service Request',
        icon: Icons.health_and_safety,
        accentColor: Color(0xFF2E8A79),
      ),
    ),
    _ServiceAction(
      'Community',
      Icons.forum,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Community',
        serviceTitle: 'Community Service Request',
        icon: Icons.forum,
        accentColor: Color(0xFF8A5A44),
      ),
    ),
  ];

  static const _allServices = [
    _ServiceAction('Requests', Icons.assignment, ResidentRequestsPage()),
    _ServiceAction('Assistance', Icons.volunteer_activism, AssistancePage()),
    _ServiceAction(
      'BPAT',
      Icons.shield,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'BPAT',
        serviceTitle: 'BPAT Assistance',
        icon: Icons.shield,
        accentColor: Color(0xFF3C5EA0),
      ),
    ),
    _ServiceAction(
      'Clearance',
      Icons.description,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Clearance',
        serviceTitle: 'Barangay Clearance',
        icon: Icons.description,
        accentColor: Color(0xFF4A66CB),
      ),
    ),
    _ServiceAction(
      'Council',
      Icons.groups,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Council',
        serviceTitle: 'Council Coordination',
        icon: Icons.groups,
        accentColor: Color(0xFF6A57BE),
      ),
    ),
    _ServiceAction(
      'Disclosure',
      Icons.table_chart,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Disclosure',
        serviceTitle: 'Disclosure Request',
        icon: Icons.table_chart,
        accentColor: Color(0xFF4B6AC8),
      ),
    ),
    _ServiceAction(
      'Special Docs',
      Icons.stars,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Special Docs',
        serviceTitle: 'Special Docs Request',
        icon: Icons.stars,
        accentColor: Color(0xFF5F6AD6),
      ),
    ),
    _ServiceAction(
      'Responder',
      Icons.local_shipping,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Responder',
        serviceTitle: 'Responder Service Request',
        icon: Icons.local_shipping,
        accentColor: Color(0xFF4E6DBA),
      ),
    ),
    _ServiceAction(
      'Provincial Gov',
      Icons.apartment,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Provincial Gov',
        serviceTitle: 'Provincial Gov Request',
        icon: Icons.apartment,
        accentColor: Color(0xFF4D78BE),
      ),
    ),
    _ServiceAction(
      'Health',
      Icons.health_and_safety,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Health',
        serviceTitle: 'Health Service Request',
        icon: Icons.health_and_safety,
        accentColor: Color(0xFF2E8A79),
      ),
    ),
    _ServiceAction(
      'Community',
      Icons.forum,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Community',
        serviceTitle: 'Community Service Request',
        icon: Icons.forum,
        accentColor: Color(0xFF8A5A44),
      ),
    ),
    _ServiceAction(
      'QR ID',
      Icons.qr_code_scanner,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'QR ID',
        serviceTitle: 'QR ID Request',
        icon: Icons.qr_code_scanner,
        accentColor: Color(0xFF4E6ECC),
      ),
    ),
    _ServiceAction(
      'RBI',
      Icons.badge,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'RBI',
        serviceTitle: 'RBI Request',
        icon: Icons.badge,
        accentColor: Color(0xFF5D6AC8),
      ),
    ),
    _ServiceAction(
      'Education',
      Icons.menu_book,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Education',
        serviceTitle: 'Education Request',
        icon: Icons.menu_book,
        accentColor: Color(0xFF536FBE),
      ),
    ),
    _ServiceAction(
      'Police',
      Icons.local_police,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Police',
        serviceTitle: 'Police Request',
        icon: Icons.local_police,
        accentColor: Color(0xFF4E64B4),
      ),
    ),
    _ServiceAction(
      'Other Barangay',
      Icons.travel_explore,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Other Barangay',
        serviceTitle: 'Other Barangay Request',
        icon: Icons.travel_explore,
        accentColor: Color(0xFF5362B9),
      ),
    ),
    _ServiceAction(
      'SK Education',
      Icons.school,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'SK Education',
        serviceTitle: 'SK Education Request',
        icon: Icons.school,
        accentColor: Color(0xFF5D75CB),
      ),
    ),
    _ServiceAction(
      'Officials',
      Icons.groups_2,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Officials',
        serviceTitle: 'Officials Request',
        icon: Icons.groups_2,
        accentColor: Color(0xFF5D67AF),
      ),
    ),
    _ServiceAction(
      'Programs',
      Icons.assignment,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Programs',
        serviceTitle: 'Programs Request',
        icon: Icons.assignment,
        accentColor: Color(0xFF4F6EC5),
      ),
    ),
    _ServiceAction(
      'Scholarship',
      Icons.card_giftcard,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Scholarship',
        serviceTitle: 'Scholarship Request',
        icon: Icons.card_giftcard,
        accentColor: Color(0xFF7D5AA7),
      ),
    ),
    _ServiceAction(
      'Sports',
      Icons.sports_basketball,
      ResidentServiceCategoryRequestPage(
        serviceCategory: 'Sports',
        serviceTitle: 'Sports Request',
        icon: Icons.sports_basketball,
        accentColor: Color(0xFF5B73C8),
      ),
    ),
  ];

  void _openService(BuildContext context, _ServiceAction action) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => action.page));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F7FF), Color(0xFFF8F1ED)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3E4CC7), Color(0xFF6775E6)],
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
                        'Barangay Services',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Access permits, requests, support, and emergency channels.',
                        style: TextStyle(color: Color(0xFFDDE1FF)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0x33FFFFFF),
                  child: Icon(
                    Icons.miscellaneous_services,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResidentSpecialDocsPage(),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3C48BD),
                  ),
                  icon: const Icon(Icons.stars),
                  label: const Text('Special Docs'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResidentRequestsPage(),
                    ),
                  ),
                  icon: const Icon(Icons.assignment),
                  label: const Text('My Requests'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Common Services',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2F3146),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Frequently used resident services',
            style: TextStyle(
              color: Color(0xFF6A7089),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _commonServices.length,
              separatorBuilder: (_, _) => const SizedBox(width: 9),
              itemBuilder: (_, i) => _servicePill(context, _commonServices[i]),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'All Services',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2F3146),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Tap any tile to open the service page',
            style: TextStyle(
              color: Color(0xFF6A7089),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allServices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (_, i) => _serviceGridTile(context, _allServices[i]),
          ),
        ],
      ),
    );
  }

  Widget _servicePill(BuildContext context, _ServiceAction action) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _openService(context, action),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 128,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFF2F4FF)],
            ),
            border: Border.all(color: const Color(0xFFE2E5FF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x15000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: const Color(0xFF4753B8)),
              const SizedBox(height: 6),
              Text(
                action.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF424760),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceGridTile(BuildContext context, _ServiceAction action) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _openService(context, action),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE7E8F3)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE3E8FF), Color(0xFFF1F3FF)],
                  ),
                ),
                child: Icon(
                  action.icon,
                  size: 19,
                  color: const Color(0xFF4D59BF),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                action.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF43485E),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResidentProfilePhotoValue {
  final String? url;
  final Uint8List? bytes;
  final String? fileName;

  const _ResidentProfilePhotoValue({this.url, this.bytes, this.fileName});
}

class _ResidentProfilePhotoStore {
  static const presetUrls = [
    'https://i.pravatar.cc/600?img=47',
    'https://i.pravatar.cc/600?img=32',
    'https://i.pravatar.cc/600?img=44',
    'https://i.pravatar.cc/600?img=20',
    'https://i.pravatar.cc/600?img=16',
    'https://i.pravatar.cc/600?img=11',
  ];

  static final ValueNotifier<_ResidentProfilePhotoValue> photo =
      ValueNotifier<_ResidentProfilePhotoValue>(
        _ResidentProfilePhotoValue(url: presetUrls.first),
      );
}

String _fileDisplayName(String value) {
  if (value.isEmpty) return 'selected_image';
  final normalized = value.replaceAll('\\', '/');
  final parts = normalized.split('/');
  return parts.isEmpty ? value : parts.last;
}

Future<({Uint8List bytes, String fileName})?> _pickResidentPhotoData() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1200,
    imageQuality: 90,
  );
  if (picked == null) return null;
  final bytes = await picked.readAsBytes();
  return (bytes: bytes, fileName: picked.name);
}

Future<void> _openResidentProfilePhotoEditor(BuildContext context) async {
  final current = _ResidentProfilePhotoStore.photo.value;
  final urlController = TextEditingController(text: current.url ?? '');
  String selectedUrl =
      current.url ?? _ResidentProfilePhotoStore.presetUrls.first;
  Uint8List? selectedBytes = current.bytes;
  String? selectedFileName = current.fileName;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModal) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF8FAFF), Color(0xFFF8F0F2)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Change Profile Photo',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E3248),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Choose a high-quality portrait or paste image URL.',
                    style: TextStyle(
                      color: Color(0xFF687089),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await _pickResidentPhotoData();
                        if (picked == null) return;
                        setModal(() {
                          selectedBytes = picked.bytes;
                          selectedFileName = picked.fileName;
                          selectedUrl = '';
                          urlController.clear();
                        });
                      },
                      icon: const Icon(Icons.upload_file_rounded, size: 18),
                      label: const Text('Upload Photo'),
                    ),
                  ),
                  if (selectedBytes != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDCE2F2)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 46,
                              height: 46,
                              child: Image.memory(
                                selectedBytes!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedFileName == null
                                  ? 'Uploaded photo selected'
                                  : _fileDisplayName(selectedFileName!),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF3E465F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Clear',
                            onPressed: () {
                              setModal(() {
                                selectedBytes = null;
                                selectedFileName = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF7B829F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 210,
                    child: GridView.builder(
                      itemCount: _ResidentProfilePhotoStore.presetUrls.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemBuilder: (_, i) {
                        final url = _ResidentProfilePhotoStore.presetUrls[i];
                        final selectedItem =
                            selectedBytes == null && selectedUrl == url;
                        return InkWell(
                          onTap: () {
                            setModal(() {
                              selectedUrl = url;
                              selectedBytes = null;
                              selectedFileName = null;
                            });
                            urlController.text = url;
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selectedItem
                                    ? const Color(0xFF4B59C5)
                                    : const Color(0xFFD9DEEE),
                                width: selectedItem ? 2 : 1,
                              ),
                              boxShadow: selectedItem
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x334B59C5),
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                                  if (selectedItem)
                                    const Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.all(6),
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Color(0xFF4B59C5),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
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
                  TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      labelText: 'Or paste profile image URL',
                      hintText: 'https://...',
                    ),
                    onChanged: (value) => setModal(() {
                      selectedUrl = value.trim();
                      selectedBytes = null;
                      selectedFileName = null;
                    }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final seed = DateTime.now().microsecondsSinceEpoch;
                            final urls = _ResidentProfilePhotoStore.presetUrls;
                            final next = urls[seed % urls.length];
                            setModal(() {
                              selectedUrl = next;
                              selectedBytes = null;
                              selectedFileName = null;
                              urlController.text = next;
                            });
                          },
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Randomize'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _ResidentProfilePhotoStore.photo.value =
                                const _ResidentProfilePhotoValue();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                          ),
                          label: const Text('Remove'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        final value = selectedUrl.trim();
                        _ResidentProfilePhotoStore.photo.value =
                            _ResidentProfilePhotoValue(
                              url: selectedBytes == null
                                  ? (value.isEmpty ? null : value)
                                  : null,
                              bytes: selectedBytes,
                              fileName: selectedFileName,
                            );
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3E4CC7),
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text('Apply Profile Photo'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  urlController.dispose();
}

class _ResidentEditableProfileAvatar extends StatelessWidget {
  final double size;
  final VoidCallback onEdit;
  const _ResidentEditableProfileAvatar({
    required this.size,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_ResidentProfilePhotoValue>(
      valueListenable: _ResidentProfilePhotoStore.photo,
      builder: (_, photo, __) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFDCE2FF)],
                ),
                border: Border.all(color: const Color(0x99FFFFFF), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (photo.bytes != null && photo.bytes!.isNotEmpty)
                        Image.memory(
                          photo.bytes!,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFE2E7FF),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF5B64A6),
                              size: 38,
                            ),
                          ),
                        )
                      else if (photo.url != null && photo.url!.isNotEmpty)
                        Image.network(
                          photo.url!,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFE2E7FF),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF5B64A6),
                              size: 38,
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFDEE2FF), Color(0xFFBAC2FF)],
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: size * 0.35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.28),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3E4CC7),
                    border: Border.all(color: Colors.white, width: 1.8),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ResidentProfilePage extends StatefulWidget {
  const ResidentProfilePage({super.key});

  @override
  State<ResidentProfilePage> createState() => _ResidentProfilePageState();
}

class _ResidentProfilePageState extends State<ResidentProfilePage> {
  @override
  void initState() {
    super.initState();
    unawaited(_ResidentProfileStore.ensureLoaded());
    unawaited(_ResidentProfileVerificationHub.ensureLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _ResidentProfileStore.refresh,
      builder: (context, _, __) {
        final profile = _ResidentProfileStore.profile;
        final completion = profile.profileCompletion.clamp(0.0, 1.0);
        final personalSummary = _residentPersonalSummary();
        final residenceSummary = _residentLocationSummary();

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF6F8FF), Color(0xFFF8F0EE)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3E4CC7), Color(0xFF6573E3)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x262E35D3),
                      blurRadius: 15,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _ResidentEditableProfileAvatar(
                      size: 72,
                      onEdit: () => _openResidentProfilePhotoEditor(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _residentDisplayName(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            residenceSummary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFFDDE0FF)),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Tap camera icon to change profile photo',
                            style: TextStyle(
                              color: Color(0xFFD8DCFF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResidentVerifyProfilePage(),
                        ),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: const Color(0xFFE6E7F2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile Completion',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F3146),
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: completion,
                      minHeight: 8,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      backgroundColor: const Color(0xFFE9ECFA),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4250C4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(completion * 100).round()}% complete. Finish your profile to unlock all services.',
                      style: const TextStyle(color: Color(0xFF666B86)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _profileAction(
                      context,
                      title: 'Verify',
                      icon: Icons.verified_user,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResidentVerifyProfilePage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _profileAction(
                      context,
                      title: 'RBI Card',
                      icon: Icons.badge,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResidentRbiCardPage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _profileAction(
                      context,
                      title: 'Settings',
                      icon: Icons.settings,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResidentSettingsPage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _profileInfoCard(
                context,
                title: 'Personal Information',
                subtitle: personalSummary,
                icon: Icons.person_outline,
              ),
              _profileInfoCard(
                context,
                title: 'Residence Details',
                subtitle: residenceSummary,
                icon: Icons.home_work_outlined,
              ),
              _profileInfoCard(
                context,
                title: 'Education and Employment',
                subtitle: profile.educationSummary(),
                icon: Icons.school_outlined,
              ),
              _profileInfoCard(
                context,
                title: 'Health Information',
                subtitle: profile.healthSummary(),
                icon: Icons.health_and_safety_outlined,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResidentSupportPage()),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3A47BA),
                ),
                icon: const Icon(Icons.support_agent),
                label: const Text('Need Help? Contact Support'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _profileAction(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6E7F2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF4854BA)),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF4A4F68),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInfoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E7F2)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE4E8FF), Color(0xFFF1F3FF)],
            ),
          ),
          child: Icon(icon, color: const Color(0xFF4D59BE)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF2E3045),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF676C86),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ResidentVerifyProfilePage()),
        ),
      ),
    );
  }
}

class ResidentCartPage extends StatefulWidget {
  const ResidentCartPage({super.key});

  @override
  State<ResidentCartPage> createState() => _ResidentCartPageState();
}

class _ResidentProfileData {
  final String name;
  final String mobile;
  final String province;
  final String cityMunicipality;
  final String barangay;
  final String middleName;
  final String suffix;
  final String religion;
  final String educationAttainment;
  final String employmentType;
  final String employmentSector;
  final int householdSize;
  final double? monthlyHouseholdIncome;
  final String houseOwnershipStatus;
  final Map<String, bool> utilities;
  final double? heightCm;
  final double? weightKg;
  final String bloodType;
  final String medicalNotes;
  final bool isVerified;
  final double profileCompletion;

  const _ResidentProfileData({
    required this.name,
    required this.mobile,
    required this.province,
    required this.cityMunicipality,
    required this.barangay,
    required this.middleName,
    required this.suffix,
    required this.religion,
    required this.educationAttainment,
    required this.employmentType,
    required this.employmentSector,
    required this.householdSize,
    this.monthlyHouseholdIncome,
    required this.houseOwnershipStatus,
    required this.utilities,
    this.heightCm,
    this.weightKg,
    required this.bloodType,
    required this.medicalNotes,
    required this.isVerified,
    required this.profileCompletion,
  });

  const _ResidentProfileData.empty()
      : name = '',
        mobile = '',
        province = '',
        cityMunicipality = '',
        barangay = '',
        middleName = '',
        suffix = '',
        religion = '',
        educationAttainment = '',
        employmentType = '',
        employmentSector = '',
        householdSize = 0,
        monthlyHouseholdIncome = null,
        houseOwnershipStatus = '',
        utilities = const <String, bool>{},
        heightCm = null,
        weightKg = null,
        bloodType = '',
        medicalNotes = '',
        isVerified = false,
        profileCompletion = 0;

  static _ResidentProfileData fromJson(Map<String, dynamic> raw) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value == null) {
        return fallback;
      }
      if (value is String) {
        return value.trim();
      }
      return value.toString().trim();
    }

    int readInt(String key) {
      final value = raw[key];
      if (value is int) {
        return value;
      }
      if (value is String) {
        return int.tryParse(value.trim()) ?? 0;
      }
      if (value is num) {
        return value.toInt();
      }
      return 0;
    }

    double? readDouble(String key) {
      final value = raw[key];
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value.trim());
      }
      return null;
    }

    bool readBool(String key) {
      final value = raw[key];
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        final lowered = value.trim().toLowerCase();
        return lowered == 'true' || lowered == '1' || lowered == 'yes';
      }
      return false;
    }

    final rawUtilities = raw['utilities'];
    final utilities = <String, bool>{};
    if (rawUtilities is Map) {
      rawUtilities.forEach((key, value) {
        final label = key.toString().trim();
        if (label.isEmpty) {
          return;
        }
        if (value is bool) {
          utilities[label] = value;
          return;
        }
        if (value is num) {
          utilities[label] = value != 0;
          return;
        }
        final lowered = value.toString().trim().toLowerCase();
        utilities[label] = lowered == 'true' || lowered == '1' || lowered == 'yes';
      });
    }

    return _ResidentProfileData(
      name: read('name'),
      mobile: read('mobile'),
      province: read('province'),
      cityMunicipality: read('city_municipality'),
      barangay: read('barangay'),
      middleName: read('middle_name'),
      suffix: read('suffix'),
      religion: read('religion'),
      educationAttainment: read('education_attainment'),
      employmentType: read('employment_type'),
      employmentSector: read('employment_sector'),
      householdSize: readInt('household_size'),
      monthlyHouseholdIncome: readDouble('monthly_household_income'),
      houseOwnershipStatus: read('house_ownership_status'),
      utilities: utilities,
      heightCm: readDouble('height_cm'),
      weightKg: readDouble('weight_kg'),
      bloodType: read('blood_type'),
      medicalNotes: read('medical_notes'),
      isVerified: readBool('is_verified'),
      profileCompletion: readDouble('profile_completion') ?? 0,
    );
  }

  String educationSummary() {
    if (educationAttainment.isEmpty &&
        employmentType.isEmpty &&
        employmentSector.isEmpty) {
      return 'Attainment, occupation, skills, and job status';
    }
    final parts = <String>[
      if (educationAttainment.isNotEmpty) educationAttainment,
      if (employmentType.isNotEmpty) employmentType,
      if (employmentSector.isNotEmpty) employmentSector,
    ];
    return parts.join(' | ');
  }

  String healthSummary() {
    if (heightCm == null &&
        weightKg == null &&
        bloodType.isEmpty &&
        medicalNotes.isEmpty) {
      return 'Height, weight, blood type, and medical details';
    }
    final parts = <String>[
      if (heightCm != null) '${heightCm!.toStringAsFixed(1)} cm',
      if (weightKg != null) '${weightKg!.toStringAsFixed(1)} kg',
      if (bloodType.isNotEmpty) 'Blood: $bloodType',
      if (medicalNotes.isNotEmpty) medicalNotes,
    ];
    return parts.join(' | ');
  }
}

class _ResidentProfileApiResult {
  final bool success;
  final String message;
  final _ResidentProfileData? profile;

  const _ResidentProfileApiResult({
    required this.success,
    required this.message,
    this.profile,
  });
}

class _ResidentProfileApi {
  _ResidentProfileApi._();
  static final _ResidentProfileApi instance = _ResidentProfileApi._();
  static const Duration _requestTimeout = Duration(seconds: 8);

  Future<_ResidentProfileApiResult> fetchProfile() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ResidentProfileApiResult(
        success: false,
        message: 'Please log in again to load profile.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    const paths = <String>['profile/resident', 'resident/profile', 'profile'];
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
            final rawProfile = body['profile'] ?? body['data'] ?? body;
            if (rawProfile is! Map<String, dynamic>) {
              return const _ResidentProfileApiResult(
                success: false,
                message: 'Resident profile payload is invalid.',
              );
            }
            return _ResidentProfileApiResult(
              success: true,
              message: _extractApiMessage(body, fallback: 'Resident profile loaded.'),
              profile: _ResidentProfileData.fromJson(rawProfile),
            );
          }
          return _ResidentProfileApiResult(
            success: false,
            message: _extractApiMessage(
              body,
              fallback: 'Unable to load resident profile.',
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
      return const _ResidentProfileApiResult(
        success: false,
        message: 'Loading resident profile timed out.',
      );
    }
    if (sawConnectionError) {
      return const _ResidentProfileApiResult(
        success: false,
        message: 'Cannot connect to server to load resident profile.',
      );
    }
    return const _ResidentProfileApiResult(
      success: false,
      message: 'Resident profile endpoint is not available yet.',
    );
  }

  Future<_ResidentProfileApiResult> submitProfile({
    required String educationAttainment,
    required String employmentType,
    required String employmentSector,
    required int householdSize,
    required double? monthlyHouseholdIncome,
    required String houseOwnershipStatus,
    required Map<String, bool> utilities,
    required double? heightCm,
    required double? weightKg,
    required String bloodType,
    required String medicalNotes,
    required bool isVerified,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ResidentProfileApiResult(
        success: false,
        message: 'Please log in again before verification.',
      );
    }

    final payload = jsonEncode({
      'education_attainment': educationAttainment.trim(),
      'employment_type': employmentType.trim(),
      if (employmentSector.trim().isNotEmpty)
        'employment_sector': employmentSector.trim(),
      'household_size': householdSize,
      if (monthlyHouseholdIncome != null)
        'monthly_household_income': monthlyHouseholdIncome,
      'house_ownership_status': houseOwnershipStatus.trim(),
      'utilities': utilities,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bloodType.trim().isNotEmpty) 'blood_type': bloodType.trim(),
      if (medicalNotes.trim().isNotEmpty) 'medical_notes': medicalNotes.trim(),
      'is_verified': isVerified,
    });

    var sawTimeout = false;
    var sawConnectionError = false;
    const paths = <String>['profile/resident', 'resident/profile', 'profile'];
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
            final rawProfile = body['profile'] ?? body['data'] ?? body;
            final mapped = rawProfile is Map<String, dynamic>
                ? _ResidentProfileData.fromJson(rawProfile)
                : null;
            return _ResidentProfileApiResult(
              success: true,
              message: _extractApiMessage(
                body,
                fallback: 'Resident profile updated.',
              ),
              profile: mapped,
            );
          }
          return _ResidentProfileApiResult(
            success: false,
            message: _extractApiMessage(
              body,
              fallback: 'Unable to save resident profile.',
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
      return const _ResidentProfileApiResult(
        success: false,
        message: 'Submitting profile timed out.',
      );
    }
    if (sawConnectionError) {
      return const _ResidentProfileApiResult(
        success: false,
        message: 'Cannot connect to server to submit profile.',
      );
    }
    return const _ResidentProfileApiResult(
      success: false,
      message: 'Resident profile endpoint is not available yet.',
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
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return fallback;
  }
}

class _ResidentProfileStore {
  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  static bool _loaded = false;
  static bool _loading = false;
  static String _loadedForMobile = '';
  static _ResidentProfileData _profile = const _ResidentProfileData.empty();

  static _ResidentProfileData get profile => _profile;

  static Future<_ResidentProfileApiResult> ensureLoaded({
    bool force = false,
  }) async {
    final activeMobile = (_currentResidentProfile?.mobile ?? '').trim();
    final shouldForceByAccount =
        activeMobile.isNotEmpty &&
        _loadedForMobile.isNotEmpty &&
        _loadedForMobile != activeMobile;
    if (shouldForceByAccount) {
      force = true;
    }
    if (_loading) {
      return const _ResidentProfileApiResult(
        success: false,
        message: 'Resident profile load already in progress.',
      );
    }
    if (_loaded && !force) {
      return _ResidentProfileApiResult(
        success: true,
        message: 'Resident profile ready.',
        profile: _profile,
      );
    }
    _loading = true;
    try {
      final result = await _ResidentProfileApi.instance.fetchProfile();
      if (result.success && result.profile != null) {
        _profile = result.profile!;
        _loaded = true;
        _loadedForMobile = activeMobile;
        _syncSessionProfile(_profile);
        unawaited(
          _ResidentProfileVerificationHub._syncVerified(
            _profile.isVerified,
            persist: true,
          ),
        );
        refresh.value++;
      }
      return result;
    } finally {
      _loading = false;
    }
  }

  static Future<_ResidentProfileApiResult> submitProfile({
    required String educationAttainment,
    required String employmentType,
    required String employmentSector,
    required int householdSize,
    required double? monthlyHouseholdIncome,
    required String houseOwnershipStatus,
    required Map<String, bool> utilities,
    required double? heightCm,
    required double? weightKg,
    required String bloodType,
    required String medicalNotes,
    required bool isVerified,
  }) async {
    final result = await _ResidentProfileApi.instance.submitProfile(
      educationAttainment: educationAttainment,
      employmentType: employmentType,
      employmentSector: employmentSector,
      householdSize: householdSize,
      monthlyHouseholdIncome: monthlyHouseholdIncome,
      houseOwnershipStatus: houseOwnershipStatus,
      utilities: utilities,
      heightCm: heightCm,
      weightKg: weightKg,
      bloodType: bloodType,
      medicalNotes: medicalNotes,
      isVerified: isVerified,
    );
    if (result.success && result.profile != null) {
      _profile = result.profile!;
      _loaded = true;
      _loadedForMobile = (_currentResidentProfile?.mobile ?? '').trim();
      _syncSessionProfile(_profile);
      unawaited(
        _ResidentProfileVerificationHub._syncVerified(
          _profile.isVerified,
          persist: true,
        ),
      );
      refresh.value++;
    }
    return result;
  }

  static void _syncSessionProfile(_ResidentProfileData profile) {
    if (_currentResidentProfile == null) {
      return;
    }
    _currentResidentProfile = _ResidentSessionProfile(
      name: profile.name.isNotEmpty ? profile.name : _currentResidentProfile!.name,
      mobile: profile.mobile.isNotEmpty
          ? profile.mobile
          : _currentResidentProfile!.mobile,
      province: profile.province.isNotEmpty
          ? profile.province
          : _currentResidentProfile!.province,
      cityMunicipality: profile.cityMunicipality.isNotEmpty
          ? profile.cityMunicipality
          : _currentResidentProfile!.cityMunicipality,
      barangay: profile.barangay.isNotEmpty
          ? profile.barangay
          : _currentResidentProfile!.barangay,
      middleName: profile.middleName.isNotEmpty
          ? profile.middleName
          : _currentResidentProfile!.middleName,
      suffix: profile.suffix.isNotEmpty
          ? profile.suffix
          : _currentResidentProfile!.suffix,
      religion: profile.religion.isNotEmpty
          ? profile.religion
          : _currentResidentProfile!.religion,
    );
  }
}

class _ResidentProfileVerificationHub {
  static const _prefsKey = 'resident_profile_verified';
  static final ValueNotifier<bool> refresh = ValueNotifier<bool>(false);
  static bool _loaded = false;
  static bool _isVerified = false;

  static bool get isVerified => _isVerified;

  static Future<void> ensureLoaded() async {
    if (_loaded) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    _isVerified = prefs.getBool(_prefsKey) ?? false;
    final remote = await _ResidentProfileStore.ensureLoaded();
    if (remote.success && remote.profile != null) {
      _isVerified = remote.profile!.isVerified;
      await prefs.setBool(_prefsKey, _isVerified);
    }
    _loaded = true;
    refresh.value = _isVerified;
  }

  static Future<void> markVerified() async {
    await _syncVerified(true, persist: true);
  }

  static Future<void> _syncVerified(bool value, {bool persist = false}) async {
    _isVerified = value;
    _loaded = true;
    if (persist) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, value);
    }
    refresh.value = _isVerified;
  }
}

class _ResidentCartHub {
  static const _itemsKey = 'resident_cart_items';
  static const _ordersKey = 'resident_cart_orders';
  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  static bool _loaded = false;

  static final List<_CartLineItem> items = [];
  static final List<_OrderHistoryEntry> orders = [];

  static void _emit() => refresh.value++;

  static List<_CartLineItem> _defaultItems() => [
    _CartLineItem(
      title: 'Lenovo IdeaPad 15.6"',
      seller: 'L. Nadong Electronics',
      price: 14999,
      qty: 1,
      icon: Icons.laptop_mac,
      imageAsset: 'public/item-laptop.jpg',
      fulfillment: 'Pickup at Brgy Hall',
      deliveryZone: _marketDeliveryZones.first,
      deliveryPurok: _marketDeliveryPuroks.first,
      deliveryFee: 0,
    ),
    _CartLineItem(
      title: 'Epson EcoTank L3210',
      seller: 'Cabalan Office Depot',
      price: 8290,
      qty: 1,
      icon: Icons.print,
      imageAsset: 'public/item-printer.jpg',
      fulfillment: 'Seller Meetup',
      deliveryZone: _marketDeliveryZones[1],
      deliveryPurok: _marketDeliveryPuroks[1],
      deliveryFee: _marketDeliveryFeeFor(
        'Seller Meetup',
        _marketDeliveryZones[1],
        _marketDeliveryPuroks[1],
      ),
    ),
  ];

  static Future<void> ensureLoaded() async {
    if (_loaded) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final itemJson = prefs.getString(_itemsKey);
    final orderJson = prefs.getString(_ordersKey);

    items
      ..clear()
      ..addAll(
        itemJson == null
            ? _defaultItems()
            : (jsonDecode(itemJson) as List<dynamic>)
                  .map(
                    (item) => _CartLineItem.fromJson(item as Map<String, dynamic>),
                  )
                  .toList(),
      );
    orders
      ..clear()
      ..addAll(
        orderJson == null
            ? const <_OrderHistoryEntry>[]
            : (jsonDecode(orderJson) as List<dynamic>)
                  .map(
                    (item) => _OrderHistoryEntry.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList(),
      );
    _loaded = true;
    _emit();
  }

  static Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _itemsKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
    await prefs.setString(
      _ordersKey,
      jsonEncode(orders.map((item) => item.toJson()).toList()),
    );
  }

  static void addProduct(
    _ResidentProductData product, {
    int qty = 1,
    String fulfillment = 'Pickup at Brgy Hall',
    String deliveryZone = 'Zone 1',
    String deliveryPurok = 'Purok 1',
  }) {
    final safeQty = qty < 1 ? 1 : qty;
    final deliveryFee = _marketDeliveryFeeFor(
      fulfillment,
      deliveryZone,
      deliveryPurok,
    );
    final index = items.indexWhere(
      (item) => item.title == product.title && item.seller == product.seller,
    );

    if (index >= 0) {
      items[index].qty = (items[index].qty + safeQty).clamp(1, 99);
      items[index].fulfillment = fulfillment;
      items[index].deliveryZone = deliveryZone;
      items[index].deliveryPurok = deliveryPurok;
      items[index].deliveryFee = deliveryFee;
      unawaited(_saveState());
      _emit();
      return;
    }

    items.insert(
      0,
      _CartLineItem(
        title: product.title,
        seller: product.seller,
        price: product.price,
        qty: safeQty,
        icon: product.icon,
        imageAsset: product.imageAsset,
        fulfillment: fulfillment,
        deliveryZone: deliveryZone,
        deliveryPurok: deliveryPurok,
        deliveryFee: deliveryFee,
      ),
    );
    unawaited(_saveState());
    _emit();
  }

  static void changeQty(int index, int delta) {
    if (index < 0 || index >= items.length) {
      return;
    }
    final next = items[index].qty + delta;
    items[index].qty = next.clamp(1, 99);
    unawaited(_saveState());
    _emit();
  }

  static void updateFulfillment(int index, String value) {
    if (index < 0 || index >= items.length) {
      return;
    }
    items[index].fulfillment = value;
    items[index].deliveryFee = _marketDeliveryFeeFor(
      value,
      items[index].deliveryZone,
      items[index].deliveryPurok,
    );
    unawaited(_saveState());
    _emit();
  }

  static void updateDeliveryArea(int index, String zone, String purok) {
    if (index < 0 || index >= items.length) {
      return;
    }
    items[index].deliveryZone = zone;
    items[index].deliveryPurok = purok;
    items[index].deliveryFee = _marketDeliveryFeeFor(
      items[index].fulfillment,
      zone,
      purok,
    );
    unawaited(_saveState());
    _emit();
  }

  static _CartLineItem removeAt(int index) {
    final removed = items.removeAt(index);
    unawaited(_saveState());
    _emit();
    return removed;
  }

  static void clearItems() {
    items.clear();
    unawaited(_saveState());
    _emit();
  }

  static void addOrder(_OrderHistoryEntry order) {
    orders.insert(0, order);
    unawaited(_saveState());
    _emit();
  }

  static void updateOrderStatus(String orderId, String status) {
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index < 0) {
      return;
    }
    orders[index] = orders[index].copyWith(status: status);
    unawaited(_saveState());
    _emit();
  }
}

class _ResidentCartPageState extends State<ResidentCartPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _payerNameController = TextEditingController(text: 'Shamira Balandra');
  final _mobileController = TextEditingController(text: '09123456789');
  final _addressController = TextEditingController(
    text: '1953 Purok 7, Old Cabalan, Olongapo City, PH',
  );
  String _paymentProvider = 'GCash';

  bool _placingOrder = false;
  List<_CartLineItem> get _cartItems => _ResidentCartHub.items;
  List<_OrderHistoryEntry> get _orders => _ResidentCartHub.orders;

  void _onCartUpdated() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _ResidentCartHub.refresh.addListener(_onCartUpdated);
    _ResidentCartHub.ensureLoaded();
  }

  @override
  void dispose() {
    _ResidentCartHub.refresh.removeListener(_onCartUpdated);
    _tabController.dispose();
    _payerNameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  double get _subtotal =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.qty));
  double get _deliveryFee =>
      _cartItems.fold(0, (sum, item) => sum + item.deliveryFee);
  double get _serviceFee => _cartItems.isEmpty ? 0 : 35;
  double get _grandTotal => _subtotal + _deliveryFee + _serviceFee;

  String _currency(double amount) => 'PHP ${amount.toStringAsFixed(2)}';

  String _formatOrderDate(DateTime now) =>
      '${now.month}/${now.day}/${now.year}';

  void _changeQty(int index, int delta) {
    _ResidentCartHub.changeQty(index, delta);
  }

  void _removeItem(int index) {
    final item = _ResidentCartHub.removeAt(index);
    _showFeature(context, '${item.title} removed from cart');
  }

  Future<void> _placeOrder() async {
    if (_cartItems.isEmpty) {
      _showFeature(context, 'Your cart is empty.');
      return;
    }
    if (_payerNameController.text.trim().isEmpty ||
        _mobileController.text.trim().length < 11) {
      _showFeature(context, 'Please complete payer details.');
      return;
    }

    setState(() => _placingOrder = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) {
      return;
    }
    final now = DateTime.now();
    final orderItems = List<_CartLineItem>.from(
      _cartItems.map(
        (e) => _CartLineItem(
          title: e.title,
          seller: e.seller,
          price: e.price,
          qty: e.qty,
          icon: e.icon,
          imageAsset: e.imageAsset,
          fulfillment: e.fulfillment,
          deliveryZone: e.deliveryZone,
          deliveryPurok: e.deliveryPurok,
          deliveryFee: e.deliveryFee,
        ),
      ),
    );
    final payLink =
        'https://pay.barangaymo.local/${_paymentProvider.toLowerCase()}/${now.millisecondsSinceEpoch}';
    final order = _OrderHistoryEntry(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch % 100000}',
      date: _formatOrderDate(now),
      status: 'Pending',
      total: _grandTotal,
      items: orderItems,
      paymentProvider: _paymentProvider,
      paymentLink: payLink,
      deliveryFee: _deliveryFee,
    );
    _ResidentCartHub.addOrder(order);
    _ResidentCartHub.clearItems();
    setState(() => _placingOrder = false);
    _tabController.animateTo(1);
    _showFeature(context, 'Order placed. Pay via $_paymentProvider link.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: const Color(0xFFF7F8FF),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          indicator: BoxDecoration(
            color: const Color(0xFFDCE2FF),
            borderRadius: BorderRadius.circular(999),
          ),
          labelColor: const Color(0xFF2D3150),
          unselectedLabelColor: const Color(0xFF717793),
          labelStyle: const TextStyle(fontWeight: FontWeight.w800),
          tabs: const [
            Tab(text: 'My Cart'),
            Tab(text: 'My Orders'),
            Tab(text: 'Billing'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FF), Color(0xFFF8F0EE)],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3E4CC7), Color(0xFF6E7DE9)],
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
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0x33FFFFFF),
                        child: Icon(Icons.shopping_cart, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cart Summary',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${_cartItems.length} item(s) | Total ${_currency(_grandTotal)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFFDDE1FF),
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
                if (_cartItems.isEmpty)
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.remove_shopping_cart),
                      title: Text('Your cart is empty'),
                      subtitle: Text('Add products from the marketplace.'),
                    ),
                  )
                else
                  ...List.generate(_cartItems.length, (i) => _cartItemCard(i)),
                const SizedBox(height: 10),
                _billRow('Subtotal', _currency(_subtotal)),
                _billRow('Delivery Fee', _currency(_deliveryFee)),
                _billRow('Service Fee', _currency(_serviceFee)),
                const Divider(),
                _billRow('Grand Total', _currency(_grandTotal), bold: true),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _cartItems.isEmpty
                      ? null
                      : () => _tabController.animateTo(2),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                  ),
                  icon: const Icon(Icons.payment),
                  label: const Text('Proceed to Checkout'),
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              children: [
                if (_orders.isEmpty)
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.inventory_2_outlined),
                      title: Text('No orders yet'),
                      subtitle: Text(
                        'Your confirmed checkout orders appear here.',
                      ),
                    ),
                  )
                else
                  ..._orders.map(
                    (o) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E8F4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                o.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2E3046),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _orderStatusColor(o.status).withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  o.status,
                                  style: TextStyle(
                                    color: _orderStatusColor(o.status),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${o.date} | Total: ${_currency(o.total)}',
                            style: const TextStyle(
                              color: Color(0xFF666C86),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pay via ${o.paymentProvider} | Delivery ${_currency(o.deliveryFee)}',
                            style: const TextStyle(
                              color: Color(0xFF66708A),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...o.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.qty}x ${item.title} (${_currency(item.price * item.qty)})',
                                    style: const TextStyle(
                                      color: Color(0xFF4F5672),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${item.fulfillment} | ${item.deliveryZone}, ${item.deliveryPurok}',
                                    style: const TextStyle(
                                      color: Color(0xFF79809A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _showFeature(
                                    context,
                                    'Opening ${o.paymentProvider} link: ${o.paymentLink}',
                                  ),
                                  icon: const Icon(Icons.link_rounded),
                                  label: const Text('Pay Link'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (o.status == 'Pending')
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () {
                                      _ResidentCartHub.updateOrderStatus(
                                        o.id,
                                        'Paid',
                                      );
                                      _showFeature(
                                        context,
                                        '${o.id} marked as paid.',
                                      );
                                    },
                                    child: const Text('Mark Paid'),
                                  ),
                                ),
                              if (o.status == 'Paid')
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () {
                                      _ResidentCartHub.updateOrderStatus(
                                        o.id,
                                        'Fulfilled',
                                      );
                                      _showFeature(
                                        context,
                                        '${o.id} marked as fulfilled.',
                                      );
                                    },
                                    child: const Text('Fulfilled'),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E8F4)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _payerNameController,
                        decoration: const InputDecoration(
                          labelText: 'Payer name',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile number',
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _paymentProvider,
                        decoration: const InputDecoration(
                          labelText: 'Pay via link',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'GCash', child: Text('GCash')),
                          DropdownMenuItem(value: 'Maya', child: Text('Maya')),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() => _paymentProvider = value);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            labelText: 'Delivery Address',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F9FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFDDE3F3)),
                          ),
                          child: Text(
                            'Generated pay link will use $_paymentProvider and appear in My Orders after checkout.',
                            style: const TextStyle(
                              color: Color(0xFF5D6580),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _billRow('Subtotal', _currency(_subtotal)),
                _billRow('Delivery Fee', _currency(_deliveryFee)),
                _billRow('Service Fee', _currency(_serviceFee)),
                const Divider(),
                _billRow('Payable Amount', _currency(_grandTotal), bold: true),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: (_placingOrder || _cartItems.isEmpty)
                      ? null
                      : _placeOrder,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                  ),
                  icon: const Icon(Icons.check_circle),
                  label: Text(
                    _placingOrder ? 'Placing Order...' : 'Place Order',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartItemCard(int i) {
    final item = _cartItems[i];
    const fulfillmentOptions = ['Pickup at Brgy Hall', 'Seller Meetup'];
    final deliveryZoneField = DropdownButtonFormField<String>(
      initialValue: item.deliveryZone,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Zone',
        filled: true,
        fillColor: const Color(0xFFF7F9FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE3F3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE3F3)),
        ),
      ),
      items: _marketDeliveryZones
          .map(
            (zone) => DropdownMenuItem<String>(
              value: zone,
              child: Text(zone),
            ),
          )
          .toList(),
      onChanged: item.fulfillment == 'Pickup at Brgy Hall'
          ? null
          : (value) {
              if (value == null) {
                return;
              }
              _ResidentCartHub.updateDeliveryArea(i, value, item.deliveryPurok);
            },
    );
    final deliveryPurokField = DropdownButtonFormField<String>(
      initialValue: item.deliveryPurok,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Purok',
        filled: true,
        fillColor: const Color(0xFFF7F9FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE3F3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE3F3)),
        ),
      ),
      items: _marketDeliveryPuroks
          .map(
            (purok) => DropdownMenuItem<String>(
              value: purok,
              child: Text(purok),
            ),
          )
          .toList(),
      onChanged: item.fulfillment == 'Pickup at Brgy Hall'
          ? null
          : (value) {
              if (value == null) {
                return;
              }
              _ResidentCartHub.updateDeliveryArea(i, item.deliveryZone, value);
            },
    );

    Widget thumbnail() {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: item.imageAsset == null
            ? Icon(item.icon, color: const Color(0xFF4C57BB))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.imageAsset!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(item.icon, color: const Color(0xFF4C57BB)),
                ),
              ),
      );
    }

    Widget qtyControls() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FF),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFDDE2F2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _changeQty(i, -1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 26, height: 26),
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.remove_circle_outline, size: 18),
            ),
            SizedBox(
              width: 18,
              child: Text(
                '${item.qty}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            IconButton(
              onPressed: () => _changeQty(i, 1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 26, height: 26),
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.add_circle_outline, size: 18),
            ),
            IconButton(
              onPressed: () => _removeItem(i),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 26, height: 26),
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete_outline, size: 18),
            ),
          ],
        ),
      );
    }

    final fulfillmentField = DropdownButtonFormField<String>(
      initialValue: item.fulfillment,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Fulfillment',
        filled: true,
        fillColor: const Color(0xFFF7F9FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE3F3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE3F3)),
        ),
      ),
      items: fulfillmentOptions
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4F5674),
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }
        _ResidentCartHub.updateFulfillment(i, value);
      },
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7F3)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 390;
            final details = Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F3248),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.seller} | ${_currency(item.price)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF686D86),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  fulfillmentField,
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: deliveryZoneField),
                      const SizedBox(width: 8),
                      Expanded(child: deliveryPurokField),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Local delivery fee: ${_currency(item.deliveryFee)}',
                    style: const TextStyle(
                      color: Color(0xFF64708B),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
            if (compact) {
              return Column(
                children: [
                  Row(
                    children: [thumbnail(), const SizedBox(width: 10), details],
                  ),
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerRight, child: qtyControls()),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                thumbnail(),
                const SizedBox(width: 10),
                details,
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: qtyControls(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _billRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
      color: bold ? const Color(0xFF2E3046) : const Color(0xFF676D86),
      fontSize: bold ? 18 : 14,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }

  Color _orderStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF1F8A4D);
      case 'Fulfilled':
        return const Color(0xFF3A63CC);
      default:
        return const Color(0xFFB86919);
    }
  }
}

class _CartLineItem {
  final String title;
  final String seller;
  final double price;
  final IconData icon;
  final String? imageAsset;
  String fulfillment;
  String deliveryZone;
  String deliveryPurok;
  double deliveryFee;
  int qty;

  _CartLineItem({
    required this.title,
    required this.seller,
    required this.price,
    required this.qty,
    required this.icon,
    required this.fulfillment,
    required this.deliveryZone,
    required this.deliveryPurok,
    required this.deliveryFee,
    this.imageAsset,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'seller': seller,
    'price': price,
    'qty': qty,
    'imageAsset': imageAsset,
    'fulfillment': fulfillment,
    'deliveryZone': deliveryZone,
    'deliveryPurok': deliveryPurok,
    'deliveryFee': deliveryFee,
    'iconCodePoint': icon.codePoint,
    'iconFontFamily': icon.fontFamily,
    'iconFontPackage': icon.fontPackage,
  };

  factory _CartLineItem.fromJson(Map<String, dynamic> json) {
    return _CartLineItem(
      title: json['title'] as String? ?? 'Marketplace Item',
      seller: json['seller'] as String? ?? 'Barangay Seller',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      qty: (json['qty'] as num?)?.toInt() ?? 1,
      icon: IconData(
        (json['iconCodePoint'] as num?)?.toInt() ?? Icons.storefront.codePoint,
        fontFamily:
            json['iconFontFamily'] as String? ?? Icons.storefront.fontFamily,
        fontPackage: json['iconFontPackage'] as String?,
      ),
      imageAsset: json['imageAsset'] as String?,
      fulfillment:
          json['fulfillment'] as String? ?? 'Pickup at Brgy Hall',
      deliveryZone: json['deliveryZone'] as String? ?? _marketDeliveryZones.first,
      deliveryPurok:
          json['deliveryPurok'] as String? ?? _marketDeliveryPuroks.first,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
    );
  }
}

class _OrderHistoryEntry {
  final String id;
  final String date;
  final String status;
  final double total;
  final double deliveryFee;
  final String paymentProvider;
  final String paymentLink;
  final List<_CartLineItem> items;

  const _OrderHistoryEntry({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.deliveryFee,
    required this.paymentProvider,
    required this.paymentLink,
    required this.items,
  });

  _OrderHistoryEntry copyWith({
    String? id,
    String? date,
    String? status,
    double? total,
    double? deliveryFee,
    String? paymentProvider,
    String? paymentLink,
    List<_CartLineItem>? items,
  }) {
    return _OrderHistoryEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      total: total ?? this.total,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      paymentProvider: paymentProvider ?? this.paymentProvider,
      paymentLink: paymentLink ?? this.paymentLink,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'status': status,
    'total': total,
    'deliveryFee': deliveryFee,
    'paymentProvider': paymentProvider,
    'paymentLink': paymentLink,
    'items': items.map((item) => item.toJson()).toList(),
  };

  factory _OrderHistoryEntry.fromJson(Map<String, dynamic> json) {
    return _OrderHistoryEntry(
      id: json['id'] as String? ?? 'ORD-00000',
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      total: (json['total'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
      paymentProvider: json['paymentProvider'] as String? ?? 'GCash',
      paymentLink: json['paymentLink'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? const <dynamic>[])
          .map((item) => _CartLineItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

