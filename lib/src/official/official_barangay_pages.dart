part of barangaymo_app;

class OfficialBarangayProfilePage extends StatefulWidget {
  final int initialTabIndex;
  const OfficialBarangayProfilePage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<OfficialBarangayProfilePage> createState() =>
      _OfficialBarangayProfilePageState();
}

class _OfficialBarangayProfilePageState
    extends State<OfficialBarangayProfilePage> {
  static const _profileBgStart = Color(0xFFFFFAF5);
  static const _profileBgEnd = Color(0xFFFFF1E8);
  static const _profileCardBorder = Color(0xFFF2DDCF);
  static const _profileIcon = Color(0xFFB45309);
  static const _profileSoft = Color(0xFFFFEFE3);
  static const _profileTabInactive = Color(0xFF8E765E);
  late String _addressPin;
  late String _addressBarangay;
  late String _addressCity;
  late String _addressProvince;
  late String _addressRegion;
  late String _website;
  late String _facebook;
  late int _population;
  late String _divisionType;
  late int _divisionCount;
  late int _foundingYear;
  late double _latitude;
  late double _longitude;
  Uint8List? _logoBytes;
  bool _showSkCouncil = false;
  bool get _isReadOnlyAfterActivation => _officialActivationCompleted;

  bool _ensureEditable() {
    if (!_isReadOnlyAfterActivation) {
      return true;
    }
    _showFeature(
      context,
      'Read-only mode: barangay setup can only be edited during first activation.',
    );
    return false;
  }

  LatLng get _mapCenter => LatLng(_latitude, _longitude);

  @override
  void initState() {
    super.initState();
    _addressPin = _officialBarangaySetup.landmark.toUpperCase();
    _addressBarangay = _officialBarangaySetup.barangay.toUpperCase();
    _addressCity = _officialBarangaySetup.city.toUpperCase();
    _addressProvince = _officialBarangaySetup.province.toUpperCase();
    _addressRegion = _officialBarangaySetup.region.toUpperCase();
    _website = _officialBarangaySetup.website;
    _facebook = _officialBarangaySetup.facebook;
    _population = _officialPopulationForYear();
    _divisionType = _officialBarangaySetup.divisionType;
    _divisionCount = _officialBarangaySetup.divisionCount;
    _foundingYear = _officialBarangaySetup.foundingYear;
    _latitude = _officialBarangaySetup.latitude;
    _longitude = _officialBarangaySetup.longitude;
    _logoBytes = _officialBarangaySetup.logoBytes;
  }

  final List<_CouncilMember> _councilMembers = [
    _CouncilMember(
      name: 'DONALD ELAD AQUINO',
      role: 'Punong Barangay',
      committee: 'Executive Head',
      pinned: true,
    ),
    _CouncilMember(
      name:
          '${_officialBarangaySetup.secretaryFirstName} ${_officialBarangaySetup.secretaryLastName}'
              .trim()
              .toUpperCase(),
      role: 'Barangay Secretary',
      committee: 'Records and Administration',
      pinned: true,
    ),
    _CouncilMember(
      name: 'LARRY DELA ROSA TOLEDO',
      role: 'Sangguniang Barangay Member',
      committee: 'Committee on Infrastructure',
    ),
    _CouncilMember(
      name: 'RIGOR BILONO AVILANES',
      role: 'Sangguniang Barangay Member',
      committee: 'Committee on Finance and Budget',
    ),
    _CouncilMember(
      name: 'ROBERTO TOGONON ANTONIO',
      role: 'Sangguniang Barangay Member',
      committee: 'Committee on Social Services',
    ),
    _CouncilMember(
      name: 'WILFREDO FABABI MIRANDA',
      role: 'Sangguniang Barangay Member',
      committee: 'Committee on Education and Youth',
    ),
  ];

  final List<_CouncilMember> _skCouncilMembers = [
    _CouncilMember(
      name: 'ANGEL VICTORIA BIBANCO',
      role: 'SK Chairperson',
      committee: 'Youth Council Lead',
      pinned: true,
    ),
    _CouncilMember(
      name: 'JULIUS MANUEL SANTOS',
      role: 'SK Kagawad',
      committee: 'Sports and Wellness',
    ),
    _CouncilMember(
      name: 'BEA LORENCE MENDOZA',
      role: 'SK Kagawad',
      committee: 'Education and Scholarship',
    ),
    _CouncilMember(
      name: 'JEROME AGUIRRE',
      role: 'SK Kagawad',
      committee: 'Community Engagement',
    ),
  ];

  Future<void> _editAddressDetails() async {
    if (!_ensureEditable()) {
      return;
    }
    final pin = TextEditingController(text: _addressPin);
    final barangay = TextEditingController(text: _addressBarangay);
    final city = TextEditingController(text: _addressCity);
    final province = TextEditingController(text: _addressProvince);
    final region = TextEditingController(text: _addressRegion);
    final latitude = TextEditingController(
      text: _formatCoordinateValue(_latitude),
    );
    final longitude = TextEditingController(
      text: _formatCoordinateValue(_longitude),
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Address Details',
                style: TextStyle(
                  color: _officialText,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pin,
                decoration: const InputDecoration(
                  labelText: 'Pin / Landmark',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: barangay,
                decoration: const InputDecoration(labelText: 'Barangay'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: city,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: province,
                decoration: const InputDecoration(labelText: 'Province'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: region,
                decoration: const InputDecoration(labelText: 'Region'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: latitude,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      inputFormatters: [const _SixDecimalCoordinateFormatter()],
                      decoration: const InputDecoration(labelText: 'Latitude'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: longitude,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      inputFormatters: [const _SixDecimalCoordinateFormatter()],
                      decoration: const InputDecoration(labelText: 'Longitude'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final nextLatitude = _parseCoordinateValue(
                      latitude.text,
                      min: -90,
                      max: 90,
                    );
                    final nextLongitude = _parseCoordinateValue(
                      longitude.text,
                      min: -180,
                      max: 180,
                    );
                    if (pin.text.trim().isEmpty ||
                        barangay.text.trim().isEmpty ||
                        city.text.trim().isEmpty ||
                        province.text.trim().isEmpty ||
                        region.text.trim().isEmpty ||
                        nextLatitude == null ||
                        nextLongitude == null) {
                      _showFeature(ctx, 'Please complete all address fields');
                      return;
                    }
                    setState(() {
                      _addressPin = pin.text.trim().toUpperCase();
                      _addressBarangay = barangay.text.trim().toUpperCase();
                      _addressCity = city.text.trim().toUpperCase();
                      _addressProvince = province.text.trim().toUpperCase();
                      _addressRegion = region.text.trim().toUpperCase();
                      _latitude = nextLatitude;
                      _longitude = nextLongitude;
                      _officialBarangaySetup
                        ..landmark = _addressPin
                        ..barangay = _addressBarangay
                        ..city = _addressCity
                        ..province = _addressProvince
                        ..region = _addressRegion
                        ..latitude = _latitude
                        ..longitude = _longitude;
                    });
                    Navigator.pop(ctx);
                    _showFeature(context, 'Address details updated');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _officialHeaderStart,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Address'),
                ),
              ),
            ],
          ),
        );
      },
    );
    barangay.dispose();
    city.dispose();
    province.dispose();
    region.dispose();
    latitude.dispose();
    longitude.dispose();
  }

  List<_CouncilMember> get _activeCouncilMembers =>
      _showSkCouncil ? _skCouncilMembers : _councilMembers;

  int get _fixedCouncilCount => _showSkCouncil ? 1 : 2;

  String _directoryBadgeFor(int index, _CouncilMember member) {
    if (member.role == 'Punong Barangay') {
      return 'Head';
    }
    if (member.role == 'Barangay Secretary') {
      return 'Secretary';
    }
    if (member.role == 'SK Chairperson') {
      return 'Youth Head';
    }
    final rank = (index - _fixedCouncilCount) + 1;
    return member.role.contains('SK') ? 'SK Rank $rank' : 'Kagawad Rank $rank';
  }

  void _reorderCouncilMember(int oldIndex, int newIndex) {
    if (!_ensureEditable()) {
      return;
    }
    final list = _activeCouncilMembers;
    if (oldIndex < _fixedCouncilCount || newIndex < _fixedCouncilCount) {
      return;
    }
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final member = list.removeAt(oldIndex);
      list.insert(newIndex, member);
    });
  }

  Future<void> _editCouncilMember({int? index}) async {
    if (!_ensureEditable()) {
      return;
    }
    final list = _activeCouncilMembers;
    final isEdit = index != null;
    final current = isEdit ? list[index] : null;
    final name = TextEditingController(text: current?.name ?? '');
    final role = TextEditingController(text: current?.role ?? '');
    final committee = TextEditingController(text: current?.committee ?? '');

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Council Member' : 'Add Council Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: role,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: committee,
                decoration: const InputDecoration(
                  labelText: 'Committee / Responsibility',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (name.text.trim().isEmpty ||
                    role.text.trim().isEmpty ||
                    committee.text.trim().isEmpty) {
                  _showFeature(ctx, 'Please complete name, role, and committee');
                  return;
                }
                setState(() {
                  if (isEdit) {
                    list[index].name = name.text.trim().toUpperCase();
                    list[index].role = role.text.trim();
                    list[index].committee = committee.text.trim();
                  } else {
                    list.add(
                      _CouncilMember(
                        name: name.text.trim().toUpperCase(),
                        role: role.text.trim(),
                        committee: committee.text.trim(),
                      ),
                    );
                  }
                });
                Navigator.pop(ctx);
                _showFeature(
                  context,
                  isEdit ? 'Council member updated' : 'Council member added',
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: _officialHeaderStart,
                foregroundColor: Colors.white,
              ),
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
    name.dispose();
    role.dispose();
    committee.dispose();
  }

  Widget _contentCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _profileCardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15B45309),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _officialText,
        fontSize: 32,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String title,
    required String value,
    required String note,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _profileSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _profileCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: _profileIcon),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6E4A2A),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: _officialText,
              fontWeight: FontWeight.w900,
              fontSize: 18,
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

  Widget _infoTile({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _profileCardBorder)),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _profileSoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _profileIcon, size: 20),
        ),
        title: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _officialText,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          label,
          style: const TextStyle(
            color: _officialSubtext,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _profileDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool last = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: _profileCardBorder)),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _profileSoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _profileIcon, size: 20),
        ),
        title: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _officialText,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          label,
          style: const TextStyle(
            color: _officialSubtext,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _detailsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      children: [
        _sectionTitle('Barangay Details'),
        const SizedBox(height: 10),
        _contentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Details',
                style: TextStyle(
                  color: _officialText,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              _profileDetailRow(
                icon: Icons.email_outlined,
                value: 'westtapinac@olongapo.gov.ph',
                label: 'Email',
              ),
              _profileDetailRow(
                icon: Icons.language_rounded,
                value: _website,
                label: 'Website',
              ),
              _profileDetailRow(
                icon: Icons.facebook_rounded,
                value: _facebook,
                label: 'Facebook',
              ),
              _profileDetailRow(
                icon: Icons.gps_fixed_rounded,
                value:
                    '${_formatCoordinateValue(_latitude)}, ${_formatCoordinateValue(_longitude)}',
                label: 'Coordinates',
              ),
              _profileDetailRow(
                icon: Icons.square_foot_rounded,
                value: '2.40 km??',
                label: 'Land Area',
              ),
              _profileDetailRow(
                icon: Icons.groups_2_outlined,
                value: '${_population.toString()} residents',
                label: 'Population',
                last: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _contentCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      icon: Icons.groups_outlined,
                      title: 'Population',
                      value: _population.toString(),
                      note: 'Local setup',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _metricCard(
                      icon: Icons.badge_outlined,
                      title: 'RBI',
                      value: '5,420',
                      note: 'Active records',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      icon: Icons.hub_outlined,
                      title: 'Divisions',
                      value: _divisionCount.toString(),
                      note: '${_divisionType}s',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _metricCard(
                      icon: Icons.history_edu_outlined,
                      title: 'Founded',
                      value: '$_foundingYear',
                      note:
                          '${DateTime.now().year - _foundingYear} years',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _infoTile(
                icon: Icons.phone_android,
                value: '0917-223-4545',
                label: 'Mobile Number',
              ),
              _infoTile(
                icon: Icons.call_outlined,
                value: '047-223-3434',
                label: 'Landline',
              ),
              _infoTile(
                icon: Icons.calendar_today_outlined,
                value: 'August 8',
                label: 'Foundation Day',
              ),
              _infoTile(
                icon: Icons.account_balance_wallet_outlined,
                value: 'PHP 12.4M Annual Budget',
                label: 'CY 2026 Allocation',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _contentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Emergency Contacts',
                style: TextStyle(
                  color: _officialText,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              _infoTile(
                icon: Icons.local_fire_department_outlined,
                value: '166',
                label: 'Fire Department',
              ),
              _infoTile(
                icon: Icons.shield_outlined,
                value: '0917-111-2287',
                label: 'BPAT',
              ),
              _infoTile(
                icon: Icons.local_police_outlined,
                value: '117',
                label: 'Police',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _addressRow({
    required IconData icon,
    required String value,
    required String label,
    bool last = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: _profileCardBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: _profileIcon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _officialText,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF7A6857),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      children: [
        _sectionTitle('Barangay Address'),
        const SizedBox(height: 10),
        _contentCard(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
          child: Column(
            children: [
              Container(
                height: 215,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _profileCardBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: _mapCenter,
                        initialZoom: 14.9,
                        interactionOptions: const InteractionOptions(
                          flags:
                              InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.barangaymo_app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _mapCenter,
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.location_on,
                                color: _officialHeaderStart,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _profileCardBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.place_rounded,
                              color: _officialHeaderStart,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$_addressBarangay, $_addressCity, $_addressProvince',
                                style: const TextStyle(
                                  color: _officialText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => _FullscreenMapPage(
                                    title: 'Barangay Address Map',
                                    initialCenter: _mapCenter,
                                    initialZoom: 16,
                                    pins: [
                                      _MapPin(
                                        point: _mapCenter,
                                        icon: Icons.location_on,
                                        color: _officialHeaderStart,
                                        label:
                                            '$_addressBarangay, $_addressCity, $_addressProvince',
                                        ),
                                    ],
                                  ),
                                 ),
                               ),
                              child: const Text(
                                'Full View',
                                style: TextStyle(fontWeight: FontWeight.w800),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _profileCardBorder),
                  color: const Color(0xFFFFFCF8),
                ),
                child: Column(
                  children: [
                    _addressRow(
                      icon: Icons.push_pin_outlined,
                      value: _addressPin,
                      label: 'Pin / Landmark',
                    ),
                    _addressRow(
                      icon: Icons.location_city_outlined,
                      value: _addressBarangay,
                      label: 'Barangay',
                    ),
                    _addressRow(
                      icon: Icons.place_outlined,
                      value: _addressCity,
                      label: 'Municipality / City',
                    ),
                    _addressRow(
                      icon: Icons.map_outlined,
                      value: _addressProvince,
                      label: 'Province',
                    ),
                    _addressRow(
                      icon: Icons.fullscreen_outlined,
                      value: _addressRegion,
                      label: 'Region',
                    ),
                    _addressRow(
                      icon: Icons.gps_fixed_rounded,
                      value:
                          '${_formatCoordinateValue(_latitude)}, ${_formatCoordinateValue(_longitude)}',
                      label: 'Coordinates',
                      last: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isReadOnlyAfterActivation
                      ? null
                      : _editAddressDetails,
                  style: FilledButton.styleFrom(
                    backgroundColor: _officialHeaderStart,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Update Address Details',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _councilMemberCard(
    BuildContext context, {
    required int index,
    required _CouncilMember member,
  }) {
    final canReorder =
        !_isReadOnlyAfterActivation && index >= _fixedCouncilCount && !member.pinned;
    return Container(
      key: ValueKey('${member.name}-${member.role}-$index'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: _profileSoft,
            child: Icon(Icons.person, color: _profileIcon, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name.trim().isEmpty ? 'UNNAMED MEMBER' : member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _officialText,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  member.role,
                  style: const TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  member.committee,
                  style: const TextStyle(
                    color: Color(0xFF6E748F),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _profileSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _directoryBadgeFor(index, member),
                  style: const TextStyle(
                    color: _profileIcon,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _isReadOnlyAfterActivation
                        ? null
                        : () => _editCouncilMember(index: index),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: _profileIcon,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 6),
                  if (canReorder)
                    ReorderableDragStartListener(
                      index: index,
                      child: const Icon(
                        Icons.drag_handle_rounded,
                        color: _profileIcon,
                      ),
                    )
                  else
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: _profileIcon,
                      size: 18,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _councilTab(BuildContext context) {
    final councilMembers = _activeCouncilMembers;
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      children: [
        _sectionTitle(_showSkCouncil ? 'SK Council' : 'Official Directory'),
        const SizedBox(height: 10),
        _contentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (!_ensureEditable()) {
                          return;
                        }
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _OfficialSecretaryProfilePage(),
                          ),
                        );
                        if (updated == true && mounted) {
                          setState(() {
                            _councilMembers[1]
                              ..name =
                                  '${_officialBarangaySetup.secretaryFirstName} ${_officialBarangaySetup.secretaryLastName}'
                                      .trim()
                                      .toUpperCase()
                              ..committee = 'Records and Administration';
                          });
                          _showFeature(context, 'Secretary profile updated.');
                        }
                      },
                      icon: const Icon(Icons.badge_outlined, size: 18),
                      label: const Text('Secretary Profile'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        if (!_ensureEditable()) {
                          return;
                        }
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _OfficialSignaturePadPage(),
                          ),
                        );
                        if (updated == true && mounted) {
                          setState(() {});
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _officialHeaderStart,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.draw_outlined, size: 18),
                      label: const Text('Punong Signature'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Barangay Council'),
                    icon: Icon(Icons.account_balance_outlined),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('SK Council'),
                    icon: Icon(Icons.groups_2_outlined),
                  ),
                ],
                selected: {_showSkCouncil},
                onSelectionChanged: (selection) {
                  setState(() => _showSkCouncil = selection.first);
                },
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _profileCardBorder),
                ),
                child: Text(
                  _showSkCouncil
                      ? 'Switch between the barangay directory and youth council, then drag SK kagawads to set seniority.'
                      : 'The directory follows position hierarchy. Drag kagawads below the fixed leadership roles to update seniority.',
                  style: const TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _profileCardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Punong Barangay Digital Signature',
                      style: TextStyle(
                        color: _officialText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 86,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _profileCardBorder),
                      ),
                      child: _officialBarangaySetup.punongSignaturePaths.isEmpty
                          ? const Center(
                              child: Text(
                                'No saved e-sign yet',
                                style: TextStyle(
                                  color: _officialSubtext,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : CustomPaint(
                              painter: _OfficialSignaturePainter(
                                strokes:
                                    _officialBarangaySetup.punongSignaturePaths,
                              ),
                              child: const SizedBox.expand(),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: councilMembers.length,
                onReorder: _reorderCouncilMember,
                buildDefaultDragHandles: false,
                itemBuilder: (context, index) => _councilMemberCard(
                  context,
                  index: index,
                  member: councilMembers[index],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isReadOnlyAfterActivation
                      ? null
                      : () => _editCouncilMember(),
                  style: FilledButton.styleFrom(
                    backgroundColor: _officialHeaderStart,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.group_add_outlined, size: 18),
                  label: Text(
                    _showSkCouncil ? 'Add SK Member' : 'Add Council Member',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Barangay Profile'),
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
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_profileBgStart, _profileBgEnd],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: _profileCardBorder, width: 2),
                ),
                padding: const EdgeInsets.all(10),
                child: _logoBytes != null
                    ? ClipOval(child: Image.memory(_logoBytes!, fit: BoxFit.cover))
                    : Image.asset(
                        'public/barangaymo.png',
                        fit: BoxFit.contain,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                _addressBarangay,
                style: const TextStyle(
                  color: _officialText,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '$_addressCity $_addressProvince',
                style: const TextStyle(
                  color: _officialSubtext,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              const TabBar(
                labelColor: _officialHeaderStart,
                unselectedLabelColor: _profileTabInactive,
                indicatorColor: _officialHeaderStart,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
                tabs: [
                  Tab(text: 'Details'),
                  Tab(text: 'Address'),
                  Tab(text: 'Council'),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: TabBarView(
                  children: [
                    _detailsTab(context),
                    _addressTab(context),
                    _councilTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
