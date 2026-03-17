part of barangaymo_app;

class ResidentSettingsPage extends StatefulWidget {
  const ResidentSettingsPage({super.key});

  @override
  State<ResidentSettingsPage> createState() => _ResidentSettingsPageState();
}

class _ResidentSettingsPageState extends State<ResidentSettingsPage> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3644B7), Color(0xFF6B79E9)],
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
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Your Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Control security, profile updates, and preferences.',
                          style: TextStyle(color: Color(0xFFDDE1FF)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE6E8F4)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: _pushNotifications,
                    onChanged: (v) => setState(() => _pushNotifications = v),
                    title: Text(
                      _appText('Push Notifications', 'Push Notifications'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      _appText(
                        'Receive account and service updates',
                        'Tumanggap ng mga update sa account at serbisyo',
                      ),
                    ),
                    activeThumbColor: const Color(0xFF2E35D3),
                    activeTrackColor: const Color(0xFFBAC0FF),
                  ),
                  const Divider(height: 1),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: _appThemeMode,
                    builder: (_, mode, __) => SwitchListTile.adaptive(
                      value: mode == ThemeMode.dark,
                      onChanged: (v) => setState(() => _setDarkModeEnabled(v)),
                      title: Text(
                        _appText('Dark Mode', 'Dark Mode'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        _appText(
                          'Use a darker color scheme at night',
                          'Gumamit ng mas madilim na kulay sa gabi',
                        ),
                      ),
                      activeThumbColor: const Color(0xFF2E35D3),
                      activeTrackColor: const Color(0xFFBAC0FF),
                    ),
                  ),
                  const Divider(height: 1),
                  ValueListenableBuilder<_AppLocalePreference>(
                    valueListenable: _appLocalePreference,
                    builder: (_, locale, __) => SwitchListTile.adaptive(
                      value: locale == _AppLocalePreference.tagalog,
                      onChanged: (v) => setState(() => _setTagalogEnabled(v)),
                      title: Text(
                        _appText('Tagalog Interface', 'Tagalog Interface'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        _appText(
                          'Switch between English and Tagalog labels',
                          'Magpalit sa English at Tagalog na mga label',
                        ),
                      ),
                      activeThumbColor: const Color(0xFF2E35D3),
                      activeTrackColor: const Color(0xFFBAC0FF),
                    ),
                  ),
                  const Divider(height: 1),
                  _settingsTile(
                    context,
                    title: 'Secure Settings',
                    icon: Icons.lock_reset,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const _SecurePinSettingsPage(role: UserRole.resident),
                      ),
                    ),
                  ),
                  _settingsTile(
                    context,
                    title: 'Edit Profile',
                    icon: Icons.person_outline,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const _ProfileEditorPage(role: UserRole.resident),
                      ),
                    ),
                  ),
                  _settingsTile(
                    context,
                    title: 'Notification Center',
                    icon: Icons.notifications_none_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const _AdvancedNotificationCenterPage(
                              role: UserRole.resident,
                            ),
                      ),
                    ),
                  ),
                  _settingsTile(
                    context,
                    title: 'Security Log',
                    icon: Icons.security_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const _SecurityLogPage(role: UserRole.resident),
                      ),
                    ),
                  ),
                  _settingsTile(
                    context,
                    title: 'Transaction History',
                    icon: Icons.history_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const _TransactionHistoryPage(role: UserRole.resident),
                      ),
                    ),
                  ),
                  _settingsTile(
                    context,
                    title: 'Help Desk',
                    icon: Icons.support_agent_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const _HelpDeskPage(role: UserRole.resident),
                      ),
                    ),
                  ),
                  _settingsTile(
                    context,
                    title: 'About',
                    icon: Icons.info_outline,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _AboutPage(role: UserRole.resident),
                      ),
                    ),
                  ),
                  _settingsTile(
                    context,
                    title: 'FAQs',
                    icon: Icons.quiz_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _FaqCenterPage(role: UserRole.resident),
                      ),
                    ),
                  ),
                  _settingsTile(
                    context,
                    title: 'Delete Account',
                    icon: Icons.delete_outline,
                    danger: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _AccountDeletionWorkflowPage(
                          role: UserRole.resident,
                        ),
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

  Widget _settingsTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final color = danger ? const Color(0xFFD74637) : const Color(0xFF404662);
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w700, color: color),
      ),
      trailing: Icon(Icons.chevron_right, color: color),
      onTap: onTap,
    );
  }
}

class ResidentChangePasswordPage extends StatelessWidget {
  const ResidentChangePasswordPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 8),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _showFeature(context, 'Password updated'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E35D3),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResidentChangeEmailPage extends StatelessWidget {
  const ResidentChangeEmailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Email')),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'New Email')),
            SizedBox(height: 8),
            TextField(decoration: InputDecoration(labelText: 'Confirm Email')),
          ],
        ),
      ),
    );
  }
}

class ResidentChangeAddressPage extends StatelessWidget {
  const ResidentChangeAddressPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Address')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          12,
          12,
          12 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ListView(
          children: [
            const _StepTabs(active: 'Address'),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Please Complete Your Address Details:',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(labelText: '1. Select Province'),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: '2. Select City/Municipality',
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(labelText: '3. Select Barangay'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _showFeature(context, 'Address saved'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E35D3),
                ),
                child: const Text('CONTINUE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResidentDeleteAccountPage extends StatefulWidget {
  const ResidentDeleteAccountPage({super.key});

  @override
  State<ResidentDeleteAccountPage> createState() =>
      _ResidentDeleteAccountPageState();
}

class _ResidentDeleteAccountPageState extends State<ResidentDeleteAccountPage> {
  final _confirmController = TextEditingController();
  bool _accepted = false;

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    final typed = _confirmController.text.trim().toUpperCase();
    if (typed != 'DELETE') {
      _showFeature(context, 'Type DELETE to continue.');
      return;
    }
    if (!_accepted) {
      _showFeature(context, 'Please confirm account deletion notice.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: const Text(
          'This action permanently deletes your resident account and profile records. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD74637),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleGatewayScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FF), Color(0xFFF9F1EF)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFF1D4D4)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFD74637),
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Before You Continue',
                        style: TextStyle(
                          color: Color(0xFFAC3226),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Deleting your account is permanent. Your profile, requests, and saved records will no longer be accessible.',
                    style: TextStyle(
                      color: Color(0xFF5A607B),
                      fontWeight: FontWeight.w600,
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
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE6E8F4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Type DELETE to confirm',
                    style: TextStyle(
                      color: Color(0xFF32374E),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _confirmController,
                    decoration: const InputDecoration(
                      hintText: 'DELETE',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    value: _accepted,
                    onChanged: (v) => setState(() => _accepted = v ?? false),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'I understand this action cannot be undone.',
                      style: TextStyle(
                        color: Color(0xFF4E546F),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _handleDelete,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD74637),
                ),
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text('Delete Account Permanently'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResidentMemberListPage extends StatelessWidget {
  const ResidentMemberListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Added Member Profiles')),
      body: Column(
        children: [
          const Expanded(child: Center(child: Text('No Added Profiles'))),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ResidentAddMemberPage(),
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E35D3),
                ),
                child: const Text('Add New Member'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResidentAddMemberPage extends StatefulWidget {
  const ResidentAddMemberPage({super.key});

  @override
  State<ResidentAddMemberPage> createState() => _ResidentAddMemberPageState();
}

class _ResidentAddMemberPageState extends State<ResidentAddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _dobController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _genderController = TextEditingController();
  final _religionController = TextEditingController();
  final _civilStatusController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _dobController.dispose();
    _birthPlaceController.dispose();
    _bloodTypeController.dispose();
    _genderController.dispose();
    _religionController.dispose();
    _civilStatusController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _showFeature(
      context,
      'New resident profile saved for ${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Resident'),
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
        child: Form(
          key: _formKey,
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
                    colors: [Color(0xFF3746B9), Color(0xFF6B78E8)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x262E35D3),
                      blurRadius: 13,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0x33FFFFFF),
                      child: Icon(Icons.person_add, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resident Profile Intake',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Capture identity and household details for records.',
                            style: TextStyle(color: Color(0xFFDDE1FF)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _memberInput(
                controller: _firstNameController,
                label: 'First Name *',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'First name is required.'
                    : null,
              ),
              const SizedBox(height: 8),
              _memberInput(
                controller: _middleNameController,
                label: 'Middle Name (Optional)',
              ),
              const SizedBox(height: 8),
              _memberInput(
                controller: _lastNameController,
                label: 'Last Name *',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Last name is required.'
                    : null,
              ),
              const SizedBox(height: 8),
              _memberInput(
                controller: _suffixController,
                label: 'Suffix (Optional)',
              ),
              const SizedBox(height: 8),
              _memberInput(
                controller: _dobController,
                label: 'Date of Birth *',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Date of birth is required.'
                    : null,
              ),
              const SizedBox(height: 8),
              _memberInput(
                controller: _birthPlaceController,
                label: 'Place of Birth',
              ),
              const SizedBox(height: 8),
              _memberInput(
                controller: _bloodTypeController,
                label: 'Blood Type',
              ),
              const SizedBox(height: 8),
              _memberInput(controller: _genderController, label: 'Gender'),
              const SizedBox(height: 8),
              _memberInput(controller: _religionController, label: 'Religion'),
              const SizedBox(height: 8),
              _memberInput(
                controller: _civilStatusController,
                label: 'Civil Status',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2E35D3),
          ),
          child: const Text('Save and Finish'),
        ),
      ),
    );
  }

  Widget _memberInput({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4E7F4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4B56BA), width: 1.4),
        ),
      ),
    );
  }
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _query = '';

  static const _faqItems = [
    (
      'How do I request a barangay clearance?',
      'Open Services > Clearance, complete your profile details, submit purpose, and track status in Requests.',
      'Clearance',
    ),
    (
      'How long does assistance approval take?',
      'Assistance requests are reviewed within 1-3 working days depending on document completeness.',
      'Assistance',
    ),
    (
      'How do I verify my RBI profile?',
      'Go to Profile > Verify Account, complete required details, and upload valid supporting documents.',
      'RBI',
    ),
    (
      'Can I update my address after registration?',
      'Yes. Open Settings > Change Address and submit your updated barangay details.',
      'Account',
    ),
    (
      'How do I report an emergency incident?',
      'Go to Services > BPAT or Responder and select report/patrol request for immediate action.',
      'Safety',
    ),
    (
      'How do I contact support?',
      'Use Support page quick actions (call, email, FAQ search, or submit a ticket).',
      'Support',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final items = _faqItems.where((item) {
      final bag = '${item.$1} ${item.$2} ${item.$3}'.toLowerCase();
      return q.isEmpty || bag.contains(q);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4453C8), Color(0xFF7382F0)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x233441B2),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.help_center, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search using keywords...',
              ),
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.search_off),
                  title: Text('No FAQ results found'),
                ),
              )
            else
              ...items.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFE6E8F4)),
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    title: Text(
                      item.$1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F3248),
                      ),
                    ),
                    subtitle: Text(
                      item.$3,
                      style: const TextStyle(
                        color: Color(0xFF6D7390),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.$2,
                            style: const TextStyle(
                              color: Color(0xFF5C627D),
                              fontWeight: FontWeight.w600,
                            ),
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
    );
  }
}

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy and Terms'),
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4453C8), Color(0xFF6D7CE8)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x223541B3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.policy, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Data Privacy and Platform Terms',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _policyCard(
              title: 'Privacy Policy',
              subtitle: 'Last Updated: Feb 20, 2026',
              points: const [
                'Personal information is used only for barangay service delivery.',
                'Sensitive profile data is protected and access-controlled.',
                'Residents may request profile corrections through Settings.',
              ],
            ),
            const SizedBox(height: 9),
            _policyCard(
              title: 'Terms and Conditions',
              subtitle: 'Last Updated: Feb 20, 2026',
              points: const [
                'Use accurate information for requests and registrations.',
                'Abusive, fraudulent, or false submissions may be blocked.',
                'Service timelines may vary based on document verification.',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _policyCard({
    required String title,
    required String subtitle,
    required List<String> points,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E8F4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E3248),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B728D),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Color(0xFF3FA96D),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      p,
                      style: const TextStyle(
                        color: Color(0xFF5B617D),
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
    );
  }
}

class ResidentFaqPage extends StatelessWidget {
  const ResidentFaqPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const _FaqCenterPage(role: UserRole.resident);
}

class ResidentSharePage extends StatelessWidget {
  const ResidentSharePage({super.key});

  static const _residentPrimary = Color(0xFF3E4CC7);
  static const _residentSoft = Color(0xFFE7ECFF);

  static const _shareMessage =
      'Download BarangayMo Residents to access barangay services, '
      'request documents, and community updates in one app.';
  static const _androidLink =
      'https://play.google.com/store/apps/details?id=ph.barangaymo.residents';
  static const _iosLink = 'https://apps.apple.com/ph/app/barangaymo-residents';

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
            Icon(icon, color: _residentPrimary),
            const SizedBox(width: 9),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2C3147),
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
        foregroundColor: _residentPrimary,
        side: const BorderSide(color: Color(0xFFC7D2FF)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share'),
        backgroundColor: _residentPrimary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FF), Color(0xFFF1F4FF)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                const Text(
                  'BarangayMo Residents',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2A3048),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Help your friends and family discover barangay services and community updates through Smart Barangay.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF616881),
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
                      border: Border.all(color: const Color(0xFFE2E6F2)),
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
                    border: Border.all(color: const Color(0xFFDDE4FA)),
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
                          color: _residentPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _shareOptionTile(
                        context: context,
                        icon: Icons.email_outlined,
                        label: 'SHARE VIA EMAIL',
                        actionText: 'Preparing email with app link...',
                      ),
                      _shareOptionTile(
                        context: context,
                        icon: Icons.facebook,
                        label: 'SHARE VIA FACEBOOK',
                        actionText: 'Preparing Facebook share post...',
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _residentSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFCDD8FF)),
                        ),
                        child: Text(
                          _shareMessage,
                          style: const TextStyle(
                            color: Color(0xFF4C5577),
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
                    border: Border.all(color: const Color(0xFFDDE4FA)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'App Store Links',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: _residentPrimary,
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

class ResidentCommunityChatPage extends StatefulWidget {
  const ResidentCommunityChatPage({super.key});

  @override
  State<ResidentCommunityChatPage> createState() =>
      _ResidentCommunityChatPageState();
}

class _ResidentCommunityChatPageState extends State<ResidentCommunityChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  String _channel = 'General';
  String _barangay = 'West Tapinac';

  static const _registeredBarangays = [
    'West Tapinac',
    'Old Cabalan',
    'Banicain',
    'East Tapinac',
    'Kalaklan',
  ];
  static const _channels = ['General', 'Announcements', 'Health', 'Events'];
  static const _onlineNow = {
    'West Tapinac': 134,
    'Old Cabalan': 98,
    'Banicain': 76,
    'East Tapinac': 88,
    'Kalaklan': 64,
  };
  static const _barangaySecretaries = {
    'West Tapinac': 'Brigette Barrera',
    'Old Cabalan': 'Maricel Dela Cruz',
    'Banicain': 'Jocelyn Reyes',
    'East Tapinac': 'Aileen Santos',
    'Kalaklan': 'Rowena Mendoza',
  };

  late final Map<String, List<_ResidentChatMessage>> _messagesByBarangay = {
    'West Tapinac': [
      _ResidentChatMessage(
        sender: 'Brigette Barrera (Barangay Secretary)',
        text:
            'Secretary desk is now online for West Tapinac concerns and document follow-ups.',
        channel: 'Announcements',
        sentAt: DateTime.now().subtract(const Duration(minutes: 36)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'Barangay Admin',
        text:
            'Good morning residents. Water interruption is scheduled tomorrow 9:00 AM to 12:00 PM.',
        channel: 'Announcements',
        sentAt: DateTime.now().subtract(const Duration(minutes: 34)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'Lester C. Nadong',
        text:
            'Please avoid parking near the barangay hall gate for today\'s relief truck unloading.',
        channel: 'General',
        sentAt: DateTime.now().subtract(const Duration(minutes: 28)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'Shamira Balandra',
        text: 'Noted po, salamat sa update.',
        channel: 'General',
        sentAt: DateTime.now().subtract(const Duration(minutes: 25)),
        isMine: true,
        isOfficial: false,
      ),
      _ResidentChatMessage(
        sender: 'Health Desk',
        text: 'Free blood pressure screening starts at 2:00 PM today.',
        channel: 'Health',
        sentAt: DateTime.now().subtract(const Duration(minutes: 14)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'Shamira Balandra',
        text: 'Can seniors join without prior registration?',
        channel: 'Health',
        sentAt: DateTime.now().subtract(const Duration(minutes: 11)),
        isMine: true,
        isOfficial: false,
      ),
      _ResidentChatMessage(
        sender: 'Health Desk',
        text: 'Yes. Walk-ins are accepted from 1:30 PM onward.',
        channel: 'Health',
        sentAt: DateTime.now().subtract(const Duration(minutes: 9)),
        isMine: false,
        isOfficial: true,
      ),
    ],
    'Old Cabalan': [
      _ResidentChatMessage(
        sender: 'Maricel Dela Cruz (Barangay Secretary)',
        text:
            'Old Cabalan secretary desk is open today for permits, endorsements, and records inquiries.',
        channel: 'Announcements',
        sentAt: DateTime.now().subtract(const Duration(minutes: 24)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'Old Cabalan Admin',
        text:
            'Reminder: Barangay clean-up drive starts at 6:00 AM this Saturday.',
        channel: 'Announcements',
        sentAt: DateTime.now().subtract(const Duration(minutes: 22)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'Rina G.',
        text: 'May truck ba for garbage collection later?',
        channel: 'General',
        sentAt: DateTime.now().subtract(const Duration(minutes: 17)),
        isMine: false,
        isOfficial: false,
      ),
    ],
    'Banicain': [
      _ResidentChatMessage(
        sender: 'Jocelyn Reyes (Barangay Secretary)',
        text:
            'Secretary office reminder: bring valid ID and request form copy for same-day document processing.',
        channel: 'Announcements',
        sentAt: DateTime.now().subtract(const Duration(minutes: 31)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'Banicain Health Desk',
        text: 'Pediatric vaccination is open until 4:00 PM at health center.',
        channel: 'Health',
        sentAt: DateTime.now().subtract(const Duration(minutes: 29)),
        isMine: false,
        isOfficial: true,
      ),
    ],
    'East Tapinac': [
      _ResidentChatMessage(
        sender: 'Aileen Santos (Barangay Secretary)',
        text:
            'East Tapinac secretary desk confirms walk-in records verification until 4:30 PM.',
        channel: 'Announcements',
        sentAt: DateTime.now().subtract(const Duration(minutes: 21)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'East Tapinac SK',
        text: 'Youth sportsfest registration closes tonight at 8:00 PM.',
        channel: 'Events',
        sentAt: DateTime.now().subtract(const Duration(minutes: 19)),
        isMine: false,
        isOfficial: true,
      ),
    ],
    'Kalaklan': [
      _ResidentChatMessage(
        sender: 'Rowena Mendoza (Barangay Secretary)',
        text:
            'Kalaklan secretary office now accepts certificate requests through this chat thread.',
        channel: 'Announcements',
        sentAt: DateTime.now().subtract(const Duration(minutes: 18)),
        isMine: false,
        isOfficial: true,
      ),
      _ResidentChatMessage(
        sender: 'Kalaklan Admin',
        text: 'Road repainting on Olongapo-Bugallon Road starts tomorrow.',
        channel: 'Announcements',
        sentAt: DateTime.now().subtract(const Duration(minutes: 16)),
        isMine: false,
        isOfficial: true,
      ),
    ],
  };

  List<_ResidentChatMessage> get _filteredMessages =>
      (_messagesByBarangay[_barangay] ?? const <_ResidentChatMessage>[])
          .where((m) => m.channel == _channel)
          .toList()
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messagesByBarangay.putIfAbsent(_barangay, () => []);
      _messagesByBarangay[_barangay]!.add(
        _ResidentChatMessage(
          sender: 'Shamira Balandra',
          text: text,
          channel: _channel,
          sentAt: DateTime.now(),
          isMine: true,
          isOfficial: false,
        ),
      );
      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _switchBarangay(String barangay) {
    if (_barangay == barangay) return;
    setState(() {
      _barangay = barangay;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = _filteredMessages;
    final onlineNow = _onlineNow[_barangay] ?? 0;
    final secretary = _barangaySecretaries[_barangay] ?? 'Not assigned';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Chat'),
        backgroundColor: const Color(0xFFF7F8FC),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FC), Color(0xFFF2F4FF)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE1E5F4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEFE3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.forum_rounded,
                            color: Color(0xFFB45309),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_barangay Resident Chat',
                                style: const TextStyle(
                                  color: Color(0xFF2D334A),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                '$onlineNow online now',
                                style: const TextStyle(
                                  color: Color(0xFF5F6682),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Secretary on duty: $secretary',
                                style: const TextStyle(
                                  color: Color(0xFF7A5A3C),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE9E2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Color(0xFFB11E1E),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connected Registered Barangays',
                      style: TextStyle(
                        color: Color(0xFF555D78),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _registeredBarangays.map((entry) {
                          final active = entry == _barangay;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(entry),
                              selected: active,
                              onSelected: (_) => _switchBarangay(entry),
                              selectedColor: const Color(0xFFFFE9E2),
                              labelStyle: TextStyle(
                                color: active
                                    ? const Color(0xFFB11E1E)
                                    : const Color(0xFF4B5371),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _channels.map((entry) {
                          final active = entry == _channel;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(entry),
                              selected: active,
                              onSelected: (_) =>
                                  setState(() => _channel = entry),
                              selectedColor: const Color(0xFFE8EFFF),
                              labelStyle: TextStyle(
                                color: active
                                    ? const Color(0xFF3346A8)
                                    : const Color(0xFF4B5371),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet for $_barangay ($_channel).',
                        style: TextStyle(
                          color: Color(0xFF6A7089),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
                      itemCount: messages.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 7),
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final mine = message.isMine;
                        return Align(
                          alignment: mine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
                            decoration: BoxDecoration(
                              color: mine
                                  ? const Color(0xFFDCE6FF)
                                  : const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: mine
                                    ? const Color(0xFFC3D3FF)
                                    : const Color(0xFFE2E6F4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      message.sender,
                                      style: TextStyle(
                                        color: mine
                                            ? const Color(0xFF3346A8)
                                            : const Color(0xFF2E334A),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (message.isOfficial) ...[
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.verified,
                                        color: Color(0xFF2E8B57),
                                        size: 14,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  message.text,
                                  style: const TextStyle(
                                    color: Color(0xFF3A4057),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatTime(message.sentAt),
                                  style: const TextStyle(
                                    color: Color(0xFF78809A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 6),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F8FC),
                  border: Border(top: BorderSide(color: Color(0xFFE0E4F3))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Message $_barangay ??? $_channel...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFDCE1F1),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _sendMessage,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4052CA),
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Icon(Icons.send_rounded),
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

class _ResidentChatMessage {
  final String sender;
  final String text;
  final String channel;
  final DateTime sentAt;
  final bool isMine;
  final bool isOfficial;

  const _ResidentChatMessage({
    required this.sender,
    required this.text,
    required this.channel,
    required this.sentAt,
    required this.isMine,
    required this.isOfficial,
  });
}

class ResidentSupportPage extends StatelessWidget {
  const ResidentSupportPage({super.key});

  static const _officePoint = LatLng(14.8386, 120.2865);

  @override
  Widget build(BuildContext context) {
    return const _HelpDeskPage(role: UserRole.resident);
  }

  Widget _supportAction(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6E8F4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF5D647F)),
            const SizedBox(height: 7),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF2F3248),
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF666D88),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResidentBugReportPage extends StatefulWidget {
  const ResidentBugReportPage({super.key});

  @override
  State<ResidentBugReportPage> createState() => _ResidentBugReportPageState();
}

class _ResidentBugReportPageState extends State<ResidentBugReportPage> {
  final _bugNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _screenshotName;

  @override
  void dispose() {
    _bugNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bug Report'),
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3443B7), Color(0xFF6976E7)],
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
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.bug_report, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report a Problem',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Help us resolve issues quickly by sharing clear details and a screenshot.',
                          style: TextStyle(color: Color(0xFFDDE1FF)),
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
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE6E8F4)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _bugNameController,
                    decoration: const InputDecoration(labelText: 'Bug Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText:
                          'Describe what happened and steps to reproduce.',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDDE2F6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: Color(0xFF4A55B8),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Upload Screenshot',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF363B57),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_screenshotName != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFE0E3F4),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.insert_photo,
                                  color: Color(0xFF4A55B8),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _screenshotName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      setState(() => _screenshotName = null),
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          )
                        else
                          const Text(
                            'No screenshot attached yet.',
                            style: TextStyle(color: Color(0xFF6A6F89)),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _mockAttach('gallery'),
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text('Gallery'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _mockAttach('camera'),
                                icon: const Icon(Icons.camera_alt_outlined),
                                label: const Text('Camera'),
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton(
          onPressed: () {
            _showFeature(context, 'Bug report submitted. Thank you!');
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2E35D3),
          ),
          child: const Text('Submit Ticket'),
        ),
      ),
    );
  }

  void _mockAttach(String source) {
    final stamp = DateTime.now().millisecondsSinceEpoch % 100000;
    setState(() => _screenshotName = '${source}_screenshot_$stamp.png');
  }
}

class ResidentVerifyProfilePage extends StatefulWidget {
  const ResidentVerifyProfilePage({super.key});

  @override
  State<ResidentVerifyProfilePage> createState() =>
      _ResidentVerifyProfilePageState();
}

class _ResidentVerifyProfilePageState extends State<ResidentVerifyProfilePage> {
  final Map<String, bool> _utilities = {
    'Electricity': true,
    'Water Supply': true,
    'Sewage/Toilet Facilities': true,
    'Garbage/Waste Disposal': false,
    'Internet Access': true,
  };

  @override
  Widget build(BuildContext context) {
    final residenceSummary = _residentLocationSummary(
      fallback: _residentProfileCode(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      appBar: AppBar(
        title: const Text(
          'Complete Profile Information',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFFF6F8FF),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6F8FF), Color(0xFFF8F0EE)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3E4CC7), Color(0xFF6673E5)],
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
                  _ResidentEditableProfileAvatar(
                    size: 64,
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
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          residenceSummary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFFDDE1FF)),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Profile Completion: 78%',
                          style: TextStyle(
                            color: Color(0xFFF2F4FF),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _openResidentProfilePhotoEditor(context),
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _formSection(
              title: 'Education and Employment',
              icon: Icons.school_outlined,
              children: const [
                SizedBox(height: 8),
                _StyledInput(label: 'Highest Educational Attainment *'),
                SizedBox(height: 8),
                _StyledInput(label: 'Type of Employment *'),
                SizedBox(height: 8),
                _StyledInput(label: 'Sector'),
              ],
            ),
            const SizedBox(height: 10),
            _formSection(
              title: 'Household Information',
              icon: Icons.home_work_outlined,
              children: const [
                SizedBox(height: 8),
                _StyledInput(label: 'Number of People in the Household *'),
                SizedBox(height: 8),
                _StyledInput(label: 'Monthly Household Income'),
                SizedBox(height: 8),
                _StyledInput(label: 'House Ownership Status *'),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE4E7F3)),
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
                  const Row(
                    children: [
                      Icon(Icons.power, color: Color(0xFF4653B7)),
                      SizedBox(width: 8),
                      Text(
                        'Utilities Available',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2E3146),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._utilities.entries.map(
                    (entry) => _utilityRow(
                      label: entry.key,
                      enabled: entry.value,
                      onChanged: (v) =>
                          setState(() => _utilities[entry.key] = v),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE7EAFF), Color(0xFFF4F2FF)],
                ),
                border: Border.all(color: const Color(0xFFD9DFFF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified_user, color: Color(0xFF2E35D3)),
                      SizedBox(width: 8),
                      Text(
                        'Verify Your Account',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'To access comprehensive barangay services, e-commerce, and job benefits, ensure your profile details are complete and accurate.',
                    style: TextStyle(
                      color: Color(0xFF4B4F69),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            await _ResidentProfileVerificationHub.markVerified();
                            if (!context.mounted) {
                              return;
                            }
                            _showFeature(
                              context,
                              'Verification submitted. Commercial selling is now enabled.',
                            );
                            Navigator.pop(context);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2E35D3),
                          ),
                          child: const Text('Verify Now'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Maybe Later'),
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
    );
  }

  Widget _formSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E7F3)),
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
              Icon(icon, color: const Color(0xFF4653B7)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E3146),
                ),
              ),
            ],
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _utilityRow({
    required String label,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F7),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFEDE7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF5C5F74),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch.adaptive(
            value: enabled,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2E35D3),
            activeTrackColor: const Color(0xFFB5B9FF),
          ),
        ],
      ),
    );
  }
}

class _StyledInput extends StatelessWidget {
  final String label;
  const _StyledInput({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF9FAFF),
        labelStyle: const TextStyle(
          color: Color(0xFF5D6281),
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E5F1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4B56BA), width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }
}

class ResidentAboutPage extends StatelessWidget {
  const ResidentAboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3F4CC5), Color(0xFF6B79E8)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26303AB0),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.apartment, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BarangayMo Platform',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Digital frontline services for residents, officials, and local governance.',
                          style: TextStyle(
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
            Row(
              children: const [
                Expanded(
                  child: _AboutKpi(
                    title: '22,365',
                    subtitle: 'Residents Served',
                    icon: Icons.people,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _AboutKpi(
                    title: '24/7',
                    subtitle: 'Service Access',
                    icon: Icons.public,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _aboutCard(
              title: 'Our Mission',
              body:
                  'Improve local governance through transparent and accessible digital services that connect residents, officials, and community programs.',
              icon: Icons.track_changes,
            ),
            const SizedBox(height: 9),
            _aboutCard(
              title: 'Our Team',
              body:
                  'A joint team of barangay officers, service staff, and technology partners committed to faster public service delivery.',
              icon: Icons.groups,
            ),
            const SizedBox(height: 9),
            _aboutCard(
              title: 'Core Values',
              body:
                  'Accuracy, accountability, inclusivity, and community-first support for every request and transaction.',
              icon: Icons.verified_user,
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutCard({
    required String title,
    required String body,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E8F4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFE8ECFF),
            ),
            child: Icon(icon, color: const Color(0xFF4B56BA), size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E3248),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF5D637F),
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

class _AboutKpi extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _AboutKpi({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E8F4)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFE8ECFF),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF4B56BA)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2E3248),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6A708C),
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

class ResidentTermsPage extends StatelessWidget {
  const ResidentTermsPage({super.key});
  @override
  Widget build(BuildContext context) => const TermsPolicyScreen();
}

