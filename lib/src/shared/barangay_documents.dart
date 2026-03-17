part of barangaymo_app;

class LegacyClearancePage extends StatelessWidget {
  const LegacyClearancePage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Documents'),
          backgroundColor: const Color(0xFFF7F8FF),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.transparent,
            indicator: BoxDecoration(
              color: const Color(0xFFDDE2FF),
              borderRadius: BorderRadius.circular(999),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: const Color(0xFF2D3150),
            unselectedLabelColor: const Color(0xFF737992),
            labelStyle: const TextStyle(fontWeight: FontWeight.w800),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LegacyDocList(status: 'Pending'),
            _LegacyDocList(status: 'Approved'),
            _LegacyDocList(status: 'Rejected'),
            _LegacyDocList(status: 'Completed'),
          ],
        ),
      ),
    );
  }
}

class _LegacyDocList extends StatefulWidget {
  final String status;
  const _LegacyDocList({required this.status});

  @override
  State<_LegacyDocList> createState() => _LegacyDocListState();
}

class _LegacyDocListState extends State<_LegacyDocList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final documents = _documentsByStatus(widget.status);
    final accent = _statusColor(widget.status);
    final q = _query.trim().toLowerCase();
    final rows = documents.where((d) {
      final bag = '${d.title} ${d.subtitle} ${d.reference} ${d.detail}'
          .toLowerCase();
      return q.isEmpty || bag.contains(q);
    }).toList();

    return Container(
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
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.95),
                  accent.withValues(alpha: 0.75),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x36FFFFFF),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.folder_copy, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.status} Documents',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 21,
                        ),
                      ),
                      Text(
                        '${documents.length} requests | Avg turnaround ${_processingEta(widget.status)}',
                        style: const TextStyle(
                          color: Color(0xFFECEFFF),
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
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search by name, ID, purpose...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE3E6F4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE3E6F4)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (rows.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.search_off),
                title: Text('No matching documents'),
              ),
            )
          else
            ...rows.map(
              (d) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E7F3)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
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
                        CircleAvatar(
                          backgroundColor: accent.withValues(alpha: 0.13),
                          child: Icon(d.icon, color: accent),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            d.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D314A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.status,
                            style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      d.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF555C77),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      d.detail,
                      style: const TextStyle(
                        color: Color(0xFF666B84),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          size: 16,
                          color: Color(0xFF7A809A),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          d.reference,
                          style: const TextStyle(
                            color: Color(0xFF7A809A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _DocumentStatusDetailPage(
                                entry: d,
                                status: widget.status,
                                accent: accent,
                              ),
                            ),
                          ),
                          icon: Icon(
                            widget.status == 'Approved'
                                ? Icons.visibility
                                : widget.status == 'Completed'
                                ? Icons.download
                                : Icons.chevron_right,
                            color: accent,
                            size: 18,
                          ),
                          label: Text(
                            _statusAction(widget.status),
                            style: TextStyle(color: accent),
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
    );
  }

  List<_LegacyDocEntry> _documentsByStatus(String status) {
    switch (status) {
      case 'Approved':
        return const [
          _LegacyDocEntry(
            title: 'Barangay Clearance',
            subtitle: 'Approved on Feb 18, 2026',
            detail: 'Purpose: Employment requirement',
            reference: 'BC-26-0218',
            icon: Icons.task_alt,
          ),
          _LegacyDocEntry(
            title: 'Certificate of Residency',
            subtitle: 'Approved on Feb 14, 2026',
            detail: 'Purpose: Scholarship application',
            reference: 'CR-26-0214',
            icon: Icons.home,
          ),
          _LegacyDocEntry(
            title: 'Business Endorsement',
            subtitle: 'Approved on Feb 10, 2026',
            detail: 'Purpose: Market stall permit',
            reference: 'BE-26-0210',
            icon: Icons.store,
          ),
        ];
      case 'Rejected':
        return const [
          _LegacyDocEntry(
            title: 'Medical Assistance Form',
            subtitle: 'Rejected on Feb 16, 2026',
            detail: 'Reason: Missing hospital abstract',
            reference: 'MA-26-0216',
            icon: Icons.local_hospital,
          ),
          _LegacyDocEntry(
            title: 'Scholarship Assistance',
            subtitle: 'Rejected on Feb 11, 2026',
            detail: 'Reason: Incomplete school attachments',
            reference: 'SA-26-0211',
            icon: Icons.school,
          ),
        ];
      case 'Completed':
        return const [
          _LegacyDocEntry(
            title: 'Barangay Clearance',
            subtitle: 'Completed and downloaded',
            detail: 'Released to resident on Feb 04, 2026',
            reference: 'BC-26-0204',
            icon: Icons.download_done,
          ),
          _LegacyDocEntry(
            title: 'Community Certificate',
            subtitle: 'Completed and released',
            detail: 'Released to resident on Jan 29, 2026',
            reference: 'CC-26-0129',
            icon: Icons.verified,
          ),
        ];
      case 'Pending':
      default:
        return const [
          _LegacyDocEntry(
            title: 'Barangay Clearance',
            subtitle: 'Pending verification of residency',
            detail: 'Submitted Feb 20, 2026',
            reference: 'BC-26-0220',
            icon: Icons.description,
          ),
          _LegacyDocEntry(
            title: 'Certificate of Indigency',
            subtitle: 'Queued for captain signature',
            detail: 'Submitted Feb 19, 2026',
            reference: 'CI-26-0219',
            icon: Icons.assignment_turned_in,
          ),
          _LegacyDocEntry(
            title: 'Medical Assistance Form',
            subtitle: 'Under social worker review',
            detail: 'Submitted Feb 18, 2026',
            reference: 'MA-26-0218',
            icon: Icons.health_and_safety,
          ),
        ];
    }
  }

  String _processingEta(String status) {
    switch (status) {
      case 'Approved':
        return '2 days';
      case 'Rejected':
        return '1 day';
      case 'Completed':
        return '0 day';
      case 'Pending':
      default:
        return '3 days';
    }
  }

  String _statusAction(String status) {
    switch (status) {
      case 'Approved':
        return 'View';
      case 'Completed':
        return 'Download';
      case 'Rejected':
        return 'Review';
      case 'Pending':
      default:
        return 'Track';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF2D8E55);
      case 'Rejected':
        return const Color(0xFFD74637);
      case 'Completed':
        return const Color(0xFF3650C4);
      case 'Pending':
      default:
        return const Color(0xFF7A5A43);
    }
  }
}

class _LegacyDocEntry {
  final String title;
  final String subtitle;
  final String detail;
  final String reference;
  final IconData icon;
  const _LegacyDocEntry({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.reference,
    required this.icon,
  });
}

final ValueNotifier<List<Map<String, dynamic>>> _officialNotificationFeed =
    ValueNotifier<List<Map<String, dynamic>>>([
      {
        'title': 'Barangay Clearance ready for pickup',
        'time': '5 min ago',
        'read': false,
      },
      {
        'title': 'Council meeting schedule updated',
        'time': '2 hours ago',
        'read': true,
      },
      {
        'title': 'New RBI verification request',
        'time': 'Yesterday',
        'read': false,
      },
    ]);

class _DocEntry {
  final String id;
  final String serialNumber;
  final String title;
  final String residentName;
  final String residentAddress;
  final String purpose;
  final String status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String verificationUrl;
  final String kind;
  final bool privacyConsent;
  final String? ctcCedulaNumber;
  final bool firstTimeJobSeeker;
  final double fee;
  final String? rejectionReason;
  final String? officialActionBy;
  final IconData icon;

  const _DocEntry({
    required this.id,
    required this.serialNumber,
    required this.title,
    required this.residentName,
    required this.residentAddress,
    required this.purpose,
    required this.status,
    required this.submittedAt,
    required this.reviewedAt,
    required this.verificationUrl,
    required this.kind,
    required this.privacyConsent,
    this.ctcCedulaNumber,
    this.firstTimeJobSeeker = false,
    this.fee = 75,
    this.rejectionReason,
    this.officialActionBy,
    required this.icon,
  });

  _DocEntry copyWith({
    String? status,
    DateTime? reviewedAt,
    String? rejectionReason,
    String? officialActionBy,
    String? serialNumber,
    String? ctcCedulaNumber,
    bool? firstTimeJobSeeker,
    double? fee,
  }) {
    return _DocEntry(
      id: id,
      serialNumber: serialNumber ?? this.serialNumber,
      title: title,
      residentName: residentName,
      residentAddress: residentAddress,
      purpose: purpose,
      status: status ?? this.status,
      submittedAt: submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      verificationUrl: verificationUrl,
      kind: kind,
      privacyConsent: privacyConsent,
      ctcCedulaNumber: ctcCedulaNumber ?? this.ctcCedulaNumber,
      firstTimeJobSeeker: firstTimeJobSeeker ?? this.firstTimeJobSeeker,
      fee: fee ?? this.fee,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      officialActionBy: officialActionBy ?? this.officialActionBy,
      icon: icon,
    );
  }

  String get subtitle {
    final actionDate = reviewedAt ?? submittedAt;
    final prefix = switch (status) {
      'Approved' => 'Approved',
      'Rejected' => 'Rejected',
      _ => 'Submitted',
    };
    return '$prefix on ${_formatDocDate(actionDate)}';
  }

  String get detail {
    if (status == 'Rejected' && rejectionReason != null) {
      return 'Reason: $rejectionReason';
    }
    return 'Resident: $residentName - Purpose: $purpose';
  }

  DateTime get expiresAt => DateTime(
    submittedAt.year,
    submittedAt.month + 6,
    submittedAt.day,
    submittedAt.hour,
    submittedAt.minute,
  );

  bool get hasExpiry => kind == 'clearance';

  bool get isExpired => hasExpiry && DateTime.now().isAfter(expiresAt);

  String get feeLabel => fee <= 0 ? 'PHP 0.00' : 'PHP ${fee.toStringAsFixed(2)}';
}

class _SerbilisDocumentStore {
  static String _barangayCode() {
    final source = _officialBarangaySetup.barangay.trim().isNotEmpty
        ? _officialBarangaySetup.barangay
        : 'Barangay';
    final tokens = source
        .split(RegExp(r'[\s-]+'))
        .where((token) => token.trim().isNotEmpty)
        .toList();
    final initials = tokens.map((token) => token[0]).join().toUpperCase();
    return (initials.isEmpty ? 'BRGY' : initials).padRight(4, 'X').substring(0, 4);
  }

  static String _serialForIndex(DateTime when, int index) {
    final padded = index.toString().padLeft(4, '0');
    return '${when.year}-${_barangayCode()}-$padded';
  }

  static final ValueNotifier<List<_DocEntry>> documents =
      ValueNotifier<List<_DocEntry>>([
        _DocEntry(
          id: 'BC-26-0314-001',
          serialNumber: '2026-WTXX-0001',
          title: 'Barangay Clearance',
          residentName: 'JOHN DELA CRUZ',
          residentAddress: 'Purok 3 Main Road, West Tapinac, Olongapo City',
          purpose: 'Work',
          status: 'Pending',
          submittedAt: DateTime(2026, 3, 14, 9, 5),
          reviewedAt: null,
          verificationUrl:
              'https://barangaymo.app/verify/BC-26-0314-001',
          kind: 'clearance',
          privacyConsent: true,
          ctcCedulaNumber: 'CTC-2026-14402',
          icon: Icons.description_rounded,
        ),
        _DocEntry(
          id: 'CI-26-0314-002',
          serialNumber: '2026-WTXX-0002',
          title: 'Certificate of Indigency',
          residentName: 'MARIA SANTOS',
          residentAddress: 'Zone 2, Gordon Heights, Olongapo City',
          purpose: 'Scholarship support',
          status: 'Pending',
          submittedAt: DateTime(2026, 3, 14, 8, 35),
          reviewedAt: null,
          verificationUrl:
              'https://barangaymo.app/verify/CI-26-0314-002',
          kind: 'indigent',
          privacyConsent: true,
          fee: 0,
          icon: Icons.assignment_turned_in_rounded,
        ),
        _DocEntry(
          id: 'BC-26-0313-004',
          serialNumber: '2026-WTXX-0003',
          title: 'Barangay Clearance',
          residentName: 'LESTER NADONG',
          residentAddress: 'West Tapinac, Olongapo City',
          purpose: 'Travel',
          status: 'Approved',
          submittedAt: DateTime(2026, 3, 13, 14, 10),
          reviewedAt: DateTime(2026, 3, 13, 16, 25),
          verificationUrl:
              'https://barangaymo.app/verify/BC-26-0313-004',
          kind: 'clearance',
          privacyConsent: true,
          ctcCedulaNumber: 'CTC-2026-14400',
          officialActionBy: 'Barangay Secretary',
          icon: Icons.verified_rounded,
        ),
        _DocEntry(
          id: 'BC-26-0312-006',
          serialNumber: '2026-WTXX-0004',
          title: 'Barangay Clearance',
          residentName: 'PEDRO REYES',
          residentAddress: 'East Tapinac, Olongapo City',
          purpose: 'ID',
          status: 'Rejected',
          submittedAt: DateTime(2026, 3, 12, 11, 20),
          reviewedAt: DateTime(2026, 3, 12, 15, 40),
          verificationUrl:
              'https://barangaymo.app/verify/BC-26-0312-006',
          kind: 'clearance',
          privacyConsent: true,
          ctcCedulaNumber: 'CTC-2026-14396',
          rejectionReason: 'Residency record needs updated household address.',
          officialActionBy: 'Records Officer',
          icon: Icons.cancel_outlined,
        ),
      ]);

  static List<_DocEntry> entriesForStatus(String status) {
    final items = [...documents.value]
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    if (status == 'All') {
      return items;
    }
    return items.where((entry) => entry.status == status).toList();
  }

  static String submitClearance({
    required String residentName,
    required String residentAddress,
    required String purpose,
    required String ctcCedulaNumber,
    required bool firstTimeJobSeeker,
  }) {
    final now = DateTime.now();
    final nextIndex = documents.value.length + 1;
    final id =
        'BC-${now.year % 100}-${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${100 + documents.value.length}';
    final entry = _DocEntry(
      id: id,
      serialNumber: _serialForIndex(now, nextIndex),
      title: 'Barangay Clearance',
      residentName: residentName.trim().toUpperCase(),
      residentAddress: residentAddress.trim(),
      purpose: purpose,
      status: 'Pending',
      submittedAt: now,
      reviewedAt: null,
      verificationUrl: 'https://barangaymo.app/verify/$id',
      kind: 'clearance',
      privacyConsent: true,
      ctcCedulaNumber: ctcCedulaNumber.trim(),
      firstTimeJobSeeker: firstTimeJobSeeker,
      fee: firstTimeJobSeeker ? 0 : 75,
      icon: Icons.description_rounded,
    );
    documents.value = [entry, ...documents.value];
    _pushOfficialNotification(
      'New clearance request from ${entry.residentName}',
      unread: true,
    );
    return id;
  }

  static void approve(String id, {required String officer}) {
    final updated = [
      for (final entry in documents.value)
        if (entry.id == id)
          entry.copyWith(
            status: 'Approved',
            reviewedAt: DateTime.now(),
            officialActionBy: officer,
            rejectionReason: null,
          )
        else
          entry,
    ];
    documents.value = updated;
    final current = updated.firstWhere((entry) => entry.id == id);
    _pushOfficialNotification(
      '${current.title} for ${current.residentName} approved',
      unread: true,
    );
    _pushSystemNotification(
      UserRole.resident,
      title: '${current.title} approved',
      body: 'Record ${current.id} is approved and ready for release.',
      category: 'Documents',
      icon: Icons.task_alt_rounded,
      priority: 'high',
      recordId: current.id,
      deepLink: 'barangaymo://document/${current.id}',
    );
  }

  static void reject(
    String id, {
    required String officer,
    required String reason,
  }) {
    final updated = [
      for (final entry in documents.value)
        if (entry.id == id)
          entry.copyWith(
            status: 'Rejected',
            reviewedAt: DateTime.now(),
            officialActionBy: officer,
            rejectionReason: reason,
          )
        else
          entry,
    ];
    documents.value = updated;
    final current = updated.firstWhere((entry) => entry.id == id);
    _pushOfficialNotification(
      '${current.title} for ${current.residentName} rejected',
      unread: true,
    );
    _pushSystemNotification(
      UserRole.resident,
      title: '${current.title} rejected',
      body: 'Record ${current.id} requires corrections before resubmission.',
      category: 'Documents',
      icon: Icons.cancel_outlined,
      priority: 'normal',
      recordId: current.id,
      deepLink: 'barangaymo://document/${current.id}',
    );
  }

  static List<_DocEntry> dailyQueue(DateTime date) {
    return entriesForStatus('All')
        .where((entry) => _sameDocDay(entry.submittedAt, date))
        .toList();
  }

  static String bulkExportLabel(DateTime date) {
    final queue = dailyQueue(date);
    final pending = queue.where((entry) => entry.status == 'Pending').length;
    final approved = queue.where((entry) => entry.status == 'Approved').length;
    return '${queue.length} total - $pending pending - $approved approved';
  }
}

void _pushOfficialNotification(String title, {required bool unread}) {
  _officialNotificationFeed.value = [
    {
      'title': title,
      'time': 'Just now',
      'read': !unread,
    },
    ..._officialNotificationFeed.value,
  ];
}

Color _statusColor(String status) {
  switch (status) {
    case 'Approved':
      return const Color(0xFF2D8E55);
    case 'Rejected':
      return const Color(0xFFD74637);
    case 'All':
      return const Color(0xFF3650C4);
    case 'Pending':
    default:
      return const Color(0xFF7A5A43);
  }
}

String _statusAction(String status) {
  switch (status) {
    case 'Approved':
      return 'View Document';
    case 'Rejected':
      return 'Review Notes';
    case 'Pending':
      return 'Track Status';
    case 'All':
    default:
      return 'Open Request';
  }
}

String _processingEta(String status) {
  switch (status) {
    case 'Approved':
      return 'same day';
    case 'Rejected':
      return '1 day';
    case 'All':
      return '1-3 days';
    case 'Pending':
    default:
      return '2 days';
  }
}

String _formatDocDate(DateTime date) {
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
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

bool _sameDocDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class ClearancePage extends StatefulWidget {
  const ClearancePage({super.key});

  @override
  State<ClearancePage> createState() => _ClearancePageState();
}

class _ClearancePageState extends State<ClearancePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool get _isOfficialView => _currentOfficialMobile != null;

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

  void _openRequestForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _ClearanceRequestPage()),
    );
  }

  void _openBulkExport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _BulkDocumentExportPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isOfficialView ? 'Document Queue' : 'Documents'),
        backgroundColor: const Color(0xFFF7F8FF),
        actions: [
          if (_isOfficialView)
            IconButton(
              onPressed: _openBulkExport,
              icon: const Icon(Icons.picture_as_pdf_outlined),
            )
          else
            IconButton(
              onPressed: _openRequestForm,
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          indicator: BoxDecoration(
            color: const Color(0xFFDDE2FF),
            borderRadius: BorderRadius.circular(999),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: const Color(0xFF2D3150),
          unselectedLabelColor: const Color(0xFF737992),
          labelStyle: const TextStyle(fontWeight: FontWeight.w800),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      floatingActionButton: _isOfficialView
          ? null
          : FloatingActionButton.extended(
              onPressed: _openRequestForm,
              backgroundColor: const Color(0xFF2E35D3),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.description_outlined),
              label: const Text('Request Clearance'),
            ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DocList(status: 'All'),
          _DocList(status: 'Pending'),
          _DocList(status: 'Approved'),
          _DocList(status: 'Rejected'),
        ],
      ),
    );
  }
}

class _DocList extends StatefulWidget {
  final String status;
  const _DocList({required this.status});

  @override
  State<_DocList> createState() => _DocListState();
}

class _DocListState extends State<_DocList> {
  String _query = '';
  String _dateFilter = 'Any Date';

  bool get _isOfficialView => _currentOfficialMobile != null;

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) {
      return;
    }
    setState(() {});
    _showFeature(
      context,
      _appText('Document list refreshed.', 'Na-refresh ang listahan ng dokumento.'),
      tone: _ToastTone.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(widget.status);
    return ValueListenableBuilder<List<_DocEntry>>(
      valueListenable: _SerbilisDocumentStore.documents,
      builder: (context, _, __) {
        final documents = _SerbilisDocumentStore.entriesForStatus(widget.status);
        final rows = documents.where((entry) {
          final bag =
              '${entry.title} ${entry.residentName} ${entry.purpose} ${entry.id} ${entry.residentAddress}'
                  .toLowerCase();
          final matchesQuery = _query.trim().isEmpty ||
              bag.contains(_query.trim().toLowerCase());
          final now = DateTime.now();
          final matchesDate = switch (_dateFilter) {
            'Today' => _sameDocDay(entry.submittedAt, now),
            'This Week' => now.difference(entry.submittedAt).inDays < 7,
            'This Month' =>
              entry.submittedAt.year == now.year &&
                  entry.submittedAt.month == now.month,
            _ => true,
          };
          return matchesQuery && matchesDate;
        }).toList();

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF7F8FF), Color(0xFFF8F0EE)],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accent.withValues(alpha: 0.95),
                      accent.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0x36FFFFFF),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.folder_copy, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.status == 'All'
                                ? 'All Document Requests'
                                : '${widget.status} Documents',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 21,
                            ),
                          ),
                          Text(
                            '${documents.length} requests | Avg turnaround ${_processingEta(widget.status)}',
                            style: const TextStyle(
                              color: Color(0xFFECEFFF),
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
              if (widget.status == 'All')
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE3E6F4)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isOfficialView
                                  ? 'Bulk PDF Export'
                                  : 'Request Barangay Clearance',
                              style: const TextStyle(
                                color: Color(0xFF2D3150),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isOfficialView
                                  ? _SerbilisDocumentStore.bulkExportLabel(
                                      DateTime.now(),
                                    )
                                  : 'Submit work, ID, or travel clearance requests and track them here.',
                              style: const TextStyle(
                                color: Color(0xFF666D86),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _isOfficialView
                            ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const _BulkDocumentExportPage(),
                                ),
                              )
                            : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const _ClearanceRequestPage(),
                                ),
                              ),
                        style: FilledButton.styleFrom(
                          backgroundColor: _isOfficialView
                              ? const Color(0xFFD70000)
                              : const Color(0xFF2E35D3),
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(
                          _isOfficialView
                              ? Icons.picture_as_pdf_outlined
                              : Icons.send_outlined,
                        ),
                        label: Text(_isOfficialView ? 'Export' : 'Request'),
                      ),
                    ],
                  ),
                ),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search by resident name, date, ID, or purpose...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE3E6F4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE3E6F4)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _dateFilter,
                decoration: InputDecoration(
                  labelText: 'Filter by Date',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Any Date', child: Text('Any Date')),
                  DropdownMenuItem(value: 'Today', child: Text('Today')),
                  DropdownMenuItem(value: 'This Week', child: Text('This Week')),
                  DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _dateFilter = value);
                  }
                },
              ),
              const SizedBox(height: 10),
              if (rows.isEmpty)
                _AppEmptyState(
                  icon: Icons.folder_off_outlined,
                  title: _appText('No matching documents', 'Walang tugmang dokumento'),
                  subtitle: _appText(
                    'Try a different resident name, date filter, or reference number.',
                    'Subukan ang ibang pangalan, date filter, o reference number.',
                  ),
                )
              else
                ...rows.map(
                  (entry) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E7F3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: accent.withValues(alpha: 0.13),
                              child: Icon(entry.icon, color: accent),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  _HighlightedText(
                                    text: entry.title,
                                    query: _query,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF2D314A),
                                    ),
                                  ),
                                  _HighlightedText(
                                    text: entry.residentName,
                                    query: _query,
                                    style: const TextStyle(
                                      color: Color(0xFF555C77),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(entry.status).withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                entry.status,
                                style: TextStyle(
                                  color: _statusColor(entry.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _HighlightedText(
                          text: entry.subtitle,
                          query: _query,
                          style: const TextStyle(
                            color: Color(0xFF555C77),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        _HighlightedText(
                          text: entry.detail,
                          query: _query,
                          style: const TextStyle(
                            color: Color(0xFF666B84),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        _HighlightedText(
                          text: entry.residentAddress,
                          query: _query,
                          style: const TextStyle(
                            color: Color(0xFF7A809A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.confirmation_number_outlined,
                              size: 16,
                              color: Color(0xFF7A809A),
                            ),
                            const SizedBox(width: 4),
                            _HighlightedText(
                              text: entry.id,
                              query: _query,
                              style: const TextStyle(
                                color: Color(0xFF7A809A),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      _AutomatedDocumentStatusDetailPage(
                                        entryId: entry.id,
                                      ),
                                ),
                              ),
                              icon: Icon(
                                entry.status == 'Approved'
                                    ? Icons.visibility_outlined
                                    : entry.status == 'Rejected'
                                    ? Icons.rule_rounded
                                    : Icons.chevron_right,
                                color: _statusColor(entry.status),
                                size: 18,
                              ),
                              label: Text(
                                _statusAction(entry.status),
                                style: TextStyle(
                                  color: _statusColor(entry.status),
                                ),
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
          ),
        );
      },
    );
  }
}

class _ClearanceRequestPage extends StatefulWidget {
  const _ClearanceRequestPage();

  @override
  State<_ClearanceRequestPage> createState() => _ClearanceRequestPageState();
}

class _ClearanceRequestPageState extends State<_ClearanceRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _ctcController = TextEditingController();
  String _purpose = 'Work';
  bool _privacyConsent = false;
  bool _firstTimeJobSeeker = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = _residentDisplayName();
    _addressController.text =
        _currentResidentProfile?.locationSummary ?? 'West Tapinac, Olongapo City';
    _ctcController.text = 'CTC-${DateTime.now().year}-${14000 + DateTime.now().day}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _ctcController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_privacyConsent) {
      _showFeature(
        context,
        'You must accept the Data Privacy Act consent before submitting.',
      );
      return;
    }
    final reference = _SerbilisDocumentStore.submitClearance(
      residentName: _nameController.text,
      residentAddress: _addressController.text,
      purpose: _purpose,
      ctcCedulaNumber: _ctcController.text,
      firstTimeJobSeeker: _firstTimeJobSeeker,
    );
    Navigator.pop(context);
    _showFeature(context, 'Clearance request submitted. Ref: $reference');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clearance Request'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E7F3)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Barangay Clearance Request',
                    style: TextStyle(
                      color: Color(0xFF2F3248),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Resident Name'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _purpose,
                    decoration: const InputDecoration(labelText: 'Purpose'),
                    items: const [
                      DropdownMenuItem(value: 'Work', child: Text('Work')),
                      DropdownMenuItem(value: 'ID', child: Text('ID')),
                      DropdownMenuItem(value: 'Travel', child: Text('Travel')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _purpose = value);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _ctcController,
                    decoration: const InputDecoration(
                      labelText: 'CTC / Cedula Number',
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile.adaptive(
                    value: _firstTimeJobSeeker,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('RA 11261 First-Time Jobseeker'),
                    subtitle: Text(
                      _firstTimeJobSeeker
                          ? 'Document fee auto-set to PHP 0.00'
                          : 'Standard clearance fee: PHP 75.00',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _firstTimeJobSeeker = value;
                        if (value) {
                          _purpose = 'Work';
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EEFF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _firstTimeJobSeeker
                            ? 'Fee: PHP 0.00'
                            : 'Fee: PHP 75.00',
                        style: const TextStyle(
                          color: Color(0xFF2E35D3),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: _privacyConsent,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'I consent to the use of my personal information under the Data Privacy Act for barangay document processing.',
                      style: TextStyle(
                        color: Color(0xFF555C77),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _privacyConsent = value ?? false);
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E35D3),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Submit Request'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AutomatedDocumentStatusDetailPage extends StatelessWidget {
  final String entryId;

  const _AutomatedDocumentStatusDetailPage({required this.entryId});

  bool get _isOfficialView => _currentOfficialMobile != null;

  _DocEntry _entry() {
    return _SerbilisDocumentStore.documents.value.firstWhere(
      (entry) => entry.id == entryId,
    );
  }

  Future<void> _handleApproval(
    BuildContext context, {
    required bool approve,
  }) async {
    if (!_isOfficialView || _currentOfficialMobile == null) {
      _showFeature(context, 'Official approval is only available to logged-in officials.');
      return;
    }
    final pinController = TextEditingController();
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(approve ? 'Approve with MPIN' : 'Reject with MPIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Official MPIN'),
              ),
              if (!approve) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Rejection Reason',
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: approve
                    ? const Color(0xFF2D8E55)
                    : const Color(0xFFD74637),
              ),
              child: Text(approve ? 'Approve' : 'Reject'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      pinController.dispose();
      reasonController.dispose();
      return;
    }
    final isValid = await _OfficialMpinStore.verifyPin(
      _currentOfficialMobile!,
      pinController.text.trim(),
    );
    if (!isValid) {
      if (context.mounted) {
        _showFeature(context, 'Incorrect MPIN. Approval action cancelled.');
      }
      pinController.dispose();
      reasonController.dispose();
      return;
    }
    if (!approve && reasonController.text.trim().isEmpty) {
      if (context.mounted) {
        _showFeature(context, 'Please provide a rejection reason.');
      }
      pinController.dispose();
      reasonController.dispose();
      return;
    }
    if (approve) {
      _SerbilisDocumentStore.approve(entryId, officer: 'Barangay Secretary');
    } else {
      _SerbilisDocumentStore.reject(
        entryId,
        officer: 'Barangay Secretary',
        reason: reasonController.text.trim(),
      );
    }
    if (context.mounted) {
      _showFeature(
        context,
        approve ? 'Document approved and alert queued.' : 'Document rejected and alert queued.',
      );
    }
    pinController.dispose();
    reasonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_DocEntry>>(
      valueListenable: _SerbilisDocumentStore.documents,
      builder: (context, _, __) {
        final entry = _entry();
        final accent = _statusColor(entry.status);
        return Scaffold(
          appBar: AppBar(
            title: Text(entry.title),
            backgroundColor: const Color(0xFFF7F8FF),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF5F8FF), Color(0xFFF9F2EE)],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4E7F3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: accent.withValues(alpha: 0.14),
                            child: Icon(entry.icon, color: accent),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2F3248),
                                  ),
                                ),
                                Text(
                                  'Reference: ${entry.id}',
                                  style: const TextStyle(
                                    color: Color(0xFF69708A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              entry.status,
                              style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        entry.residentName,
                        style: const TextStyle(
                          color: Color(0xFF3E445E),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        entry.residentAddress,
                        style: const TextStyle(
                          color: Color(0xFF666B84),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Purpose: ${entry.purpose}',
                        style: const TextStyle(
                          color: Color(0xFF555C77),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (entry.officialActionBy != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Reviewed by ${entry.officialActionBy}',
                          style: const TextStyle(
                            color: Color(0xFF666B84),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4E7F3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verification and Privacy',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2F3248),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.shield_outlined),
                        title: const Text('Data Privacy Act consent'),
                        subtitle: Text(
                          entry.privacyConsent ? 'Accepted before submission' : 'Missing consent',
                        ),
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.qr_code_2_rounded),
                        title: const Text('QR verification URL'),
                        subtitle: Text(entry.verificationUrl),
                        trailing: TextButton(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: entry.verificationUrl),
                            );
                            if (context.mounted) {
                              _showFeature(context, 'Verification URL copied.');
                            }
                          },
                          child: const Text('Copy'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (_isOfficialView && entry.status == 'Pending')
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _handleApproval(context, approve: false),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFD74637),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _handleApproval(context, approve: true),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2D8E55),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Approve'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _DocumentPdfPreviewPage(entry: entry),
                    ),
                  ),
                  style: FilledButton.styleFrom(backgroundColor: accent),
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: Text(entry.status == 'Rejected' ? 'Review Record' : 'Open Document'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BulkDocumentExportPage extends StatelessWidget {
  const _BulkDocumentExportPage();

  @override
  Widget build(BuildContext context) {
    final queue = _SerbilisDocumentStore.dailyQueue(DateTime.now());
    final approved = queue.where((entry) => entry.status == 'Approved').toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk PDF Export'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E7F3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Queue Export',
                  style: TextStyle(
                    color: Color(0xFF2F3248),
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _SerbilisDocumentStore.bulkExportLabel(DateTime.now()),
                  style: const TextStyle(
                    color: Color(0xFF666B84),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Merged approvals ready: ${approved.length}',
                  style: const TextStyle(
                    color: Color(0xFF2F3248),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...queue.map(
            (entry) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE4E7F3)),
              ),
              child: ListTile(
                title: Text(entry.title),
                subtitle: Text(
                  '${entry.residentName} - ${entry.id}\nSerial ${entry.serialNumber}',
                ),
                trailing: Text(
                  entry.status,
                  style: TextStyle(
                    color: _statusColor(entry.status),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton.icon(
          onPressed: () => _showFeature(
            context,
            approved.isEmpty
                ? 'No approved documents available for merged PDF export.'
                : 'Merged ${approved.length} approved documents into one batch print file.',
          ),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD70000)),
          icon: const Icon(Icons.print_outlined),
          label: const Text('Merge and Export Daily Approvals'),
        ),
      ),
    );
  }
}

class _DocumentPdfPreviewPage extends StatelessWidget {
  final _DocEntry entry;

  const _DocumentPdfPreviewPage({required this.entry});

  bool get _isApproved => entry.status == 'Approved';

  bool get _hasSignature => _officialBarangaySetup.punongSignaturePaths.any(
        (stroke) => stroke.length > 1,
      );

  String get _watermarkLabel {
    if (_isApproved) {
      return '';
    }
    return entry.status == 'Rejected' ? 'REJECTED' : 'UNAPPROVED PREVIEW';
  }

  String get _signatureName {
    final text = _officialBarangaySetup.punongSignatureText.trim();
    return text.isEmpty ? 'Punong Barangay' : text;
  }

  String _formatTimestamp(DateTime date) {
    final normalizedHour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${_formatDocDate(date)} $normalizedHour:$minute $suffix';
  }

  String _auditFooter() {
    if (entry.reviewedAt == null || entry.officialActionBy == null) {
      return 'Audit trail: Awaiting approving official action.';
    }
    return 'Audit trail: ${entry.officialActionBy} - ${_formatTimestamp(entry.reviewedAt!)}';
  }

  List<String> _templateLines() {
    if (entry.kind == 'indigent') {
      return [
        'CERTIFICATE OF INDIGENCY',
        '',
        'This is to certify that ${entry.residentName}, residing at ${entry.residentAddress}, is a bonafide resident of this barangay and is recognized as an indigent resident for ${entry.purpose.toLowerCase()}.',
        '',
        'Issued on ${_formatDocDate(entry.reviewedAt ?? entry.submittedAt)} for whatever legal purpose it may serve.',
      ];
    }
    return [
      'BARANGAY CLEARANCE',
      '',
      'This certifies that ${entry.residentName}, of legal age and a resident of ${entry.residentAddress}, is cleared by this barangay for ${entry.purpose.toLowerCase()} purposes.',
      '',
      'Issued on ${_formatDocDate(entry.reviewedAt ?? entry.submittedAt)} with reference ${entry.id}.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(entry.status);
    final watermarkColor = entry.status == 'Rejected'
        ? const Color(0xFFD74637)
        : const Color(0xFFD08D1A);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Preview'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        color: const Color(0xFFF1F3F9),
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _docMetaChip(
                  label: 'Status',
                  value: entry.status,
                  color: accent,
                  icon: Icons.verified_outlined,
                ),
                _docMetaChip(
                  label: 'Serial',
                  value: entry.serialNumber,
                  color: const Color(0xFF3650C4),
                  icon: Icons.tag_rounded,
                ),
                _docMetaChip(
                  label: 'Fee',
                  value: entry.feeLabel,
                  color: entry.fee <= 0 ? const Color(0xFF2D8E55) : const Color(0xFF7A5A43),
                  icon: Icons.payments_outlined,
                ),
                if (entry.hasExpiry)
                  _docMetaChip(
                    label: entry.isExpired ? 'Expired' : 'Valid Until',
                    value: _formatDocDate(entry.expiresAt),
                    color: entry.isExpired
                        ? const Color(0xFFD74637)
                        : const Color(0xFF2D8E55),
                    icon: entry.isExpired
                        ? Icons.error_outline_rounded
                        : Icons.event_available_rounded,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD9DDEA)),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Republic of the Philippines',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Center(
                          child: Text(
                            _officialBarangaySetup.barangay.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${_officialBarangaySetup.city}, ${_officialBarangaySetup.province}',
                            style: const TextStyle(
                              color: Color(0xFF6A718B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'BarangayMo Digital Document',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Reference ${entry.id}',
                                style: const TextStyle(
                                  color: Color(0xFF505770),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              'Serial ${entry.serialNumber}',
                              style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        ..._templateLines().map(
                          (line) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              line,
                              style: TextStyle(
                                fontSize:
                                    line == line.toUpperCase() && line.isNotEmpty ? 18 : 14,
                                fontWeight:
                                    line == line.toUpperCase() && line.isNotEmpty
                                        ? FontWeight.w900
                                        : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _docMetaChip(
                              label: 'Purpose',
                              value: entry.purpose,
                              color: const Color(0xFF3650C4),
                              icon: Icons.assignment_rounded,
                            ),
                            if ((entry.ctcCedulaNumber ?? '').trim().isNotEmpty)
                              _docMetaChip(
                                label: 'CTC / Cedula',
                                value: entry.ctcCedulaNumber!.trim(),
                                color: const Color(0xFF7A5A43),
                                icon: Icons.badge_outlined,
                              ),
                            if (entry.firstTimeJobSeeker)
                              _docMetaChip(
                                label: 'RA 11261',
                                value: 'First-Time Jobseeker',
                                color: const Color(0xFF2D8E55),
                                icon: Icons.work_history_outlined,
                              ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verification URL',
                                    style: TextStyle(
                                      color: accent,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    entry.verificationUrl,
                                    style: const TextStyle(
                                      color: Color(0xFF5B637C),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _auditFooter(),
                                    style: const TextStyle(
                                      color: Color(0xFF79809A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 78,
                              height: 78,
                              child: CustomPaint(
                                painter: _DocumentQrPainter(entry.verificationUrl),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: Container(
                      width: 102,
                      height: 102,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0x11D70000),
                        border: Border.all(
                          color: const Color(0x88D70000),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'DRY\nSEAL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFD70000),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 112,
                    child: Container(
                      width: 184,
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F5F4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8D5D0)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 54,
                            width: double.infinity,
                            child: _hasSignature
                                ? CustomPaint(
                                    painter: _DocumentSignatureStampPainter(
                                      strokes: _officialBarangaySetup.punongSignaturePaths,
                                      color: accent,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      _signatureName,
                                      style: TextStyle(
                                        color: accent,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _signatureName,
                            style: const TextStyle(
                              color: Color(0xFF2F3248),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'Punong Barangay e-signature auto-stamp',
                            style: TextStyle(
                              color: Color(0xFF7A8098),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!_isApproved)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Center(
                          child: Transform.rotate(
                            angle: -math.pi / 5,
                            child: Opacity(
                              opacity: 0.18,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: watermarkColor,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  _watermarkLabel,
                                  style: TextStyle(
                                    color: watermarkColor,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _PublicVerificationPortalPage(entry: entry),
                        ),
                      );
                    },
                    icon: const Icon(Icons.public_rounded),
                    label: const Text('Open Verification Portal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () => _showFeature(
              context,
              _isApproved
                  ? 'PDF output prepared for ${entry.id}.'
                  : 'Preview prepared with watermark, dry seal, and e-sign placeholders for ${entry.id}.',
            ),
            style: FilledButton.styleFrom(backgroundColor: accent),
            icon: const Icon(Icons.download_outlined),
            label: Text(_isApproved ? 'Generate PDF' : 'Generate Preview PDF'),
          ),
        ),
      ),
    );
  }
}

Widget _docMetaChip({
  required String label,
  required String value,
  required Color color,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withValues(alpha: 0.22)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 7),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Color(0xFF2F3248),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(color: color),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DocumentSignatureStampPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;

  const _DocumentSignatureStampPainter({
    required this.strokes,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final points = strokes.expand((stroke) => stroke).toList();
    if (points.length < 2) {
      return;
    }

    var minX = points.first.dx;
    var minY = points.first.dy;
    var maxX = points.first.dx;
    var maxY = points.first.dy;
    for (final point in points.skip(1)) {
      minX = math.min(minX, point.dx);
      minY = math.min(minY, point.dy);
      maxX = math.max(maxX, point.dx);
      maxY = math.max(maxY, point.dy);
    }

    final sourceWidth = math.max(maxX - minX, 1.0);
    final sourceHeight = math.max(maxY - minY, 1.0);
    final scale = math.min(size.width / sourceWidth, size.height / sourceHeight) * 0.86;
    final offsetX = (size.width - (sourceWidth * scale)) / 2;
    final offsetY = (size.height - (sourceHeight * scale)) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in strokes.where((stroke) => stroke.length > 1)) {
      final path = ui.Path()
        ..moveTo(
          ((stroke.first.dx - minX) * scale) + offsetX,
          ((stroke.first.dy - minY) * scale) + offsetY,
        );
      for (final point in stroke.skip(1)) {
        path.lineTo(
          ((point.dx - minX) * scale) + offsetX,
          ((point.dy - minY) * scale) + offsetY,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DocumentSignatureStampPainter oldDelegate) {
    return oldDelegate.strokes != strokes || oldDelegate.color != color;
  }
}

class _PublicVerificationPortalPage extends StatelessWidget {
  final _DocEntry entry;

  const _PublicVerificationPortalPage({required this.entry});

  String _statusHeadline() {
    if (entry.status != 'Approved') {
      return 'This document is not yet approved.';
    }
    if (entry.isExpired) {
      return 'This document is expired.';
    }
    return 'This document is valid and verified.';
  }

  Color _headlineColor() {
    if (entry.status != 'Approved' || entry.isExpired) {
      return const Color(0xFFD74637);
    }
    return const Color(0xFF2D8E55);
  }

  String _timestamp(DateTime date) {
    final normalizedHour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${_formatDocDate(date)} $normalizedHour:${date.minute.toString().padLeft(2, '0')} $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final accent = _headlineColor();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Verification Portal'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.96),
                  accent.withValues(alpha: 0.78),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BarangayMo Verification',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _statusHeadline(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _docMetaChip(
                      label: 'Status',
                      value: entry.status,
                      color: Colors.white,
                      icon: Icons.verified_user_outlined,
                    ),
                    _docMetaChip(
                      label: 'Serial',
                      value: entry.serialNumber,
                      color: Colors.white,
                      icon: Icons.numbers_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE1E5F2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Record Details',
                  style: TextStyle(
                    color: Color(0xFF2F3248),
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: accent.withValues(alpha: 0.12),
                    foregroundColor: accent,
                    child: const Icon(Icons.description_outlined),
                  ),
                  title: Text(entry.title),
                  subtitle: Text('${entry.residentName}\n${entry.residentAddress}'),
                ),
                const Divider(height: 22),
                Text(
                  'Purpose: ${entry.purpose}',
                  style: const TextStyle(
                    color: Color(0xFF454D67),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Submitted: ${_timestamp(entry.submittedAt)}',
                  style: const TextStyle(
                    color: Color(0xFF69708A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.reviewedAt != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Reviewed: ${_timestamp(entry.reviewedAt!)}',
                    style: const TextStyle(
                      color: Color(0xFF69708A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (entry.hasExpiry) ...[
                  const SizedBox(height: 6),
                  Text(
                    entry.isExpired
                        ? 'Expired: ${_formatDocDate(entry.expiresAt)}'
                        : 'Valid until: ${_formatDocDate(entry.expiresAt)}',
                    style: TextStyle(
                      color: entry.isExpired
                          ? const Color(0xFFD74637)
                          : const Color(0xFF2D8E55),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  'Fee: ${entry.feeLabel}',
                  style: const TextStyle(
                    color: Color(0xFF454D67),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if ((entry.ctcCedulaNumber ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'CTC / Cedula: ${entry.ctcCedulaNumber}',
                    style: const TextStyle(
                      color: Color(0xFF454D67),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                if ((entry.officialActionBy ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Approving official: ${entry.officialActionBy}',
                    style: const TextStyle(
                      color: Color(0xFF454D67),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 138,
                    height: 138,
                    child: CustomPaint(
                      painter: _DocumentQrPainter(entry.verificationUrl),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  entry.verificationUrl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6C738D),
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

class _DocumentQrPainter extends CustomPainter {
  final String data;

  const _DocumentQrPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1E243B);
    const grid = 17;
    final cell = size.width / grid;
    for (var y = 0; y < grid; y++) {
      for (var x = 0; x < grid; x++) {
        final code = data.codeUnitAt((x + y) % data.length);
        final filled = ((code + (x * 7) + (y * 13)) % 3) != 0;
        if (filled) {
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell - 0.5, cell - 0.5),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DocumentQrPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

