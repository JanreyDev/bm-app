part of barangaymo_app;

class RoleGatewayScreen extends StatelessWidget {
  const RoleGatewayScreen({super.key});

  Future<void> _openRoleEntry(BuildContext context, UserRole role) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RoleAuthChoicePage(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                width: 240,
                height: 116,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFFFFF), Color(0xFFF1F3FF)],
                  ),
                  border: Border.all(color: const Color(0xFFE4E7FF)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Color(0x66FFFFFF),
                      blurRadius: 6,
                      offset: Offset(-2, -2),
                    ),
                  ],
                ),
                child: Image.asset(
                  'public/barangaymo.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(height: 26),
              Expanded(
                child: Column(
                  children: [
                    _roleCard(
                      context,
                      title: 'Residents',
                      subtitle: 'Community services, profile, and RBI card',
                      role: UserRole.resident,
                    ),
                    const SizedBox(height: 14),
                    _roleCard(
                      context,
                      title: 'Barangay Officials',
                      subtitle: 'Activation, administration, and records',
                      role: UserRole.official,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required UserRole role,
  }) {
    final isResident = role == UserRole.resident;
    final accent = isResident
        ? const Color(0xFF2E35D3)
        : _officialThemePrimary;
    final logoAsset = isResident
        ? 'public/bm-residents.png'
        : 'public/bm-officials.png';
    final activeCount = isResident ? '1,284' : '64';

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openRoleEntry(context, role),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFF3F3FF),
            border: Border.all(color: accent, width: 1.3),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                      border: Border.all(color: accent.withValues(alpha: 0.2)),
                    ),
                    child: Image.asset(logoAsset, fit: BoxFit.contain),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: accent.withValues(alpha: 0.08),
                      border: Border.all(color: accent.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Active Accounts',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: accent.withValues(alpha: 0.95),
                          ),
                        ),
                        Text(
                          activeCount,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(subtitle),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Continue', style: TextStyle(color: accent)),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward, color: accent, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleAuthChoicePage extends StatelessWidget {
  final UserRole role;
  const RoleAuthChoicePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isResident = role == UserRole.resident;
    return Scaffold(
      appBar: AppBar(
        title: Text(isResident ? 'Residents' : 'Barangay Officials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            SizedBox(
              height: 120,
              child: Image.asset(
                isResident
                    ? 'public/bm-residents.png'
                    : 'public/bm-officials.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isResident ? 'Resident Log In' : 'Official Log In',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 26),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AuthRegisterPage(role: role)),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: isResident
                    ? const Color(0xFF2E35D3)
                    : _officialThemePrimary,
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _loginPageForRole(role)),
              ),
              child: const Text('Log In'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class OfficialLoginPage extends StatelessWidget {
  const OfficialLoginPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const OfficialAccessPage();
}

class AuthRegisterPage extends StatefulWidget {
  final UserRole role;
  const AuthRegisterPage({super.key, required this.role});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _noMiddleName = false;
  bool _noSuffix = true;
  String _suffix = 'None';
  String _religion = 'Select...';
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedBarangay;
  bool _submitting = false;

  static const Map<String, Map<String, List<String>>> _locationDirectory = {
    'Zambales': {
      'Botolan': [
        'Bancal',
        'Bangan',
        'Batonlapoc',
        'Belbel',
        'Beneg',
        'Binuclutan',
        'Burgos',
        'Cabatuan',
        'Capayawan',
        'Carael',
        'Danacbunga',
        'Maguisguis',
        'Malomboy',
        'Mambog',
        'Moraza',
        'Nacolcol',
        'Owaog-Nibloc',
        'Paco',
        'Palis',
        'Panan',
        'Parel',
        'Paudpod',
        'Poonbato',
        'Porac',
        'San Isidro',
        'San Juan',
        'San Miguel',
        'Santiago',
        'Tampo',
        'Taugtog',
        'Villar',
      ],
      'Cabangan': [
        'Anonang',
        'Apo-apo',
        'Arew',
        'Banuambayo',
        'Cadmang-Reserva',
        'Camiling',
        'Casabaan',
        'Del Carmen',
        'Dolores',
        'Felmida-Diaz',
        'Laoag',
        'Lomboy',
        'Longos',
        'Mabanglit',
        'New San Juan',
        'San Antonio',
        'San Isidro',
        'San Juan',
        'San Rafael',
        'Santa Rita',
        'Santo Nino',
        'Tondo',
      ],
      'Candelaria': [
        'Babancal',
        'Binabalian',
        'Catol',
        'Dampay',
        'Lauis',
        'Libertador',
        'Malabon',
        'Malimanga',
        'Pamibian',
        'Panayonan',
        'Pinagrealan',
        'Poblacion',
        'Sinabacan',
        'Taposo',
        'Uacon',
        'Yamot',
      ],
      'Castillejos': [
        'Balaybay',
        'Buenavista',
        'Del Pilar',
        'Looc',
        'Magsaysay',
        'Nagbayan',
        'Nagbunga',
        'San Agustin',
        'San Jose',
        'San Juan',
        'San Nicolas',
        'San Pablo',
        'San Roque',
        'Santa Maria',
      ],
      'City of Olongapo': [
        'Asinan',
        'Banicain',
        'Barretto',
        'East Bajac-bajac',
        'East Tapinac',
        'Gordon Heights',
        'Kalaklan',
        'Mabayuan',
        'New Cabalan',
        'New Ilalim',
        'New Kababae',
        'New Kalalake',
        'Old Cabalan',
        'Pag-asa',
        'Santa Rita',
        'West Bajac-bajac',
        'West Tapinac',
      ],
      'Iba': [
        'Amungan',
        'Bangantalinga',
        'Dirita-Baloguen',
        'Lipay-Dingin-Panibuatan',
        'Palanginan',
        'San Agustin',
        'Santa Barbara',
        'Santo Rosario',
        'Zone 1 Poblacion',
        'Zone 2 Poblacion',
        'Zone 3 Poblacion',
        'Zone 4 Poblacion',
        'Zone 5 Poblacion',
        'Zone 6 Poblacion',
      ],
      'Masinloc': [
        'Baloganon',
        'Bamban',
        'Bani',
        'Collat',
        'Inhobol',
        'North Poblacion',
        'San Lorenzo',
        'San Salvador',
        'Santa Rita',
        'Santo Rosario',
        'South Poblacion',
        'Taltal',
        'Tapuac',
      ],
      'Palauig': [
        'Alwa',
        'Bato',
        'Bulawen',
        'Cauyan',
        'East Poblacion',
        'Garreta',
        'Libaba',
        'Liozon',
        'Lipay',
        'Locloc',
        'Macarang',
        'Magalawa',
        'Pangolingan',
        'Salaza',
        'San Juan',
        'Santo Nino',
        'Santo Tomas',
        'Tition',
        'West Poblacion',
      ],
      'San Antonio': [
        'Angeles',
        'Antipolo',
        'Burgos',
        'East Dirita',
        'Luna',
        'Pundaquit',
        'Rizal',
        'San Esteban',
        'San Gregorio',
        'San Juan',
        'San Miguel',
        'San Nicolas',
        'Santiago',
        'West Dirita',
      ],
      'San Felipe': [
        'Amagna',
        'Apostol',
        'Balincaguing',
        'Faranal',
        'Feria',
        'Maloma',
        'Manglicmot',
        'Rosete',
        'San Rafael',
        'Santo Nino',
        'Sindol',
      ],
      'San Marcelino': [
        'Aglao',
        'Buhawen',
        'Burgos',
        'Central',
        'Consuelo Norte',
        'Consuelo Sur',
        'La Paz',
        'Laoag',
        'Linasin',
        'Linusungan',
        'Lucero',
        'Nagbunga',
        'Rabanes',
        'Rizal',
        'San Guillermo',
        'San Isidro',
        'San Rafael',
        'Santa Fe',
      ],
      'San Narciso': [
        'Alusiis',
        'Beddeng',
        'Candelaria',
        'Dallipawen',
        'Grullo',
        'La Paz',
        'Libertad',
        'Namatacan',
        'Natividad',
        'Omaya',
        'Paite',
        'Patrocinio',
        'San Jose',
        'San Juan',
        'San Pascual',
        'San Rafael',
        'Siminublan',
      ],
      'Santa Cruz': [
        'Babuyan',
        'Bangcol',
        'Bayto',
        'Biay',
        'Bolitoc',
        'Bulawon',
        'Canaynayan',
        'Gama',
        'Guinabon',
        'Guisguis',
        'Lipay',
        'Lomboy',
        'Lucapon North',
        'Lucapon South',
        'Malabago',
        'Naulo',
        'Pagatpat',
        'Pamonoran',
        'Poblacion North',
        'Poblacion South',
        'Sabang',
        'San Fernando',
        'Tabalong',
        'Tubotubo North',
        'Tubotubo South',
      ],
      'Subic': [
        'Aningway Sacatihan',
        'Asinan Poblacion',
        'Asinan Proper',
        'Baraca-Camachile',
        'Batiawan',
        'Calapacuan',
        'Calapandayan',
        'Cawag',
        'Ilwas',
        'Mangan-Vaca',
        'Matain',
        'Naugsol',
        'Pamatawan',
        'San Isidro',
        'Santo Tomas',
        'Wawandue',
      ],
    },
    'Bataan': {
      'Balanga City': ['Bagumbayan', 'Cupang Proper', 'Poblacion', 'Tuyo'],
      'Dinalupihan': ['Bangal', 'Layac', 'Pag-asa', 'Tucop'],
      'Orani': ['Baluarte', 'Sibul', 'Tala', 'Wawa'],
    },
    'Pampanga': {
      'City of San Fernando': ['Del Pilar', 'Sindalan', 'Calulut', 'Lourdes'],
      'Angeles City': ['Pampang', 'Pulungbulu', 'Malabanias', 'Cutcut'],
      'Mabalacat City': ['Dau', 'Mawaque', 'Mabiga', 'Camachiles'],
    },
  };

  List<String> get _cities {
    if (_selectedProvince == null) return const [];
    final cities = _locationDirectory[_selectedProvince];
    if (cities == null) return const [];
    return cities.keys.toList();
  }

  List<String> get _barangays {
    if (_selectedProvince == null || _selectedCity == null) return const [];
    final cities = _locationDirectory[_selectedProvince];
    if (cities == null) return const [];
    return cities[_selectedCity] ?? const [];
  }

  _BarangayDirectoryEntry? get _selectedBarangayEntry =>
      _lookupBarangayDirectoryEntry(
        _selectedProvince,
        _selectedCity,
        _selectedBarangay,
      );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _middleNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isResident => widget.role == UserRole.resident;

  Color get _primaryColor =>
      _isResident ? const Color(0xFF2E35D3) : _officialThemePrimary;

  String get _title =>
      _isResident ? 'Resident Registration' : 'Official Registration';

  Color get _surfaceStart =>
      _isResident ? const Color(0xFFF4F7FF) : _officialThemeSurfaceWarm;

  Color get _surfaceEnd =>
      _isResident ? const Color(0xFFEFF3FF) : _officialThemeSurfaceCool;

  Color get _fieldBorderColor =>
      _isResident ? const Color(0xFFC6D1FA) : _officialThemeBorder;

  Color get _cardColor =>
      _isResident ? const Color(0xFFFBFCFF) : const Color(0xFFFFFCF8);

  Color get _titleColor =>
      _isResident ? const Color(0xFF26305F) : _officialThemeText;

  Color get _labelColor =>
      _isResident ? const Color(0xFF5D6788) : _officialThemeSubtext;

  OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: _labelColor, fontWeight: FontWeight.w600),
      floatingLabelStyle: TextStyle(
        color: _primaryColor,
        fontWeight: FontWeight.w700,
      ),
      filled: true,
      fillColor: Colors.white,
      border: _inputBorder(_fieldBorderColor),
      enabledBorder: _inputBorder(_fieldBorderColor),
      focusedBorder: _inputBorder(_primaryColor, width: 1.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorderColor.withValues(alpha: 0.95)),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _titleColor,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Future<void> _showActivationWarningForBarangay(
    _BarangayDirectoryEntry entry,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Barangay Activation Required'),
          content: Text(
            '${entry.name} is listed in the Olongapo PSGC roster, but it is not activated in BarangayMo yet. You may continue registration, but resident-facing services will stay limited until the barangay finishes activation.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (!mounted) {
                  return;
                }
                setState(() => _selectedBarangay = null);
              },
              child: const Text('Choose Another'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: FilledButton.styleFrom(backgroundColor: _primaryColor),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleResidentBarangaySelection(String? value) async {
    if (!_isResident || value == null) {
      return;
    }
    final entry = _lookupBarangayDirectoryEntry(
      _selectedProvince,
      _selectedCity,
      value,
    );
    if (entry != null && !entry.activated) {
      await _showActivationWarningForBarangay(entry);
    }
  }

  Widget _barangayStatusCard(_BarangayDirectoryEntry entry) {
    final badgeBackground = entry.activated
        ? const Color(0xFFE7F8EC)
        : const Color(0xFFFFEEE6);
    final badgeForeground = entry.activated
        ? const Color(0xFF147A3F)
        : const Color(0xFFB34A16);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _fieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.name,
                  style: TextStyle(
                    color: _titleColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBackground,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  entry.statusLabel,
                  style: TextStyle(
                    color: badgeForeground,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            entry.psgcListed
                ? 'Official PSGC Olongapo roster - ${entry.classification}'
                : entry.classification,
            style: TextStyle(color: _labelColor, fontWeight: FontWeight.w600),
          ),
          if (!entry.activated) ...[
            const SizedBox(height: 6),
            Text(
              'Residents can register, but the barangay still needs official activation.',
              style: TextStyle(
                color: _labelColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);
    final result = await _AuthApi.instance.register(
      role: widget.role,
      name: _nameController.text,
      email: _emailController.text.trim(),
      mobile: _mobileController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      province: _isResident ? _selectedProvince : null,
      cityMunicipality: _isResident ? _selectedCity : null,
      barangay: _isResident ? _selectedBarangay : null,
      middleName: _isResident && !_noMiddleName
          ? _middleNameController.text.trim()
          : null,
      suffix: _isResident && !_noSuffix && _suffix != 'None' ? _suffix : null,
      religion: _isResident && _religion != 'Select...' ? _religion : null,
    );
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);

    if (!result.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));

    if (result.otpRequired) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AuthOtpVerificationPage(
            role: widget.role,
            mobile: _mobileController.text,
            debugOtpCode: result.otpDebugCode,
            pin: _passwordController.text.trim(),
          ),
        ),
      );
      return;
    }

    _authToken = result.token;
    if (_isResident) {
      await _completeResidentSignIn(
        context,
        mobile: _mobileController.text,
        token: result.token ?? '',
        user: result.user,
        pin: _passwordController.text.trim(),
      );
      return;
    }

    await _completeOfficialSignIn(
      context,
      mobile: _mobileController.text,
      token: result.token ?? '',
      activationCompleted: result.activationCompleted,
      user: result.user,
      pin: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_title),
        elevation: 0,
        backgroundColor: _surfaceStart,
        surfaceTintColor: _surfaceStart,
        foregroundColor: _titleColor,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_surfaceStart, _surfaceEnd],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Container(
                  height: 112,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _fieldBorderColor),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withValues(alpha: 0.09),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    _isResident
                        ? 'public/bm-residents.png'
                        : 'public/bm-officials.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  title: 'Account Basics',
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _fieldDecoration('Full Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldDecoration('Email (Optional)'),
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return null;
                        final valid = RegExp(
                          r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                        ).hasMatch(v);
                        if (!valid) {
                          return 'Enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: _fieldDecoration('Mobile Number'),
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
                  ],
                ),
                const SizedBox(height: 10),
                if (_isResident) ...[
                  _sectionCard(
                    title: 'Address Assignment (Required)',
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _selectedProvince,
                        decoration: _fieldDecoration('1. Select Province'),
                        items: _locationDirectory.keys
                            .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProvince = value;
                            _selectedCity = null;
                            _selectedBarangay = null;
                          });
                        },
                        validator: (value) {
                          if (!_isResident) return null;
                          if (value == null || value.isEmpty) {
                            return 'Province is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCity,
                        decoration: _fieldDecoration(
                          '2. Select City/Municipality',
                        ),
                        items: _cities
                            .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value;
                            _selectedBarangay = null;
                          });
                        },
                        validator: (value) {
                          if (!_isResident) return null;
                          if (value == null || value.isEmpty) {
                            return 'City/Municipality is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedBarangay,
                        decoration: _fieldDecoration('3. Select Barangay'),
                        items: _barangays
                            .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedBarangay = value);
                          _handleResidentBarangaySelection(value);
                        },
                        validator: (value) {
                          if (!_isResident) return null;
                          if (value == null || value.isEmpty) {
                            return 'Barangay is required.';
                          }
                          return null;
                        },
                      ),
                      if (_selectedBarangayEntry != null) ...[
                        const SizedBox(height: 10),
                        _barangayStatusCard(_selectedBarangayEntry!),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  _sectionCard(
                    title: 'Personal Details',
                    children: [
                      TextFormField(
                        controller: _middleNameController,
                        enabled: !_noMiddleName,
                        decoration: _fieldDecoration(
                          '4. Middle Name (Optional)',
                        ),
                      ),
                      CheckboxListTile(
                        dense: true,
                        activeColor: _primaryColor,
                        contentPadding: EdgeInsets.zero,
                        value: _noMiddleName,
                        title: Text(
                          'I have no middle name',
                          style: TextStyle(
                            color: _labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (v) => setState(() {
                          _noMiddleName = v ?? false;
                          if (_noMiddleName) _middleNameController.clear();
                        }),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _suffix,
                        decoration: _fieldDecoration('5. Suffix (Optional)'),
                        items: const [
                          DropdownMenuItem(
                            value: 'None',
                            child: Text('Select...'),
                          ),
                          DropdownMenuItem(value: 'Jr.', child: Text('Jr.')),
                          DropdownMenuItem(value: 'Sr.', child: Text('Sr.')),
                          DropdownMenuItem(value: 'III', child: Text('III')),
                          DropdownMenuItem(value: 'IV', child: Text('IV')),
                        ],
                        onChanged: (value) =>
                            setState(() => _suffix = value ?? 'None'),
                      ),
                      CheckboxListTile(
                        dense: true,
                        activeColor: _primaryColor,
                        contentPadding: EdgeInsets.zero,
                        value: _noSuffix,
                        title: Text(
                          'I have no suffix',
                          style: TextStyle(
                            color: _labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (v) => setState(() {
                          _noSuffix = v ?? true;
                          if (_noSuffix) _suffix = 'None';
                        }),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _religion,
                        decoration: _fieldDecoration('6. Religion'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Select...',
                            child: Text('Select...'),
                          ),
                          DropdownMenuItem(
                            value: 'Catholic',
                            child: Text('Catholic'),
                          ),
                          DropdownMenuItem(
                            value: 'Christian',
                            child: Text('Christian'),
                          ),
                          DropdownMenuItem(
                            value: 'Islam',
                            child: Text('Islam'),
                          ),
                          DropdownMenuItem(
                            value: 'Iglesia ni Cristo',
                            child: Text('Iglesia ni Cristo'),
                          ),
                          DropdownMenuItem(
                            value: 'Others',
                            child: Text('Others'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _religion = v ?? 'Select...'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                _sectionCard(
                  title: 'Security PIN',
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: _appPinLength,
                      decoration: _fieldDecoration('6-digit PIN').copyWith(
                        counterText: '',
                      ),
                      validator: (value) {
                        final normalized = value?.trim() ?? '';
                        if (!_isValidAppPin(normalized)) {
                          return 'Enter a 6-digit PIN.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: _appPinLength,
                      decoration: _fieldDecoration(
                        'Confirm 6-digit PIN',
                      ).copyWith(counterText: ''),
                      validator: (value) {
                        if ((value?.trim() ?? '') !=
                            _passwordController.text.trim()) {
                          return 'PINs do not match.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: _primaryColor,
                    ),
                    child: Text(
                      _submitting ? 'Please wait...' : 'Create Account',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.pop(context),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: _isResident
                          ? const Color(0xFF303A8D)
                          : _officialThemeSecondary,
                    ),
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

class AuthOtpVerificationPage extends StatefulWidget {
  final UserRole role;
  final String mobile;
  final String? debugOtpCode;
  final String? pin;

  const AuthOtpVerificationPage({
    super.key,
    required this.role,
    required this.mobile,
    this.debugOtpCode,
    this.pin,
  });

  @override
  State<AuthOtpVerificationPage> createState() => _AuthOtpVerificationPageState();
}

class _AuthOtpVerificationPageState extends State<AuthOtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _submitting = false;
  bool _resending = false;
  String? _debugOtpCode;

  bool get _isResident => widget.role == UserRole.resident;

  Color get _primaryColor =>
      _isResident ? const Color(0xFF2E35D3) : _officialThemePrimary;

  Widget _homeForRole() {
    if (_isResident) {
      return const ResidentHomeShell();
    }
    return _officialActivationCompleted
        ? const HomeShell()
        : const ActivationFlow();
  }

  @override
  void initState() {
    super.initState();
    _debugOtpCode = widget.debugOtpCode;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);
    final result = await _AuthApi.instance.verifyOtp(
      role: widget.role,
      mobile: widget.mobile,
      otp: _otpController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _submitting = false;
      if (result.otpDebugCode != null) {
        _debugOtpCode = result.otpDebugCode;
      }
    });

    if (!result.success || result.token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
      return;
    }

    _authToken = result.token;
    if (_isResident) {
      await _completeResidentSignIn(
        context,
        mobile: widget.mobile,
        token: result.token!,
        user: result.user,
        pin: widget.pin,
      );
      return;
    } else {
      await _completeOfficialSignIn(
        context,
        mobile: widget.mobile,
        token: result.token!,
        activationCompleted: result.activationCompleted,
        user: result.user,
        pin: widget.pin,
      );
      return;
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _resending = true);
    final result = await _AuthApi.instance.resendOtp(
      role: widget.role,
      mobile: widget.mobile,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _resending = false;
      _debugOtpCode = result.otpDebugCode;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));
  }

  @override
  Widget build(BuildContext context) {
    final mobileLabel = widget.mobile.replaceAll(RegExp(r'\D'), '');

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Icon(Icons.lock_clock_outlined, color: _primaryColor, size: 72),
              const SizedBox(height: 16),
              Text(
                'Enter the 6-digit OTP for $mobileLabel',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use the OTP generated for this new account before logging in.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF666B86)),
              ),
              if (_debugOtpCode != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F5FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD9E1FF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Local Debug OTP',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF33409C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _debugOtpCode!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'OTP Code',
                  counterText: '',
                ),
                validator: (value) {
                  final normalized = value?.trim() ?? '';
                  if (normalized.length != 6) {
                    return 'Enter the 6-digit OTP.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submitting ? null : _verify,
                style: FilledButton.styleFrom(backgroundColor: _primaryColor),
                child: Text(_submitting ? 'Verifying...' : 'Verify OTP'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _resending || _submitting ? null : _resendOtp,
                child: Text(_resending ? 'Sending...' : 'Resend OTP'),
              ),
              TextButton(
                onPressed: _submitting
                    ? null
                    : () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _loginPageForRole(
                            widget.role,
                            prefilledMobile: widget.mobile,
                          ),
                        ),
                        (route) => false,
                      ),
                child: const Text('Back to PIN Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthLoginPage extends StatefulWidget {
  final UserRole role;
  final String? prefilledMobile;
  const AuthLoginPage({super.key, required this.role, this.prefilledMobile});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _pinController = TextEditingController();
  bool _submitting = false;
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedBarangay;

  bool get _isResident => widget.role == UserRole.resident;

  Color get _primaryColor =>
      _isResident ? const Color(0xFF2E35D3) : _officialThemePrimary;

  Color get _fieldBorderColor =>
      _isResident ? const Color(0xFFC6D1FA) : _officialThemeBorder;

  Color get _titleColor =>
      _isResident ? const Color(0xFF26305F) : _officialThemeText;

  Color get _labelColor =>
      _isResident ? const Color(0xFF5D6788) : _officialThemeSubtext;

  String get _title => _isResident ? 'Resident Login' : 'Official Login';

  Widget _homeForRole() {
    if (_isResident) {
      return const ResidentHomeShell();
    }
    return _officialActivationCompleted
        ? const HomeShell()
        : const ActivationFlow();
  }

  @override
  void initState() {
    super.initState();
    _mobileController.text = widget.prefilledMobile ?? '';
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _showActivationWarningForBarangay(
    _BarangayDirectoryEntry entry,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Barangay Activation Required'),
          content: Text(
            '${entry.name} is listed in the Olongapo PSGC roster, but it is not activated in BarangayMo yet. You may continue registration, but resident-facing services will stay limited until the barangay finishes activation.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (!mounted) {
                  return;
                }
                setState(() => _selectedBarangay = null);
              },
              child: const Text('Choose Another'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: FilledButton.styleFrom(backgroundColor: _primaryColor),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleResidentBarangaySelection(String? value) async {
    if (!_isResident || value == null) {
      return;
    }
    final entry = _lookupBarangayDirectoryEntry(
      _selectedProvince,
      _selectedCity,
      value,
    );
    if (entry != null && !entry.activated) {
      await _showActivationWarningForBarangay(entry);
    }
  }

  Widget _barangayStatusCard(_BarangayDirectoryEntry entry) {
    final badgeBackground = entry.activated
        ? const Color(0xFFE7F8EC)
        : const Color(0xFFFFEEE6);
    final badgeForeground = entry.activated
        ? const Color(0xFF147A3F)
        : const Color(0xFFB34A16);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _fieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.name,
                  style: TextStyle(
                    color: _titleColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBackground,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  entry.statusLabel,
                  style: TextStyle(
                    color: badgeForeground,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            entry.psgcListed
                ? 'Official PSGC Olongapo roster - ${entry.classification}'
                : entry.classification,
            style: TextStyle(color: _labelColor, fontWeight: FontWeight.w600),
          ),
          if (!entry.activated) ...[
            const SizedBox(height: 6),
            Text(
              'Residents can register, but the barangay still needs official activation.',
              style: TextStyle(
                color: _labelColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);
    final result = await _AuthApi.instance.login(
      role: widget.role,
      mobile: _mobileController.text,
      password: _pinController.text.trim(),
    );
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);

    if (!result.success) {
      if (result.otpRequired) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message)));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AuthOtpVerificationPage(
              role: widget.role,
              mobile: _mobileController.text,
              debugOtpCode: result.otpDebugCode,
              pin: _pinController.text.trim(),
            ),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
      return;
    }

    _authToken = result.token;
    if (_isResident) {
      await _completeResidentSignIn(
        context,
        mobile: _mobileController.text,
        token: result.token ?? '',
        user: result.user,
        pin: _pinController.text.trim(),
      );
      return;
    } else {
      await _completeOfficialSignIn(
        context,
        mobile: _mobileController.text,
        token: result.token ?? '',
        activationCompleted: result.activationCompleted,
        user: result.user,
        pin: _pinController.text.trim(),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              SizedBox(
                height: 100,
                child: Image.asset(
                  _isResident
                      ? 'public/bm-residents.png'
                      : 'public/bm-officials.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: _appPinLength,
                decoration: const InputDecoration(
                  labelText: '6-digit PIN',
                  counterText: '',
                ),
                validator: (value) {
                  final normalized = value?.trim() ?? '';
                  if (!_isValidAppPin(normalized)) {
                    return 'Enter a 6-digit PIN.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting ? null : _submit,
                  style: FilledButton.styleFrom(backgroundColor: _primaryColor),
                  child: Text(_submitting ? 'Please wait...' : 'Log In'),
                ),
              ),
              TextButton(
                onPressed: _submitting
                    ? null
                    : () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AuthRegisterPage(role: widget.role),
                        ),
                      ),
                child: const Text('No account yet? Create one'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
