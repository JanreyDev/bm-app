part of barangaymo_app;

enum UserRole { resident, official }

const int _appPinLength = 6;
const _officialThemePrimary = Color(0xFFD70000);
const _officialThemeSecondary = Color(0xFFB22727);
const _officialThemeBackground = Color(0xFFFFF4F4);
const _officialThemeSurfaceWarm = Color(0xFFFFF6F6);
const _officialThemeSurfaceCool = Color(0xFFFFEFEF);
const _officialThemeSurfaceAlt = Color(0xFFFFEAEA);
const _officialThemeBorder = Color(0xFFF0D1D1);
const _officialThemeText = Color(0xFF5A2B2B);
const _officialThemeSubtext = Color(0xFF7A5959);

bool _isValidAppPin(String value) => RegExp(r'^\d{6}$').hasMatch(value);

String? _authToken;
String? _currentOfficialMobile;
_ResidentSessionProfile? _currentResidentProfile;

class _ResidentSessionProfile {
  final String name;
  final String mobile;
  final String province;
  final String cityMunicipality;
  final String barangay;
  final String middleName;
  final String suffix;
  final String religion;

  const _ResidentSessionProfile({
    required this.name,
    required this.mobile,
    required this.province,
    required this.cityMunicipality,
    required this.barangay,
    required this.middleName,
    required this.suffix,
    required this.religion,
  });

  factory _ResidentSessionProfile.fromApiUser(Map<String, dynamic> user) {
    String read(String key) => (user[key] as String? ?? '').trim();

    return _ResidentSessionProfile(
      name: read('name'),
      mobile: read('mobile'),
      province: read('province'),
      cityMunicipality: read('city_municipality'),
      barangay: read('barangay'),
      middleName: read('middle_name'),
      suffix: read('suffix'),
      religion: read('religion'),
    );
  }

  String get displayName => name.isNotEmpty ? name : 'Resident';

  String get firstName {
    final parts = displayName.split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : 'Resident';
  }

  String get locationSummary {
    final parts = [
      barangay,
      cityMunicipality,
      province,
    ].where((part) => part.trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  String get personalSummary {
    if (mobile.isEmpty) {
      return displayName;
    }
    return '$displayName • $mobile';
  }

  String get profileCode {
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return 'Resident Account';
    }
    final tail = digits.length > 8 ? digits.substring(digits.length - 8) : digits;
    return 'RBI-$tail';
  }
}

_ResidentSessionProfile _residentSessionProfileFromApiUser(
  Map<String, dynamic>? user, {
  required String fallbackMobile,
}) {
  final profile = _ResidentSessionProfile.fromApiUser(user ?? const {});
  if (profile.mobile.isNotEmpty) {
    return profile;
  }
  return _ResidentSessionProfile(
    name: profile.name,
    mobile: fallbackMobile.trim(),
    province: profile.province,
    cityMunicipality: profile.cityMunicipality,
    barangay: profile.barangay,
    middleName: profile.middleName,
    suffix: profile.suffix,
    religion: profile.religion,
  );
}

void _setResidentSessionProfile(Map<String, dynamic>? user) {
  if (user == null) {
    return;
  }
  _currentResidentProfile = _ResidentSessionProfile.fromApiUser(user);
}

void _clearResidentSessionProfile() {
  _currentResidentProfile = null;
}

String _residentDisplayName() {
  return _currentResidentProfile?.displayName ?? 'Resident';
}

String _residentFirstName() {
  return _currentResidentProfile?.firstName ?? 'Resident';
}

String _residentMobileDisplay() {
  final mobile = _currentResidentProfile?.mobile ?? '';
  return mobile.isNotEmpty ? mobile : 'No mobile number';
}

String _residentLocationSummary({
  String fallback = 'Residence details not added yet.',
}) {
  final location = _currentResidentProfile?.locationSummary ?? '';
  return location.isNotEmpty ? location : fallback;
}

String _residentPersonalSummary() {
  return _currentResidentProfile?.personalSummary ??
      'Complete your profile to show your personal information.';
}

String _residentProfileCode() {
  return _currentResidentProfile?.profileCode ?? 'Resident Account';
}

String _normalizeMobileForKey(String input) {
  return input.replaceAll(RegExp(r'\D'), '');
}

List<String> _mobileKeyVariants(String input) {
  final normalized = _normalizeMobileForKey(input);
  if (normalized.isEmpty) {
    return const [];
  }
  final variants = <String>{normalized};
  if (normalized.startsWith('0') && normalized.length >= 10) {
    variants.add('63${normalized.substring(1)}');
  }
  if (normalized.startsWith('63') && normalized.length >= 11) {
    variants.add('0${normalized.substring(2)}');
  }
  return variants.toList();
}

class _LocalActivationStore {
  static const String _keyPrefix = 'official_activation_completed_';

  static String _keyFor(String mobile) {
    return '$_keyPrefix${_normalizeMobileForKey(mobile)}';
  }

  static Future<void> markCompleted(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFor(mobile), true);
  }

  static Future<bool> isCompleted(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFor(mobile)) ?? false;
  }
}

class _FirstRoleAccessStore {
  static const String _keyPrefix = 'first_role_access_';

  static String _keyFor(UserRole role) {
    final roleKey = role == UserRole.resident ? 'resident' : 'official';
    return '$_keyPrefix$roleKey';
  }

  static Future<bool> hasRegistered(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFor(role)) ?? false;
  }

  static Future<bool> shouldOpenRegister(UserRole role) async {
    return !(await hasRegistered(role));
  }

  static Future<void> markRegistered(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFor(role), true);
  }

  static Future<void> markVisited(UserRole role) async {
    await markRegistered(role);
  }
}

class _ResidentMpinStore {
  static const String _pinPrefix = 'resident_mpin_';
  static const String _lastMobileKey = 'resident_mpin_last_mobile';

  static String _keyFor(String mobile) {
    return '$_pinPrefix${_normalizeMobileForKey(mobile)}';
  }

  static Future<void> savePin(String mobile, String pin) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty || !_isValidAppPin(pin)) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(mobile), pin);
    await prefs.setString(_lastMobileKey, normalized);
  }

  static Future<bool> hasPin(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      final value = prefs.getString(_keyFor(variant));
      if (value != null && _isValidAppPin(value)) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> verifyPin(String mobile, String pin) async {
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      if (prefs.getString(_keyFor(variant)) == pin) {
        return true;
      }
    }
    return false;
  }

  static Future<void> rememberMobile(String mobile) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastMobileKey, normalized);
  }

  static Future<String?> lastMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastMobileKey);
  }
}

class _ResidentAuthCacheStore {
  static const String _tokenPrefix = 'resident_session_token_';
  static const String _namePrefix = 'resident_session_name_';
  static const String _mobilePrefix = 'resident_session_mobile_';
  static const String _provincePrefix = 'resident_session_province_';
  static const String _cityPrefix = 'resident_session_city_';
  static const String _barangayPrefix = 'resident_session_barangay_';
  static const String _middleNamePrefix = 'resident_session_middle_name_';
  static const String _suffixPrefix = 'resident_session_suffix_';
  static const String _religionPrefix = 'resident_session_religion_';

  static String _key(String prefix, String mobile) {
    return '$prefix${_normalizeMobileForKey(mobile)}';
  }

  static Future<void> save({
    required String token,
    required String accountMobile,
    required _ResidentSessionProfile profile,
  }) async {
    final normalized = _normalizeMobileForKey(accountMobile);
    if (normalized.isEmpty || token.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_tokenPrefix, accountMobile), token);
    await prefs.setString(_key(_namePrefix, accountMobile), profile.name);
    await prefs.setString(_key(_mobilePrefix, accountMobile), normalized);
    await prefs.setString(_key(_provincePrefix, accountMobile), profile.province);
    await prefs.setString(
      _key(_cityPrefix, accountMobile),
      profile.cityMunicipality,
    );
    await prefs.setString(_key(_barangayPrefix, accountMobile), profile.barangay);
    await prefs.setString(
      _key(_middleNamePrefix, accountMobile),
      profile.middleName,
    );
    await prefs.setString(_key(_suffixPrefix, accountMobile), profile.suffix);
    await prefs.setString(_key(_religionPrefix, accountMobile), profile.religion);
  }

  static Future<bool> restore(String mobile) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    String? keyMobile;
    String token = '';
    for (final variant in _mobileKeyVariants(mobile)) {
      final current = prefs.getString(_key(_tokenPrefix, variant)) ?? '';
      if (current.isNotEmpty) {
        keyMobile = variant;
        token = current;
        break;
      }
    }
    if (token.isEmpty || keyMobile == null) {
      return false;
    }
    _authToken = token;
    _currentResidentProfile = _ResidentSessionProfile(
      name: prefs.getString(_key(_namePrefix, keyMobile)) ?? '',
      mobile: prefs.getString(_key(_mobilePrefix, keyMobile)) ?? normalized,
      province: prefs.getString(_key(_provincePrefix, keyMobile)) ?? '',
      cityMunicipality: prefs.getString(_key(_cityPrefix, keyMobile)) ?? '',
      barangay: prefs.getString(_key(_barangayPrefix, keyMobile)) ?? '',
      middleName: prefs.getString(_key(_middleNamePrefix, keyMobile)) ?? '',
      suffix: prefs.getString(_key(_suffixPrefix, keyMobile)) ?? '',
      religion: prefs.getString(_key(_religionPrefix, keyMobile)) ?? '',
    );
    await _ResidentMpinStore.rememberMobile(normalized);
    return true;
  }

  static Future<void> clear(String mobile) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      await prefs.remove(_key(_tokenPrefix, variant));
      await prefs.remove(_key(_namePrefix, variant));
      await prefs.remove(_key(_mobilePrefix, variant));
      await prefs.remove(_key(_provincePrefix, variant));
      await prefs.remove(_key(_cityPrefix, variant));
      await prefs.remove(_key(_barangayPrefix, variant));
      await prefs.remove(_key(_middleNamePrefix, variant));
      await prefs.remove(_key(_suffixPrefix, variant));
      await prefs.remove(_key(_religionPrefix, variant));
    }
  }
}

class _OfficialMpinStore {
  static const String _pinPrefix = 'official_mpin_';
  static const String _lastMobileKey = 'official_mpin_last_mobile';

  static String _keyFor(String mobile) {
    return '$_pinPrefix${_normalizeMobileForKey(mobile)}';
  }

  static Future<void> savePin(String mobile, String pin) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty || !_isValidAppPin(pin)) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(mobile), pin);
    await prefs.setString(_lastMobileKey, normalized);
  }

  static Future<bool> hasPin(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      final value = prefs.getString(_keyFor(variant));
      if (value != null && _isValidAppPin(value)) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> verifyPin(String mobile, String pin) async {
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      if (prefs.getString(_keyFor(variant)) == pin) {
        return true;
      }
    }
    return false;
  }

  static Future<void> rememberMobile(String mobile) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastMobileKey, normalized);
  }

  static Future<String?> lastMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastMobileKey);
  }
}

class _OfficialAuthCacheStore {
  static const String _tokenPrefix = 'official_session_token_';
  static const String _mobilePrefix = 'official_session_mobile_';
  static const String _activationPrefix = 'official_session_activation_';

  static String _key(String prefix, String mobile) {
    return '$prefix${_normalizeMobileForKey(mobile)}';
  }

  static Future<void> save({
    required String token,
    required String mobile,
    required bool activationCompleted,
  }) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty || token.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_tokenPrefix, mobile), token);
    await prefs.setString(_key(_mobilePrefix, mobile), normalized);
    await prefs.setBool(_key(_activationPrefix, mobile), activationCompleted);
  }

  static Future<bool> restore(String mobile) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    String? keyMobile;
    String token = '';
    for (final variant in _mobileKeyVariants(mobile)) {
      final current = prefs.getString(_key(_tokenPrefix, variant)) ?? '';
      if (current.isNotEmpty) {
        keyMobile = variant;
        token = current;
        break;
      }
    }
    if (token.isEmpty || keyMobile == null) {
      return false;
    }
    final storedActivation =
        prefs.getBool(_key(_activationPrefix, keyMobile)) ?? false;
    final localCompleted = await _LocalActivationStore.isCompleted(normalized);
    _authToken = token;
    _currentOfficialMobile = normalized;
    _officialActivationCompleted = storedActivation || localCompleted;
    await _OfficialMpinStore.rememberMobile(normalized);
    return true;
  }

  static Future<void> clear(String mobile) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      await prefs.remove(_key(_tokenPrefix, variant));
      await prefs.remove(_key(_mobilePrefix, variant));
      await prefs.remove(_key(_activationPrefix, variant));
    }
  }
}

Widget _officialHomeForSession() {
  return _officialActivationCompleted
      ? const HomeShell()
      : const ActivationFlow();
}

Future<void> _completeResidentSignIn(
  BuildContext context, {
  required String mobile,
  required String token,
  Map<String, dynamic>? user,
  String? pin,
}) async {
  final profile = _residentSessionProfileFromApiUser(
    user,
    fallbackMobile: mobile,
  );
  final normalizedMobile = _normalizeMobileForKey(mobile);
  _currentResidentProfile = _ResidentSessionProfile(
    name: profile.name,
    mobile: normalizedMobile,
    province: profile.province,
    cityMunicipality: profile.cityMunicipality,
    barangay: profile.barangay,
    middleName: profile.middleName,
    suffix: profile.suffix,
    religion: profile.religion,
  );
  await _ResidentAuthCacheStore.save(
    token: token,
    accountMobile: mobile,
    profile: _currentResidentProfile!,
  );
  if (pin != null && _isValidAppPin(pin)) {
    await _ResidentMpinStore.savePin(mobile, pin);
  }
  await _ResidentMpinStore.rememberMobile(mobile);
  await _FirstRoleAccessStore.markRegistered(UserRole.resident);
  if (!context.mounted) {
    return;
  }
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const ResidentHomeShell()),
    (route) => false,
  );
}

Future<void> _completeOfficialSignIn(
  BuildContext context, {
  required String mobile,
  required String token,
  required bool activationCompleted,
  String? pin,
}) async {
  final normalized = _normalizeMobileForKey(mobile);
  if (normalized.isEmpty) {
    return;
  }
  _clearResidentSessionProfile();
  final localCompleted = await _LocalActivationStore.isCompleted(normalized);
  _currentOfficialMobile = normalized;
  _officialActivationCompleted = activationCompleted || localCompleted;
  await _OfficialAuthCacheStore.save(
    token: token,
    mobile: normalized,
    activationCompleted: _officialActivationCompleted,
  );
  if (pin != null && _isValidAppPin(pin)) {
    await _OfficialMpinStore.savePin(normalized, pin);
  }
  await _OfficialMpinStore.rememberMobile(normalized);
  await _FirstRoleAccessStore.markRegistered(UserRole.official);
  if (!context.mounted) {
    return;
  }
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => _officialHomeForSession()),
    (route) => false,
  );
}

Widget _loginPageForRole(UserRole role, {String? prefilledMobile}) {
  if (role == UserRole.resident) {
    return ResidentAccessPage(prefilledMobile: prefilledMobile);
  }
  return OfficialAccessPage(prefilledMobile: prefilledMobile);
}

class _AuthApiResult {
  final bool success;
  final String message;
  final String? token;
  final Map<String, dynamic>? user;
  final bool otpRequired;
  final String? otpDebugCode;
  final bool activationCompleted;
  const _AuthApiResult({
    required this.success,
    required this.message,
    this.token,
    this.user,
    this.otpRequired = false,
    this.otpDebugCode,
    this.activationCompleted = false,
  });
}

class _AuthRequestOutcome {
  final http.Response? response;
  final Map<String, dynamic> body;
  final bool sawTimeout;
  final bool sawConnectionError;

  const _AuthRequestOutcome({
    required this.response,
    required this.body,
    required this.sawTimeout,
    required this.sawConnectionError,
  });
}

class _AuthApi {
  _AuthApi._();
  static final _AuthApi instance = _AuthApi._();

  static const String _liveBaseUrl = 'https://api.barangaymo.com';
  static const String _detectedLanBaseUrl = 'http://10.100.150.96:8000';
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const Duration _requestTimeout = Duration(seconds: 5);

  String _normalizeMobile(String input) {
    return input.replaceAll(RegExp(r'\D'), '');
  }

  String _trimTrailingSlash(String input) {
    return input.endsWith('/') ? input.substring(0, input.length - 1) : input;
  }

  List<String> _baseUrlCandidates() {
    final out = <String>[];

    void add(String baseUrl) {
      final trimmed = _trimTrailingSlash(baseUrl.trim());
      if (trimmed.isNotEmpty && !out.contains(trimmed)) {
        out.add(trimmed);
      }
    }

    if (_configuredBaseUrl.trim().isNotEmpty) {
      add(_configuredBaseUrl);
      return out;
    }

    if (!bool.fromEnvironment('dart.vm.product')) {
      if (kIsWeb) {
        add('http://127.0.0.1:8000');
        add('http://localhost:8000');
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            add(_detectedLanBaseUrl);
            add('http://10.0.2.2:8000');
            add('http://127.0.0.1:8000');
            add('http://localhost:8000');
            break;
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
          case TargetPlatform.linux:
            add('http://127.0.0.1:8000');
            add('http://localhost:8000');
            break;
          case TargetPlatform.fuchsia:
            break;
        }
      }
      return out;
    }

    add(_liveBaseUrl);
    return out;
  }

  Uri _endpoint(String baseUrl, String path) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('${_trimTrailingSlash(baseUrl)}/$normalizedPath');
  }

  List<Uri> _endpointCandidates(String path) {
    final out = <Uri>[];
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final pathVariants = <String>[
      normalizedPath,
      if (!normalizedPath.startsWith('auth/')) 'auth/$normalizedPath',
    ];

    void add(String baseUrl, String currentPath) {
      final uri = _endpoint(baseUrl, currentPath);
      if (!out.any((existing) => existing.toString() == uri.toString())) {
        out.add(uri);
      }
    }

    for (final baseUrl in _baseUrlCandidates()) {
      if (baseUrl.toLowerCase().endsWith('/api')) {
        for (final variant in pathVariants) {
          add(baseUrl, variant);
        }
      } else {
        for (final variant in pathVariants) {
          add(baseUrl, 'api/$variant');
        }
        for (final variant in pathVariants) {
          add(baseUrl, variant);
        }
      }
    }

    return out;
  }

  bool _isRouteNotFound(
    http.Response response,
    Map<String, dynamic> decodedBody,
  ) {
    final message = ((decodedBody['message'] as String?) ?? '').toLowerCase();
    return response.statusCode == 404 ||
        (message.contains('route') && message.contains('not be found'));
  }

  String _connectionHelpMessage() {
    if (!bool.fromEnvironment('dart.vm.product') &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android) {
      return 'Cannot connect to local Laravel backend. Run `php artisan serve --host=0.0.0.0 --port=8000`, then use `flutter run --dart-define=API_BASE_URL=$_detectedLanBaseUrl`, or use `adb reverse tcp:8000 tcp:8000` over USB.';
    }
    return 'Cannot connect to server. Check backend URL and if Laravel is running.';
  }

  Future<_AuthRequestOutcome> _postToEndpointCandidates({
    required String path,
    required Map<String, String> headers,
    Object? body,
  }) async {
    http.Response? response;
    Map<String, dynamic> decodedBody = <String, dynamic>{};
    var sawTimeout = false;
    var sawConnectionError = false;
    final endpoints = _endpointCandidates(path);

    for (var i = 0; i < endpoints.length; i++) {
      try {
        final current = await http
            .post(endpoints[i], headers: headers, body: body)
            .timeout(_requestTimeout);
        final decoded = _decodeResponseBody(current.body);
        if (i < endpoints.length - 1 && _isRouteNotFound(current, decoded)) {
          continue;
        }
        response = current;
        decodedBody = decoded;
        break;
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    return _AuthRequestOutcome(
      response: response,
      body: decodedBody,
      sawTimeout: sawTimeout,
      sawConnectionError: sawConnectionError,
    );
  }

  Future<_AuthApiResult> register({
    required UserRole role,
    required String name,
    required String mobile,
    required String password,
    required String confirmPassword,
    String? province,
    String? cityMunicipality,
    String? barangay,
    String? middleName,
    String? suffix,
    String? religion,
  }) async {
    final normalizedMobile = _normalizeMobile(mobile);
    if (normalizedMobile.length < 10) {
      return const _AuthApiResult(
        success: false,
        message: 'Please enter a valid mobile number.',
      );
    }
    if (!_isValidAppPin(password)) {
      return const _AuthApiResult(
        success: false,
        message: 'PIN must be 6 digits.',
      );
    }
    if (password != confirmPassword) {
      return const _AuthApiResult(
        success: false,
        message: 'PINs do not match.',
      );
    }

    final outcome = await _postToEndpointCandidates(
      path: 'register',
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name.trim(),
        'mobile': normalizedMobile,
        'role': role.name,
        'password': password,
        'password_confirmation': confirmPassword,
        if (province != null && province.isNotEmpty) 'province': province,
        if (cityMunicipality != null && cityMunicipality.isNotEmpty)
          'city_municipality': cityMunicipality,
        if (barangay != null && barangay.isNotEmpty) 'barangay': barangay,
        if (middleName != null && middleName.isNotEmpty)
          'middle_name': middleName,
        if (suffix != null && suffix.isNotEmpty) 'suffix': suffix,
        if (religion != null && religion.isNotEmpty) 'religion': religion,
      }),
    );
    final response = outcome.response;
    final body = outcome.body;

    if (response == null) {
      if (outcome.sawTimeout) {
        return _AuthApiResult(
          success: false,
          message: _connectionHelpMessage(),
        );
      }
      if (outcome.sawConnectionError) {
        return _AuthApiResult(
          success: false,
          message: _connectionHelpMessage(),
        );
      }
      return const _AuthApiResult(
        success: false,
        message: 'Registration failed.',
      );
    }

    if (response.statusCode == 201) {
      final user = _extractUserValue(body);
      return _AuthApiResult(
        success: true,
        message: (body['message'] as String?) ?? 'Account created successfully.',
        token: _extractTokenValue(body),
        user: user,
        otpRequired: _toBool(body['otp_required']),
        otpDebugCode: body['otp_debug_code'] as String?,
        activationCompleted: _extractActivationCompleted(user),
      );
    }

    return _AuthApiResult(
      success: false,
      message: _extractMessage(body, fallback: 'Registration failed.'),
    );
  }

  Future<_AuthApiResult> login({
    required UserRole role,
    required String mobile,
    required String password,
  }) async {
    final normalizedMobile = _normalizeMobile(mobile);
    final outcome = await _postToEndpointCandidates(
      path: 'login',
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'mobile': normalizedMobile,
        'role': role.name,
        'password': password,
      }),
    );
    final response = outcome.response;
    final body = outcome.body;

    if (response == null) {
      if (outcome.sawTimeout) {
        return _AuthApiResult(
          success: false,
          message: _connectionHelpMessage(),
        );
      }
      if (outcome.sawConnectionError) {
        return _AuthApiResult(
          success: false,
          message: _connectionHelpMessage(),
        );
      }
      return const _AuthApiResult(
        success: false,
        message: 'Invalid credentials.',
      );
    }

    if (response.statusCode == 200) {
      final user = _extractUserValue(body);
      return _AuthApiResult(
        success: true,
        message: (body['message'] as String?) ?? 'Login successful.',
        token: _extractTokenValue(body),
        user: user,
        otpRequired: _toBool(body['otp_required']),
        otpDebugCode: body['otp_debug_code'] as String?,
        activationCompleted: _extractActivationCompleted(user),
      );
    }

    if (response.statusCode == 403 && _toBool(body['otp_required'])) {
      return _AuthApiResult(
        success: false,
        message: _extractMessage(
          body,
          fallback: 'Verify your OTP before logging in.',
        ),
        otpRequired: true,
        otpDebugCode: body['otp_debug_code'] as String?,
        user: _extractUserValue(body),
      );
    }

    return _AuthApiResult(
      success: false,
      message: _extractMessage(body, fallback: 'Invalid credentials.'),
    );
  }

  Future<_AuthApiResult> verifyOtp({
    required UserRole role,
    required String mobile,
    required String otp,
  }) async {
    final normalizedMobile = _normalizeMobile(mobile);
    final outcome = await _postToEndpointCandidates(
      path: 'verify-otp',
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'mobile': normalizedMobile,
        'role': role.name,
        'otp': otp.trim(),
      }),
    );
    final response = outcome.response;
    final body = outcome.body;

    if (response == null) {
      if (outcome.sawTimeout) {
        return _AuthApiResult(
          success: false,
          message: _connectionHelpMessage(),
        );
      }
      return _AuthApiResult(
        success: false,
        message: _connectionHelpMessage(),
      );
    }

    if (response.statusCode == 200) {
      final user = _extractUserValue(body);
      return _AuthApiResult(
        success: true,
        message: (body['message'] as String?) ?? 'OTP verified successfully.',
        token: _extractTokenValue(body),
        user: user,
        activationCompleted: _extractActivationCompleted(user),
      );
    }

    return _AuthApiResult(
      success: false,
      message: _extractMessage(body, fallback: 'OTP verification failed.'),
      otpRequired: _toBool(body['otp_required']),
      otpDebugCode: body['otp_debug_code'] as String?,
    );
  }

  Future<_AuthApiResult> resendOtp({
    required UserRole role,
    required String mobile,
  }) async {
    final normalizedMobile = _normalizeMobile(mobile);
    final outcome = await _postToEndpointCandidates(
      path: 'resend-otp',
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'mobile': normalizedMobile,
        'role': role.name,
      }),
    );
    final response = outcome.response;
    final body = outcome.body;

    if (response == null) {
      if (outcome.sawTimeout) {
        return _AuthApiResult(
          success: false,
          message: _connectionHelpMessage(),
        );
      }
      return _AuthApiResult(
        success: false,
        message: _connectionHelpMessage(),
      );
    }

    return _AuthApiResult(
      success: response.statusCode >= 200 && response.statusCode < 300,
      message: _extractMessage(body, fallback: 'OTP request failed.'),
      otpRequired: _toBool(body['otp_required']),
      otpDebugCode: body['otp_debug_code'] as String?,
    );
  }

  Future<_AuthApiResult> completeOfficialActivation({
    required Map<String, dynamic> payload,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _AuthApiResult(
        success: false,
        message: 'Missing login session. Please log in again.',
      );
    }

    final outcome = await _postToEndpointCandidates(
      path: 'activation/complete',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
      body: jsonEncode(payload),
    );
    final response = outcome.response;
    final body = outcome.body;

    if (response == null) {
      if (outcome.sawTimeout) {
        return _AuthApiResult(
          success: false,
          message: _connectionHelpMessage(),
        );
      }
      if (outcome.sawConnectionError) {
        return _AuthApiResult(
          success: false,
          message: _connectionHelpMessage(),
        );
      }
      return const _AuthApiResult(
        success: false,
        message: 'Could not save activation data. Please try again.',
      );
    }

    if (response.statusCode == 200) {
      return _AuthApiResult(
        success: true,
        message: (body['message'] as String?) ?? 'Activation details saved.',
        activationCompleted: true,
      );
    }

    if (response.statusCode == 404 &&
        ((body['message'] as String?) ?? '')
            .toLowerCase()
            .contains('could not be found')) {
      return const _AuthApiResult(
        success: true,
        message:
            'Server activation endpoint is not available yet. Activation is saved on this device.',
        activationCompleted: true,
      );
    }

    return _AuthApiResult(
      success: false,
      message: _extractMessage(
        body,
        fallback: 'Could not save activation data. Please try again.',
      ),
    );
  }

  Future<void> logout() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return;
    }

    final endpoints = _endpointCandidates('logout');
    for (var i = 0; i < endpoints.length; i++) {
      try {
        final current = await http
            .post(
              endpoints[i],
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
            )
            .timeout(_requestTimeout);
        if (current.statusCode != 404) {
          break;
        }
      } catch (_) {
        if (i == endpoints.length - 1) {
          break;
        }
      }
    }
  }

  bool _extractActivationCompleted(dynamic user) {
    if (user is Map<String, dynamic>) {
      return _toBool(user['activation_completed']);
    }
    return false;
  }

  bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == '1' || normalized == 'true' || normalized == 'yes';
    }
    return false;
  }

  String? _extractTokenValue(Map<String, dynamic> body) {
    final directCandidates = [
      body['token'],
      body['access_token'],
      body['plainTextToken'],
      body['auth_token'],
    ];
    for (final candidate in directCandidates) {
      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }

    final data = body['data'];
    if (data is Map<String, dynamic>) {
      final nestedCandidates = [
        data['token'],
        data['access_token'],
        data['plainTextToken'],
        data['auth_token'],
      ];
      for (final candidate in nestedCandidates) {
        if (candidate is String && candidate.trim().isNotEmpty) {
          return candidate.trim();
        }
      }
    }

    return null;
  }

  Map<String, dynamic>? _extractUserValue(Map<String, dynamic> body) {
    final user = body['user'];
    if (user is Map<String, dynamic>) {
      return user;
    }

    final data = body['data'];
    if (data is Map<String, dynamic> && data['user'] is Map<String, dynamic>) {
      return data['user'] as Map<String, dynamic>;
    }

    return null;
  }

  String _extractMessage(
    Map<String, dynamic> body, {
    required String fallback,
  }) {
    final message = body['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
    final errors = body['errors'];
    if (errors is Map<String, dynamic>) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty && value.first is String) {
          return value.first as String;
        }
      }
    }
    return fallback;
  }

  Map<String, dynamic> _decodeResponseBody(String raw) {
    if (raw.isEmpty) {
      return <String, dynamic>{};
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return <String, dynamic>{};
  }
}

class RoleGatewayScreen extends StatelessWidget {
  const RoleGatewayScreen({super.key});

  Future<void> _openRoleEntry(BuildContext context, UserRole role) async {
    final hasRegistered = await _FirstRoleAccessStore.hasRegistered(role);
    if (!context.mounted) {
      return;
    }
    if (!hasRegistered) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AuthRegisterPage(role: role)),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _loginPageForRole(role)),
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
        'New Kalalake',
        'Mabayuan',
        'New Cabalan',
        'New Ilalim',
        'New Kababae',
        'Pag-asa',
        'Santa Rita',
        'West Bajac-bajac',
        'West Tapinac',
        'Old Cabalan',
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

  @override
  void dispose() {
    _nameController.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);
    final result = await _AuthApi.instance.register(
      role: widget.role,
      name: _nameController.text,
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
                        onChanged: (value) =>
                            setState(() => _selectedBarangay = value),
                        validator: (value) {
                          if (!_isResident) return null;
                          if (value == null || value.isEmpty) {
                            return 'Barangay is required.';
                          }
                          return null;
                        },
                      ),
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

  bool get _isResident => widget.role == UserRole.resident;

  Color get _primaryColor =>
      _isResident ? const Color(0xFF2E35D3) : _officialThemePrimary;

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
              pin.padRight(4, '•'),
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
                            : ('•' * _pin.length),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: _pin.isEmpty
                              ? const Color(0xFF676D86)
                              : const Color(0xFF2D3458),
                          fontWeight: FontWeight.w700,
                          letterSpacing: _pin.isEmpty ? 0 : 4,
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
                            : ('•' * _pin.length),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: _pin.isEmpty
                              ? _officialThemeSubtext
                              : _officialThemeText,
                          fontWeight: FontWeight.w700,
                          letterSpacing: _pin.isEmpty ? 0 : 4,
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
