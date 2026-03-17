part of barangaymo_app;

class ResidentWelcomePage extends StatelessWidget {
  const ResidentWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Welcome to BarangayMo!',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2E35D3),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text('Ang unang sandigan ng mamamayan.'),
              const SizedBox(height: 24),
              SizedBox(
                height: 110,
                child: Image.asset(
                  'public/bm-residents.png',
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResidentRegisterFlow(),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                  ),
                  child: const Text('GET STARTED'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResidentRegisterFlow extends StatefulWidget {
  const ResidentRegisterFlow({super.key});

  @override
  State<ResidentRegisterFlow> createState() => _ResidentRegisterFlowState();
}

class _ResidentRegisterFlowState extends State<ResidentRegisterFlow> {
  final page = PageController();
  int i = 0;
  bool noMiddleName = false;
  bool noSuffix = false;
  String religion = 'Select...';
  final steps = const [
    'Register with Mobile',
    'OTP Verification',
    'Set PIN',
    'Address',
    'Details',
    'Photo',
    'Done',
  ];

  void next() {
    if (i == steps.length - 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ResidentHomeShell()),
        (route) => false,
      );
      return;
    }
    page.nextPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resident Registration'),
        backgroundColor: const Color(0xFF2E35D3),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: LinearProgressIndicator(
              value: (i + 1) / steps.length,
              minHeight: 7,
              color: const Color(0xFF2E35D3),
            ),
          ),
          Text('${i + 1}/${steps.length} ${steps[i]}'),
          Expanded(
            child: PageView(
              controller: page,
              onPageChanged: (v) => setState(() => i = v),
              children: [
                _regWrap(
                  children: const [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Mobile Number (+63)',
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('By continuing, you agree to Terms and Policies.'),
                  ],
                  button: 'Get OTP',
                  onNext: next,
                ),
                _regWrap(
                  children: const [
                    Text('Enter the 6-digit code sent to your phone.'),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(labelText: 'OTP Code'),
                    ),
                  ],
                  button: 'Verify',
                  onNext: next,
                ),
                _regWrap(
                  children: const [
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Type 6-digit PIN',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm 6-digit PIN',
                      ),
                    ),
                  ],
                  button: 'Submit',
                  onNext: next,
                ),
                _regWrap(
                  children: [
                    const _StepTabs(active: 'Address'),
                    const SizedBox(height: 8),
                    const Text(
                      'Please Complete Your Address Details:',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '1. Select Province',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '2. Select City/Municipality',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '3. Select Barangay',
                      ),
                    ),
                  ],
                  button: 'Save Changes',
                  onNext: next,
                ),
                _regWrap(
                  children: [
                    const _StepTabs(active: 'Details'),
                    const SizedBox(height: 8),
                    const Text(
                      'Please Complete Your Personal Details:',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      decoration: InputDecoration(labelText: '4. First Name'),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '5. Middle Name (Optional)',
                      ),
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: noMiddleName,
                      title: const Text('I have no middle name'),
                      onChanged: (v) =>
                          setState(() => noMiddleName = v ?? false),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(labelText: '6. Last Name'),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '7. Suffix (Optional)',
                      ),
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: noSuffix,
                      title: const Text('I have no suffix'),
                      onChanged: (v) => setState(() => noSuffix = v ?? false),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '8. Date of Birth',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '9. Place of Birth',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(labelText: '10. Sex'),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(labelText: '11. Nationality'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: religion,
                      decoration: const InputDecoration(
                        labelText: '12. Religion',
                      ),
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
                        DropdownMenuItem(value: 'Islam', child: Text('Islam')),
                        DropdownMenuItem(
                          value: 'Others',
                          child: Text('Others'),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => religion = v ?? 'Select...'),
                    ),
                  ],
                  button: 'Save Details',
                  onNext: next,
                ),
                _regWrap(
                  children: [
                    const _StepTabs(active: 'Photo'),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Please Add a Photo for your identity:',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('Sample Photo')),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Choose a photo to upload'),
                      ),
                    ),
                  ],
                  button: 'Save Photo',
                  onNext: next,
                ),
                _regWrap(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF2E35D3),
                      size: 90,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Congratulations, Shamira!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text('You\'ve successfully registered in BarangayMo.'),
                  ],
                  button: 'Let\'s Go',
                  onNext: next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _regWrap({
    required List<Widget> children,
    required String button,
    required VoidCallback onNext,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          ...children,
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onNext,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E35D3),
            ),
            child: Text(button),
          ),
        ],
      ),
    );
  }
}

class ResidentLoginPage extends StatelessWidget {
  const ResidentLoginPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const AuthLoginPage(role: UserRole.resident);
}

class ResidentMpinLoginPage extends StatefulWidget {
  const ResidentMpinLoginPage({super.key});
  @override
  State<ResidentMpinLoginPage> createState() => _ResidentMpinLoginPageState();
}

class _ResidentMpinLoginPageState extends State<ResidentMpinLoginPage> {
  String pin = '';

  void tap(String v) {
    if (v == 'C') {
      setState(() => pin = '');
      return;
    }
    if (v == '<') {
      if (pin.isNotEmpty) {
        setState(() => pin = pin.substring(0, pin.length - 1));
      }
      return;
    }
    if (pin.length < 4) {
      setState(() => pin += v);
    }
  }

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'C', '0', '<'];
    return Scaffold(
      appBar: AppBar(title: const Text('PIN Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Enter your 6-digit PIN',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              pin.isEmpty ? '• • • • • •' : _maskedPinPreview(pin),
              style: const TextStyle(fontSize: 42, letterSpacing: 8),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.4,
                children: keys
                    .map(
                      (k) => Padding(
                        padding: const EdgeInsets.all(6),
                        child: OutlinedButton(
                          onPressed: () => tap(k),
                          child: Text(k, style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: pin.length == 4
                    ? () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResidentHomeShell(),
                        ),
                        (route) => false,
                      )
                    : null,
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

Future<String?> _showPinEntrySheet(
  BuildContext context, {
  required String title,
  required Color accentColor,
  String initialPin = '',
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      var pin = initialPin;
      const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'C', '0', '<'];
      return StatefulBuilder(
        builder: (context, setModalState) {
          void tapKey(String value) {
            if (value == 'C') {
              setModalState(() => pin = '');
              return;
            }
            if (value == '<') {
              if (pin.isNotEmpty) {
                setModalState(() => pin = pin.substring(0, pin.length - 1));
              }
              return;
            }
            if (pin.length < _appPinLength) {
              setModalState(() => pin += value);
            }
          }

          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                18,
                20,
                20 + MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8DCE8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your $_appPinLength-digit PIN',
                    style: const TextStyle(
                      color: Color(0xFF6D738B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _appPinLength,
                      (index) => Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: index < pin.length ? accentColor : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: accentColor, width: 1.4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: keys
                        .map(
                          (key) => FilledButton(
                            onPressed: () => tapKey(key),
                            style: FilledButton.styleFrom(
                              backgroundColor: key == 'C' || key == '<'
                                  ? accentColor.withValues(alpha: 0.12)
                                  : Colors.white,
                              foregroundColor: accentColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(
                                  color: accentColor.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                            child: key == '<'
                                ? const Icon(Icons.backspace_outlined)
                                : Text(
                                    key,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: pin.length == _appPinLength
                          ? () => Navigator.pop(sheetContext, pin)
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Use PIN'),
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
}

class ResidentAccessPage extends StatefulWidget {
  final String? prefilledMobile;

  const ResidentAccessPage({super.key, this.prefilledMobile});

  @override
  State<ResidentAccessPage> createState() => _ResidentAccessPageState();
}

class _ResidentAccessPageState extends State<ResidentAccessPage> {
  final _mobileController = TextEditingController();
  String _pin = '';
  bool _loadingLastMobile = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _mobileController.text = widget.prefilledMobile?.trim() ?? '';
    _loadLastMobile();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _loadLastMobile() async {
    final lastMobile = await _ResidentMpinStore.lastMobile();
    if (!mounted) {
      return;
    }
    if (_mobileController.text.trim().isEmpty && lastMobile != null) {
      _mobileController.text = lastMobile;
    }
    setState(() => _loadingLastMobile = false);
  }

  String get _normalizedMobile =>
      _mobileController.text.replaceAll(RegExp(r'\D'), '');

  bool get _hasValidMobile => _normalizedMobile.length >= 10;

  Future<void> _openPinPad() async {
    final pin = await _showPinEntrySheet(
      context,
      title: 'Resident PIN',
      accentColor: const Color(0xFF2E35D3),
      initialPin: _pin,
    );
    if (pin == null || !mounted) {
      return;
    }
    setState(() => _pin = pin);
  }

  Future<void> _submitPinLogin() async {
    if (!_hasValidMobile) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid mobile number first.')),
      );
      return;
    }
    if (!_isValidAppPin(_pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your 6-digit PIN.'),
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    final mobile = _mobileController.text.trim();
    final hasLocalPin = await _ResidentMpinStore.hasPin(mobile);
    final localPinValid = hasLocalPin && await _ResidentMpinStore.verifyPin(mobile, _pin);
    if (localPinValid) {
      final restored = await _ResidentAuthCacheStore.restore(mobile);
      if (!mounted) {
        return;
      }
      if (restored) {
        setState(() => _submitting = false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ResidentHomeShell()),
          (route) => false,
        );
        return;
      }
    }

    final result = await _AuthApi.instance.login(
      role: UserRole.resident,
      mobile: mobile,
      password: _pin,
    );
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    if (!result.success) {
      if (result.otpRequired) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AuthOtpVerificationPage(
              role: UserRole.resident,
              mobile: mobile,
              debugOtpCode: result.otpDebugCode,
              pin: _pin,
            ),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
      return;
    }

    _authToken = result.token;
    await _completeResidentSignIn(
      context,
      mobile: mobile,
      token: result.token ?? '',
      user: result.user,
      pin: _pin,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E35D3);
    const background = Color(0xFFF3F1FF);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 130,
              child: Image.asset('public/barangaymo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            const Text(
              '"Ang unang sandigan ng mamamayan!"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E2235),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 78),
            const Text(
              'Resident Log In',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF3D4158),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8FF),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '+63',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3458),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submitPinLogin(),
                      decoration: const InputDecoration(
                        hintText: 'Enter mobile number...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _loadingLastMobile || _submitting ? null : _openPinPad,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2D3458),
                  side: const BorderSide(color: Color(0xFFD5D9F0)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.dialpad_rounded, color: primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _pin.isEmpty
                            ? 'Tap to enter $_appPinLength-digit PIN'
                            : _maskedPinPreview(_pin),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: _pin.isEmpty
                              ? const Color(0xFF676D86)
                              : const Color(0xFF2D3458),
                          fontWeight: FontWeight.w700,
                          letterSpacing: _pin.isEmpty ? 0 : 2,
                        ),
                      ),
                    ),
                    if (_pin.isNotEmpty)
                      IconButton(
                        onPressed: _submitting ? null : () => setState(() => _pin = ''),
                        icon: const Icon(Icons.close_rounded),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loadingLastMobile || _submitting ? null : _submitPinLogin,
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _loadingLastMobile
                      ? 'Loading...'
                      : (_submitting ? 'Checking PIN...' : 'Log In with PIN'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Registered users can log in here using their mobile number and 6-digit PIN.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF666B86),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResidentMpinSetupPage extends StatefulWidget {
  final String mobile;

  const ResidentMpinSetupPage({super.key, required this.mobile});

  @override
  State<ResidentMpinSetupPage> createState() => _ResidentMpinSetupPageState();
}

class _ResidentMpinSetupPageState extends State<ResidentMpinSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _saveMpin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    await _ResidentMpinStore.savePin(widget.mobile, _pinController.text.trim());
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ResidentHomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1FF),
      appBar: AppBar(
        title: const Text('Set PIN'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Icon(
                Icons.lock_person_rounded,
                size: 72,
                color: Color(0xFF2E35D3),
              ),
              const SizedBox(height: 18),
              const Text(
                'Create your 6-digit PIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Use this PIN for faster resident login on this device for ${widget.mobile}.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF5B6079)),
              ),
              const SizedBox(height: 28),
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: _appPinLength,
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  counterText: '',
                ),
                validator: (value) {
                  if ((value?.trim() ?? '') != _pinController.text.trim()) {
                    return 'PIN does not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _saving ? null : _saveMpin,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E35D3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(_saving ? 'Saving...' : 'Save PIN'),
              ),
              TextButton(
                onPressed: _saving
                    ? null
                    : () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResidentHomeShell(),
                        ),
                        (route) => false,
                      ),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResidentMpinUnlockPage extends StatefulWidget {
  final String? mobile;

  const ResidentMpinUnlockPage({super.key, this.mobile});

  @override
  State<ResidentMpinUnlockPage> createState() => _ResidentMpinUnlockPageState();
}

class _ResidentMpinUnlockPageState extends State<ResidentMpinUnlockPage> {
  static const _keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'C', '0', '<'];

  String _pin = '';
  String _mobile = '';
  bool _loadingMobile = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadMobile();
  }

  Future<void> _loadMobile() async {
    final storedMobile = widget.mobile?.trim();
    final fallbackMobile = await _ResidentMpinStore.lastMobile();
    if (!mounted) {
      return;
    }
    setState(() {
      _mobile = (storedMobile != null && storedMobile.isNotEmpty)
          ? storedMobile
          : (fallbackMobile ?? '');
      _loadingMobile = false;
    });
  }

  void _tapKey(String value) {
    if (_submitting) {
      return;
    }
    if (value == 'C') {
      setState(() => _pin = '');
      return;
    }
    if (value == '<') {
      if (_pin.isNotEmpty) {
        setState(() => _pin = _pin.substring(0, _pin.length - 1));
      }
      return;
    }
    if (_pin.length < _appPinLength) {
      setState(() => _pin += value);
    }
  }

  Future<void> _submitMpin() async {
    if (_mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No resident mobile number found for PIN login.'),
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    final hasPin = await _ResidentMpinStore.hasPin(_mobile);
    final isValid = hasPin && await _ResidentMpinStore.verifyPin(_mobile, _pin);
    if (!mounted) {
      return;
    }
    if (!isValid) {
      setState(() {
        _submitting = false;
        _pin = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasPin
                ? 'Incorrect PIN. Try again.'
                : 'No PIN found for this account. Log in on the access page.',
          ),
        ),
      );
      return;
    }

    final restored = await _ResidentAuthCacheStore.restore(_mobile);
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    if (!restored) {
      setState(() => _pin = '');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved session expired. Log in again on the access page.'),
        ),
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ResidentHomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1FF),
      appBar: AppBar(
        title: const Text('PIN Login'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Enter your 6-digit PIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                _loadingMobile
                    ? 'Loading account...'
                    : (_mobile.isEmpty ? 'Resident account not found' : _mobile),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF666B86),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _appPinLength,
                  (index) => Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: index < _pin.length
                          ? const Color(0xFF2E35D3)
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2E35D3)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.25,
                  children: _keys
                      .map(
                        (key) => FilledButton(
                          onPressed: () => _tapKey(key),
                          style: FilledButton.styleFrom(
                            backgroundColor: key == 'C' || key == '<'
                                ? const Color(0xFFE4E6FF)
                                : Colors.white,
                            foregroundColor: const Color(0xFF243082),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(
                                color: Color(0xFFD7DBFF),
                              ),
                            ),
                          ),
                          child: key == '<'
                              ? const Icon(Icons.backspace_outlined)
                              : Text(
                                  key,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _pin.length == _appPinLength && !_submitting
                      ? _submitMpin
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(_submitting ? 'Checking...' : 'Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
