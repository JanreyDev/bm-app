part of barangaymo_app;

class CouncilPage extends StatelessWidget {
  const CouncilPage({super.key});
  @override
  Widget build(BuildContext context) {
    final data = const [
      (
        'DONALD ELAD AQUINO',
        'Sangguniang Barangay Member',
        'Committee on Peace and Order',
      ),
      (
        'LARRY DELA ROSA TOLEDO',
        'Sangguniang Barangay Member',
        'Committee on Infrastructure',
      ),
      (
        'RIGOR BILONO AVILANES',
        'Sangguniang Barangay Member',
        'Committee on Finance and Budget',
      ),
      (
        'ROBERTO TOGONON ANTONIO',
        'Sangguniang Barangay Member',
        'Committee on Social Services',
      ),
      (
        'WILFREDO FABABI MIRANDA',
        'Sangguniang Barangay Member',
        'Committee on Education and Youth',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Council'),
        backgroundColor: const Color(0xFF9F1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF9F1A1A), Color(0xFFC92A2A)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF9F1A1A), Color(0xFFC92A2A)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.groups_2, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Council Directory and Committee Assignments',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...data.map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E7F3)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFEA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person, color: Color(0xFF9F1A1A)),
                  ),
                  title: Text(
                    e.$1,
                    style: const TextStyle(
                      color: Color(0xFF2F3248),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.$2,
                        style: const TextStyle(
                          color: Color(0xFF676C86),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        e.$3,
                        style: const TextStyle(
                          color: Color(0xFF8A5A4A),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.edit, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB42121),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const _CouncilFormSheet(),
        ),
      ),
    );
  }
}

class _CouncilFormSheet extends StatelessWidget {
  const _CouncilFormSheet();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            Text(
              'Add Member of Council',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: 'First Name')),
            SizedBox(height: 8),
            TextField(decoration: InputDecoration(labelText: 'Middle Name')),
            SizedBox(height: 8),
            TextField(decoration: InputDecoration(labelText: 'Last Name')),
            SizedBox(height: 8),
            TextField(decoration: InputDecoration(labelText: 'Position')),
          ],
        ),
      ),
    );
  }
}

class DisclosureBoardPage extends StatefulWidget {
  const DisclosureBoardPage({super.key});

  @override
  State<DisclosureBoardPage> createState() => _FiscalWorkspaceState();
}

class _DisclosureBoardPageState extends State<DisclosureBoardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _purposeFilter = 'All';
  String _statusFilter = 'All';
  String _selectedDate = '08/08/2025';
  String _aipView = 'AIP TABLE';

  static const _purposeOptions = [
    'All',
    'General Services',
    'MOOE',
    'Capital Outlay',
    'Social Services',
  ];

  static const _statusOptions = ['All', 'Released', 'Processing', 'Posted'];

  static const _sectors = [
    _DisbursementSector(
      title: 'General Services',
      available: 1899622.76,
      utilized: 2302268.50,
    ),
    _DisbursementSector(
      title: 'Maintenance and Other Operating Expenses (MOOE)',
      available: 150000.00,
      utilized: 62500.00,
    ),
    _DisbursementSector(
      title: 'Capital Outlay',
      available: 150000.00,
      utilized: 0.00,
    ),
    _DisbursementSector(
      title: 'Social Services',
      available: 720000.00,
      utilized: 1480000.00,
    ),
  ];

  static const _disclosureRows = [
    _DisclosureEntry(
      date: '9/26/2024',
      number: 'DBR-2024-085',
      purpose: 'General Services',
      status: 'Released',
    ),
    _DisclosureEntry(
      date: '9/27/2024',
      number: 'DBR-2024-084',
      purpose: 'MOOE',
      status: 'Released',
    ),
    _DisclosureEntry(
      date: '9/28/2024',
      number: 'DBR-2024-083',
      purpose: 'Capital Outlay',
      status: 'Posted',
    ),
    _DisclosureEntry(
      date: '9/29/2024',
      number: 'DBR-2024-082',
      purpose: 'Social Services',
      status: 'Processing',
    ),
    _DisclosureEntry(
      date: '9/30/2024',
      number: 'DBR-2024-081',
      purpose: 'General Services',
      status: 'Released',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _peso(double value) {
    final whole = value.floor();
    final decimal = ((value - whole) * 100).round().toString().padLeft(2, '0');
    final parts = whole.toString().split('').reversed.toList();
    final chunks = <String>[];
    for (var i = 0; i < parts.length; i += 3) {
      final end = (i + 3 < parts.length) ? i + 3 : parts.length;
      chunks.add(parts.sublist(i, end).join(''));
    }
    return '₱${chunks.map((e) => e.split('').reversed.join('')).toList().reversed.join(',')}.$decimal';
  }

  List<_DisclosureEntry> get _filteredRows {
    final q = _searchController.text.trim().toLowerCase();
    return _disclosureRows.where((row) {
      final byPurpose =
          _purposeFilter == 'All' || row.purpose == _purposeFilter;
      final byStatus = _statusFilter == 'All' || row.status == _statusFilter;
      final haystack = '${row.date} ${row.number} ${row.purpose} ${row.status}'
          .toLowerCase();
      final byQuery = q.isEmpty || haystack.contains(q);
      return byPurpose && byStatus && byQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Disbursement'),
          backgroundColor: const Color(0xFF9F1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9F1A1A), Color(0xFFC92A2A)],
              ),
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFFFD8D8),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            tabs: [
              Tab(text: 'Disbursement'),
              Tab(text: 'Disclosure'),
              Tab(text: 'AIP'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_disbursementTab(), _disclosureTab(), _aipTab()],
        ),
      ),
    );
  }

  Widget _disbursementTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE3E6F1)),
            ),
            child: Column(
              children: [
                const Text(
                  'Available Balance: ₱15,064,054.00',
                  style: TextStyle(
                    color: _officialText,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  '(as of September 13, 2024)',
                  style: TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const _DisbursementSummaryRow(
                  label: 'Allocated:',
                  value: '₱20,064,054.00',
                ),
                const _DisbursementSummaryRow(
                  label: 'Beginning Balance:',
                  value: '₱2,064,054.00',
                ),
                const _DisbursementSummaryRow(
                  label: 'Utilized:',
                  value: '₱5,064,054.00',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ..._sectors.map(
            (sector) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE3E6F1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB20D0D),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      sector.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available: ${_peso(sector.available)}',
                          style: const TextStyle(
                            color: _officialText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Utilized: ${_peso(sector.utilized)}',
                          style: const TextStyle(
                            color: _officialText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

  Widget _disclosureTab() {
    final rows = _filteredRows;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE3E6F1)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.menu_rounded),
                suffixIcon: Icon(Icons.search_rounded),
                hintText: 'Search products or services...',
              ),
            ),
          ),
          const SizedBox(height: 10),
          _filterDropdown(
            label: 'Purpose',
            value: _purposeFilter,
            items: _purposeOptions,
            onChanged: (v) => setState(() => _purposeFilter = v ?? 'All'),
          ),
          const SizedBox(height: 8),
          _filterDropdown(
            label: 'Status',
            value: _statusFilter,
            items: _statusOptions,
            onChanged: (v) => setState(() => _statusFilter = v ?? 'All'),
          ),
          const SizedBox(height: 8),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Date',
              hintText: _selectedDate,
              suffixIcon: const Icon(Icons.calendar_month_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2025, 8, 8),
                firstDate: DateTime(2024, 1, 1),
                lastDate: DateTime(2026, 12, 31),
              );
              if (picked == null) return;
              setState(() {
                _selectedDate =
                    '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
              });
            },
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE3E6F1)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3F7),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Date',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Disbursement No.',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
                if (rows.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'No disbursement entries matched your filters.',
                      style: TextStyle(color: _officialSubtext),
                    ),
                  )
                else
                  ...rows.map(
                    (row) => Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFEAECEF)),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              row.date,
                              style: const TextStyle(
                                color: _officialText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row.number,
                              style: const TextStyle(
                                color: _officialText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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

  Widget _aipTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          const Center(
            child: Text(
              'Annual Investment Plan (AIP)\nCY 2025',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _officialText,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'By Program/Project/Activity by Sector\nas of August 2025',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _officialSubtext,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'WEST TAPINAC, CITY OF OLONGAPO, ZAMBALES',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _officialText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE3E6F1)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFB20D0D),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _aipView,
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                      iconEnabledColor: Colors.white,
                      items: const [
                        DropdownMenuItem(
                          value: 'AIP TABLE',
                          child: Text('AIP TABLE'),
                        ),
                        DropdownMenuItem(
                          value: 'SECTOR SUMMARY',
                          child: Text('SECTOR SUMMARY'),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _aipView = value ?? 'AIP TABLE'),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: const Text(
                    'GRAND TOTAL: ₱94,545,498.87',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: _officialText,
                      fontWeight: FontWeight.w900,
                      fontSize: 21,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Prepared by:\n'
                  'Vicente T. Capalla\n'
                  'Barangay Secretary\n'
                  'Date: 8/8/2025\n\n'
                  'Cresencio A.\n'
                  'Fernandez, Jr.\n'
                  'Barangay Treasurer\n'
                  'Date: 8/8/2025',
                  style: TextStyle(
                    color: _officialText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Attested by:\n'
                  'Lester C. Nadong\n\n'
                  'Punong Barangay\n'
                  'Date: 8/8/2025',
                  style: TextStyle(
                    color: _officialText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () =>
                  _showFeature(context, 'AIP report sent to print queue.'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB20D0D),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'PRINT REPORT',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _DisbursementSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _DisbursementSummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _officialText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: _officialText,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisbursementSector {
  final String title;
  final double available;
  final double utilized;
  const _DisbursementSector({
    required this.title,
    required this.available,
    required this.utilized,
  });
}

class _DisclosureEntry {
  final String date;
  final String number;
  final String purpose;
  final String status;
  const _DisclosureEntry({
    required this.date,
    required this.number,
    required this.purpose,
    required this.status,
  });
}

class _FiscalWorkspaceState extends State<DisclosureBoardPage> {
  final TextEditingController _ledgerSearchController = TextEditingController();
  String _selectedFinancialYear = '2026';
  String _ledgerStatusFilter = 'All';
  int _pbcSeed = 412;
  int _dvSeed = 96;
  int _obrSeed = 61;

  static const _ledgerStatusOptions = [
    'All',
    'Pending',
    'Approved',
    'Paid',
    'For Posting',
  ];
  static const _approvalStages = ['Secretary', 'PB'];
  static const _expenseCategoryOptions = [
    'Personnel Services',
    'General Services',
    'Maintenance and Other Operating Expenses',
    'Capital Outlay',
    'Social Services',
    'Disaster Preparedness',
  ];
  static const _procurementStages = ['PR', 'RFQ', 'Philgeps', 'PO'];

  final Map<String, _FinanceYearSnapshot> _yearSnapshots = {
    '2026': const _FinanceYearSnapshot(
      year: '2026',
      totalBudget: 24500000,
      psaPopulation: 18942,
      allocations: [
        _FinanceBudgetAllocation(
          label: 'General Services',
          amount: 6200000,
          color: Color(0xFFB31212),
          note: 'Frontline operations and governance services',
        ),
        _FinanceBudgetAllocation(
          label: 'Personnel Services',
          amount: 5800000,
          color: Color(0xFFD84040),
          note: 'Honoraria and mandated compensation',
        ),
        _FinanceBudgetAllocation(
          label: 'MOOE',
          amount: 5100000,
          color: Color(0xFFE76A6A),
          note: 'Utilities, supplies, trainings, and field ops',
        ),
        _FinanceBudgetAllocation(
          label: 'Capital Outlay',
          amount: 4300000,
          color: Color(0xFFF39A9A),
          note: 'Equipment and facility upgrades',
        ),
        _FinanceBudgetAllocation(
          label: 'Social Services',
          amount: 3100000,
          color: Color(0xFFF8C1C1),
          note: 'Medical aid and welfare support',
        ),
      ],
    ),
    '2025': const _FinanceYearSnapshot(
      year: '2025',
      totalBudget: 22750000,
      psaPopulation: 18631,
      allocations: [
        _FinanceBudgetAllocation(
          label: 'General Services',
          amount: 5700000,
          color: Color(0xFFB31212),
          note: 'Core governance operations',
        ),
        _FinanceBudgetAllocation(
          label: 'Personnel Services',
          amount: 5450000,
          color: Color(0xFFD84040),
          note: 'Staffing and compensation',
        ),
        _FinanceBudgetAllocation(
          label: 'MOOE',
          amount: 4850000,
          color: Color(0xFFE76A6A),
          note: 'Admin operations and field work',
        ),
        _FinanceBudgetAllocation(
          label: 'Capital Outlay',
          amount: 3600000,
          color: Color(0xFFF39A9A),
          note: 'Facility and equipment improvements',
        ),
        _FinanceBudgetAllocation(
          label: 'Social Services',
          amount: 3150000,
          color: Color(0xFFF8C1C1),
          note: 'Assistance and interventions',
        ),
      ],
    ),
    '2024': const _FinanceYearSnapshot(
      year: '2024',
      totalBudget: 21300000,
      psaPopulation: 18294,
      allocations: [
        _FinanceBudgetAllocation(
          label: 'General Services',
          amount: 5400000,
          color: Color(0xFFB31212),
          note: 'Governance and compliance',
        ),
        _FinanceBudgetAllocation(
          label: 'Personnel Services',
          amount: 4980000,
          color: Color(0xFFD84040),
          note: 'Compensation and staffing',
        ),
        _FinanceBudgetAllocation(
          label: 'MOOE',
          amount: 4560000,
          color: Color(0xFFE76A6A),
          note: 'Admin consumables and operations',
        ),
        _FinanceBudgetAllocation(
          label: 'Capital Outlay',
          amount: 3250000,
          color: Color(0xFFF39A9A),
          note: 'Repairs and procurement',
        ),
        _FinanceBudgetAllocation(
          label: 'Social Services',
          amount: 3110000,
          color: Color(0xFFF8C1C1),
          note: 'Community assistance',
        ),
      ],
    ),
  };

  final List<_FinanceLedgerEntry> _ledgerEntries = [
    _FinanceLedgerEntry(
      pbcNumber: 'PBC-01-12-2026-401',
      dvNumber: 'DV-01-12-2026-096',
      obrNumber: 'OBR-2026-061',
      financialYear: '2026',
      title: 'Quarter 1 office utilities',
      category: 'Maintenance and Other Operating Expenses',
      aipLineItemCode: 'AIP-2026-MOOE-01',
      aipLineItemTitle: 'Office utilities and connectivity',
      payeeName: 'Subic Utilities Cooperative',
      amount: 86500,
      date: DateTime(2026, 1, 12),
      status: 'Paid',
      requestedBy: 'Barangay Treasurer',
      receiptLabel: 'receipt_q1_utilities.jpg',
      approvalStageIndex: 2,
    ),
    _FinanceLedgerEntry(
      pbcNumber: 'PBC-02-06-2026-402',
      dvNumber: 'DV-02-06-2026-097',
      obrNumber: 'OBR-2026-062',
      financialYear: '2026',
      title: 'Medical assistance release',
      category: 'Social Services',
      aipLineItemCode: 'AIP-2026-SS-04',
      aipLineItemTitle: 'Medical and burial assistance fund',
      payeeName: 'Maria Santos',
      amount: 125000,
      date: DateTime(2026, 2, 6),
      status: 'Approved',
      requestedBy: 'Social Services Desk',
      receiptLabel: 'medical_assistance_feb.png',
      approvalStageIndex: 2,
    ),
    _FinanceLedgerEntry(
      pbcNumber: 'PBC-02-18-2026-403',
      dvNumber: 'DV-02-18-2026-098',
      obrNumber: 'OBR-2026-063',
      financialYear: '2026',
      title: 'Printer and scanner procurement',
      category: 'Capital Outlay',
      aipLineItemCode: 'AIP-2026-CO-02',
      aipLineItemTitle: 'Office equipment modernization',
      payeeName: 'Tapinac Office Depot',
      amount: 96500,
      date: DateTime(2026, 2, 18),
      status: 'Pending',
      requestedBy: 'Admin Office',
      receiptLabel: 'scanner_procurement.jpg',
      approvalStageIndex: 0,
    ),
    _FinanceLedgerEntry(
      pbcNumber: 'PBC-11-21-2025-318',
      dvNumber: 'DV-11-21-2025-084',
      obrNumber: 'OBR-2025-048',
      financialYear: '2025',
      title: 'Community clean-up logistics',
      category: 'General Services',
      aipLineItemCode: 'AIP-2025-GS-03',
      aipLineItemTitle: 'Clean-up and sanitation operations',
      payeeName: 'West Tapinac Events Supply',
      amount: 48200,
      date: DateTime(2025, 11, 21),
      status: 'Paid',
      requestedBy: 'Operations Desk',
      receiptLabel: 'cleanup_logistics.jpg',
      approvalStageIndex: 2,
    ),
  ];

  final List<_FinanceProcurementRecord> _procurementRecords = [
    _FinanceProcurementRecord(
      id: 'PROC-2026-011',
      financialYear: '2026',
      title: 'Barangay command center desktop set',
      supplierName: 'Tapinac Office Depot',
      selectedSupplierName: 'Tapinac Office Depot',
      amount: 214500,
      stageIndex: 2,
      updatedAt: DateTime(2026, 3, 10),
      owner: 'Barangay Treasurer',
      quotations: const [
        _FinanceQuotationEntry(
          supplierName: 'Tapinac Office Depot',
          amount: 214500,
          note: '3-year warranty and delivery included',
        ),
        _FinanceQuotationEntry(
          supplierName: 'Subic Bay Civic Printshop',
          amount: 221900,
          note: 'Bundled with toner and printer setup',
        ),
        _FinanceQuotationEntry(
          supplierName: 'West Tapinac Events Supply',
          amount: 228400,
          note: 'Includes surge protection package',
        ),
      ],
      timelineSteps: const [
        _FinanceProjectMilestone(
          label: 'Site Validation',
          detail: 'IT and admin desks inspected the command center room.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Procurement',
          detail: 'Quotation comparison and supplier recommendation underway.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Delivery',
          detail: 'Awaiting final PO release and equipment turnover.',
          completed: false,
        ),
      ],
    ),
    _FinanceProcurementRecord(
      id: 'PROC-2026-009',
      financialYear: '2026',
      title: 'Street lighting replacement package',
      supplierName: 'Zambales Electrical Hub',
      selectedSupplierName: 'Zambales Electrical Hub',
      amount: 398000,
      stageIndex: 3,
      updatedAt: DateTime(2026, 3, 4),
      owner: 'General Services Unit',
      quotations: const [
        _FinanceQuotationEntry(
          supplierName: 'Zambales Electrical Hub',
          amount: 398000,
          note: 'Preferred due to certified install crew',
        ),
        _FinanceQuotationEntry(
          supplierName: 'Tapinac Office Depot',
          amount: 412500,
          note: 'Supply only, installation outsourced',
        ),
        _FinanceQuotationEntry(
          supplierName: 'West Tapinac Events Supply',
          amount: 405700,
          note: 'Longer lead time on poles and fixtures',
        ),
      ],
      timelineSteps: const [
        _FinanceProjectMilestone(
          label: 'Survey',
          detail: 'Lighting failure points mapped across the barangay.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Awarded',
          detail: 'Supplier selected and notice of award prepared.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Installation',
          detail: 'Replacement package now in deployment stage.',
          completed: true,
        ),
      ],
    ),
    _FinanceProcurementRecord(
      id: 'PROC-2025-026',
      financialYear: '2025',
      title: 'Youth council sound system',
      supplierName: 'West Tapinac Events Supply',
      selectedSupplierName: 'West Tapinac Events Supply',
      amount: 128600,
      stageIndex: 3,
      updatedAt: DateTime(2025, 10, 2),
      owner: 'SK Council',
      quotations: const [
        _FinanceQuotationEntry(
          supplierName: 'West Tapinac Events Supply',
          amount: 128600,
          note: 'Portable sound system with event support',
        ),
        _FinanceQuotationEntry(
          supplierName: 'Tapinac Office Depot',
          amount: 133200,
          note: 'Warehouse pickup only',
        ),
        _FinanceQuotationEntry(
          supplierName: 'Subic Bay Civic Printshop',
          amount: 131500,
          note: 'Includes accessory stand package',
        ),
      ],
      timelineSteps: const [
        _FinanceProjectMilestone(
          label: 'Request',
          detail: 'SK council resolution endorsed to procurement.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Award',
          detail: 'Winning quotation approved and released.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Turnover',
          detail: 'Equipment turned over to SK office.',
          completed: true,
        ),
      ],
    ),
  ];

  final List<_FinanceAipLineItem> _aipLineItems = const [
    _FinanceAipLineItem(
      financialYear: '2026',
      code: 'AIP-2026-MOOE-01',
      title: 'Office utilities and connectivity',
      category: 'Maintenance and Other Operating Expenses',
      amount: 480000,
    ),
    _FinanceAipLineItem(
      financialYear: '2026',
      code: 'AIP-2026-SS-04',
      title: 'Medical and burial assistance fund',
      category: 'Social Services',
      amount: 850000,
    ),
    _FinanceAipLineItem(
      financialYear: '2026',
      code: 'AIP-2026-CO-02',
      title: 'Office equipment modernization',
      category: 'Capital Outlay',
      amount: 540000,
    ),
    _FinanceAipLineItem(
      financialYear: '2026',
      code: 'AIP-2026-GS-07',
      title: 'Command center desktop upgrade',
      category: 'General Services',
      amount: 260000,
    ),
    _FinanceAipLineItem(
      financialYear: '2025',
      code: 'AIP-2025-GS-03',
      title: 'Clean-up and sanitation operations',
      category: 'General Services',
      amount: 340000,
    ),
    _FinanceAipLineItem(
      financialYear: '2024',
      code: 'AIP-2024-GS-01',
      title: 'Governance operations and community support',
      category: 'General Services',
      amount: 320000,
    ),
  ];

  final List<_FinanceSupplierEntry> _suppliers = [
    const _FinanceSupplierEntry(
      name: 'Tapinac Office Depot',
      category: 'Office Supplies',
      contactPerson: 'Mia Ramos',
      mobile: '09171230011',
      tin: '238-441-991-000',
      contactEmail: 'mia@tapinacofficedepot.ph',
      active: true,
    ),
    const _FinanceSupplierEntry(
      name: 'Zambales Electrical Hub',
      category: 'Electrical Materials',
      contactPerson: 'Rodel Tan',
      mobile: '09181230022',
      tin: '114-822-730-000',
      contactEmail: 'sales@zambaleselectricalhub.ph',
      active: true,
    ),
    const _FinanceSupplierEntry(
      name: 'West Tapinac Events Supply',
      category: 'Equipment Rental',
      contactPerson: 'Liezl Cruz',
      mobile: '09191230033',
      tin: '905-117-451-000',
      contactEmail: 'ops@wtevents.ph',
      active: true,
    ),
    const _FinanceSupplierEntry(
      name: 'Subic Bay Civic Printshop',
      category: 'Printing Services',
      contactPerson: 'Jules De Vera',
      mobile: '09261230044',
      tin: '640-912-218-000',
      contactEmail: 'desk@subicprintshop.ph',
      active: false,
    ),
  ];

  final List<_FinanceRealignmentEntry> _realignmentEntries = [
    _FinanceRealignmentEntry(
      financialYear: '2026',
      fromCategory: 'General Services',
      toCategory: 'Capital Outlay',
      amount: 150000,
      note: 'Desktop set procurement top-up from savings in operations.',
      timestamp: DateTime(2026, 3, 6, 15, 20),
    ),
  ];

  final List<_FinanceTransparencyProject> _transparencyProjects = [
    const _FinanceTransparencyProject(
      financialYear: '2026',
      title: 'Covered waiting shed improvements',
      status: 'Approved',
      budget: 680000,
      timeline: 'Apr 2026 - Jun 2026',
      beneficiaries: 'Commuters and senior citizens',
      summary: 'Phase 2 rehabilitation of the public waiting shed and sidewalk.',
      milestones: [
        _FinanceProjectMilestone(
          label: 'Design',
          detail: 'Engineering scope and layout approved.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Procurement',
          detail: 'Materials package is under canvass and RFQ.',
          completed: false,
        ),
        _FinanceProjectMilestone(
          label: 'Construction',
          detail: 'Implementation starts after procurement award.',
          completed: false,
        ),
      ],
    ),
    const _FinanceTransparencyProject(
      financialYear: '2026',
      title: 'Women and child desk equipment',
      status: 'In Progress',
      budget: 245000,
      timeline: 'Mar 2026 - Apr 2026',
      beneficiaries: 'Women and child protection desk',
      summary: 'New desktop, storage, scanner, and privacy partition.',
      milestones: [
        _FinanceProjectMilestone(
          label: 'Specification',
          detail: 'Equipment list finalized with desk officers.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Award',
          detail: 'Supplier recommendation ready for approval.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Turnover',
          detail: 'Pending delivery and inventory tagging.',
          completed: false,
        ),
      ],
    ),
    const _FinanceTransparencyProject(
      financialYear: '2025',
      title: 'Rainwater collection upgrade',
      status: 'Completed',
      budget: 410000,
      timeline: 'Aug 2025 - Nov 2025',
      beneficiaries: 'Public hall and evacuation staging area',
      summary: 'Storage tanks and guttering for hall and annex structures.',
      milestones: [
        _FinanceProjectMilestone(
          label: 'Survey',
          detail: 'Drainage and tank placement mapped.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Installation',
          detail: 'Tank base, gutters, and piping installed.',
          completed: true,
        ),
        _FinanceProjectMilestone(
          label: 'Commissioning',
          detail: 'System tested and accepted by barangay engineering team.',
          completed: true,
        ),
      ],
    ),
  ];

  final List<_FinanceAuditEntry> _auditTrail = [
    _FinanceAuditEntry(
      actor: 'Barangay Treasurer',
      action: 'Created ledger entry',
      detail: 'PBC-02-18-2026-403 was added to the 2026 ledger.',
      timestamp: DateTime(2026, 2, 18, 14, 22),
    ),
    _FinanceAuditEntry(
      actor: 'Punong Barangay',
      action: 'Approved procurement',
      detail: 'PROC-2026-009 advanced to PO.',
      timestamp: DateTime(2026, 3, 4, 9, 10),
    ),
    _FinanceAuditEntry(
      actor: 'Barangay Secretary',
      action: 'Published transparency item',
      detail:
          'Covered waiting shed improvements posted to the transparency board.',
      timestamp: DateTime(2026, 3, 8, 11, 35),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _publishTreasurerHomeBalance();
  }

  @override
  void dispose() {
    _ledgerSearchController.dispose();
    super.dispose();
  }

  _FinanceYearSnapshot get _selectedSnapshot =>
      _yearSnapshots[_selectedFinancialYear]!;

  List<_FinanceLedgerEntry> get _yearLedgerEntries => _ledgerEntries
      .where((entry) => entry.financialYear == _selectedFinancialYear)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  List<_FinanceProcurementRecord> get _yearProcurements =>
      _procurementRecords
          .where((record) => record.financialYear == _selectedFinancialYear)
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  List<_FinanceAipLineItem> get _yearAipLineItems => _aipLineItems
      .where((item) => item.financialYear == _selectedFinancialYear)
      .toList();

  List<_FinanceTransparencyProject> get _yearTransparencyProjects =>
      _transparencyProjects
          .where((project) => project.financialYear == _selectedFinancialYear)
          .toList();

  List<_FinanceRealignmentEntry> get _yearRealignmentEntries => _realignmentEntries
      .where((entry) => entry.financialYear == _selectedFinancialYear)
      .toList()
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  List<_FinanceBudgetAllocation> get _computedAllocations {
    final adjustments = <String, double>{
      for (final allocation in _selectedSnapshot.allocations) allocation.label: allocation.amount,
    };
    for (final realignment in _yearRealignmentEntries) {
      adjustments[realignment.fromCategory] =
          (adjustments[realignment.fromCategory] ?? 0) - realignment.amount;
      adjustments[realignment.toCategory] =
          (adjustments[realignment.toCategory] ?? 0) + realignment.amount;
    }
    return _selectedSnapshot.allocations
        .map(
          (allocation) => _FinanceBudgetAllocation(
            label: allocation.label,
            amount: adjustments[allocation.label] ?? allocation.amount,
            color: allocation.color,
            note: allocation.note,
          ),
        )
        .toList();
  }

  double get _yearDisbursements => _yearLedgerEntries.fold<double>(
    0,
    (sum, entry) => sum + entry.amount,
  );

  double get _availableFund => _selectedSnapshot.totalBudget - _yearDisbursements;

  double get _skFundAllocation => _selectedSnapshot.totalBudget * 0.10;

  List<_FinanceLedgerEntry> get _filteredLedgerEntries {
    final query = _ledgerSearchController.text.trim().toLowerCase();
    return _yearLedgerEntries.where((entry) {
      final matchesStatus =
          _ledgerStatusFilter == 'All' || entry.status == _ledgerStatusFilter;
      final haystack =
          '${entry.pbcNumber} ${entry.title} ${entry.category} ${entry.requestedBy}'
              .toLowerCase();
      final matchesQuery = query.isEmpty || haystack.contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  String _currency(double value) {
    final whole = value.floor();
    final decimal = ((value - whole) * 100).round().toString().padLeft(2, '0');
    final parts = whole.toString().split('').reversed.toList();
    final chunks = <String>[];
    for (var i = 0; i < parts.length; i += 3) {
      final end = (i + 3 < parts.length) ? i + 3 : parts.length;
      chunks.add(parts.sublist(i, end).join(''));
    }
    return 'PHP ${chunks.map((e) => e.split('').reversed.join('')).toList().reversed.join(',')}.$decimal';
  }

  String _currencyCompact(double value) {
    if (value >= 1000000) {
      return 'PHP ${(value / 1000000).toStringAsFixed(2)}M';
    }
    if (value >= 1000) {
      return 'PHP ${(value / 1000).toStringAsFixed(1)}K';
    }
    return _currency(value);
  }

  String _dateLabel(DateTime value) {
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

  String _generatePbc(DateTime date) {
    final nextId = _pbcSeed++;
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return 'PBC-$mm-$dd-${date.year}-${nextId.toString().padLeft(3, '0')}';
  }

  String _generateDv(DateTime date) {
    final nextId = _dvSeed++;
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return 'DV-$mm-$dd-${date.year}-${nextId.toString().padLeft(3, '0')}';
  }

  String _generateObr(DateTime date) {
    final nextId = _obrSeed++;
    return 'OBR-${date.year}-${nextId.toString().padLeft(3, '0')}';
  }

  void _publishTreasurerHomeBalance() {
    final currentYear = DateTime.now().year.toString();
    final snapshot = _yearSnapshots[currentYear];
    if (snapshot == null) {
      return;
    }
    final disbursements = _ledgerEntries
        .where((entry) => entry.financialYear == currentYear)
        .fold<double>(0, (sum, entry) => sum + entry.amount);
    _treasurerRemainingBalanceHome.value =
        _currencyCompact(snapshot.totalBudget - disbursements);
  }

  void _recordAudit({
    required String actor,
    required String action,
    required String detail,
    DateTime? timestamp,
  }) {
    _auditTrail.insert(
      0,
      _FinanceAuditEntry(
        actor: actor,
        action: action,
        detail: detail,
        timestamp: timestamp ?? DateTime.now(),
      ),
    );
  }

  Future<void> _showBudgetRealignmentSheet() async {
    String fromCategory = _selectedSnapshot.allocations.first.label;
    String toCategory = _selectedSnapshot.allocations[1].label;
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    final created = await showModalBottomSheet<_FinanceRealignmentEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 12,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Budget Realignment',
                        style: TextStyle(
                          color: _officialText,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Transfer funds between approved budget categories for the selected fiscal year.',
                        style: TextStyle(
                          color: _officialSubtext,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: fromCategory,
                        decoration: const InputDecoration(
                          labelText: 'From category',
                          border: OutlineInputBorder(),
                        ),
                        items: _selectedSnapshot.allocations
                            .map(
                              (allocation) => DropdownMenuItem(
                                value: allocation.label,
                                child: Text(allocation.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setSheetState(() {
                            fromCategory = value ?? fromCategory;
                            if (toCategory == fromCategory &&
                                _selectedSnapshot.allocations.length > 1) {
                              toCategory = _selectedSnapshot.allocations
                                  .firstWhere((allocation) => allocation.label != fromCategory)
                                  .label;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: toCategory,
                        decoration: const InputDecoration(
                          labelText: 'To category',
                          border: OutlineInputBorder(),
                        ),
                        items: _selectedSnapshot.allocations
                            .where((allocation) => allocation.label != fromCategory)
                            .map(
                              (allocation) => DropdownMenuItem(
                                value: allocation.label,
                                child: Text(allocation.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setSheetState(() {
                            toCategory = value ?? toCategory;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixText: 'PHP ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: noteController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Realignment note',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (errorText != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          errorText!,
                          style: const TextStyle(
                            color: Color(0xFFB31212),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            final amount = double.tryParse(amountController.text.trim());
                            if (amount == null || amount <= 0) {
                              setSheetState(() {
                                errorText = 'Enter a valid realignment amount.';
                              });
                              return;
                            }
                            if (noteController.text.trim().isEmpty) {
                              setSheetState(() {
                                errorText = 'Provide the realignment reason.';
                              });
                              return;
                            }
                            if (fromCategory == toCategory) {
                              setSheetState(() {
                                errorText = 'Source and destination categories must differ.';
                              });
                              return;
                            }
                            Navigator.of(sheetContext).pop(
                              _FinanceRealignmentEntry(
                                financialYear: _selectedFinancialYear,
                                fromCategory: fromCategory,
                                toCategory: toCategory,
                                amount: amount,
                                note: noteController.text.trim(),
                                timestamp: DateTime.now(),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFB31212),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Save Realignment',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    amountController.dispose();
    noteController.dispose();

    if (created == null) return;
    setState(() {
      _realignmentEntries.insert(0, created);
      _recordAudit(
        actor: 'Barangay Treasurer',
        action: 'Budget realigned',
        detail:
            '${_currency(created.amount)} moved from ${created.fromCategory} to ${created.toCategory}.',
      );
    });
  }

  Future<void> _showAddExpenseSheet() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final requesterController =
        TextEditingController(text: 'Barangay Treasurer');
    final payeeController = TextEditingController();
    String category = _expenseCategoryOptions.first;
    String status = 'Pending';
    DateTime expenseDate = DateTime.now();
    String? receiptLabel;
    var selectedAip = _yearAipLineItems.first;

    final created = await showModalBottomSheet<_FinanceExpenseDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> pickReceipt(ImageSource source) async {
              final image = await ImagePicker().pickImage(
                source: source,
                imageQuality: 82,
              );
              if (image == null) return;
              setSheetState(() {
                receiptLabel = image.name;
              });
            }

            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 12,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Expense',
                          style: TextStyle(
                            color: _officialText,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Receipt upload is required before the expense can be saved.',
                          style: TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Expense title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: _expenseCategoryOptions
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setSheetState(() {
                              category = value ?? _expenseCategoryOptions.first;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}$'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            prefixText: 'PHP ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: requesterController,
                          decoration: const InputDecoration(
                            labelText: 'Requested by',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<_FinanceAipLineItem>(
                          initialValue: selectedAip,
                          decoration: const InputDecoration(
                            labelText: 'OBR / AIP line item',
                            border: OutlineInputBorder(),
                          ),
                          items: _yearAipLineItems
                              .map(
                                (item) => DropdownMenuItem<_FinanceAipLineItem>(
                                  value: item,
                                  child: Text('${item.code} - ${item.title}'),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setSheetState(() {
                              selectedAip = value;
                              category = value.category;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: payeeController,
                          decoration: const InputDecoration(
                            labelText: 'Payee / Supplier',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: _ledgerStatusOptions
                              .where((item) => item != 'All')
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setSheetState(() {
                              status = value ?? 'Pending';
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Expense date',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(_dateLabel(expenseDate)),
                          trailing: const Icon(Icons.calendar_month_rounded),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: expenseDate,
                              firstDate: DateTime(2024, 1, 1),
                              lastDate: DateTime(2030, 12, 31),
                            );
                            if (picked == null) return;
                            setSheetState(() {
                              expenseDate = picked;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F4F4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEBCACA)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Receipt photo',
                                style: TextStyle(
                                  color: _officialText,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                receiptLabel ?? 'No photo selected yet',
                                style: const TextStyle(
                                  color: _officialSubtext,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          pickReceipt(ImageSource.camera),
                                      icon: const Icon(Icons.photo_camera),
                                      label: const Text('Camera'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () =>
                                          pickReceipt(ImageSource.gallery),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(0xFFB31212),
                                        foregroundColor: Colors.white,
                                      ),
                                      icon: const Icon(Icons.photo_library),
                                      label: const Text('Gallery'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (errorText != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            errorText!,
                            style: const TextStyle(
                              color: Color(0xFFB31212),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              final title = titleController.text.trim();
                              final amount =
                                  double.tryParse(amountController.text.trim());
                              final requester = requesterController.text.trim();
                              final payee = payeeController.text.trim();
                              if (title.isEmpty ||
                                  requester.isEmpty ||
                                  payee.isEmpty ||
                                  amount == null ||
                                  amount <= 0 ||
                                  receiptLabel == null) {
                                setSheetState(() {
                                  errorText =
                                      'Complete all fields and upload the receipt photo first.';
                                });
                                return;
                              }
                              Navigator.of(sheetContext).pop(
                                _FinanceExpenseDraft(
                                  title: title,
                                  category: category,
                                  aipLineItemCode: selectedAip.code,
                                  aipLineItemTitle: selectedAip.title,
                                  payeeName: payee,
                                  amount: amount,
                                  requestedBy: requester,
                                  date: expenseDate,
                                  status: status,
                                  receiptLabel: receiptLabel!,
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFB31212),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Save Expense',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    amountController.dispose();
    requesterController.dispose();
    payeeController.dispose();

    if (created == null) return;
    setState(() {
      final pbcNumber = _generatePbc(created.date);
      final dvNumber = _generateDv(created.date);
      final obrNumber = _generateObr(created.date);
      _ledgerEntries.insert(
        0,
        _FinanceLedgerEntry(
          pbcNumber: pbcNumber,
          dvNumber: dvNumber,
          obrNumber: obrNumber,
          financialYear: _selectedFinancialYear,
          title: created.title,
          category: created.category,
          aipLineItemCode: created.aipLineItemCode,
          aipLineItemTitle: created.aipLineItemTitle,
          payeeName: created.payeeName,
          amount: created.amount,
          date: created.date,
          status: created.status,
          requestedBy: created.requestedBy,
          receiptLabel: created.receiptLabel,
          approvalStageIndex:
              created.status == 'Approved' || created.status == 'Paid' ? 2 : 0,
        ),
      );
      _recordAudit(
        actor: created.requestedBy,
        action: 'Added expense',
        detail:
            '$pbcNumber / $obrNumber linked to ${created.aipLineItemCode} for ${created.title}.',
      );
      _publishTreasurerHomeBalance();
    });
  }

  Future<void> _showAddSupplierSheet() async {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final personController = TextEditingController();
    final mobileController = TextEditingController();
    final tinController = TextEditingController();
    final emailController = TextEditingController();
    bool active = true;

    final created = await showModalBottomSheet<_FinanceSupplierDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 12,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Supplier',
                        style: TextStyle(
                          color: _officialText,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: personController,
                        decoration: const InputDecoration(
                          labelText: 'Contact person',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: tinController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'TIN',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Contact email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        value: active,
                        contentPadding: EdgeInsets.zero,
                        activeColor: const Color(0xFFB31212),
                        title: const Text(
                          'Active vendor',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: const Text(
                          'Inactive suppliers stay in the database but are hidden from the active roster.',
                        ),
                        onChanged: (value) {
                          setSheetState(() {
                            active = value;
                          });
                        },
                      ),
                      if (errorText != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          errorText!,
                          style: const TextStyle(
                            color: Color(0xFFB31212),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            final name = nameController.text.trim();
                            final category = categoryController.text.trim();
                            final contactPerson = personController.text.trim();
                            final mobile = mobileController.text.trim();
                            final tin = tinController.text.trim();
                            final email = emailController.text.trim();
                            if (name.isEmpty ||
                                category.isEmpty ||
                                contactPerson.isEmpty ||
                                mobile.isEmpty ||
                                tin.isEmpty ||
                                email.isEmpty) {
                              setSheetState(() {
                                errorText = 'Complete all supplier fields.';
                              });
                              return;
                            }
                            Navigator.of(sheetContext).pop(
                              _FinanceSupplierDraft(
                                name: name,
                                category: category,
                                contactPerson: contactPerson,
                                mobile: mobile,
                                tin: tin,
                                contactEmail: email,
                                active: active,
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFB31212),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Save Supplier',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    nameController.dispose();
    categoryController.dispose();
    personController.dispose();
    mobileController.dispose();
    tinController.dispose();
    emailController.dispose();

    if (created == null) return;
    setState(() {
      _suppliers.insert(
        0,
        _FinanceSupplierEntry(
          name: created.name,
          category: created.category,
          contactPerson: created.contactPerson,
          mobile: created.mobile,
          tin: created.tin,
          contactEmail: created.contactEmail,
          active: created.active,
        ),
      );
      _recordAudit(
        actor: 'Barangay Secretary',
        action: 'Updated supplier database',
        detail: '${created.name} was added to the vendor registry.',
      );
    });
  }

  void _advanceVoucherApproval(_FinanceLedgerEntry entry) {
    if (entry.approvalStageIndex >= _approvalStages.length) {
      return;
    }
    final currentIndex = _ledgerEntries.indexOf(entry);
    if (currentIndex == -1) {
      return;
    }
    final nextStage = entry.approvalStageIndex + 1;
    final actor = nextStage == 1 ? 'Barangay Secretary' : 'Punong Barangay';
    final updated = entry.copyWith(
      approvalStageIndex: nextStage,
      status: nextStage >= _approvalStages.length ? 'Approved' : entry.status,
    );
    setState(() {
      _ledgerEntries[currentIndex] = updated;
      _recordAudit(
        actor: actor,
        action: 'Approved disbursement voucher',
        detail: '${updated.dvNumber} advanced to ${_approvalStages[nextStage - 1]}.',
      );
    });
  }

  void _selectAwardSupplier(
    _FinanceProcurementRecord record,
    String supplierName,
  ) {
    final index = _procurementRecords.indexOf(record);
    if (index == -1) return;
    setState(() {
      _procurementRecords[index] = record.copyWith(
        supplierName: supplierName,
        selectedSupplierName: supplierName,
        updatedAt: DateTime.now(),
      );
      _recordAudit(
        actor: 'Barangay Treasurer',
        action: 'Updated supplier award',
        detail: '${record.id} selected $supplierName for the notice of award.',
      );
    });
  }

  void _advanceProcurement(_FinanceProcurementRecord record) {
    if (record.stageIndex >= _procurementStages.length - 1) return;
    setState(() {
      final index = _procurementRecords.indexOf(record);
      if (index == -1) return;
      final updated = record.copyWith(
        stageIndex: record.stageIndex + 1,
        updatedAt: DateTime.now(),
      );
      _procurementRecords[index] = updated;
      _recordAudit(
        actor: updated.owner,
        action: 'Advanced procurement stage',
        detail:
            '${updated.id} moved to ${_procurementStages[updated.stageIndex]}.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fiscal & Procurement'),
          backgroundColor: const Color(0xFF9F1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9F1A1A), Color(0xFFC92A2A)],
              ),
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              initialValue: _selectedFinancialYear,
              onSelected: (value) =>
                  setState(() => _selectedFinancialYear = value),
              itemBuilder: (context) => _yearSnapshots.keys
                  .map(
                    (year) => PopupMenuItem<String>(
                      value: year,
                      child: Text('FY $year'),
                    ),
                  )
                  .toList(),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'FY $_selectedFinancialYear',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.expand_more, size: 18),
                  ],
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFFFD8D8),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            tabs: [
              Tab(text: 'Budget'),
              Tab(text: 'Ledger'),
              Tab(text: 'Procurement'),
              Tab(text: 'Transparency'),
              Tab(text: 'Audit'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBudgetTab(),
            _buildLedgerTab(),
            _buildProcurementTab(),
            _buildTransparencyTab(),
            _buildAuditTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9F1A1A), Color(0xFFD84040)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Breakdown FY $_selectedFinancialYear',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fund allocation, remaining balance, and approved public spend for the selected financial year.',
                  style: TextStyle(
                    color: Color(0xFFFFE3E3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _FinanceOverviewChip(
                      label: 'Total Budget',
                      value: _currency(_selectedSnapshot.totalBudget),
                    ),
                    _FinanceOverviewChip(
                      label: 'Available Fund',
                      value: _currency(_availableFund),
                    ),
                    _FinanceOverviewChip(
                      label: 'Disbursements',
                      value: _currency(_yearDisbursements),
                    ),
                    _FinanceOverviewChip(
                      label: 'SK Fund 10%',
                      value: _currency(_skFundAllocation),
                    ),
                    _FinanceOverviewChip(
                      label: 'PSA Population',
                      value: _selectedSnapshot.psaPopulation.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Available Fund',
                  value: _currency(_availableFund),
                  caption: 'Total budget minus posted disbursements',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.receipt_long,
                  title: 'Ledger Entries',
                  value: _yearLedgerEntries.length.toString(),
                  caption: 'Recorded cash outflows this year',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.child_care_outlined,
                  title: 'SK Fund',
                  value: _currency(_skFundAllocation),
                  caption: 'Auto-allocation using Total Budget x 0.10',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _showBudgetRealignmentSheet,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFB31212),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.compare_arrows_rounded),
                  label: const Text(
                    'Realign Budget',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7D7D7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fund Allocation Pie Chart',
                  style: TextStyle(
                    color: _officialText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pie chart of approved fund allocations for the selected financial year.',
                  style: TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: _FinanceBudgetPieChart(
                        allocations: _computedAllocations,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: _computedAllocations
                            .map(
                              (allocation) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 14,
                                      height: 14,
                                      margin: const EdgeInsets.only(top: 4),
                                      decoration: BoxDecoration(
                                        color: allocation.color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            allocation.label,
                                            style: const TextStyle(
                                              color: _officialText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            allocation.note,
                                            style: const TextStyle(
                                              color: _officialSubtext,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            _currency(allocation.amount),
                                            style: const TextStyle(
                                              color: Color(0xFFB31212),
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
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
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7D7D7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget Realignment Log',
                  style: TextStyle(
                    color: _officialText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Transfers between fund categories are tracked here for audit and transparency.',
                  style: TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (_yearRealignmentEntries.isEmpty)
                  const Text(
                    'No budget realignments recorded for this fiscal year.',
                    style: TextStyle(
                      color: _officialSubtext,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  ..._yearRealignmentEntries.map(
                    (entry) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFBFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE7D7D7)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.fromCategory} -> ${entry.toCategory}',
                            style: const TextStyle(
                              color: _officialText,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currency(entry.amount),
                            style: const TextStyle(
                              color: Color(0xFFB31212),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.note,
                            style: const TextStyle(
                              color: _officialSubtext,
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
        ],
      ),
    );
  }

  Widget _buildLedgerTab() {
    final rows = _filteredLedgerEntries;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Row(
            children: [
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.payments_outlined,
                  title: 'Available Fund',
                  value: _currency(_availableFund),
                  caption: 'Live counter for FY $_selectedFinancialYear',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.confirmation_number_outlined,
                  title: 'Latest PBC',
                  value: _yearLedgerEntries.isEmpty
                      ? 'None'
                      : _yearLedgerEntries.first.pbcNumber,
                  caption: 'Generated using PBC-MM-DD-YYYY-ID',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE3E6F1)),
            ),
            child: TextField(
              controller: _ledgerSearchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search_rounded),
                suffixIcon: Icon(Icons.search_rounded),
                hintText: 'Search PBC, title, category, or requester...',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _financeFilterDropdown(
                  label: 'Status',
                  value: _ledgerStatusFilter,
                  items: _ledgerStatusOptions,
                  onChanged: (v) =>
                      setState(() => _ledgerStatusFilter = v ?? 'All'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _showAddExpenseSheet,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFB31212),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text(
                    'Add Expense',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7D7D7)),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'PBC / Date',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Expense',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Amount',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (rows.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      'No disbursement ledger entries matched your filters.',
                      style: TextStyle(
                        color: _officialSubtext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  ...rows.map(
                    (entry) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFBFB),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE7D7D7)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.pbcNumber,
                                      style: const TextStyle(
                                        color: Color(0xFFB31212),
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      _dateLabel(entry.date),
                                      style: const TextStyle(
                                        color: _officialSubtext,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.title,
                                      style: const TextStyle(
                                        color: _officialText,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                     Text(
                                       entry.category,
                                       style: const TextStyle(
                                         color: _officialSubtext,
                                         fontWeight: FontWeight.w600,
                                       ),
                                     ),
                                     Text(
                                       'Payee: ${entry.payeeName}',
                                       style: const TextStyle(
                                         color: _officialSubtext,
                                         fontSize: 12,
                                         fontWeight: FontWeight.w600,
                                       ),
                                     ),
                                     Text(
                                       'Requested by ${entry.requestedBy}',
                                       style: const TextStyle(
                                         color: _officialSubtext,
                                         fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _currency(entry.amount),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        color: _officialText,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    _FinanceStatusPill(
                                      label: entry.status,
                                      color: _ledgerStatusColor(entry.status),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                size: 16,
                                color: _officialSubtext,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Receipt: ${entry.receiptLabel}',
                                  style: const TextStyle(
                                    color: _officialSubtext,
                                    fontWeight: FontWeight.w600,
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
                              _FinanceInfoChip(
                                icon: Icons.account_tree_outlined,
                                text: '${entry.obrNumber} / ${entry.aipLineItemCode}',
                              ),
                              _FinanceInfoChip(
                                icon: Icons.list_alt_rounded,
                                text: entry.aipLineItemTitle,
                              ),
                              _FinanceInfoChip(
                                icon: Icons.receipt_long_outlined,
                                text: entry.dvNumber,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _FinanceApprovalWorkflowBar(
                            labels: _approvalStages,
                            currentIndex: entry.approvalStageIndex,
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
                                        builder: (_) =>
                                            _DisbursementVoucherPreviewPage(entry: entry),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.picture_as_pdf_outlined),
                                  label: const Text('Generate DV'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: entry.approvalStageIndex >=
                                          _approvalStages.length
                                      ? null
                                      : () => _advanceVoucherApproval(entry),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFB31212),
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.how_to_reg_outlined),
                                  label: Text(
                                    entry.approvalStageIndex >= _approvalStages.length
                                        ? 'Fully Approved'
                                        : 'Approve Next',
                                    style: const TextStyle(fontWeight: FontWeight.w800),
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
        ],
      ),
    );
  }

  Widget _buildProcurementTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Row(
            children: [
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.storefront_outlined,
                  title: 'Active Suppliers',
                  value:
                      _suppliers.where((supplier) => supplier.active).length.toString(),
                  caption: 'Vendor database for current procurements',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Open Procurements',
                  value: _yearProcurements
                      .where(
                        (record) =>
                            record.stageIndex < _procurementStages.length - 1,
                      )
                      .length
                      .toString(),
                  caption: 'Requests not yet finalized to PO',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Procurement Stepper',
                  style: TextStyle(
                    color: _officialText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: _showAddSupplierSheet,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB31212),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text(
                  'Add Supplier',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Every procurement record moves through PR, RFQ, Philgeps, and PO with a visible status trail.',
            style: TextStyle(
              color: _officialSubtext,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ..._yearProcurements.map(
            (record) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE7D7D7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.title,
                              style: const TextStyle(
                                color: _officialText,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${record.id} • ${record.supplierName}',
                              style: const TextStyle(
                                color: _officialSubtext,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _currency(record.amount),
                        style: const TextStyle(
                          color: Color(0xFFB31212),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _FinanceProcurementStepper(
                    stages: _procurementStages,
                    currentStageIndex: record.stageIndex,
                  ),
                  const SizedBox(height: 12),
                  _FinanceQuotationComparisonTable(
                    quotations: record.quotations,
                    selectedSupplierName: record.selectedSupplierName,
                    onSelect: (supplierName) =>
                        _selectAwardSupplier(record, supplierName),
                    currencyBuilder: _currency,
                  ),
                  const SizedBox(height: 12),
                  _FinanceProjectTimelinePanel(
                    title: 'Project Timeline',
                    milestones: record.timelineSteps,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Owner: ${record.owner}\nUpdated ${_dateLabel(record.updatedAt)}',
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _NoticeOfAwardPage(record: record),
                            ),
                          );
                        },
                        icon: const Icon(Icons.workspace_premium_outlined),
                        label: const Text('Notice of Award'),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: record.stageIndex >=
                                _procurementStages.length - 1
                            ? null
                            : () => _advanceProcurement(record),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB31212),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          record.stageIndex >= _procurementStages.length - 1
                              ? 'Completed'
                              : 'Advance Step',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Supplier Management',
            style: TextStyle(
              color: _officialText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ..._suppliers.map(
            (supplier) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE7D7D7)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEAEA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      color: Color(0xFFB31212),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier.name,
                          style: const TextStyle(
                            color: _officialText,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${supplier.category} • ${supplier.contactPerson}',
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          supplier.mobile,
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          supplier.contactEmail,
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'TIN ${supplier.tin}',
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _FinanceStatusPill(
                    label: supplier.active ? 'Active' : 'Inactive',
                    color: supplier.active
                        ? const Color(0xFFB31212)
                        : const Color(0xFF8A8FA8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransparencyTab() {
    final projects = _yearTransparencyProjects;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE7D7D7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transparency Board',
                  style: TextStyle(
                    color: _officialText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Public view of approved and published projects for FY $_selectedFinancialYear.',
                  style: const TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (projects.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No transparency items are published for this year yet.',
                  style: TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            ...projects.map(
              (project) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE7D7D7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: const TextStyle(
                              color: _officialText,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _FinanceStatusPill(
                          label: project.status,
                          color: _transparencyStatusColor(project.status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      project.summary,
                      style: const TextStyle(
                        color: _officialSubtext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _FinanceInfoChip(
                          icon: Icons.payments_outlined,
                          text: _currency(project.budget),
                        ),
                        _FinanceInfoChip(
                          icon: Icons.schedule,
                          text: project.timeline,
                        ),
                        _FinanceInfoChip(
                          icon: Icons.groups_rounded,
                          text: project.beneficiaries,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FinanceProjectTimelinePanel(
                      title: 'Implementation Timeline',
                      milestones: project.milestones,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAuditTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FC), Color(0xFFF3ECEC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Row(
            children: [
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.fact_check_outlined,
                  title: 'Audit Entries',
                  value: _auditTrail.length.toString(),
                  caption: 'Every financial action is logged',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FinanceStatCard(
                  icon: Icons.people_alt_outlined,
                  title: 'Actors Logged',
                  value:
                      _auditTrail.map((entry) => entry.actor).toSet().length.toString(),
                  caption: 'Users contributing to the audit trail',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Audit Trail',
            style: TextStyle(
              color: _officialText,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Every finance action records the user, timestamp, and the specific change applied.',
            style: TextStyle(
              color: _officialSubtext,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ..._auditTrail.map(
            (entry) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE7D7D7)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEAEA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.history_rounded,
                      color: Color(0xFFB31212),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.action,
                          style: const TextStyle(
                            color: _officialText,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${entry.actor} • ${_dateLabel(entry.timestamp)}',
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry.detail,
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  Color _ledgerStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFFB31212);
      case 'Approved':
        return const Color(0xFFC94A4A);
      case 'For Posting':
        return const Color(0xFFD97A7A);
      case 'Pending':
      default:
        return const Color(0xFF8A8FA8);
    }
  }

  Color _transparencyStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFFB31212);
      case 'Approved':
        return const Color(0xFFC94A4A);
      case 'In Progress':
      default:
        return const Color(0xFFD97A7A);
    }
  }

  Widget _financeFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _FinanceOverviewChip extends StatelessWidget {
  final String label;
  final String value;

  const _FinanceOverviewChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFDADA),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String caption;

  const _FinanceStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7D7D7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFCEAEA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFFB31212)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: _officialSubtext,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: _officialText,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            style: const TextStyle(
              color: _officialSubtext,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceStatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _FinanceStatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _FinanceInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FinanceInfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEAEA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFB31212)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF7E1111),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceBudgetPieChart extends StatelessWidget {
  final List<_FinanceBudgetAllocation> allocations;

  const _FinanceBudgetPieChart({required this.allocations});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FinanceBudgetPiePainter(allocations),
      child: const SizedBox.expand(),
    );
  }
}

class _FinanceBudgetPiePainter extends CustomPainter {
  final List<_FinanceBudgetAllocation> allocations;

  _FinanceBudgetPiePainter(this.allocations);

  @override
  void paint(Canvas canvas, Size size) {
    final total = allocations.fold<double>(0, (sum, item) => sum + item.amount);
    if (total <= 0) return;
    final rect = Offset.zero & size;
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 4;
    var startAngle = -math.pi / 2;
    for (final allocation in allocations) {
      final sweepAngle = (allocation.amount / total) * math.pi * 2;
      fillPaint.color = allocation.color;
      canvas.drawArc(rect, startAngle, sweepAngle, true, fillPaint);
      canvas.drawArc(rect, startAngle, sweepAngle, true, borderPaint);
      startAngle += sweepAngle;
    }
    canvas.drawCircle(
      rect.center,
      size.width * 0.24,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _FinanceBudgetPiePainter oldDelegate) =>
      oldDelegate.allocations != allocations;
}

class _FinanceProcurementStepper extends StatelessWidget {
  final List<String> stages;
  final int currentStageIndex;

  const _FinanceProcurementStepper({
    required this.stages,
    required this.currentStageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(stages.length * 2 - 1, (index) {
        if (index.isOdd) {
          final completed = index ~/ 2 < currentStageIndex;
          return Expanded(
            child: Container(
              height: 4,
              color: completed
                  ? const Color(0xFFB31212)
                  : const Color(0xFFE7D7D7),
            ),
          );
        }
        final stageIndex = index ~/ 2;
        final active = stageIndex <= currentStageIndex;
        return Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFFB31212)
                : const Color(0xFFF5EAEA),
            shape: BoxShape.circle,
          ),
          child: Text(
            stages[stageIndex],
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF8A8FA8),
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        );
      }),
    );
  }
}

class _FinanceApprovalWorkflowBar extends StatelessWidget {
  final List<String> labels;
  final int currentIndex;

  const _FinanceApprovalWorkflowBar({
    required this.labels,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final completed = currentIndex > index;
        final active = currentIndex == index;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 8),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: completed || active
                  ? const Color(0xFFFCEAEA)
                  : const Color(0xFFF4F5F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: completed || active
                    ? const Color(0xFFD88B8B)
                    : const Color(0xFFE4E7F0),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : active
                          ? Icons.pending_actions_rounded
                          : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: completed || active
                      ? const Color(0xFFB31212)
                      : const Color(0xFF8A8FA8),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  style: const TextStyle(
                    color: _officialText,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _FinanceQuotationComparisonTable extends StatelessWidget {
  final List<_FinanceQuotationEntry> quotations;
  final String selectedSupplierName;
  final ValueChanged<String> onSelect;
  final String Function(double amount) currencyBuilder;

  const _FinanceQuotationComparisonTable({
    required this.quotations,
    required this.selectedSupplierName,
    required this.onSelect,
    required this.currencyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quotation Comparison',
          style: TextStyle(
            color: _officialText,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: quotations
              .take(3)
              .map(
                (quote) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: quote.supplierName == selectedSupplierName
                          ? const Color(0xFFFCEAEA)
                          : const Color(0xFFFDFBFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: quote.supplierName == selectedSupplierName
                            ? const Color(0xFFD99090)
                            : const Color(0xFFE7D7D7),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote.supplierName,
                          style: const TextStyle(
                            color: _officialText,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currencyBuilder(quote.amount),
                          style: const TextStyle(
                            color: Color(0xFFB31212),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          quote.note,
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => onSelect(quote.supplierName),
                            child: Text(
                              quote.supplierName == selectedSupplierName
                                  ? 'Selected'
                                  : 'Select',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _FinanceProjectTimelinePanel extends StatelessWidget {
  final String title;
  final List<_FinanceProjectMilestone> milestones;

  const _FinanceProjectTimelinePanel({
    required this.title,
    required this.milestones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7D7D7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _officialText,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ...milestones.map(
            (milestone) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    milestone.completed
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: milestone.completed
                        ? const Color(0xFFB31212)
                        : const Color(0xFF8A8FA8),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          milestone.label,
                          style: const TextStyle(
                            color: _officialText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          milestone.detail,
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

class _DisbursementVoucherPreviewPage extends StatelessWidget {
  final _FinanceLedgerEntry entry;

  const _DisbursementVoucherPreviewPage({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disbursement Voucher'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9F1A1A), Color(0xFFD84040)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Disbursement Voucher PDF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${entry.dvNumber} linked to ${entry.obrNumber}',
                  style: const TextStyle(
                    color: Color(0xFFFFE3E3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE7D7D7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    color: _officialText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Payee: ${entry.payeeName}'),
                Text('Amount: ${entry.amount.toStringAsFixed(2)}'),
                Text('AIP Line Item: ${entry.aipLineItemCode} - ${entry.aipLineItemTitle}'),
                Text('Requested By: ${entry.requestedBy}'),
                Text('Status: ${entry.status}'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () => _showFeature(
              context,
              'Disbursement voucher PDF prepared for ${entry.dvNumber}.',
            ),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFB31212)),
            icon: const Icon(Icons.download_outlined),
            label: const Text('Generate DV PDF'),
          ),
        ),
      ),
    );
  }
}

class _NoticeOfAwardPage extends StatelessWidget {
  final _FinanceProcurementRecord record;

  const _NoticeOfAwardPage({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice of Award'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9F1A1A), Color(0xFFD84040)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notice of Award',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Auto-generated for ${record.selectedSupplierName}',
                  style: const TextStyle(
                    color: Color(0xFFFFE3E3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE7D7D7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    color: _officialText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Procurement ID: ${record.id}'),
                Text('Winning Supplier: ${record.selectedSupplierName}'),
                Text('Approved Amount: ${record.amount.toStringAsFixed(2)}'),
                Text('Owner: ${record.owner}'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () => _showFeature(
              context,
              'Notice of Award generated for ${record.selectedSupplierName}.',
            ),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFB31212)),
            icon: const Icon(Icons.download_outlined),
            label: const Text('Generate Notice of Award'),
          ),
        ),
      ),
    );
  }
}

class _FinanceYearSnapshot {
  final String year;
  final double totalBudget;
  final int psaPopulation;
  final List<_FinanceBudgetAllocation> allocations;

  const _FinanceYearSnapshot({
    required this.year,
    required this.totalBudget,
    required this.psaPopulation,
    required this.allocations,
  });
}

class _FinanceBudgetAllocation {
  final String label;
  final double amount;
  final Color color;
  final String note;

  const _FinanceBudgetAllocation({
    required this.label,
    required this.amount,
    required this.color,
    required this.note,
  });
}

class _FinanceLedgerEntry {
  final String pbcNumber;
  final String dvNumber;
  final String obrNumber;
  final String financialYear;
  final String title;
  final String category;
  final String aipLineItemCode;
  final String aipLineItemTitle;
  final String payeeName;
  final double amount;
  final DateTime date;
  final String status;
  final String requestedBy;
  final String receiptLabel;
  final int approvalStageIndex;

  const _FinanceLedgerEntry({
    required this.pbcNumber,
    required this.dvNumber,
    required this.obrNumber,
    required this.financialYear,
    required this.title,
    required this.category,
    required this.aipLineItemCode,
    required this.aipLineItemTitle,
    required this.payeeName,
    required this.amount,
    required this.date,
    required this.status,
    required this.requestedBy,
    required this.receiptLabel,
    required this.approvalStageIndex,
  });

  _FinanceLedgerEntry copyWith({
    String? status,
    int? approvalStageIndex,
  }) {
    return _FinanceLedgerEntry(
      pbcNumber: pbcNumber,
      dvNumber: dvNumber,
      obrNumber: obrNumber,
      financialYear: financialYear,
      title: title,
      category: category,
      aipLineItemCode: aipLineItemCode,
      aipLineItemTitle: aipLineItemTitle,
      payeeName: payeeName,
      amount: amount,
      date: date,
      status: status ?? this.status,
      requestedBy: requestedBy,
      receiptLabel: receiptLabel,
      approvalStageIndex: approvalStageIndex ?? this.approvalStageIndex,
    );
  }
}

class _FinanceProcurementRecord {
  final String id;
  final String financialYear;
  final String title;
  final String supplierName;
  final String selectedSupplierName;
  final double amount;
  final int stageIndex;
  final DateTime updatedAt;
  final String owner;
  final List<_FinanceQuotationEntry> quotations;
  final List<_FinanceProjectMilestone> timelineSteps;

  const _FinanceProcurementRecord({
    required this.id,
    required this.financialYear,
    required this.title,
    required this.supplierName,
    required this.selectedSupplierName,
    required this.amount,
    required this.stageIndex,
    required this.updatedAt,
    required this.owner,
    required this.quotations,
    required this.timelineSteps,
  });

  _FinanceProcurementRecord copyWith({
    int? stageIndex,
    DateTime? updatedAt,
    String? selectedSupplierName,
    String? supplierName,
  }) {
    return _FinanceProcurementRecord(
      id: id,
      financialYear: financialYear,
      title: title,
      supplierName: supplierName ?? this.supplierName,
      selectedSupplierName: selectedSupplierName ?? this.selectedSupplierName,
      amount: amount,
      stageIndex: stageIndex ?? this.stageIndex,
      updatedAt: updatedAt ?? this.updatedAt,
      owner: owner,
      quotations: quotations,
      timelineSteps: timelineSteps,
    );
  }
}

class _FinanceSupplierEntry {
  final String name;
  final String category;
  final String contactPerson;
  final String mobile;
  final String tin;
  final String contactEmail;
  final bool active;

  const _FinanceSupplierEntry({
    required this.name,
    required this.category,
    required this.contactPerson,
    required this.mobile,
    required this.tin,
    required this.contactEmail,
    required this.active,
  });
}

class _FinanceTransparencyProject {
  final String financialYear;
  final String title;
  final String status;
  final double budget;
  final String timeline;
  final String beneficiaries;
  final String summary;
  final List<_FinanceProjectMilestone> milestones;

  const _FinanceTransparencyProject({
    required this.financialYear,
    required this.title,
    required this.status,
    required this.budget,
    required this.timeline,
    required this.beneficiaries,
    required this.summary,
    required this.milestones,
  });
}

class _FinanceAuditEntry {
  final String actor;
  final String action;
  final String detail;
  final DateTime timestamp;

  const _FinanceAuditEntry({
    required this.actor,
    required this.action,
    required this.detail,
    required this.timestamp,
  });
}

class _FinanceExpenseDraft {
  final String title;
  final String category;
  final String aipLineItemCode;
  final String aipLineItemTitle;
  final String payeeName;
  final double amount;
  final String requestedBy;
  final DateTime date;
  final String status;
  final String receiptLabel;

  const _FinanceExpenseDraft({
    required this.title,
    required this.category,
    required this.aipLineItemCode,
    required this.aipLineItemTitle,
    required this.payeeName,
    required this.amount,
    required this.requestedBy,
    required this.date,
    required this.status,
    required this.receiptLabel,
  });
}

class _FinanceSupplierDraft {
  final String name;
  final String category;
  final String contactPerson;
  final String mobile;
  final String tin;
  final String contactEmail;
  final bool active;

  const _FinanceSupplierDraft({
    required this.name,
    required this.category,
    required this.contactPerson,
    required this.mobile,
    required this.tin,
    required this.contactEmail,
    required this.active,
  });
}

class _FinanceAipLineItem {
  final String financialYear;
  final String code;
  final String title;
  final String category;
  final double amount;

  const _FinanceAipLineItem({
    required this.financialYear,
    required this.code,
    required this.title,
    required this.category,
    required this.amount,
  });
}

class _FinanceQuotationEntry {
  final String supplierName;
  final double amount;
  final String note;

  const _FinanceQuotationEntry({
    required this.supplierName,
    required this.amount,
    required this.note,
  });
}

class _FinanceProjectMilestone {
  final String label;
  final String detail;
  final bool completed;

  const _FinanceProjectMilestone({
    required this.label,
    required this.detail,
    required this.completed,
  });
}

class _FinanceRealignmentEntry {
  final String financialYear;
  final String fromCategory;
  final String toCategory;
  final double amount;
  final String note;
  final DateTime timestamp;

  const _FinanceRealignmentEntry({
    required this.financialYear,
    required this.fromCategory,
    required this.toCategory,
    required this.amount,
    required this.note,
    required this.timestamp,
  });
}

final ValueNotifier<String> _treasurerRemainingBalanceHome =
    ValueNotifier<String>('PHP 24.19M');

