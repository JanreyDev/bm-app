part of barangaymo_app;

class OfficialSettingsPage extends StatefulWidget {
  const OfficialSettingsPage({super.key});

  @override
  State<OfficialSettingsPage> createState() => _OfficialSettingsPageState();
}

class _OfficialSettingsPageState extends State<OfficialSettingsPage> {
  bool _notificationsEnabled = false;

  Widget _settingsRow({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    bool highlight = false,
  }) {
    final borderColor = highlight
        ? const Color(0xFFFFC9C9)
        : const Color(0xFFF0F1F5);
    final tileColor = highlight ? const Color(0xFFFFF6F6) : Colors.white;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Icon(icon, color: const Color(0xFF2D3348), size: 21),
        title: Text(
          title,
          style: const TextStyle(
            color: _officialText,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        trailing:
            trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFD32A2A),
              size: 24,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _officialEditableProfile.value;
    final displayName = profile.name.trim().isEmpty
        ? 'Barangay Official'
        : profile.name.trim();
    final barangay = profile.barangay.trim().isNotEmpty
        ? profile.barangay.trim()
        : _officialBarangaySetup.barangay.trim();
    final city = _officialBarangaySetup.city.trim();
    final province = _officialBarangaySetup.province.trim();
    final placeParts = <String>[barangay, city, province]
        .where((part) => part.isNotEmpty)
        .toList();
    final displayBarangay = placeParts.isEmpty
        ? 'Barangay Administration'
        : placeParts.join(', ');
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: _officialText,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            icon: const Icon(Icons.home_rounded, size: 20),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _officialCardBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFECEFF8), Color(0xFFDDE3F1)],
                      ),
                      border: Border.all(
                        color: const Color(0xFFE0E4EF),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 62,
                      color: Color(0xFF7A829A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    displayName,
                    style: TextStyle(
                      color: _officialText,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    displayBarangay,
                    style: TextStyle(
                      color: _officialSubtext,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        _showFeature(context, 'Change letter head'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _officialHeaderStart,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'CHANGE LETTER HEAD',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFE9EBF2)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                    child: Column(
                      children: [
                        _settingsRow(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notification Center',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _AdvancedNotificationCenterPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                          trailing: Switch.adaptive(
                            value: _notificationsEnabled,
                            onChanged: (v) {
                              setState(() => _notificationsEnabled = v);
                            },
                          ),
                        ),
                        ValueListenableBuilder<ThemeMode>(
                          valueListenable: _appThemeMode,
                          builder: (_, mode, __) => _settingsRow(
                            icon: Icons.dark_mode_outlined,
                            title: _appText('Dark Mode', 'Dark Mode'),
                            trailing: Switch.adaptive(
                              value: mode == ThemeMode.dark,
                              onChanged: (value) => setState(
                                () => _setDarkModeEnabled(value),
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<_AppLocalePreference>(
                          valueListenable: _appLocalePreference,
                          builder: (_, locale, __) => _settingsRow(
                            icon: Icons.translate_rounded,
                            title: _appText('Tagalog Interface', 'Tagalog Interface'),
                            trailing: Switch.adaptive(
                              value: locale == _AppLocalePreference.tagalog,
                              onChanged: (value) => setState(
                                () => _setTagalogEnabled(value),
                              ),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.person_outline_rounded,
                          title: 'Profile',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _ProfileEditorPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.location_city_outlined,
                          title: 'Barangay Setup',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OfficialBarangaySetupPage(),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.local_phone_outlined,
                          title: 'Emergency Contacts',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OfficialEmergencyContactsPage(),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.lock_outline_rounded,
                          title: 'Secure Settings',
                          highlight: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _SecurePinSettingsPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.security_outlined,
                          title: 'Security Log',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _SecurityLogPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.history_outlined,
                          title: 'Transaction History',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _TransactionHistoryPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.support_agent_outlined,
                          title: 'Help Desk',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _HelpDeskPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.quiz_outlined,
                          title: 'FAQs',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _FaqCenterPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.info_outline,
                          title: 'About',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _AboutPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.share_outlined,
                          title: 'Share the App',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OfficialSharePage(),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.logout_rounded,
                          title: 'Log Out',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OfficialLogoutPage(),
                            ),
                          ),
                        ),
                        _settingsRow(
                          icon: Icons.delete_outline,
                          title: 'Delete Account',
                          highlight: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _AccountDeletionWorkflowPage(
                                role: UserRole.official,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Opacity(
                          opacity: 0.55,
                          child: TextButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OfficialBugReportPage(),
                              ),
                            ),
                            icon: const Icon(
                              Icons.bug_report_outlined,
                              size: 18,
                            ),
                            label: const Text('Report a Bug'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF636A80),
                            ),
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
      ),
    );
  }
}

class OfficialEmergencyContactsPage extends StatefulWidget {
  const OfficialEmergencyContactsPage({super.key});

  @override
  State<OfficialEmergencyContactsPage> createState() =>
      _OfficialEmergencyContactsPageState();
}

class _OfficialEmergencyContactsPageState
    extends State<OfficialEmergencyContactsPage> {
  bool _loading = true;
  List<_EmergencyContactItem> _items = const <_EmergencyContactItem>[];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    if (!mounted) return;
    setState(() => _loading = true);
    await _syncEmergencyContacts(force: true);
    final items = [..._emergencyContacts.value]
      ..sort((a, b) {
        final bySort = a.sortOrder.compareTo(b.sortOrder);
        if (bySort != 0) return bySort;
        return a.label.toLowerCase().compareTo(b.label.toLowerCase());
      });
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  void _toast(String text, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: success
            ? const Color(0xFF1C8C4B)
            : const Color(0xFFC0392B),
      ),
    );
  }

  Future<void> _createOrEdit({_EmergencyContactItem? existing}) async {
    final result = await showDialog<_EmergencyContactFormData>(
      context: context,
      builder: (_) => _EmergencyContactEditorDialog(existing: existing),
    );
    if (result == null) return;
    final response = existing == null
        ? await _EmergencyContactsApi.instance.createContact(
            label: result.label,
            phoneNumber: result.phoneNumber,
            description: result.description,
            quickDial: result.quickDial,
            sortOrder: result.sortOrder,
          )
        : await _EmergencyContactsApi.instance.updateContact(
            contactId: existing.id,
            label: result.label,
            phoneNumber: result.phoneNumber,
            description: result.description,
            quickDial: result.quickDial,
            sortOrder: result.sortOrder,
          );
    _toast(response.message, success: response.success);
    if (!response.success) return;
    await _reload();
  }

  Future<void> _delete(_EmergencyContactItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete contact?'),
        content: Text('Remove ${item.label} from emergency contacts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final result = await _EmergencyContactsApi.instance.deleteContact(item.id);
    _toast(result.message, success: result.success);
    if (!result.success) return;
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: Colors.white,
        foregroundColor: _officialText,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createOrEdit,
        backgroundColor: const Color(0xFFD32A2A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Contact'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? Center(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7F3)),
                ),
                child: const Text(
                  'No emergency contacts yet.\nTap Add Contact to create one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF646B84),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 92),
              itemBuilder: (_, index) {
                final item = _items[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7F3)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _emergencyIconForLabel(item.label),
                        color: const Color(0xFF59607A),
                      ),
                    ),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        color: Color(0xFF2D3348),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        '${item.phoneNumber} | ${item.description}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF646B84),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        if (item.quickDial)
                          const Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text('Quick'),
                          ),
                        IconButton(
                          tooltip: 'Edit',
                          onPressed: () =>
                            _createOrEdit(existing: item),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () => _delete(item),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: _items.length,
            ),
    );
  }
}

class _EmergencyContactFormData {
  final String label;
  final String phoneNumber;
  final String description;
  final bool quickDial;
  final int sortOrder;

  const _EmergencyContactFormData({
    required this.label,
    required this.phoneNumber,
    required this.description,
    required this.quickDial,
    required this.sortOrder,
  });
}

class _EmergencyContactEditorDialog extends StatefulWidget {
  final _EmergencyContactItem? existing;
  const _EmergencyContactEditorDialog({this.existing});

  @override
  State<_EmergencyContactEditorDialog> createState() =>
      _EmergencyContactEditorDialogState();
}

class _EmergencyContactEditorDialogState
    extends State<_EmergencyContactEditorDialog> {
  late final TextEditingController _labelController;
  late final TextEditingController _numberController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sortController;
  late bool _quickDial;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _labelController = TextEditingController(text: existing?.label ?? '');
    _numberController = TextEditingController(text: existing?.phoneNumber ?? '');
    _descriptionController = TextEditingController(
      text: existing?.description ?? '',
    );
    _sortController = TextEditingController(
      text: '${existing?.sortOrder ?? 0}',
    );
    _quickDial = existing?.quickDial ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _numberController.dispose();
    _descriptionController.dispose();
    _sortController.dispose();
    super.dispose();
  }

  void _submit() {
    final label = _labelController.text.trim();
    final number = _numberController.text.trim();
    final description = _descriptionController.text.trim();
    final sortOrder = int.tryParse(_sortController.text.trim()) ?? 0;
    if (label.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter contact name and number.')),
      );
      return;
    }
    Navigator.pop(
      context,
      _EmergencyContactFormData(
        label: label,
        phoneNumber: number,
        description: description,
        quickDial: _quickDial,
        sortOrder: sortOrder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Contact' : 'Edit Contact'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(labelText: 'Label'),
            ),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _sortController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sort Order'),
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: _quickDial,
              onChanged: (v) => setState(() => _quickDial = v),
              contentPadding: EdgeInsets.zero,
              title: const Text('Show in Quick Dial'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}

class _RbiPerson {
  final int apiId;
  final String name;
  final String idNo;
  final int age;
  final String gender;
  final bool verified;
  final String disabilityTag;
  final bool bloodDonor;
  final String bloodType;
  final String barangay;
  final String zonePurok;
  final int vaccinationCount;
  final String educationAidStatus;
  final double? bmi;
  final int verificationStep;

  const _RbiPerson({
    this.apiId = 0,
    required this.name,
    required this.idNo,
    required this.age,
    required this.gender,
    required this.verified,
    this.disabilityTag = 'None',
    this.bloodDonor = false,
    this.bloodType = 'N/A',
    this.barangay = 'West Tapinac',
    this.zonePurok = 'Zone 1',
    this.vaccinationCount = 0,
    this.educationAidStatus = 'Not Enrolled',
    this.bmi,
    this.verificationStep = 1,
  });

  bool get seniorCitizen => age >= 60;

  bool get isPwd => disabilityTag != 'None';
}

Widget _officialRbiRegistryPill(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE6E1),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: _officialHeaderStart,
        fontWeight: FontWeight.w800,
        fontSize: 11,
      ),
    ),
  );
}

Widget _officialRbiMetricChip(String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFF6F7FB),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      '$label: $value',
      style: const TextStyle(
        color: _officialText,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class OfficialRbiRecordsPage extends StatefulWidget {
  const OfficialRbiRecordsPage({super.key});

  @override
  State<OfficialRbiRecordsPage> createState() => _OfficialRbiRecordsPageState();
}

class _OfficialRbiRecordsPageState extends State<OfficialRbiRecordsPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedTab = 'All';
  bool _loadingBackend = false;
  List<_RbiPerson> _backendRecords = const <_RbiPerson>[];

  @override
  void initState() {
    super.initState();
    unawaited(_loadBackendRecords());
  }

  List<_RbiPerson> get _liveRecords {
    return _ResidentRbiStore.all.value.map((record) {
      return _RbiPerson(
        apiId: 0,
        name: record.fullName,
        idNo: record.rbiId,
        age: record.age,
        gender: record.gender,
        verified: record.verificationStep >= 2,
        disabilityTag: record.disabilityTag,
        bloodDonor: record.bloodDonorOptIn,
        bloodType: record.bloodType,
        barangay: record.barangay,
        zonePurok: record.zonePurok,
        vaccinationCount: record.vaccinations.length,
        educationAidStatus: record.educationAidStatus,
        bmi: record.latestNutritionEntry?.bmi,
        verificationStep: record.verificationStep,
      );
    }).toList();
  }

  List<_RbiPerson> get _allRecords =>
      _backendRecords.isNotEmpty ? _backendRecords : [..._liveRecords];

  Future<void> _loadBackendRecords() async {
    setState(() => _loadingBackend = true);
    final result = await _OfficialRbiApi.instance.fetchRecords();
    if (!mounted) return;
    if (result.success) {
      setState(() => _backendRecords = result.records);
    } else {
      _showFeature(context, result.message, tone: _ToastTone.warning);
    }
    setState(() => _loadingBackend = false);
  }

  List<_RbiPerson> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _allRecords.where((person) {
      final isVerified = person.verified || person.verificationStep >= 2;
      final matchedTab =
          _selectedTab == 'All' ||
          (_selectedTab == 'Verified' && isVerified) ||
          (_selectedTab == 'Unverified' && !isVerified) ||
          (_selectedTab == 'Seniors' && person.seniorCitizen) ||
          (_selectedTab == 'PWD' && person.isPwd) ||
          (_selectedTab == 'Donors' && person.bloodDonor);
      final matchedText =
          q.isEmpty ||
          person.name.toLowerCase().contains(q) ||
          person.idNo.toLowerCase().contains(q) ||
          person.zonePurok.toLowerCase().contains(q) ||
          person.barangay.toLowerCase().contains(q);
      return matchedTab && matchedText;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Widget _chip(String label) {
    final selected = _selectedTab == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF4D556F),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
      selected: selected,
      onSelected: (_) => setState(() => _selectedTab = label),
      selectedColor: _officialHeaderStart,
      backgroundColor: const Color(0xFFF0F2F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      side: BorderSide(
        color: selected ? _officialHeaderStart : Colors.transparent,
      ),
      showCheckmark: false,
    );
  }

  Widget _avatar(_RbiPerson person) {
    final initials = person.name
        .split(',')
        .first
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0])
        .join();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: person.verified
              ? const Color(0xFFE8F8EF)
              : const Color(0xFFF7F0E8),
          child: Text(
            initials,
            style: TextStyle(
              color: person.verified
                  ? const Color(0xFF1A8F50)
                  : const Color(0xFFB9771D),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: person.verified
                  ? const Color(0xFF19C261)
                  : const Color(0xFFE29423),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _recordCard(_RbiPerson person) {
    final query = _searchCtrl.text.trim();
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final changed = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => _OfficialRbiProfilePage(person: person),
          ),
        );
        if (!mounted) return;
        if (changed == true) {
          await _loadBackendRecords();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4E7F1)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _avatar(person),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  _HighlightedText(
                    text: person.name,
                    query: query,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _officialText,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 1),
                  _HighlightedText(
                    text: 'ID No ${person.idNo}',
                    query: query,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _officialSubtext,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  _HighlightedText(
                    text: 'Age ${person.age}',
                    query: query,
                    style: const TextStyle(
                      color: _officialSubtext,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  _HighlightedText(
                    text: 'Gender ${person.gender}',
                    query: query,
                    style: const TextStyle(
                      color: _officialSubtext,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  _HighlightedText(
                    text: person.zonePurok,
                    query: query,
                    style: const TextStyle(
                      color: _officialSubtext,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (person.seniorCitizen) _officialRbiRegistryPill('Senior'),
                      if (person.isPwd) _officialRbiRegistryPill('PWD'),
                      if (person.bloodDonor)
                        _officialRbiRegistryPill('Donor ${person.bloodType}'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF767E97),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shown = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('RBI Records'),
        backgroundColor: _officialHeaderStart,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search name...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadBackendRecords,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            if (_loadingBackend)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: LinearProgressIndicator(minHeight: 2),
              ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip('All'),
              _chip('Verified'),
              _chip('Unverified'),
              _chip('Seniors'),
              _chip('PWD'),
              _chip('Donors'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Registry Overview',
            style: TextStyle(
              color: _officialSubtext,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _officialCardBorder),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _officialRbiMetricChip('Residents', '${_allRecords.length}'),
                _officialRbiMetricChip(
                  'Senior/PWD',
                  '${_allRecords.where((entry) => entry.seniorCitizen || entry.isPwd).length}',
                ),
                _officialRbiMetricChip(
                  'Blood Donors',
                  '${_allRecords.where((entry) => entry.bloodDonor).length}',
                ),
              ],
            ),
          ),
            if (shown.isEmpty)
              _AppEmptyState(
                icon: Icons.badge_outlined,
                title: _appText('No records found', 'Walang record na nahanap'),
                subtitle: _appText(
                  'Try another resident name, RBI ID, or zone keyword.',
                  'Subukan ang ibang pangalan, RBI ID, o zone keyword.',
                ),
              )
            else
              ...shown.map(_recordCard),
          ],
        ),
      ),
    );
  }
}

class _OfficialRbiApiResult {
  final bool success;
  final String message;
  final List<_RbiPerson> records;

  const _OfficialRbiApiResult({
    required this.success,
    required this.message,
    this.records = const <_RbiPerson>[],
  });
}

class _OfficialRbiApi {
  _OfficialRbiApi._();
  static final instance = _OfficialRbiApi._();

  Future<_OfficialRbiApiResult> fetchRecords() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _OfficialRbiApiResult(success: false, message: 'Login required.');
    }
    const paths = <String>['rbi/records'];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http.get(
            endpoint,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_authToken',
            },
          ).timeout(const Duration(seconds: 8));
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode < 200 || response.statusCode >= 300) {
            return _OfficialRbiApiResult(
              success: false,
              message: _extractApiMessage(response.body, 'Unable to load RBI records.'),
            );
          }
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          if (decoded is! Map<String, dynamic>) {
            return const _OfficialRbiApiResult(success: false, message: 'Invalid RBI response.');
          }
          final raw = decoded['records'];
          if (raw is! List) {
            return _OfficialRbiApiResult(
              success: true,
              message: _extractApiMessage(response.body, 'No RBI records found.'),
            );
          }
          final records = <_RbiPerson>[];
          for (final item in raw) {
            if (item is! Map<String, dynamic>) {
              continue;
            }
            records.add(_toPerson(item));
          }
          return _OfficialRbiApiResult(
            success: true,
            message: _extractApiMessage(response.body, 'RBI records synced.'),
            records: records,
          );
        } on TimeoutException {
          return const _OfficialRbiApiResult(success: false, message: 'RBI request timed out.');
        } catch (_) {
          return const _OfficialRbiApiResult(success: false, message: 'Unable to load RBI records.');
        }
      }
    }
    return const _OfficialRbiApiResult(success: false, message: 'RBI endpoint unavailable.');
  }

  _RbiPerson _toPerson(Map<String, dynamic> item) {
    String readString(String key, [String fallback = '']) {
      final value = item[key];
      if (value is String) return value.trim();
      if (value != null) return value.toString().trim();
      return fallback;
    }

    int readInt(String key, [int fallback = 0]) {
      final value = item[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value.trim()) ?? fallback;
      return fallback;
    }

    bool readBool(String key, [bool fallback = false]) {
      final value = item[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final lowered = value.trim().toLowerCase();
        return lowered == '1' || lowered == 'true' || lowered == 'yes';
      }
      return fallback;
    }

    double? readDouble(String key) {
      final value = item[key];
      if (value is double) return value;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value.trim());
      return null;
    }

    final verificationStep = readInt(
      'verification_step',
      readBool('is_verified', readBool('verified')) ? 2 : 1,
    );
    final verificationStatus = readString('verification_status');
    final isVerified = readBool('is_verified', readBool('verified')) ||
        verificationStep >= 2 ||
        verificationStatus.toLowerCase().contains('verified');

    return _RbiPerson(
      apiId: readInt('id', 0),
      name: readString('full_name', readString('name', 'Unknown Resident')),
      idNo: readString('rbi_id', 'RBI-UNKNOWN'),
      age: readInt('age', 0),
      gender: readString('gender', 'Prefer not to say'),
      verified: isVerified,
      disabilityTag: readString('disability_tag', 'None'),
      bloodDonor: readBool('blood_donor_opt_in'),
      bloodType: readString('blood_type', 'N/A'),
      barangay: readString('barangay', 'N/A'),
      zonePurok: readString('zone_purok', 'N/A'),
      vaccinationCount: readInt('vaccination_count', 0),
      educationAidStatus: readString('education_aid_status', 'Not Enrolled'),
      bmi: readDouble('latest_bmi'),
      verificationStep: verificationStep,
    );
  }

  Future<_OfficialRbiApiActionResult> updateVerification({
    required int recordId,
    required bool verified,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _OfficialRbiApiActionResult(
        success: false,
        message: 'Login required.',
      );
    }
    final body = jsonEncode({'verified': verified});
    final paths = <String>[
      'rbi/records/$recordId/verification',
      'rbi/records/$recordId/verify',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http.patch(
            endpoint,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_authToken',
            },
            body: body,
          ).timeout(const Duration(seconds: 8));
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode >= 200 && response.statusCode < 300) {
            return _OfficialRbiApiActionResult(
              success: true,
              message: _extractApiMessage(response.body, 'RBI verification updated.'),
            );
          }
          return _OfficialRbiApiActionResult(
            success: false,
            message: _extractApiMessage(response.body, 'Unable to update RBI verification.'),
          );
        } on TimeoutException {
          return const _OfficialRbiApiActionResult(
            success: false,
            message: 'Verification request timed out.',
          );
        } catch (_) {
          return const _OfficialRbiApiActionResult(
            success: false,
            message: 'Unable to update verification.',
          );
        }
      }
    }
    return const _OfficialRbiApiActionResult(
      success: false,
      message: 'Verification endpoint unavailable.',
    );
  }

  String _extractApiMessage(String body, String fallback) {
    try {
      final decoded = _AuthApi.instance._decodeDynamicJson(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }
      }
    } catch (_) {}
    return fallback;
  }
}

class _OfficialRbiApiActionResult {
  final bool success;
  final String message;

  const _OfficialRbiApiActionResult({
    required this.success,
    required this.message,
  });
}

class _OfficialRbiProfilePage extends StatefulWidget {
  final _RbiPerson person;
  const _OfficialRbiProfilePage({required this.person});

  @override
  State<_OfficialRbiProfilePage> createState() => _OfficialRbiProfilePageState();
}

class _OfficialRbiProfilePageState extends State<_OfficialRbiProfilePage> {
  late bool _verified;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _verified = widget.person.verified || widget.person.verificationStep >= 2;
  }

  Future<void> _toggleVerification() async {
    if (widget.person.apiId <= 0) {
      _showFeature(
        context,
        'This record has no backend ID yet.',
        tone: _ToastTone.warning,
      );
      return;
    }
    setState(() => _saving = true);
    final next = !_verified;
    final result = await _OfficialRbiApi.instance.updateVerification(
      recordId: widget.person.apiId,
      verified: next,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    _showFeature(
      context,
      result.message,
      tone: result.success ? _ToastTone.success : _ToastTone.warning,
    );
    if (result.success) {
      setState(() => _verified = next);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final person = widget.person;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Resident RBI Profile'),
        backgroundColor: _officialHeaderStart,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: _verified
                      ? const Color(0xFFE8F8EF)
                      : const Color(0xFFF7F0E8),
                  child: Text(
                    person.name.trim().isEmpty
                        ? '?'
                        : person.name.trim().substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: _verified
                          ? const Color(0xFF1A8F50)
                          : const Color(0xFFB9771D),
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: const TextStyle(
                          color: _officialText,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        person.idNo,
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
          const SizedBox(height: 10),
          _officialDataCard([
            ('Age', '${person.age}'),
            ('Gender', person.gender),
            ('Status', _verified ? 'Verified' : 'Unverified'),
            ('Barangay', person.barangay),
            ('Zone / Purok', person.zonePurok),
            ('PWD Tag', person.disabilityTag),
            ('Blood Donor', person.bloodDonor ? 'Yes (${person.bloodType})' : 'No'),
            ('Vaccinations', '${person.vaccinationCount}'),
            ('Education Aid', person.educationAidStatus),
            ('BMI Snapshot', person.bmi == null ? 'No log yet' : person.bmi!.toStringAsFixed(1)),
            ('Last Updated', 'February 22, 2026'),
          ]),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _saving ? null : _toggleVerification,
                  style: FilledButton.styleFrom(
                    backgroundColor: _officialHeaderStart,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(
                    _verified
                        ? Icons.rule_folder_outlined
                        : Icons.verified_user_outlined,
                  ),
                  label: Text(
                    _saving
                        ? 'Saving...'
                        : (_verified ? 'Mark Unverified' : 'Verify Record'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showFeature(context, 'RBI profile export prepared'),
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('Print Record'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OfficialProfileSettingsPage extends StatefulWidget {
  const OfficialProfileSettingsPage({super.key});

  @override
  State<OfficialProfileSettingsPage> createState() =>
      _OfficialProfileSettingsPageState();
}

class OfficialBarangaySetupPage extends StatefulWidget {
  const OfficialBarangaySetupPage({super.key});

  @override
  State<OfficialBarangaySetupPage> createState() =>
      _OfficialBarangaySetupPageState();
}

class _OfficialBarangaySetupPageState extends State<OfficialBarangaySetupPage> {
  final _population = TextEditingController(
    text: _officialBarangaySetup.population.toString(),
  );
  final _divisionCount = TextEditingController(
    text: _officialBarangaySetup.divisionCount.toString(),
  );
  String _divisionType = _officialBarangaySetup.divisionType;
  final _foundedYear = TextEditingController(
    text: _officialBarangaySetup.foundingYear.toString(),
  );
  final _website = TextEditingController(text: _officialBarangaySetup.website);
  final _facebook = TextEditingController(text: _officialBarangaySetup.facebook);
  final _latitude = TextEditingController(
    text: _formatCoordinateValue(_officialBarangaySetup.latitude),
  );
  final _longitude = TextEditingController(
    text: _formatCoordinateValue(_officialBarangaySetup.longitude),
  );
  Uint8List? _logoBytes = _officialBarangaySetup.logoBytes;
  String? _logoName = _officialBarangaySetup.logoFileName;
  bool _saving = false;

  @override
  void dispose() {
    _population.dispose();
    _divisionCount.dispose();
    _foundedYear.dispose();
    _website.dispose();
    _facebook.dispose();
    _latitude.dispose();
    _longitude.dispose();
    super.dispose();
  }

  InputDecoration _field(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _actBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _actBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _actRed, width: 1.2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  Future<void> _pickFoundingYear() async {
    final currentYear = DateTime.now().year;
    var selectedYear =
        int.tryParse(_foundedYear.text.trim()) ?? _officialBarangaySetup.foundingYear;
    selectedYear = selectedYear.clamp(_minimumFoundingYear, currentYear).toInt();

    final pickedYear = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        var tempYear = selectedYear;
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Select Founding Year'),
              content: DropdownButtonFormField<int>(
                initialValue: tempYear,
                decoration: _field('Founding Year'),
                items: [
                  for (var year = currentYear; year >= _minimumFoundingYear; year--)
                    DropdownMenuItem<int>(value: year, child: Text('$year')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setLocalState(() => tempYear = value);
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, tempYear),
                  style: FilledButton.styleFrom(backgroundColor: _actRed),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );

    if (pickedYear == null || !mounted) {
      return;
    }
    setState(() => _foundedYear.text = '$pickedYear');
  }

  Future<void> _pickBarangayLogo() async {
    final result = await _pickAndPrepareBarangayLogo();
    if (result == null || !mounted) {
      return;
    }
    setState(() {
      _logoBytes = result.bytes;
      _logoName = result.fileName;
    });
  }

  Future<void> _saveSetup() async {
    final population = int.tryParse(_population.text.trim());
    final divisionCount = int.tryParse(_divisionCount.text.trim());
    final foundingYear = int.tryParse(_foundedYear.text.trim());
    final latitude = _parseCoordinateValue(_latitude.text, min: -90, max: 90);
    final longitude = _parseCoordinateValue(_longitude.text, min: -180, max: 180);

    if (population == null || population <= 0) {
      _showFeature(context, 'Population must be a valid number.');
      return;
    }
    if (divisionCount == null || divisionCount <= 0) {
      _showFeature(context, 'Division count must be a valid number.');
      return;
    }
    if (foundingYear == null || !_isValidFoundingYearValue(foundingYear)) {
      _showFeature(
        context,
        'Founding year must be between $_minimumFoundingYear and ${DateTime.now().year}.',
      );
      return;
    }
    if (!_isValidSchemaUrl(_website.text) || !_isValidSchemaUrl(_facebook.text)) {
      _showFeature(
        context,
        'Website and Facebook links must start with http:// or https://.',
      );
      return;
    }
    if (latitude == null || longitude == null) {
      _showFeature(context, 'Latitude and longitude must be valid values.');
      return;
    }

    setState(() => _saving = true);

    _officialBarangaySetup
      ..population = population
      ..divisionType = _divisionType
      ..divisionCount = divisionCount
      ..foundingYear = foundingYear
      ..website = _website.text.trim()
      ..facebook = _facebook.text.trim()
      ..latitude = latitude
      ..longitude = longitude
      ..logoBytes = _logoBytes
      ..logoFileName = _logoName;

    final result = await _AuthApi.instance.completeOfficialActivation(
      payload: {
        'population': population,
        'division_type': _divisionType,
        'division_count': divisionCount,
        'founding_year': foundingYear,
        if (_website.text.trim().isNotEmpty) 'website': _website.text.trim(),
        if (_facebook.text.trim().isNotEmpty)
          'facebook_url': _facebook.text.trim(),
        'latitude': latitude,
        'longitude': longitude,
        if (_logoName != null) 'logo_file_name': _logoName,
        if (_logoBytes != null) 'logo_image_base64': base64Encode(_logoBytes!),
      },
    );

    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    _showFeature(
      context,
      result.success
          ? 'Barangay setup saved.'
          : 'Saved locally. ${result.message}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _actSurface,
      appBar: AppBar(
        title: const Text('Barangay Setup'),
        backgroundColor: Colors.white,
        foregroundColor: _officialText,
      ),
      body: Column(
        children: [
          Expanded(
            child: _ActivationSetupStep(
              field: _field,
              population: _population,
              divisionCount: _divisionCount,
              divisionType: _divisionType,
              onDivision: (v) => setState(() => _divisionType = v ?? 'Zone'),
              foundedYear: _foundedYear,
              website: _website,
              facebook: _facebook,
              latitude: _latitude,
              longitude: _longitude,
              logoBytes: _logoBytes,
              logoName: _logoName,
              onPickFoundedYear: _pickFoundingYear,
              onPickLogo: _pickBarangayLogo,
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _saveSetup,
                  style: FilledButton.styleFrom(
                    backgroundColor: _actRed,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(_saving ? 'SAVING...' : 'SAVE SETUP'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialProfileSettingsPageState
    extends State<OfficialProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const _ProfileEditorPage(role: UserRole.official);
  }
}

class OfficialAccountSettingsPage extends StatefulWidget {
  const OfficialAccountSettingsPage({super.key});

  @override
  State<OfficialAccountSettingsPage> createState() =>
      _OfficialAccountSettingsPageState();
}

class _OfficialAccountSettingsPageState
    extends State<OfficialAccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const _SecurePinSettingsPage(role: UserRole.official);
  }
}

class OfficialFaqsPage extends StatefulWidget {
  const OfficialFaqsPage({super.key});

  @override
  State<OfficialFaqsPage> createState() => _OfficialFaqsPageState();
}

class _OfficialFaqsPageState extends State<OfficialFaqsPage> {
  @override
  Widget build(BuildContext context) {
    return const _FaqCenterPage(role: UserRole.official);
  }
}

class OfficialNotificationsPage extends StatefulWidget {
  const OfficialNotificationsPage({super.key});

  @override
  State<OfficialNotificationsPage> createState() =>
      _OfficialNotificationsPageState();
}

class _OfficialNotificationsPageState extends State<OfficialNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return const _AdvancedNotificationCenterPage(role: UserRole.official);
  }
}

class OfficialSupportPage extends StatelessWidget {
  const OfficialSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HelpDeskPage(role: UserRole.official);
  }
}

class OfficialSharePage extends StatelessWidget {
  const OfficialSharePage({super.key});

  static const _shareMessage =
      'Download BarangayMo to access barangay services, requests, and '
      'community updates in one app.';
  static const _androidLink =
      'https://play.google.com/store/apps/details?id=ph.barangaymo.official';
  static const _iosLink = 'https://apps.apple.com/ph/app/barangaymo-official';

  Widget _shareOptionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String actionText,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showFeature(context, actionText),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _officialHeaderStart),
            const SizedBox(width: 9),
            Text(
              label,
              style: const TextStyle(
                color: _officialText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storeButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String link,
  }) {
    return OutlinedButton.icon(
      onPressed: () => _showFeature(context, 'Open store link: $link'),
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: _officialHeaderStart,
        side: const BorderSide(color: _officialCardBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share'),
        backgroundColor: _officialHeaderStart,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFBF5F5), Color(0xFFF8F2F2)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                const Text(
                  'BarangayMo Officials',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    color: _officialText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Help your staff and partner offices coordinate requests and service updates through BarangayMo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _officialCardBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset('public/barangaymo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _officialCardBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x10000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Share Options',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: _officialHeaderStart,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _shareOptionTile(
                        context: context,
                        icon: Icons.email_outlined,
                        label: 'SHARE VIA EMAIL',
                        actionText: 'Preparing official email share...',
                      ),
                      _shareOptionTile(
                        context: context,
                        icon: Icons.facebook,
                        label: 'SHARE VIA FACEBOOK',
                        actionText: 'Preparing official Facebook share...',
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3F3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF2DADA)),
                        ),
                        child: const Text(
                          _shareMessage,
                          style: TextStyle(
                            color: Color(0xFF5C556E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _officialCardBorder),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'App Store Links',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: _officialHeaderStart,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _storeButton(
                              context: context,
                              icon: Icons.apple,
                              label: 'App Store',
                              link: _iosLink,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _storeButton(
                              context: context,
                              icon: Icons.play_arrow_rounded,
                              label: 'Google Play',
                              link: _androidLink,
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
        ),
      ),
    );
  }
}

class OfficialBugReportPage extends StatefulWidget {
  const OfficialBugReportPage({super.key});

  @override
  State<OfficialBugReportPage> createState() => _OfficialBugReportPageState();
}

class _OfficialBugReportPageState extends State<OfficialBugReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _bugName = TextEditingController();
  final _description = TextEditingController();
  String _severity = 'Medium';
  bool _attachmentAdded = false;
  bool _submitting = false;

  @override
  void dispose() {
    _bugName.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Bug Report'),
        backgroundColor: const Color(0xFFF4F5F9),
        foregroundColor: _officialText,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _officialCardBorder),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _bugName,
                    decoration: const InputDecoration(labelText: 'Bug Name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _description,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (v) => (v == null || v.trim().length < 10)
                        ? 'At least 10 characters'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _severity,
                    decoration: const InputDecoration(labelText: 'Severity'),
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                    ],
                    onChanged: (v) => setState(() => _severity = v ?? 'Medium'),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE6E8F2)),
                    ),
                    leading: Icon(
                      _attachmentAdded
                          ? Icons.check_circle_rounded
                          : Icons.upload_file_outlined,
                      color: _attachmentAdded
                          ? const Color(0xFF18A55D)
                          : _officialHeaderStart,
                    ),
                    title: Text(
                      _attachmentAdded
                          ? 'Screenshot attached'
                          : 'Upload Screenshot',
                    ),
                    trailing: TextButton(
                      onPressed: () =>
                          setState(() => _attachmentAdded = !_attachmentAdded),
                      child: Text(_attachmentAdded ? 'Remove' : 'Attach'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submitting
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _submitting = true);
                          final result = await _SupportApi.instance.submitBugReport(
                            role: UserRole.official,
                            bugName: _bugName.text.trim(),
                            description: _description.text.trim(),
                            severity: _severity,
                          );
                          if (!mounted) return;
                          setState(() => _submitting = false);
                          _showFeature(
                            context,
                            result.message,
                            tone: result.success
                                ? _ToastTone.success
                                : _ToastTone.warning,
                          );
                          if (result.success) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _officialHeaderStart,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_submitting ? 'Submitting...' : 'Submit Ticket'),
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

class OfficialTermsPoliciesPage extends StatefulWidget {
  const OfficialTermsPoliciesPage({super.key});

  @override
  State<OfficialTermsPoliciesPage> createState() =>
      _OfficialTermsPoliciesPageState();
}

class _OfficialTermsPoliciesPageState extends State<OfficialTermsPoliciesPage> {
  bool _loading = true;
  List<({String title, String body})> _entries =
      const <({String title, String body})>[];

  @override
  void initState() {
    super.initState();
    unawaited(_loadPolicies());
  }

  Future<void> _loadPolicies() async {
    setState(() => _loading = true);
    final result = await _SupportApi.instance.fetchPolicies(UserRole.official);
    if (!mounted) return;
    if (result.success && result.entries.isNotEmpty) {
      setState(() {
        _entries = result.entries;
        _loading = false;
      });
      return;
    }
    setState(() {
      _entries = const <({String title, String body})>[
        (
          title: 'Privacy Policy',
          body:
              'BarangayMo collects only the personal data required for service delivery, verification, and records management. All sensitive data is protected and used in compliance with local policies.',
        ),
        (
          title: 'Terms and Conditions',
          body:
              'By using BarangayMo, users agree to provide truthful information and comply with barangay process requirements. False declarations may result in request rejection and account restrictions.',
        ),
      ];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Terms & Policies'),
        backgroundColor: const Color(0xFFF4F5F9),
        foregroundColor: _officialText,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            ..._entries.map(
              (entry) => _policyTile(
                context,
                title: entry.title,
                body: entry.body,
              ),
            ),
        ],
      ),
    );
  }

  Widget _policyTile(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _officialCardBorder),
      ),
      child: ListTile(
        leading: const Icon(Icons.policy_outlined, color: _officialHeaderStart),
        title: Text(
          title,
          style: const TextStyle(
            color: _officialText,
            fontWeight: FontWeight.w800,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OfficialPolicyDocumentPage(title: title, body: body),
          ),
        ),
      ),
    );
  }
}

class OfficialPolicyDocumentPage extends StatelessWidget {
  final String title;
  final String body;
  const OfficialPolicyDocumentPage({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF4F5F9),
        foregroundColor: _officialText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          body,
          style: const TextStyle(
            color: _officialText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class OfficialLogoutPage extends StatelessWidget {
  const OfficialLogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Log out'),
        backgroundColor: const Color(0xFFF4F5F9),
        foregroundColor: _officialText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _officialDataCard([
              ('Session', 'Barangay Official'),
              ('Status', 'Active'),
            ]),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEDEFF6),
                  foregroundColor: _officialText,
                ),
                child: const Text('Go Back'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
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
                    MaterialPageRoute(
                      builder: (_) => const RoleGatewayScreen(),
                    ),
                    (_) => false,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _officialHeaderStart,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfficialDeleteAccountPage extends StatefulWidget {
  const OfficialDeleteAccountPage({super.key});

  @override
  State<OfficialDeleteAccountPage> createState() =>
      _OfficialDeleteAccountPageState();
}

class _OfficialDeleteAccountPageState extends State<OfficialDeleteAccountPage> {
  @override
  Widget build(BuildContext context) {
    return const _AccountDeletionWorkflowPage(role: UserRole.official);
  }
}

class _OfficialSecretaryProfilePage extends StatefulWidget {
  const _OfficialSecretaryProfilePage();

  @override
  State<_OfficialSecretaryProfilePage> createState() =>
      _OfficialSecretaryProfilePageState();
}

class _OfficialSecretaryProfilePageState
    extends State<_OfficialSecretaryProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _middleName;
  late final TextEditingController _lastName;
  late final TextEditingController _mobile;
  late final TextEditingController _email;
  late String _suffix;
  late String _idType;
  Uint8List? _idBytes;
  String? _idName;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(
      text: _officialBarangaySetup.secretaryFirstName,
    );
    _middleName = TextEditingController(
      text: _officialBarangaySetup.secretaryMiddleName,
    );
    _lastName = TextEditingController(
      text: _officialBarangaySetup.secretaryLastName,
    );
    _mobile = TextEditingController(text: _officialBarangaySetup.secretaryMobile);
    _email = TextEditingController(text: _officialBarangaySetup.secretaryEmail);
    _suffix = _officialBarangaySetup.secretarySuffix;
    _idType = _officialBarangaySetup.secretaryIdType;
    _idBytes = _officialBarangaySetup.secretaryIdBytes;
    _idName = _officialBarangaySetup.secretaryIdFileName;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _middleName.dispose();
    _lastName.dispose();
    _mobile.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickValidId() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 92,
    );
    if (picked == null) {
      return;
    }
    final bytes = await picked.readAsBytes();
    if (!mounted) {
      return;
    }
    setState(() {
      _idBytes = bytes;
      _idName = picked.name;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_idBytes == null) {
      _showFeature(context, 'Upload a valid ID for the secretary profile.');
      return;
    }
    _officialBarangaySetup
      ..secretaryFirstName = _firstName.text.trim()
      ..secretaryMiddleName = _middleName.text.trim()
      ..secretaryLastName = _lastName.text.trim()
      ..secretarySuffix = _suffix
      ..secretaryMobile = _mobile.text.trim()
      ..secretaryEmail = _email.text.trim()
      ..secretaryIdType = _idType
      ..secretaryIdBytes = _idBytes
      ..secretaryIdFileName = _idName;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Secretary Profile'),
        backgroundColor: _officialHeaderStart,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _officialCardBorder),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Barangay Secretary Directory Profile',
                    style: TextStyle(
                      color: _officialText,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _firstName,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _middleName,
                    decoration: const InputDecoration(
                      labelText: 'Middle Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastName,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _suffix,
                    decoration: const InputDecoration(labelText: 'Suffix'),
                    items: const [
                      DropdownMenuItem(value: 'None', child: Text('None')),
                      DropdownMenuItem(value: 'Jr.', child: Text('Jr.')),
                      DropdownMenuItem(value: 'Sr.', child: Text('Sr.')),
                      DropdownMenuItem(value: 'III', child: Text('III')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _suffix = value);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _mobile,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Mobile Number'),
                    validator: (v) =>
                        (v == null || v.trim().length < 10) ? 'Invalid' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Official Email'),
                    validator: (v) =>
                        (v == null || !v.contains('@')) ? 'Invalid email' : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _idType,
                    decoration: const InputDecoration(labelText: 'Valid ID Type'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Digital National ID',
                        child: Text('Digital National ID'),
                      ),
                      DropdownMenuItem(
                        value: 'PhilHealth ID',
                        child: Text('PhilHealth ID'),
                      ),
                      DropdownMenuItem(
                        value: 'Passport',
                        child: Text('Passport'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _idType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Valid ID Upload',
                    style: TextStyle(
                      color: _officialText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickValidId,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _officialCardBorder),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _idBytes == null
                          ? const Center(
                              child: Text(
                                'Tap to upload secretary valid ID',
                                style: TextStyle(
                                  color: _officialSubtext,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : Image.memory(_idBytes!, fit: BoxFit.cover),
                    ),
                  ),
                  if (_idName != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _idName!,
                      style: const TextStyle(
                        color: _officialSubtext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: _officialHeaderStart,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save Secretary Profile'),
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

class _OfficialSignaturePadPage extends StatefulWidget {
  const _OfficialSignaturePadPage();

  @override
  State<_OfficialSignaturePadPage> createState() => _OfficialSignaturePadPageState();
}

class _OfficialSignaturePadPageState extends State<_OfficialSignaturePadPage> {
  late final TextEditingController _signatureName;
  late List<List<Offset>> _strokes;
  final List<List<Offset>> _redoStrokes = <List<Offset>>[];
  List<Offset>? _activeStroke;

  @override
  void initState() {
    super.initState();
    _signatureName = TextEditingController(
      text: _officialBarangaySetup.punongSignatureText,
    );
    _strokes = _officialBarangaySetup.punongSignaturePaths
        .map((stroke) => List<Offset>.from(stroke))
        .toList();
  }

  @override
  void dispose() {
    _signatureName.dispose();
    super.dispose();
  }

  void _startStroke(DragStartDetails details) {
    setState(() {
      _activeStroke = [details.localPosition];
      _redoStrokes.clear();
    });
  }

  void _appendStroke(DragUpdateDetails details) {
    if (_activeStroke == null) {
      return;
    }
    setState(() => _activeStroke!.add(details.localPosition));
  }

  void _endStroke(DragEndDetails details) {
    if (_activeStroke == null || _activeStroke!.isEmpty) {
      return;
    }
    setState(() {
      _strokes.add(List<Offset>.from(_activeStroke!));
      _activeStroke = null;
    });
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _redoStrokes.clear();
      _activeStroke = null;
    });
  }

  void _undo() {
    if (_strokes.isEmpty) {
      return;
    }
    setState(() => _redoStrokes.add(_strokes.removeLast()));
  }

  void _redo() {
    if (_redoStrokes.isEmpty) {
      return;
    }
    setState(() => _strokes.add(_redoStrokes.removeLast()));
  }

  void _save() {
    if (_signatureName.text.trim().isEmpty) {
      _showFeature(context, 'Type the punong barangay signature label first.');
      return;
    }
    if (_strokes.isEmpty) {
      _showFeature(context, 'Draw the digital signature on the pad first.');
      return;
    }
    _officialBarangaySetup
      ..punongSignatureText = _signatureName.text.trim()
      ..punongSignaturePaths =
          _strokes.map((stroke) => List<Offset>.from(stroke)).toList();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final previewStrokes = [
      ..._strokes,
      if (_activeStroke != null && _activeStroke!.isNotEmpty)
        List<Offset>.from(_activeStroke!),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Punong Signature Pad'),
        backgroundColor: _officialHeaderStart,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _officialCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _signatureName,
                  decoration: const InputDecoration(
                    labelText: 'Punong Barangay Signature Label',
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _officialCardBorder),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: GestureDetector(
                    onPanStart: _startStroke,
                    onPanUpdate: _appendStroke,
                    onPanEnd: _endStroke,
                    child: CustomPaint(
                      painter: _OfficialSignaturePainter(strokes: previewStrokes),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use the signature pad below for the official e-sign. Undo and redo preserve senior revisions before saving.',
                  style: TextStyle(
                    color: _officialSubtext,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clear,
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _undo,
                        child: const Text('Undo'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _redo,
                        child: const Text('Redo'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: _officialHeaderStart,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Signature'),
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

class _OfficialSignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;

  const _OfficialSignaturePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _officialHeaderStart
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      if (stroke.length < 2) {
        continue;
      }
      final path = ui.Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final point in stroke.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OfficialSignaturePainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}

Widget _officialDataCard(List<(String, String)> rows) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _officialCardBorder),
    ),
    child: Column(
      children: rows
          .map(
            (row) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFECEEF5))),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 118,
                    child: Text(
                      row.$1,
                      style: const TextStyle(
                        color: _officialSubtext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row.$2,
                      style: const TextStyle(
                        color: _officialText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}

class _CouncilMember {
  String name;
  String role;
  String committee;
  final bool pinned;
  _CouncilMember({
    required this.name,
    required this.role,
    required this.committee,
    this.pinned = false,
  });
}
