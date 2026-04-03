part of barangaymo_app;

class GovAgenciesPage extends StatelessWidget {
  const GovAgenciesPage({super.key});
  @override
  Widget build(BuildContext context) {
    const agencies = [
      _AgencyInfo(
        code: 'PGO',
        name: 'Provincial Governor\'s Office - Zambales',
        subtitle: 'Executive directives, province-wide programs, and referrals',
        website: 'zambales.gov.ph/governor',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2001',
        color: Color(0xFFB80F0F),
        icon: Icons.account_balance,
      ),
      _AgencyInfo(
        code: 'SP',
        name: 'Sangguniang Panlalawigan',
        subtitle: 'Provincial ordinances, hearings, and committee schedules',
        website: 'zambales.gov.ph/sangguniang-panlalawigan',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2014',
        color: Color(0xFF8F1111),
        icon: Icons.gavel,
      ),
      _AgencyInfo(
        code: 'PHO',
        name: 'Provincial Health Office',
        subtitle:
            'Hospital referral desk, disease surveillance, and immunization',
        website: 'zambales.gov.ph/health',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2032',
        color: Color(0xFFCC2A2A),
        icon: Icons.local_hospital,
      ),
      _AgencyInfo(
        code: 'PDRRMO',
        name: 'Provincial DRRM Office',
        subtitle: 'Disaster preparedness, response coordination, and hotline',
        website: 'zambales.gov.ph/pdrrmo',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2045',
        color: Color(0xFFA51515),
        icon: Icons.warning_amber_rounded,
      ),
      _AgencyInfo(
        code: 'PSWDO',
        name: 'Provincial Social Welfare and Development Office',
        subtitle:
            'Medical aid endorsement, burial aid, and social case support',
        website: 'zambales.gov.ph/pswdo',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2058',
        color: Color(0xFFD23D3D),
        icon: Icons.volunteer_activism,
      ),
      _AgencyInfo(
        code: 'PESO',
        name: 'Provincial PESO',
        subtitle:
            'Local job matching, livelihood orientation, and hiring events',
        website: 'zambales.gov.ph/peso',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2073',
        color: Color(0xFF931010),
        icon: Icons.work_history,
      ),
      _AgencyInfo(
        code: 'PAGRI',
        name: 'Provincial Agriculture Office',
        subtitle:
            'Farm inputs, fisherfolk support, and agri-extension services',
        website: 'zambales.gov.ph/agriculture',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2096',
        color: Color(0xFFC71C1C),
        icon: Icons.agriculture,
      ),
      _AgencyInfo(
        code: 'PVET',
        name: 'Provincial Veterinary Office',
        subtitle: 'Livestock health, anti-rabies drives, and vet certification',
        website: 'zambales.gov.ph/veterinary',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2104',
        color: Color(0xFFAA1818),
        icon: Icons.pets,
      ),
      _AgencyInfo(
        code: 'PENG',
        name: 'Provincial Engineering Office',
        subtitle:
            'Road maintenance, drainage requests, and infrastructure works',
        website: 'zambales.gov.ph/engineering',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2118',
        color: Color(0xFFD44848),
        icon: Icons.engineering,
      ),
      _AgencyInfo(
        code: 'PIO',
        name: 'Provincial Information Office',
        subtitle: 'Official advisories, announcements, and media bulletins',
        website: 'zambales.gov.ph/pio',
        logoDomain: 'zambales.gov.ph',
        contact: '(047) 811-2130',
        color: Color(0xFF9E1313),
        icon: Icons.campaign,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provincial Government'),
        backgroundColor: const Color(0xFFCB1010),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8F8), Color(0xFFFFF0F0)],
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
                  colors: [Color(0xFFB90F0F), Color(0xFFD93636)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26A30E0E),
                    blurRadius: 12,
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
                          'Provincial Contact Directory',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Capitol offices, hotlines, and service pages for Zambales province.',
                          style: TextStyle(
                            color: Color(0xFFFFE7E7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0x30FFFFFF),
                    child: Icon(Icons.apartment, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: agencies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 320,
              ),
              itemBuilder: (_, i) => _agencyCard(context, agencies[i]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _agencyCard(BuildContext context, _AgencyInfo agency) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(agency.name),
          content: Text(
            '${agency.subtitle}\n\nContact: ${agency.contact}\nPage: ${agency.website}\nOpen in browser when online access is enabled.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF8F1111)),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _showFeature(context, 'Opening ${agency.website}');
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFCB1010),
                foregroundColor: Colors.white,
              ),
              child: const Text('Open Portal'),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF0D6D6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14B21A1A),
              blurRadius: 9,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AgencyLogoBadge(agency: agency),
            const SizedBox(height: 10),
            Text(
              agency.code,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: agency.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              agency.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3149),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              agency.subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF676D89),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: Color(0xFF78809B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    agency.contact,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF78809B),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.language, size: 14, color: Color(0xFF78809B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    agency.website,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF78809B),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AgencyInfo {
  final String code;
  final String name;
  final String subtitle;
  final String website;
  final String logoDomain;
  final String contact;
  final Color color;
  final IconData icon;

  const _AgencyInfo({
    required this.code,
    required this.name,
    required this.subtitle,
    required this.website,
    required this.logoDomain,
    required this.contact,
    required this.color,
    required this.icon,
  });
}

class _AgencyLogoBadge extends StatelessWidget {
  final _AgencyInfo agency;
  const _AgencyLogoBadge({required this.agency});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            agency.color.withValues(alpha: 0.18),
            agency.color.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: agency.color.withValues(alpha: 0.24)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          'https://logo.clearbit.com/${agency.logoDomain}',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: agency.color.withValues(alpha: 0.08),
            child: Center(
              child: Icon(agency.icon, color: agency.color, size: 24),
            ),
          ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return Container(
              color: agency.color.withValues(alpha: 0.08),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.3,
                    color: agency.color,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final _searchController = TextEditingController();
  int _doctorIndex = 0;

  static const _items = [
    _HealthServiceItem(
      id: 'medcert',
      title: 'Request MedCert',
      subtitle: 'Get a barangay medical certificate after physician review.',
      icon: Icons.assignment_rounded,
      bg: Color(0xFFFFECEA),
      accent: Color(0xFFD14F4F),
      eta: 'Release in 1-2 working days',
      keywords: 'medical certificate fit to work fit to travel',
    ),
    _HealthServiceItem(
      id: 'diagnostics',
      title: 'Diagnostics',
      subtitle: 'Book laboratory services and diagnostic referrals.',
      icon: Icons.biotech_rounded,
      bg: Color(0xFFEAF1FF),
      accent: Color(0xFF4263C5),
      eta: 'Referral confirmation within 24 hours',
      keywords: 'laboratory diagnostics x-ray urinalysis cbc',
    ),
    _HealthServiceItem(
      id: 'pharmacy',
      title: 'Pharmacy',
      subtitle: 'Check medicine availability and subsidy support.',
      icon: Icons.medication_rounded,
      bg: Color(0xFFE8F6EE),
      accent: Color(0xFF2D845D),
      eta: 'Stock response in 30-60 minutes',
      keywords: 'pharmacy medicine prescription maintenance drugs',
    ),
    _HealthServiceItem(
      id: 'consultation',
      title: 'Consultation',
      subtitle: 'Book a consultation with barangay physician or nurse.',
      icon: Icons.local_hospital_rounded,
      bg: Color(0xFFFFF0E9),
      accent: Color(0xFFB86A44),
      eta: 'Same-day to next-day slots',
      keywords: 'consultation doctor checkup teleconsult nurse',
    ),
  ];

  static const _physicians = [
    _BarangayPhysician(
      name: 'Dr. Lea Santos, MD',
      specialty: 'Family Medicine',
      dutySchedule: 'Mon, Wed, Fri - 9:00 AM - 2:00 PM',
      licenseNo: 'PRC 0765412',
      clinicRoom: 'BHS Room 2',
      onDuty: true,
    ),
    _BarangayPhysician(
      name: 'Dr. Carlo Dizon, MD',
      specialty: 'General Practice',
      dutySchedule: 'Tue, Thu, Sat - 1:00 PM - 6:00 PM',
      licenseNo: 'PRC 0803194',
      clinicRoom: 'BHS Room 1',
      onDuty: true,
    ),
  ];

  static const _hotlines = [
    ('Barangay Health Station', '(047) 251-2041'),
    ('City Health Office', '(047) 222-1144'),
    ('Local Ambulance', '0917-888-1122'),
    ('DOH Hotline', '1555'),
  ];

  static const _careSchedules = [
    ('Dr. Lea Santos, MD', 'Doctor', 'Mon, Wed, Fri • 9:00 AM - 2:00 PM'),
    ('Dr. Carlo Dizon, MD', 'Doctor', 'Tue, Thu, Sat • 1:00 PM - 6:00 PM'),
    ('Midwife Anna Ramos', 'Midwife', 'Mon to Fri • 8:00 AM - 4:00 PM'),
    ('Midwife Mae Lim', 'Midwife', 'Tue, Thu • 7:00 AM - 12:00 PM'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_HealthServiceItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _items;
    }
    return _items
        .where(
          (item) =>
              item.title.toLowerCase().contains(query) ||
              item.subtitle.toLowerCase().contains(query) ||
              item.keywords.contains(query),
        )
        .toList();
  }

  _BarangayPhysician get _selectedDoctor => _physicians[_doctorIndex];

  bool _needsDoctor(_HealthServiceItem item) =>
      item.id == 'consultation' ||
      item.id == 'diagnostics' ||
      item.id == 'medcert';

  void _openCheckupScheduler(
    BuildContext context,
    _BarangayPhysician physician,
  ) {
    final residentController = TextEditingController();
    final mobileController = TextEditingController();
    final concernController = TextEditingController();
    String day = 'Monday';
    String slot = '9:00 AM - 10:00 AM';

    showModalBottomSheet<void>(
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
                    colors: [Color(0xFFFFF7F6), Color(0xFFF8F5FF)],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFD84B4B), Color(0xFFEF7272)],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Schedule Barangay Check-Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${physician.name} - ${physician.specialty}',
                              style: const TextStyle(
                                color: Color(0xFFFFE8E8),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: residentController,
                        decoration: const InputDecoration(
                          labelText: 'Resident Full Name',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: day,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Day',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Monday',
                            child: Text('Monday'),
                          ),
                          DropdownMenuItem(
                            value: 'Tuesday',
                            child: Text('Tuesday'),
                          ),
                          DropdownMenuItem(
                            value: 'Wednesday',
                            child: Text('Wednesday'),
                          ),
                          DropdownMenuItem(
                            value: 'Thursday',
                            child: Text('Thursday'),
                          ),
                          DropdownMenuItem(
                            value: 'Friday',
                            child: Text('Friday'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setModal(() => day = value);
                        },
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: slot,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Time Slot',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: '9:00 AM - 10:00 AM',
                            child: Text('9:00 AM - 10:00 AM'),
                          ),
                          DropdownMenuItem(
                            value: '10:30 AM - 11:30 AM',
                            child: Text('10:30 AM - 11:30 AM'),
                          ),
                          DropdownMenuItem(
                            value: '1:00 PM - 2:00 PM',
                            child: Text('1:00 PM - 2:00 PM'),
                          ),
                          DropdownMenuItem(
                            value: '2:30 PM - 3:30 PM',
                            child: Text('2:30 PM - 3:30 PM'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setModal(() => slot = value);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: concernController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Symptoms / Reason for check-up',
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            final name = residentController.text.trim();
                            final mobile = mobileController.text.trim();
                            final concern = concernController.text.trim();
                            if (name.isEmpty ||
                                mobile.isEmpty ||
                                concern.length < 8) {
                              _showFeature(
                                context,
                                'Please complete resident info and concern details.',
                              );
                              return;
                            }
                            Navigator.pop(context);
                            final ref =
                                'CHK-${DateTime.now().millisecondsSinceEpoch % 1000000}';
                            _showFeature(
                              this.context,
                              'Check-up scheduled with ${physician.name} on $day ($slot). Ref: $ref',
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFC74C4C),
                          ),
                          icon: const Icon(Icons.event_available_rounded),
                          label: const Text('Confirm Check-Up Schedule'),
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
    ).whenComplete(() {
      residentController.dispose();
      mobileController.dispose();
      concernController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health'),
        backgroundColor: const Color(0xFFCC1010),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFF7F7F9),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          children: [
            const Text(
              'Welcome to eBarangayMo Health',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color(0xFF272B39),
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Makaisa para sa malusog at masiglang komunidad.',
              style: TextStyle(
                color: Color(0xFF6B7088),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search for health services...',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2A9A9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFCC1010),
                    width: 1.4,
                  ),
                ),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8EAF1)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Talk to a doctor now!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD22D2D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Consult with our licensed barangay physician for urgent but non-emergency concerns.',
                    style: TextStyle(
                      color: Color(0xFF5E647C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color(0xFFE8F7EE),
                          border: Border.all(color: const Color(0xFFBFE6CD)),
                        ),
                        child: const Icon(
                          Icons.verified_user,
                          color: Color(0xFF32A66D),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedDoctor.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2E3248),
                              ),
                            ),
                            Text(
                              _selectedDoctor.specialty,
                              style: const TextStyle(
                                color: Color(0xFF6B7088),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedDoctor.dutySchedule,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6F748C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 74,
                        height: 92,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFF6F7FB), Color(0xFFEBEEF9)],
                          ),
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 8,
                              right: 10,
                              child: Icon(
                                Icons.favorite_rounded,
                                color: Color(0xFFD73B3B),
                                size: 16,
                              ),
                            ),
                            Icon(
                              Icons.medical_services_rounded,
                              color: Color(0xFF4B6DC8),
                              size: 36,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(_physicians.length, (index) {
                      final active = _doctorIndex == index;
                      return ChoiceChip(
                        label: Text(active ? 'On Duty' : 'Doctor ${index + 1}'),
                        selected: active,
                        onSelected: (_) => setState(() => _doctorIndex = index),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () =>
                              _openCheckupScheduler(context, _selectedDoctor),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFCC1010),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.call),
                          label: const Text('Consult Now'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: _selectedDoctor.onDuty
                              ? const Color(0xFFE1F7EA)
                              : const Color(0xFFF1F1F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        child: Text(
                          _selectedDoctor.onDuty
                              ? 'Doctor Available'
                              : 'Fully Booked',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _selectedDoctor.onDuty
                                ? const Color(0xFF26794A)
                                : const Color(0xFF656A83),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_selectedDoctor.licenseNo} - ${_selectedDoctor.clinicRoom}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6F748C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE7E7F2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Center Schedule',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F3248),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._careSchedules.map(
                    (entry) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E8F4)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: entry.$2 == 'Doctor'
                                ? const Color(0xFFFFECEA)
                                : const Color(0xFFEAF1FF),
                            child: Icon(
                              entry.$2 == 'Doctor'
                                  ? Icons.local_hospital_rounded
                                  : Icons.pregnant_woman_rounded,
                              color: entry.$2 == 'Doctor'
                                  ? const Color(0xFFD14F4F)
                                  : const Color(0xFF4263C5),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.$1,
                                  style: const TextStyle(
                                    color: Color(0xFF2F3248),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '${entry.$2} • ${entry.$3}',
                                  style: const TextStyle(
                                    color: Color(0xFF676C86),
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
            ),
            const SizedBox(height: 10),
            if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E8F4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_off, color: Color(0xFF7A809B)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No matching health service found.',
                        style: TextStyle(
                          color: Color(0xFF646B86),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...filtered.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE7E8EF)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0E000000),
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
                        borderRadius: BorderRadius.circular(12),
                        color: item.bg,
                      ),
                      child: Icon(item.icon, color: item.accent),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F3248),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            color: Color(0xFF686C86),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.eta,
                          style: TextStyle(
                            color: item.accent.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        if (_needsDoctor(item)) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECE8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Physician-assisted service',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: item.accent,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _HealthServiceDetailPage(
                          item: item,
                          preferredDoctor: _needsDoctor(item)
                              ? _selectedDoctor.name
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE7E7F2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_phone, color: Color(0xFF7B4A3F)),
                      SizedBox(width: 7),
                      Text(
                        'Emergency Health Hotlines',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2F3248),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(
                        child: _EmergencyQuickDialButton(
                          label: 'BHS',
                          number: '(047) 251-2041',
                          icon: Icons.local_hospital_rounded,
                          color: Color(0xFFD14F4F),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _EmergencyQuickDialButton(
                          label: 'Ambulance',
                          number: '0917-888-1122',
                          icon: Icons.emergency_rounded,
                          color: Color(0xFFB86A44),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _EmergencyQuickDialButton(
                          label: 'DOH',
                          number: '1555',
                          icon: Icons.call_outlined,
                          color: Color(0xFF4263C5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._hotlines.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Color(0xFF3FA96D),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              '${line.$1}  ${line.$2}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF5D627C),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Call',
                            onPressed: () =>
                                _showFeature(context, 'Calling ${line.$2}...'),
                            icon: const Icon(
                              Icons.phone,
                              color: Color(0xFF4960BE),
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
      ),
    );
  }
}

class _HealthServiceItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;
  final Color accent;
  final String eta;
  final String keywords;

  const _HealthServiceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bg,
    required this.accent,
    required this.eta,
    required this.keywords,
  });
}

class _BarangayPhysician {
  final String name;
  final String specialty;
  final String dutySchedule;
  final String licenseNo;
  final String clinicRoom;
  final bool onDuty;

  const _BarangayPhysician({
    required this.name,
    required this.specialty,
    required this.dutySchedule,
    required this.licenseNo,
    required this.clinicRoom,
    this.onDuty = false,
  });
}

class _EmergencyHeroStat extends StatelessWidget {
  final String label;
  final String value;

  const _EmergencyHeroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFECEFFF),
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyQuickDialButton extends StatelessWidget {
  final String label;
  final String number;
  final IconData icon;
  final Color color;

  const _EmergencyQuickDialButton({
    required this.label,
    required this.number,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showFeature(context, 'Dialing $label ($number)'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.22)),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF2F3248),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            Text(
              number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6C728B),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyStatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _EmergencyStatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _EmergencyIncidentDetailSheet extends StatelessWidget {
  final _EmergencyIncident incident;

  const _EmergencyIncidentDetailSheet({required this.incident});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    incident.reference,
                    style: const TextStyle(
                      color: Color(0xFF2F3248),
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
                _EmergencyStatusPill(
                  label: incident.status,
                  color: _emergencyStatusColor(incident.status),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${incident.type} • ${incident.priority}',
              style: TextStyle(
                color: _incidentTypeColor(incident.type),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              incident.location,
              style: const TextStyle(
                color: Color(0xFF464B66),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              incident.details,
              style: const TextStyle(
                color: Color(0xFF666D86),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Victim: ${_maskedVictimName(incident.victimName)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              'Reporter: ${incident.reporterName} • ${incident.reporterMobile}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (incident.personInvolved != null && incident.personInvolved!.isNotEmpty)
              Text(
                'Person involved: ${incident.personInvolved}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            if (incident.attachmentLabel != null)
              Text(
                'Attachment: ${incident.attachmentLabel}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            const SizedBox(height: 8),
            Text(
              _formatEmergencyDateTime(incident.createdAt),
              style: const TextStyle(
                color: Color(0xFF7A8098),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstAidLibraryPage extends StatelessWidget {
  const FirstAidLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Aid Library'),
        backgroundColor: const Color(0xFFD70000),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD70000), Color(0xFF8E1515)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline emergency guides',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Browse PDF-style sheets and image guides for burns, CPR, disaster prep, and trauma response.',
                  style: TextStyle(
                    color: Color(0xFFFFE9E9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._firstAidGuides.map(
            (guide) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5E7F3)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: guide.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(guide.icon, color: guide.accent),
                ),
                title: Text(
                  guide.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  '${guide.category} • ${guide.format}\n${guide.summary}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _FirstAidGuideDetailPage(guide: guide),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FirstAidGuideDetailPage extends StatelessWidget {
  final _FirstAidGuide guide;

  const _FirstAidGuideDetailPage({required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(guide.title)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: guide.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: guide.accent.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide.format,
                  style: TextStyle(
                    color: guide.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  guide.summary,
                  style: const TextStyle(
                    color: Color(0xFF2F3248),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...guide.steps.map(
            (step) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7F3)),
              ),
              child: ListTile(
                leading: Icon(Icons.check_circle_outline, color: guide.accent),
                title: Text(
                  step,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyResponderDashboardPage extends StatelessWidget {
  const EmergencyResponderDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responder Dashboard'),
        backgroundColor: const Color(0xFFD70000),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<List<_EmergencyIncident>>(
        valueListenable: _emergencyOpsStore.incidents,
        builder: (_, incidents, __) {
          return ValueListenableBuilder<_EmergencySharedLocation?>(
            valueListenable: _emergencyOpsStore.sharedLocation,
            builder: (_, sharedLocation, __) {
              final activeIncidents = incidents
                  .where((incident) => incident.status != 'Resolved')
                  .toList();
              final patrols = _emergencyOpsStore.patrolRequests.value;
              final tanods = _emergencyOpsStore.tanods.value;
              final markers = <Marker>[
                for (final incident in activeIncidents)
                  Marker(
                    point: incident.point,
                    width: 42,
                    height: 42,
                    child: Icon(
                      incident.type == 'Fire'
                          ? Icons.local_fire_department_rounded
                          : incident.type == 'Medical'
                              ? Icons.health_and_safety_rounded
                              : Icons.report_gmailerrorred_rounded,
                      color: _incidentTypeColor(incident.type),
                    ),
                  ),
                if (sharedLocation != null)
                  Marker(
                    point: sharedLocation.point,
                    width: 44,
                    height: 44,
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: Color(0xFF2E35D3),
                    ),
                  ),
              ];
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  SizedBox(
                    height: 240,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter:
                              sharedLocation?.point ?? _defaultEmergencyPoint(),
                          initialZoom: 14.7,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.barangaymo_app',
                          ),
                          MarkerLayer(markers: markers),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (sharedLocation != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE5E7F3)),
                      ),
                      child: Text(
                        'Latest shared location: ${sharedLocation.address}\nUpdated ${_formatEmergencyDateTime(sharedLocation.updatedAt)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  const SizedBox(height: 12),
                  ...activeIncidents.map(
                    (incident) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE5E7F3)),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _incidentTypeColor(incident.type)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: _incidentTypeColor(incident.type),
                          ),
                        ),
                        title: Text(
                          '${incident.type} • ${incident.location}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          '${_maskedVictimName(incident.victimName)} • ${incident.reference}\n${incident.details}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: _EmergencyStatusPill(
                          label: incident.status,
                          color: _emergencyStatusColor(incident.status),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _sectionTitle('Patrol Queue'),
                  const SizedBox(height: 8),
                  ...patrols.take(2).map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7F3)),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.directions_walk_rounded,
                          color: Color(0xFF8E4E45),
                        ),
                        title: Text(
                          item.location,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          '${item.reason}\n${_formatEmergencyDateTime(item.scheduledAt)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _sectionTitle('Tanod Status'),
                  const SizedBox(height: 8),
                  ...tanods.take(3).map(
                    (tanod) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7F3)),
                      ),
                      child: ListTile(
                        leading: Icon(
                          tanod.online
                              ? Icons.check_circle_rounded
                              : Icons.remove_circle_rounded,
                          color: tanod.online
                              ? const Color(0xFF2D8A57)
                              : const Color(0xFF9A2E2E),
                        ),
                        title: Text(
                          tanod.name,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          '${tanod.zone} • ${tanod.assignment}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: _EmergencyStatusPill(
                          label: tanod.online ? 'Online' : 'Offline',
                          color: tanod.online
                              ? const Color(0xFF2D8A57)
                              : const Color(0xFF9A2E2E),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class EmergencyContactActionPage extends StatelessWidget {
  final String contactName;
  final String phoneNumber;
  final String description;
  const EmergencyContactActionPage({
    super.key,
    required this.contactName,
    required this.phoneNumber,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final name = contactName.toLowerCase();
    final accent = name.contains('ambulance')
        ? const Color(0xFF3846CE)
        : name.contains('fire')
        ? const Color(0xFFD34E3E)
        : name.contains('police')
        ? const Color(0xFF2A7A56)
        : const Color(0xFF8D5A49);
    final icon = name.contains('ambulance')
        ? Icons.health_and_safety_rounded
        : name.contains('fire')
        ? Icons.local_fire_department_rounded
        : name.contains('police')
        ? Icons.local_police_rounded
        : Icons.shield_rounded;

    return Scaffold(
      appBar: AppBar(
        title: Text(contactName),
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
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE4E7F3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(icon, color: accent),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contactName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Color(0xFF2F3248),
                              ),
                            ),
                            Text(
                              phoneNumber,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF5E637E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF646A84),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () =>
                  _showFeature(context, 'Dialing $contactName ($phoneNumber)'),
              style: FilledButton.styleFrom(backgroundColor: accent),
              icon: const Icon(Icons.call_rounded),
              label: const Text('Call Now'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _showFeature(
                context,
                'Sending location and incident details to $contactName',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF8E4E45),
                side: const BorderSide(color: Color(0xFFB49087)),
              ),
              icon: const Icon(Icons.share_location_outlined),
              label: const Text('Share Location First'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyLocationSharePage extends StatefulWidget {
  const EmergencyLocationSharePage({super.key});

  @override
  State<EmergencyLocationSharePage> createState() =>
      _EmergencyLocationSharePageState();
}

class _EmergencyLocationSharePageState
    extends State<EmergencyLocationSharePage> {
  bool _includeLandmark = true;
  bool _highAccuracy = true;
  late final TextEditingController _addressController;
  LatLng _currentPoint = _defaultEmergencyPoint();

  @override
  void initState() {
    super.initState();
    final shared = _emergencyOpsStore.sharedLocation.value;
    _currentPoint = shared?.point ?? _defaultEmergencyPoint();
    _addressController = TextEditingController(
      text: shared?.address ??
          _currentResidentProfile?.locationSummary ??
          'West Tapinac, Olongapo City',
    );
    _includeLandmark = shared?.includeLandmark ?? true;
    _highAccuracy = shared?.highAccuracy ?? true;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _refreshMockLocation() {
    setState(() {
      _currentPoint = LatLng(
        double.parse((_currentPoint.latitude + 0.0002).toStringAsFixed(6)),
        double.parse((_currentPoint.longitude - 0.0002).toStringAsFixed(6)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Live Location'),
        backgroundColor: const Color(0xFFD70000),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E7F3)),
            ),
            child: const Text(
              'Send your live location to barangay responders for faster dispatch.',
              style: TextStyle(
                color: Color(0xFF505674),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _currentPoint,
                  initialZoom: 15.4,
                  onTap: (_, point) => setState(() => _currentPoint = point),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.barangaymo_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPoint,
                        width: 48,
                        height: 48,
                        child: const Icon(
                          Icons.my_location_rounded,
                          color: Color(0xFF2E35D3),
                          size: 38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _refreshMockLocation,
            icon: const Icon(Icons.gps_fixed_outlined),
            label: const Text('Refresh Current Pin'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Location Address / Landmark',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            value: _highAccuracy,
            onChanged: (v) => setState(() => _highAccuracy = v),
            title: const Text('Use high accuracy GPS'),
            subtitle: const Text('Improves location precision in dense areas'),
          ),
          SwitchListTile(
            value: _includeLandmark,
            onChanged: (v) => setState(() => _includeLandmark = v),
            title: const Text('Include nearby landmark'),
            subtitle: const Text('Adds a recognizable reference point'),
          ),
          const SizedBox(height: 6),
          FilledButton.icon(
            onPressed: () {
              _emergencyOpsStore.shareLocation(
                point: _currentPoint,
                address: _addressController.text.trim().isEmpty
                    ? 'Pinned location'
                    : _addressController.text.trim(),
                highAccuracy: _highAccuracy,
                includeLandmark: _includeLandmark,
              );
              _showFeature(context, 'Location shared to responders. Ref: LOC-26-001');
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E35D3),
            ),
            icon: const Icon(Icons.send),
            label: const Text('Share Location'),
          ),
        ],
      ),
    );
  }
}

class EmergencyMessagePage extends StatefulWidget {
  const EmergencyMessagePage({super.key});

  @override
  State<EmergencyMessagePage> createState() => _EmergencyMessagePageState();
}

class _EmergencyMessagePageState extends State<EmergencyMessagePage> {
  final _locationController = TextEditingController(
    text: _currentResidentProfile?.locationSummary ?? 'West Tapinac, Olongapo City',
  );
  final _detailsController = TextEditingController();
  String _priority = 'Urgent';

  @override
  void dispose() {
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Chat'),
        backgroundColor: const Color(0xFFD70000),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFFFF3F3),
            child: Column(
              children: [
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Incident Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
                    DropdownMenuItem(value: 'High', child: Text('High')),
                    DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                  ],
                  onChanged: (value) =>
                      setState(() => _priority = value ?? _priority),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<_EmergencyChatMessage>>(
              valueListenable: _emergencyOpsStore.chatMessages,
              builder: (_, messages, __) {
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final message = messages[index];
                    final bubbleColor = message.outbound
                        ? const Color(0xFFD70000)
                        : Colors.white;
                    final textColor = message.outbound
                        ? Colors.white
                        : const Color(0xFF2F3248);
                    return Align(
                      alignment: message.outbound
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: message.outbound
                                ? const Color(0xFFD70000)
                                : const Color(0xFFE4E7F3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.sender,
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (message.kind == 'photo')
                              Container(
                                height: 96,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.photo_camera_outlined,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                            if (message.kind == 'voice')
                              Row(
                                children: [
                                  Icon(
                                    Icons.mic_rounded,
                                    color: textColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Voice clip - ${message.voiceDurationSeconds ?? 0}s',
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            if (message.kind != 'voice') ...[
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (message.attachmentLabel != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    message.attachmentLabel!,
                                    style: TextStyle(
                                      color: textColor.withValues(alpha: 0.85),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: [
                  TextField(
                    controller: _detailsController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Incident Details',
                      hintText: 'Describe what happened and who needs help.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () async {
                          final image = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                          );
                          if (image == null) {
                            return;
                          }
                          _emergencyOpsStore.addChatMessage(
                            _EmergencyChatMessage(
                              sender: 'Resident',
                              kind: 'photo',
                              text: 'Photo evidence attached.',
                              outbound: true,
                              createdAt: DateTime.now(),
                              attachmentLabel: image.name,
                            ),
                          );
                        },
                        icon: const Icon(Icons.camera_alt_outlined),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: () {
                          _emergencyOpsStore.addChatMessage(
                            _EmergencyChatMessage(
                              sender: 'Resident',
                              kind: 'voice',
                              text: 'Voice clip attached.',
                              outbound: true,
                              createdAt: DateTime.now(),
                              voiceDurationSeconds: 12 + math.Random().nextInt(18),
                            ),
                          );
                        },
                        icon: const Icon(Icons.mic_none_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            if (_locationController.text.trim().isEmpty ||
                                _detailsController.text.trim().isEmpty) {
                              _showFeature(context, 'Please provide location and details.');
                              return;
                            }
                            _emergencyOpsStore.addChatMessage(
                              _EmergencyChatMessage(
                                sender: 'Resident',
                                kind: 'text',
                                text:
                                    '[${_priority.toUpperCase()}] ${_detailsController.text.trim()}',
                                outbound: true,
                                createdAt: DateTime.now(),
                                attachmentLabel: _locationController.text.trim(),
                              ),
                            );
                            _detailsController.clear();
                            _showFeature(
                              context,
                              'Emergency message sent. Ref: MSG-26-014 ($_priority)',
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2E35D3),
                          ),
                          icon: const Icon(Icons.send),
                          label: const Text('Send'),
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
}

class AssistanceRequestPage extends StatefulWidget {
  final String assistanceType;
  final String assistanceDescription;
  final IconData assistanceIcon;
  final Color accentColor;

  const AssistanceRequestPage({
    super.key,
    required this.assistanceType,
    required this.assistanceDescription,
    required this.assistanceIcon,
    required this.accentColor,
  });

  @override
  State<AssistanceRequestPage> createState() => _AssistanceRequestPageState();
}

class _AssistanceAttachmentValue {
  final Uint8List bytes;
  final String fileName;

  const _AssistanceAttachmentValue({
    required this.bytes,
    required this.fileName,
  });
}

class _AidProgramTrackerEntry {
  final String type;
  final String residentName;
  final String status;
  final String detail;
  final DateTime createdAt;

  const _AidProgramTrackerEntry({
    required this.type,
    required this.residentName,
    required this.status,
    required this.detail,
    required this.createdAt,
  });
}

class _AssistanceRequestPageState extends State<AssistanceRequestPage> {
  static final ValueNotifier<List<_AidProgramTrackerEntry>> _tracker =
      ValueNotifier<List<_AidProgramTrackerEntry>>([
        _AidProgramTrackerEntry(
          type: 'Educational Assistance',
          residentName: 'Loida Hussey',
          status: 'Scholar',
          detail: 'Grade slip submitted for 2nd semester monitoring.',
          createdAt: DateTime(2026, 3, 10),
        ),
        _AidProgramTrackerEntry(
          type: 'Medical Assistance',
          residentName: 'Angelo Elane',
          status: 'For GL Release',
          detail: 'Hospital bill endorsed for guaranty letter release.',
          createdAt: DateTime(2026, 3, 12),
        ),
      ]);

  final _fullNameController = TextEditingController(text: 'Shamira Balandra');
  final _mobileController = TextEditingController(text: '09073170635');
  final _notesController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _billAmountController = TextEditingController();
  final _deceasedNameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _gradeLevelController = TextEditingController();
  final _gwaController = TextEditingController();
  String _urgency = 'Regular';
  _AssistanceAttachmentValue? _hospitalBillAttachment;
  _AssistanceAttachmentValue? _prescriptionAttachment;
  _AssistanceAttachmentValue? _deathCertificateAttachment;
  _AssistanceAttachmentValue? _gradeAttachment;
  bool _submitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _notesController.dispose();
    _hospitalController.dispose();
    _billAmountController.dispose();
    _deceasedNameController.dispose();
    _schoolController.dispose();
    _gradeLevelController.dispose();
    _gwaController.dispose();
    super.dispose();
  }

  bool get _isMedical => widget.assistanceType == 'Medical Assistance';

  bool get _isBurial => widget.assistanceType == 'Burial Assistance';

  bool get _isEducation => widget.assistanceType == 'Educational Assistance';

  Future<void> _pickAttachment(
    ValueChanged<_AssistanceAttachmentValue> onPicked,
  ) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 72,
    );
    if (image == null) {
      return;
    }
    final bytes = await image.readAsBytes();
    onPicked(
      _AssistanceAttachmentValue(bytes: bytes, fileName: image.name),
    );
  }

  Future<void> _submit() async {
    if (_submitting) {
      return;
    }
    if (_fullNameController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty) {
      _showFeature(context, 'Please complete full name and mobile.');
      return;
    }
    if (_isMedical &&
        (_hospitalController.text.trim().isEmpty ||
            _hospitalBillAttachment == null ||
            _prescriptionAttachment == null)) {
      _showFeature(
        context,
        'Medical assistance requires hospital name, bill, and prescription.',
      );
      return;
    }
    if (_isBurial &&
        (_deceasedNameController.text.trim().isEmpty ||
            _deathCertificateAttachment == null)) {
      _showFeature(
        context,
        'Burial assistance requires deceased name and death certificate.',
      );
      return;
    }
    if (_isEducation &&
        (_schoolController.text.trim().isEmpty ||
            _gradeLevelController.text.trim().isEmpty)) {
      _showFeature(
        context,
        'Education aid requires school and grade level details.',
      );
      return;
    }

    final parentContext = context;
    final detail = _isMedical
        ? 'Hospital: ${_hospitalController.text.trim()}'
        : _isBurial
        ? 'Deceased: ${_deceasedNameController.text.trim()}'
        : _isEducation
        ? 'School: ${_schoolController.text.trim()}'
        : _notesController.text.trim();
    final notes = <String>[
      'Urgency: $_urgency',
      'Resident: ${_fullNameController.text.trim()}',
      'Mobile: ${_mobileController.text.trim()}',
      if (_notesController.text.trim().isNotEmpty)
        'Notes: ${_notesController.text.trim()}',
      if (_isMedical && _billAmountController.text.trim().isNotEmpty)
        'Estimated Bill: ${_billAmountController.text.trim()}',
      if (_isEducation && _gradeLevelController.text.trim().isNotEmpty)
        'Grade/Course: ${_gradeLevelController.text.trim()}',
      if (_isEducation && _gwaController.text.trim().isNotEmpty)
        'Current Grade/GWA: ${_gwaController.text.trim()}',
      if (_hospitalBillAttachment != null)
        'Hospital Bill Attachment: ${_hospitalBillAttachment!.fileName}',
      if (_prescriptionAttachment != null)
        'Prescription Attachment: ${_prescriptionAttachment!.fileName}',
      if (_deathCertificateAttachment != null)
        'Death Certificate Attachment: ${_deathCertificateAttachment!.fileName}',
      if (_gradeAttachment != null)
        'Grade Attachment: ${_gradeAttachment!.fileName}',
    ].join('\n');

    final attachments = <_ServiceRequestAttachmentPayload>[
      if (_hospitalBillAttachment != null)
        _ServiceRequestAttachmentPayload(
          fileName: _hospitalBillAttachment!.fileName,
          imageBase64: base64Encode(_hospitalBillAttachment!.bytes),
        ),
      if (_prescriptionAttachment != null)
        _ServiceRequestAttachmentPayload(
          fileName: _prescriptionAttachment!.fileName,
          imageBase64: base64Encode(_prescriptionAttachment!.bytes),
        ),
      if (_deathCertificateAttachment != null)
        _ServiceRequestAttachmentPayload(
          fileName: _deathCertificateAttachment!.fileName,
          imageBase64: base64Encode(_deathCertificateAttachment!.bytes),
        ),
      if (_gradeAttachment != null)
        _ServiceRequestAttachmentPayload(
          fileName: _gradeAttachment!.fileName,
          imageBase64: base64Encode(_gradeAttachment!.bytes),
        ),
    ];

    setState(() => _submitting = true);
    final result = await _ServiceRequestApi.instance.submitRequest(
      serviceCategory: 'Assistance',
      serviceTitle: widget.assistanceType,
      purpose: detail.isEmpty ? widget.assistanceDescription : detail,
      details: notes,
      attachments: attachments,
    );
    if (!mounted) {
      return;
    }

    _tracker.value = [
      _AidProgramTrackerEntry(
        type: widget.assistanceType,
        residentName: _fullNameController.text.trim(),
        status: _isEducation
            ? 'Scholar Monitoring'
            : _isMedical
            ? 'For Assessment'
            : 'Submitted',
        detail: detail,
        createdAt: DateTime.now(),
      ),
      ..._tracker.value,
    ];
    setState(() => _submitting = false);
    if (result.success) {
      final ref = result.entry?.requestId.trim() ?? '';
      _showFeature(
        parentContext,
        ref.isEmpty
            ? result.message
            : '${result.message} Ref: $ref',
        tone: _ToastTone.success,
      );
      return;
    }
    _showFeature(
      parentContext,
      'Saved locally: ${result.message}',
      tone: _ToastTone.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assistanceType),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E7F3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.assistanceIcon,
                    color: const Color(0xFF4A4F6A),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.assistanceDescription,
                    style: const TextStyle(
                      color: Color(0xFF5C6280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _urgency,
            decoration: const InputDecoration(
              labelText: 'Urgency',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Regular', child: Text('Regular')),
              DropdownMenuItem(value: 'Priority', child: Text('Priority')),
              DropdownMenuItem(value: 'Immediate', child: Text('Immediate')),
            ],
            onChanged: (value) => setState(() => _urgency = value ?? _urgency),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _notesController,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Details / Supporting Notes',
              border: OutlineInputBorder(),
            ),
          ),
          if (_isMedical) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _hospitalController,
              decoration: const InputDecoration(
                labelText: 'Hospital / Clinic Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _billAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
              ],
              decoration: const InputDecoration(
                labelText: 'Estimated Bill Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _AssistanceAttachmentCard(
              title: 'Hospital Bill',
              fileName: _hospitalBillAttachment?.fileName,
              onPick: () async {
                await _pickAttachment(
                  (value) => setState(() => _hospitalBillAttachment = value),
                );
              },
            ),
            const SizedBox(height: 10),
            _AssistanceAttachmentCard(
              title: 'Prescription / Medical Abstract',
              fileName: _prescriptionAttachment?.fileName,
              onPick: () async {
                await _pickAttachment(
                  (value) => setState(() => _prescriptionAttachment = value),
                );
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _GuarantyLetterPreviewPage(
                      residentName: _fullNameController.text.trim().isEmpty
                          ? 'Resident'
                          : _fullNameController.text.trim(),
                      hospitalName: _hospitalController.text.trim().isEmpty
                          ? 'Barangay-accredited hospital'
                          : _hospitalController.text.trim(),
                      billAmount: _billAmountController.text.trim().isEmpty
                          ? 'To be assessed'
                          : _billAmountController.text.trim(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.description_outlined),
              label: const Text('Preview Guaranty Letter'),
            ),
          ],
          if (_isBurial) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _deceasedNameController,
              decoration: const InputDecoration(
                labelText: 'Deceased Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _AssistanceAttachmentCard(
              title: 'Death Certificate',
              fileName: _deathCertificateAttachment?.fileName,
              onPick: () async {
                await _pickAttachment(
                  (value) => setState(() => _deathCertificateAttachment = value),
                );
              },
            ),
          ],
          if (_isEducation) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _schoolController,
              decoration: const InputDecoration(
                labelText: 'School / University',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _gradeLevelController,
              decoration: const InputDecoration(
                labelText: 'Grade Level / Course',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _gwaController,
              decoration: const InputDecoration(
                labelText: 'Current Grade / GWA',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _AssistanceAttachmentCard(
              title: 'Report Card / Grade Slip',
              fileName: _gradeAttachment?.fileName,
              onPick: () async {
                await _pickAttachment(
                  (value) => setState(() => _gradeAttachment = value),
                );
              },
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<List<_AidProgramTrackerEntry>>(
              valueListenable: _tracker,
              builder: (context, entries, _) {
                final scholarEntries = entries
                    .where((entry) => entry.type == 'Educational Assistance')
                    .toList();
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4E7F3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Scholar Tracker',
                        style: TextStyle(
                          color: Color(0xFF2F3248),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (scholarEntries.isEmpty)
                        const Text(
                          'No scholarship monitoring entries yet.',
                          style: TextStyle(
                            color: Color(0xFF676C86),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        ...scholarEntries.take(3).map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              '${entry.residentName} - ${entry.status}\n${entry.detail}',
                              style: const TextStyle(
                                color: Color(0xFF5C6280),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _submitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E35D3),
            ),
            icon: const Icon(Icons.send),
            label: Text(_submitting ? 'Submitting...' : 'Submit Request'),
          ),
        ],
      ),
    );
  }
}

class _AssistanceAttachmentCard extends StatelessWidget {
  final String title;
  final String? fileName;
  final VoidCallback onPick;

  const _AssistanceAttachmentCard({
    required this.title,
    required this.fileName,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7F3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file_rounded, color: Color(0xFF4A55B8)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2F3248),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  fileName ?? 'No file attached yet',
                  style: const TextStyle(
                    color: Color(0xFF676C86),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.image_outlined),
            label: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}

class _GuarantyLetterPreviewPage extends StatelessWidget {
  final String residentName;
  final String hospitalName;
  final String billAmount;

  const _GuarantyLetterPreviewPage({
    required this.residentName,
    required this.hospitalName,
    required this.billAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guaranty Letter'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4E7F3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BARANGAY GUARANTY LETTER',
                  style: TextStyle(
                    color: Color(0xFF2F3248),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Resident: $residentName'),
                Text('Hospital: $hospitalName'),
                Text('Assessed Amount: $billAmount'),
                const SizedBox(height: 10),
                const Text(
                  'This certifies that the Barangay endorses the named resident for medical assistance evaluation, subject to document validation and available funds.',
                  style: TextStyle(
                    color: Color(0xFF5C6280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Prepared for GL release queue',
                  style: TextStyle(
                    color: Color(0xFFD14F4F),
                    fontWeight: FontWeight.w800,
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

class _DocumentStatusDetailPage extends StatelessWidget {
  final _LegacyDocEntry entry;
  final String status;
  final Color accent;
  const _DocumentStatusDetailPage({
    required this.entry,
    required this.status,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'Pending';
    final isApproved = status == 'Approved';
    final isRejected = status == 'Rejected';
    final isCompleted = status == 'Completed';
    final actionLabel = switch (status) {
      'Approved' => 'View Document',
      'Completed' => 'Download PDF',
      'Rejected' => 'Review Notes',
      _ => 'Track Status',
    };
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
                              'Reference: ${entry.reference}',
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
                          status,
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
                    entry.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF3E445E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.detail,
                    style: const TextStyle(
                      color: Color(0xFF666B84),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                    'Processing Timeline',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F3248),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle, color: Color(0xFF3BAE72)),
                    title: Text('Application received'),
                    subtitle: Text('Request encoded and validated'),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      isPending
                          ? Icons.timelapse_rounded
                          : Icons.check_circle_rounded,
                      color: isPending
                          ? const Color(0xFF6570A5)
                          : const Color(0xFF3BAE72),
                    ),
                    title: const Text('Barangay processing'),
                    subtitle: Text(
                      isPending
                          ? 'Assigned to records and approval queue'
                          : 'Review completed by assigned officer',
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      isApproved || isCompleted
                          ? Icons.task_alt_rounded
                          : isRejected
                          ? Icons.cancel_rounded
                          : Icons.assignment_turned_in_rounded,
                      color: isApproved || isCompleted
                          ? const Color(0xFF3BAE72)
                          : isRejected
                          ? const Color(0xFFD74637)
                          : const Color(0xFF6B7088),
                    ),
                    title: const Text('Final action'),
                    subtitle: Text(
                      isApproved
                          ? 'Approved and ready for release'
                          : isCompleted
                          ? 'Released and completed'
                          : isRejected
                          ? 'Application rejected due to requirements'
                          : 'Ready for release or additional review',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () =>
                  _showFeature(context, '$actionLabel: ${entry.reference}'),
              style: FilledButton.styleFrom(backgroundColor: accent),
              icon: const Icon(Icons.open_in_new),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthServiceDetailPage extends StatefulWidget {
  final _HealthServiceItem item;
  final String? preferredDoctor;
  const _HealthServiceDetailPage({required this.item, this.preferredDoctor});

  @override
  State<_HealthServiceDetailPage> createState() =>
      _HealthServiceDetailPageState();
}

class _HealthServiceDetailPageState extends State<_HealthServiceDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _notesController = TextEditingController();
  final _certificatePurposeController = TextEditingController();
  static const _doctorNames = ['Dr. Lea Santos, MD', 'Dr. Carlo Dizon, MD'];
  static const _timeSlots = [
    '9:00 AM - 10:00 AM',
    '10:30 AM - 11:30 AM',
    '1:00 PM - 2:00 PM',
    '2:30 PM - 3:30 PM',
  ];
  String _selectedDoctor = _doctorNames[0];
  String _selectedDay = 'Monday';
  String _selectedTimeSlot = _timeSlots[0];
  bool _submitting = false;
  String? _referenceCode;

  bool get _requiresDoctor =>
      widget.item.id == 'consultation' ||
      widget.item.id == 'diagnostics' ||
      widget.item.id == 'medcert';

  bool get _isMedicalCertificate => widget.item.id == 'medcert';

  @override
  void initState() {
    super.initState();
    _selectedDoctor = widget.preferredDoctor ?? _doctorNames.first;
    if (_isMedicalCertificate) {
      _certificatePurposeController.text = 'Fit-to-work clearance';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _notesController.dispose();
    _certificatePurposeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final prefix = _isMedicalCertificate
        ? 'MED'
        : (_requiresDoctor ? 'CHK' : 'HLT');
    final ref = '$prefix-${DateTime.now().millisecondsSinceEpoch % 1000000}';
    setState(() {
      _submitting = false;
      _referenceCode = ref;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FF), Color(0xFFF2F4F9)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E8F4)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
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
                      color: item.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.accent),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2F3248),
                          ),
                        ),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            color: Color(0xFF686C86),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Expected processing: ${item.eta}',
                          style: TextStyle(
                            color: item.accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E8F4)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F3248),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
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
                    if (_requiresDoctor) ...[
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDoctor,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Physician',
                        ),
                        items: _doctorNames
                            .map(
                              (doctor) => DropdownMenuItem(
                                value: doctor,
                                child: Text(doctor),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _selectedDoctor = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select a physician.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedDay,
                              decoration: const InputDecoration(
                                labelText: 'Preferred Day',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Monday',
                                  child: Text('Monday'),
                                ),
                                DropdownMenuItem(
                                  value: 'Tuesday',
                                  child: Text('Tuesday'),
                                ),
                                DropdownMenuItem(
                                  value: 'Wednesday',
                                  child: Text('Wednesday'),
                                ),
                                DropdownMenuItem(
                                  value: 'Thursday',
                                  child: Text('Thursday'),
                                ),
                                DropdownMenuItem(
                                  value: 'Friday',
                                  child: Text('Friday'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _selectedDay = value);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedTimeSlot,
                              decoration: const InputDecoration(
                                labelText: 'Time Slot',
                              ),
                              items: _timeSlots
                                  .map(
                                    (slot) => DropdownMenuItem(
                                      value: slot,
                                      child: Text(slot),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _selectedTimeSlot = value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (_isMedicalCertificate) ...[
                      TextFormField(
                        controller: _certificatePurposeController,
                        decoration: const InputDecoration(
                          labelText: 'Certificate Purpose',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 5) {
                            return 'Please enter certificate purpose.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: _requiresDoctor
                            ? 'Symptoms / Concern Details'
                            : 'Additional Notes',
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
                          backgroundColor: item.accent,
                        ),
                        icon: const Icon(Icons.send),
                        label: Text(
                          _submitting
                              ? 'Submitting...'
                              : (_isMedicalCertificate
                                    ? 'Submit Certificate Request'
                                    : (_requiresDoctor
                                          ? 'Schedule Health Check-Up'
                                          : 'Submit Health Request')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_referenceCode != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3FAF6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCEE8D8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Sent Successfully',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F4F42),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reference: $_referenceCode',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F5E47),
                      ),
                    ),
                    if (_requiresDoctor) ...[
                      const SizedBox(height: 3),
                      Text(
                        'Assigned physician: $_selectedDoctor',
                        style: const TextStyle(
                          color: Color(0xFF365A4A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Schedule: $_selectedDay - $_selectedTimeSlot',
                        style: const TextStyle(
                          color: Color(0xFF4E6770),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (_isMedicalCertificate) ...[
                      const SizedBox(height: 3),
                      Text(
                        'Certificate purpose: ${_certificatePurposeController.text}',
                        style: const TextStyle(
                          color: Color(0xFF516070),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 3),
                    const Text(
                      'You can use this code to follow up at the barangay help desk.',
                      style: TextStyle(
                        color: Color(0xFF5E6A7D),
                        fontWeight: FontWeight.w600,
                      ),
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

