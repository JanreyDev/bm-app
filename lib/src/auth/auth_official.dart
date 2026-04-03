part of barangaymo_app;

class OfficialAccessPage extends StatefulWidget {
  final String? prefilledMobile;

  const OfficialAccessPage({super.key, this.prefilledMobile});

  @override
  State<OfficialAccessPage> createState() => _OfficialAccessPageState();
}

class _OfficialAccessPageState extends State<OfficialAccessPage> {
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
    final lastMobile = await _OfficialMpinStore.lastMobile();
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
      title: 'Official PIN',
      accentColor: _officialThemePrimary,
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
    final hasLocalPin = await _OfficialMpinStore.hasPin(mobile);
    final localPinValid = hasLocalPin && await _OfficialMpinStore.verifyPin(mobile, _pin);
    if (localPinValid) {
      final restored = await _OfficialAuthCacheStore.restore(mobile);
      if (!mounted) {
        return;
      }
      if (restored) {
        setState(() => _submitting = false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => _officialHomeForSession()),
          (route) => false,
        );
        return;
      }
    }

    final result = await _AuthApi.instance.login(
      role: UserRole.official,
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
              role: UserRole.official,
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
    await _completeOfficialSignIn(
      context,
      mobile: mobile,
      token: result.token ?? '',
      activationCompleted: result.activationCompleted,
      user: result.user,
      pin: _pin,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = _officialThemePrimary;
    const background = _officialThemeBackground;

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
                color: _officialThemeText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 78),
            const Text(
              'Official Log In',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _officialThemeText,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _officialThemeSurfaceAlt,
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
                        color: _officialThemeText,
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
                  foregroundColor: _officialThemeText,
                  side: const BorderSide(color: _officialThemeBorder),
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
                              ? _officialThemeSubtext
                              : _officialThemeText,
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
              'Registered officials can log in here using their mobile number and 6-digit PIN.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _officialThemeSubtext,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfficialMpinSetupPage extends StatefulWidget {
  final String mobile;

  const OfficialMpinSetupPage({super.key, required this.mobile});

  @override
  State<OfficialMpinSetupPage> createState() => _OfficialMpinSetupPageState();
}

class _OfficialMpinSetupPageState extends State<OfficialMpinSetupPage> {
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
    await _OfficialMpinStore.savePin(widget.mobile, _pinController.text.trim());
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => _officialHomeForSession()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _officialThemeBackground,
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
                Icons.admin_panel_settings_rounded,
                size: 72,
                color: _officialThemePrimary,
              ),
              const SizedBox(height: 18),
              const Text(
                'Create your 6-digit PIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Use this PIN for faster official login on this device for ${widget.mobile}.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: _officialThemeSubtext),
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
                  backgroundColor: _officialThemePrimary,
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
                          builder: (_) => _officialHomeForSession(),
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

class OfficialMpinUnlockPage extends StatefulWidget {
  final String? mobile;

  const OfficialMpinUnlockPage({super.key, this.mobile});

  @override
  State<OfficialMpinUnlockPage> createState() => _OfficialMpinUnlockPageState();
}

class _OfficialMpinUnlockPageState extends State<OfficialMpinUnlockPage> {
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
    final fallbackMobile = await _OfficialMpinStore.lastMobile();
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
          content: Text('No official mobile number found for PIN login.'),
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    final hasPin = await _OfficialMpinStore.hasPin(_mobile);
    final isValid = hasPin && await _OfficialMpinStore.verifyPin(_mobile, _pin);
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

    final restored = await _OfficialAuthCacheStore.restore(_mobile);
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
      MaterialPageRoute(builder: (_) => _officialHomeForSession()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _officialThemeBackground,
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
                    : (_mobile.isEmpty ? 'Official account not found' : _mobile),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _officialThemeSubtext,
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
                          ? _officialThemePrimary
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _officialThemePrimary),
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
                                ? _officialThemeSurfaceAlt
                                : Colors.white,
                            foregroundColor: _officialThemeSecondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(
                                color: _officialThemeBorder,
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
                    backgroundColor: _officialThemePrimary,
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
