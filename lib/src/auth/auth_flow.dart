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
const int _minimumFoundingYear = 1900;
const Duration _cachedSessionLifetime = Duration(hours: 12);

bool _isValidAppPin(String value) => RegExp(r'^\d{6}$').hasMatch(value);

String _maskedPinPreview(String pin) {
  if (pin.isEmpty) {
    return '';
  }
  return List<String>.filled(pin.length, '•').join(' ');
}

String? _authToken;
String? _currentOfficialMobile;
_ResidentSessionProfile? _currentResidentProfile;
const String _appVersionLabel = 'v2026.03.14';
const String _appCreditsLabel =
    'BarangayMo Platform Team, Olongapo pilot deployment';

class _AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime createdAt;
  final IconData icon;
  final String priority;
  final String? recordId;
  final String? deepLink;
  final String deliveryChannel;
  final bool marketing;
  bool read;

  _AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
    required this.icon,
    this.priority = 'normal',
    this.recordId,
    this.deepLink,
    this.deliveryChannel = 'In-app',
    this.marketing = false,
    this.read = false,
  });
}

class _SecurityLogEntry {
  final UserRole role;
  final String actor;
  final String mobile;
  final String ipAddress;
  final String action;
  final DateTime createdAt;

  const _SecurityLogEntry({
    required this.role,
    required this.actor,
    required this.mobile,
    required this.ipAddress,
    required this.action,
    required this.createdAt,
  });
}

class _SystemTransactionEntry {
  final UserRole role;
  final String title;
  final String type;
  final String reference;
  final String status;
  final double amount;
  final DateTime createdAt;

  const _SystemTransactionEntry({
    required this.role,
    required this.title,
    required this.type,
    required this.reference,
    required this.status,
    required this.amount,
    required this.createdAt,
  });
}

class _HelpDeskTicketEntry {
  final String id;
  final UserRole role;
  final String subject;
  final String message;
  final String contact;
  final DateTime createdAt;
  String status;

  _HelpDeskTicketEntry({
    required this.id,
    required this.role,
    required this.subject,
    required this.message,
    required this.contact,
    required this.createdAt,
    this.status = 'Open',
  });
}

class _AccountDeletionRequest {
  final UserRole role;
  final String mobile;
  final DateTime requestedAt;
  final DateTime deleteOn;

  const _AccountDeletionRequest({
    required this.role,
    required this.mobile,
    required this.requestedAt,
    required this.deleteOn,
  });
}

class _EditableOfficialProfile {
  final String name;
  final String phone;
  final Uint8List? photoBytes;
  final String barangay;

  const _EditableOfficialProfile({
    required this.name,
    required this.phone,
    required this.barangay,
    this.photoBytes,
  });

  _EditableOfficialProfile copyWith({
    String? name,
    String? phone,
    Uint8List? photoBytes,
    bool clearPhoto = false,
    String? barangay,
  }) {
    return _EditableOfficialProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      barangay: barangay ?? this.barangay,
      photoBytes: clearPhoto ? null : photoBytes ?? this.photoBytes,
    );
  }
}

class _NotificationPreferenceSettings {
  final bool pushEnabled;
  final bool smsEnabled;
  final bool marketingEnabled;
  final bool quietHoursEnabled;
  final int quietStartHour;
  final int quietEndHour;

  const _NotificationPreferenceSettings({
    required this.pushEnabled,
    required this.smsEnabled,
    required this.marketingEnabled,
    required this.quietHoursEnabled,
    required this.quietStartHour,
    required this.quietEndHour,
  });

  _NotificationPreferenceSettings copyWith({
    bool? pushEnabled,
    bool? smsEnabled,
    bool? marketingEnabled,
    bool? quietHoursEnabled,
    int? quietStartHour,
    int? quietEndHour,
  }) {
    return _NotificationPreferenceSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      marketingEnabled: marketingEnabled ?? this.marketingEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietStartHour: quietStartHour ?? this.quietStartHour,
      quietEndHour: quietEndHour ?? this.quietEndHour,
    );
  }
}

class _NotificationDispatcherToken {
  final UserRole role;
  final String mobile;
  final String token;
  final String platform;
  final DateTime registeredAt;

  const _NotificationDispatcherToken({
    required this.role,
    required this.mobile,
    required this.token,
    required this.platform,
    required this.registeredAt,
  });
}

class _NotificationDispatchLogEntry {
  final UserRole role;
  final String title;
  final String body;
  final String audience;
  final String channel;
  final String provider;
  final String status;
  final String priority;
  final DateTime createdAt;

  const _NotificationDispatchLogEntry({
    required this.role,
    required this.title,
    required this.body,
    required this.audience,
    required this.channel,
    required this.provider,
    required this.status,
    required this.priority,
    required this.createdAt,
  });
}

class _DeferredNotificationEnvelope {
  final UserRole role;
  final String title;
  final String body;
  final String category;
  final IconData icon;
  final String priority;
  final String? recordId;
  final String? deepLink;
  final bool marketing;

  const _DeferredNotificationEnvelope({
    required this.role,
    required this.title,
    required this.body,
    required this.category,
    required this.icon,
    required this.priority,
    this.recordId,
    this.deepLink,
    this.marketing = false,
  });
}

class _BroadcastResidentProfile {
  final String name;
  final String mobile;
  final String zone;
  final String purok;
  final String residentType;

  const _BroadcastResidentProfile({
    required this.name,
    required this.mobile,
    required this.zone,
    required this.purok,
    required this.residentType,
  });
}

class _DirectMessageEntry {
  final String id;
  final String threadId;
  final UserRole senderRole;
  final String senderName;
  final String residentName;
  final String residentMobile;
  final String? text;
  final Uint8List? imageBytes;
  final DateTime createdAt;
  final DateTime? readAt;

  const _DirectMessageEntry({
    required this.id,
    required this.threadId,
    required this.senderRole,
    required this.senderName,
    required this.residentName,
    required this.residentMobile,
    required this.createdAt,
    this.text,
    this.imageBytes,
    this.readAt,
  });

  bool get hasImage => imageBytes != null;

  _DirectMessageEntry copyWith({
    DateTime? readAt,
  }) {
    return _DirectMessageEntry(
      id: id,
      threadId: threadId,
      senderRole: senderRole,
      senderName: senderName,
      residentName: residentName,
      residentMobile: residentMobile,
      text: text,
      imageBytes: imageBytes,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}

final ValueNotifier<List<_AppNotificationItem>> _residentNotificationCenter =
    ValueNotifier<List<_AppNotificationItem>>([
      _AppNotificationItem(
        id: 'res-1',
        title: 'Clearance ready for pickup',
        body: 'Your barangay clearance is approved and ready at the front desk.',
        category: 'Documents',
        createdAt: DateTime(2026, 3, 14, 8, 45),
        icon: Icons.badge_outlined,
      ),
      _AppNotificationItem(
        id: 'res-2',
        title: 'Marketplace order confirmed',
        body: 'Seller meetup for your printer order is scheduled tomorrow.',
        category: 'Marketplace',
        createdAt: DateTime(2026, 3, 13, 17, 10),
        icon: Icons.shopping_bag_outlined,
      ),
    ]);

final ValueNotifier<List<_AppNotificationItem>> _officialNotificationCenter =
    ValueNotifier<List<_AppNotificationItem>>([
      _AppNotificationItem(
        id: 'off-1',
        title: 'New clearance request',
        body: 'Resident queue has one pending work clearance for review.',
        category: 'Documents',
        createdAt: DateTime(2026, 3, 14, 9, 5),
        icon: Icons.assignment_outlined,
      ),
      _AppNotificationItem(
        id: 'off-2',
        title: 'Procurement step updated',
        body: 'Street lighting replacement has advanced to Purchase Order.',
        category: 'Finance',
        createdAt: DateTime(2026, 3, 14, 10, 15),
        icon: Icons.account_balance_wallet_outlined,
      ),
    ]);

final ValueNotifier<_NotificationPreferenceSettings>
_residentNotificationPreferences =
    ValueNotifier<_NotificationPreferenceSettings>(
      const _NotificationPreferenceSettings(
        pushEnabled: true,
        smsEnabled: true,
        marketingEnabled: true,
        quietHoursEnabled: true,
        quietStartHour: 21,
        quietEndHour: 6,
      ),
    );

final ValueNotifier<_NotificationPreferenceSettings>
_officialNotificationPreferences =
    ValueNotifier<_NotificationPreferenceSettings>(
      const _NotificationPreferenceSettings(
        pushEnabled: true,
        smsEnabled: true,
        marketingEnabled: false,
        quietHoursEnabled: false,
        quietStartHour: 21,
        quietEndHour: 6,
      ),
    );

final ValueNotifier<int> _residentNotificationBadge =
    ValueNotifier<int>(_residentNotificationCenter.value.where((item) => !item.read).length);

final ValueNotifier<int> _officialNotificationBadge =
    ValueNotifier<int>(_officialNotificationCenter.value.where((item) => !item.read).length);

final ValueNotifier<List<_NotificationDispatcherToken>> _notificationDispatcherTokens =
    ValueNotifier<List<_NotificationDispatcherToken>>([]);

final ValueNotifier<List<_NotificationDispatchLogEntry>> _notificationDispatchLog =
    ValueNotifier<List<_NotificationDispatchLogEntry>>([]);

final ValueNotifier<List<_DeferredNotificationEnvelope>> _deferredNotifications =
    ValueNotifier<List<_DeferredNotificationEnvelope>>([]);
final ValueNotifier<Uint8List?> _scopedBarangayLogoBytes =
    ValueNotifier<Uint8List?>(null);
final ValueNotifier<int> _scopedBarangayLogoRefresh =
    ValueNotifier<int>(0);

const List<_BroadcastResidentProfile> _broadcastResidentDirectory = [
  _BroadcastResidentProfile(
    name: 'John Dela Cruz',
    mobile: '09171234567',
    zone: 'Zone 1',
    purok: 'Purok 1',
    residentType: 'General',
  ),
  _BroadcastResidentProfile(
    name: 'Maria Santos',
    mobile: '09172345678',
    zone: 'Zone 1',
    purok: 'Purok 2',
    residentType: 'Senior Citizen',
  ),
  _BroadcastResidentProfile(
    name: 'Pedro Reyes',
    mobile: '09173456789',
    zone: 'Zone 2',
    purok: 'Purok 3',
    residentType: 'PWD',
  ),
  _BroadcastResidentProfile(
    name: 'Ana Villanueva',
    mobile: '09174567890',
    zone: 'Zone 3',
    purok: 'Purok 4',
    residentType: 'Solo Parent',
  ),
];

final ValueNotifier<List<_DirectMessageEntry>> _directMessageStore =
    ValueNotifier<List<_DirectMessageEntry>>([
      _DirectMessageEntry(
        id: 'dm-1',
        threadId: 'resident-09171234567',
        senderRole: UserRole.official,
        senderName: 'Barangay Secretary',
        residentName: 'John Dela Cruz',
        residentMobile: '09171234567',
        text: 'Your clearance request is under verification. Please keep your ID ready.',
        createdAt: DateTime(2026, 3, 14, 9, 30),
      ),
      _DirectMessageEntry(
        id: 'dm-2',
        threadId: 'resident-09171234567',
        senderRole: UserRole.resident,
        senderName: 'John Dela Cruz',
        residentName: 'John Dela Cruz',
        residentMobile: '09171234567',
        text: 'Noted. I can visit the barangay hall after lunch.',
        createdAt: DateTime(2026, 3, 14, 9, 37),
        readAt: DateTime(2026, 3, 14, 9, 38),
      ),
      _DirectMessageEntry(
        id: 'dm-3',
        threadId: 'resident-09172345678',
        senderRole: UserRole.resident,
        senderName: 'Maria Santos',
        residentName: 'Maria Santos',
        residentMobile: '09172345678',
        text: 'Can I follow up my indigency certificate request today?',
        createdAt: DateTime(2026, 3, 14, 10, 18),
      ),
    ]);

final StreamController<_DirectMessageEntry> _directMessageStreamController =
    StreamController<_DirectMessageEntry>.broadcast();

final ValueNotifier<List<_SecurityLogEntry>> _securityLogFeed =
    ValueNotifier<List<_SecurityLogEntry>>([]);

final ValueNotifier<List<_HelpDeskTicketEntry>> _helpDeskFeed =
    ValueNotifier<List<_HelpDeskTicketEntry>>([
      _HelpDeskTicketEntry(
        id: 'HD-24018',
        role: UserRole.resident,
        subject: 'Document follow-up',
        message: 'Resident asked for a follow-up on a travel clearance request.',
        contact: '09123456789',
        createdAt: DateTime(2026, 3, 12, 14, 25),
        status: 'In Review',
      ),
      _HelpDeskTicketEntry(
        id: 'HD-24019',
        role: UserRole.official,
        subject: 'Printer issue in records desk',
        message: 'Official reported a queue printing failure in the records desk.',
        contact: '09184443322',
        createdAt: DateTime(2026, 3, 13, 9, 40),
        status: 'Open',
      ),
    ]);

final ValueNotifier<List<_SystemTransactionEntry>> _transactionHistoryFeed =
    ValueNotifier<List<_SystemTransactionEntry>>([
      _SystemTransactionEntry(
        role: UserRole.resident,
        title: 'Barangay Clearance',
        type: 'Document Request',
        reference: 'CLR-2026-114',
        status: 'Approved',
        amount: 75,
        createdAt: DateTime(2026, 3, 11, 13, 10),
      ),
      _SystemTransactionEntry(
        role: UserRole.resident,
        title: 'Epson EcoTank L3210',
        type: 'Marketplace Order',
        reference: 'ORD-88341',
        status: 'For Meetup',
        amount: 8290,
        createdAt: DateTime(2026, 3, 10, 16, 45),
      ),
      _SystemTransactionEntry(
        role: UserRole.official,
        title: 'Daily queue bulk export',
        type: 'System Export',
        reference: 'EXP-20014',
        status: 'Completed',
        amount: 0,
        createdAt: DateTime(2026, 3, 14, 10, 5),
      ),
    ]);

final ValueNotifier<_AccountDeletionRequest?> _residentDeletionRequest =
    ValueNotifier<_AccountDeletionRequest?>(null);
final ValueNotifier<_AccountDeletionRequest?> _officialDeletionRequest =
    ValueNotifier<_AccountDeletionRequest?>(null);

final ValueNotifier<_EditableOfficialProfile> _officialEditableProfile =
    ValueNotifier<_EditableOfficialProfile>(
      const _EditableOfficialProfile(
        name: 'Lester Nadong',
        phone: '09124444233',
        barangay: 'West Tapinac',
      ),
    );

class _BarangayDirectoryEntry {
  final String name;
  final bool activated;
  final bool psgcListed;
  final String classification;

  const _BarangayDirectoryEntry({
    required this.name,
    this.activated = false,
    this.psgcListed = true,
    this.classification = 'Urban Barangay',
  });

  String get statusLabel => activated ? 'Registered' : 'For Activation';
}

// PSA PSGC roster for Olongapo City barangays, verified March 14, 2026.
const List<_BarangayDirectoryEntry> _olongapoBarangayDirectory = [
  _BarangayDirectoryEntry(name: 'Asinan'),
  _BarangayDirectoryEntry(name: 'Banicain', activated: true),
  _BarangayDirectoryEntry(name: 'Barretto'),
  _BarangayDirectoryEntry(name: 'East Bajac-bajac'),
  _BarangayDirectoryEntry(name: 'East Tapinac', activated: true),
  _BarangayDirectoryEntry(name: 'Gordon Heights'),
  _BarangayDirectoryEntry(name: 'Kalaklan', activated: true),
  _BarangayDirectoryEntry(name: 'Mabayuan'),
  _BarangayDirectoryEntry(name: 'New Cabalan'),
  _BarangayDirectoryEntry(name: 'New Ilalim'),
  _BarangayDirectoryEntry(name: 'New Kababae'),
  _BarangayDirectoryEntry(name: 'New Kalalake'),
  _BarangayDirectoryEntry(name: 'Old Cabalan', activated: true),
  _BarangayDirectoryEntry(name: 'Pag-asa'),
  _BarangayDirectoryEntry(name: 'Santa Rita'),
  _BarangayDirectoryEntry(name: 'West Bajac-bajac'),
  _BarangayDirectoryEntry(name: 'West Tapinac', activated: true),
];

final Map<String, _BarangayDirectoryEntry> _olongapoBarangayIndex = {
  for (final entry in _olongapoBarangayDirectory) entry.name: entry,
};

class _OfficialBarangaySetupDraft {
  String barangay = 'West Tapinac';
  String city = 'City of Olongapo';
  String province = 'Zambales';
  String region = 'Region 3';
  String landmark = 'WEST TAPINAC BARANGAY HALL';
  String website = 'https://www.westtapinac-olongapo.gov.ph';
  String facebook = 'https://facebook.com/westtapinacofficial';
  String divisionType = 'Zone';
  int divisionCount = 10;
  int population = 22365;
  int foundingYear = 1961;
  double latitude = 14.832231;
  double longitude = 120.279943;
  Uint8List? logoBytes;
  String? logoFileName;
  int psaPopulationBaseYear = 2025;
  String secretaryFirstName = 'Brigette';
  String secretaryMiddleName = '';
  String secretaryLastName = 'Barrera';
  String secretarySuffix = 'None';
  String secretaryMobile = '09123456701';
  String secretaryEmail = 'olongapoasinan@gmail.com';
  String secretaryIdType = 'Digital National ID';
  Uint8List? secretaryIdBytes;
  String? secretaryIdFileName;
  String punongSignatureText = 'E. NAZARENO';
  List<List<Offset>> punongSignaturePaths = <List<Offset>>[];
}

final _officialBarangaySetup = _OfficialBarangaySetupDraft();

_BarangayDirectoryEntry? _lookupBarangayDirectoryEntry(
  String? province,
  String? city,
  String? barangay,
) {
  if (province == 'Zambales' &&
      city == 'City of Olongapo' &&
      barangay != null &&
      barangay.isNotEmpty) {
    return _olongapoBarangayIndex[barangay];
  }
  return null;
}

bool _isValidSchemaUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return true;
  }
  final uri = Uri.tryParse(trimmed);
  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}

bool _isValidFoundingYearValue(int year) {
  return year >= _minimumFoundingYear && year <= DateTime.now().year;
}

int _officialPopulationForYear([int? year]) {
  final targetYear = year ?? DateTime.now().year;
  final delta = targetYear - _officialBarangaySetup.psaPopulationBaseYear;
  if (delta <= 0) {
    return _officialBarangaySetup.population;
  }
  final annualIncrease = (_officialBarangaySetup.population * 0.0125).round();
  return _officialBarangaySetup.population + (annualIncrease * delta);
}

double? _parseCoordinateValue(
  String input, {
  required double min,
  required double max,
}) {
  final trimmed = input.trim();
  if (trimmed.isEmpty || !RegExp(r'^-?\d{1,3}(\.\d{1,6})?$').hasMatch(trimmed)) {
    return null;
  }
  final parsed = double.tryParse(trimmed);
  if (parsed == null || parsed < min || parsed > max) {
    return null;
  }
  return double.parse(parsed.toStringAsFixed(6));
}

String _formatCoordinateValue(double value) => value.toStringAsFixed(6);

Future<Uint8List> _cropAndResizeSquareImage(
  Uint8List sourceBytes, {
  int size = 500,
}) async {
  final codec = await ui.instantiateImageCodec(sourceBytes);
  final frame = await codec.getNextFrame();
  final image = frame.image;
  final shortestSide = image.width < image.height ? image.width : image.height;
  final offsetX = (image.width - shortestSide) / 2;
  final offsetY = (image.height - shortestSide) / 2;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high;

  canvas.drawImageRect(
    image,
    Rect.fromLTWH(
      offsetX.toDouble(),
      offsetY.toDouble(),
      shortestSide.toDouble(),
      shortestSide.toDouble(),
    ),
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    paint,
  );

  final square = await recorder.endRecording().toImage(size, size);
  final data = await square.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

Future<({Uint8List bytes, String fileName})?> _pickAndPrepareBarangayLogo() async {
  final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (file == null) {
    return null;
  }
  final rawBytes = await file.readAsBytes();
  final preparedBytes = await _cropAndResizeSquareImage(rawBytes);
  return (bytes: preparedBytes, fileName: file.name);
}

class _SixDecimalCoordinateFormatter extends TextInputFormatter {
  const _SixDecimalCoordinateFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final next = newValue.text;
    if (next.isEmpty || RegExp(r'^-?\d{0,3}(\.\d{0,6})?$').hasMatch(next)) {
      return newValue;
    }
    return oldValue;
  }
}

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
    return '$displayName - $mobile';
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

void _updateResidentEditableProfile({
  required String name,
  required String phone,
}) {
  final current = _currentResidentProfile;
  if (current == null) {
    return;
  }
  _currentResidentProfile = _ResidentSessionProfile(
    name: name,
    mobile: phone,
    province: current.province,
    cityMunicipality: current.cityMunicipality,
    barangay: current.barangay,
    middleName: current.middleName,
    suffix: current.suffix,
    religion: current.religion,
  );
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

ValueNotifier<List<_AppNotificationItem>> _notificationCenterForRole(
  UserRole role,
) {
  return role == UserRole.resident
      ? _residentNotificationCenter
      : _officialNotificationCenter;
}

ValueNotifier<_NotificationPreferenceSettings> _notificationPreferencesForRole(
  UserRole role,
) {
  return role == UserRole.resident
      ? _residentNotificationPreferences
      : _officialNotificationPreferences;
}

ValueNotifier<int> _notificationBadgeForRole(UserRole role) {
  return role == UserRole.resident
      ? _residentNotificationBadge
      : _officialNotificationBadge;
}

bool _isInQuietHours(
  DateTime value,
  _NotificationPreferenceSettings settings,
) {
  if (!settings.quietHoursEnabled) {
    return false;
  }
  final hour = value.hour;
  final start = settings.quietStartHour;
  final end = settings.quietEndHour;
  if (start == end) {
    return true;
  }
  if (start > end) {
    return hour >= start || hour < end;
  }
  return hour >= start && hour < end;
}

void _incrementNotificationBadge(UserRole role) {
  final badge = _notificationBadgeForRole(role);
  badge.value = badge.value + 1;
}

void _resetNotificationBadge(UserRole role) {
  _notificationBadgeForRole(role).value = 0;
}

void _markNotificationRead(UserRole role, _AppNotificationItem item) {
  item.read = true;
  _notificationCenterForRole(role).value = [..._notificationCenterForRole(role).value];
}

void _registerNotificationToken(
  UserRole role,
  String mobile, {
  String platform = 'android',
}) {
  final normalized = _normalizeMobileForKey(mobile);
  if (normalized.isEmpty) {
    return;
  }
  final next = [
    for (final token in _notificationDispatcherTokens.value)
      if (!(token.role == role && token.mobile == normalized)) token,
    _NotificationDispatcherToken(
      role: role,
      mobile: normalized,
      token: 'mock-fcm-${role.name}-$normalized',
      platform: platform,
      registeredAt: DateTime.now(),
    ),
  ];
  _notificationDispatcherTokens.value = next;
}

void _appendDispatchLog({
  required UserRole role,
  required String title,
  required String body,
  required String audience,
  required String channel,
  required String provider,
  required String status,
  required String priority,
}) {
  _notificationDispatchLog.value = [
    _NotificationDispatchLogEntry(
      role: role,
      title: title,
      body: body,
      audience: audience,
      channel: channel,
      provider: provider,
      status: status,
      priority: priority,
      createdAt: DateTime.now(),
    ),
    ..._notificationDispatchLog.value,
  ];
}

void _flushDeferredNotifications() {
  if (_deferredNotifications.value.isEmpty) {
    return;
  }
  final pending = [..._deferredNotifications.value];
  final stillQueued = <_DeferredNotificationEnvelope>[];
  for (final item in pending) {
    final prefs = _notificationPreferencesForRole(item.role).value;
    if (_isInQuietHours(DateTime.now(), prefs) && item.priority != 'emergency') {
      stillQueued.add(item);
      continue;
    }
    _pushSystemNotification(
      item.role,
      title: item.title,
      body: item.body,
      category: item.category,
      icon: item.icon,
      priority: item.priority,
      recordId: item.recordId,
      deepLink: item.deepLink,
      marketing: item.marketing,
      respectQuietHours: false,
    );
  }
  _deferredNotifications.value = stillQueued;
}

void _handleAppOpened() {
  _resetNotificationBadge(UserRole.resident);
  _resetNotificationBadge(UserRole.official);
  _flushDeferredNotifications();
}

List<_BroadcastResidentProfile> _filterBroadcastRecipients({
  String zone = 'All',
  String purok = 'All',
  String residentType = 'All',
}) {
  return _broadcastResidentDirectory.where((entry) {
    final zoneOk = zone == 'All' || entry.zone == zone;
    final purokOk = purok == 'All' || entry.purok == purok;
    final typeOk = residentType == 'All' || entry.residentType == residentType;
    return zoneOk && purokOk && typeOk;
  }).toList();
}

String _directThreadId(String residentMobile) =>
    'resident-${_normalizeMobileForKey(residentMobile)}';

List<_DirectMessageEntry> _messagesForThread(String threadId) {
  final items = _directMessageStore.value
      .where((entry) => entry.threadId == threadId)
      .toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return items;
}

void _markDirectMessagesRead(UserRole viewerRole, String threadId) {
  bool changed = false;
  final updated = [
    for (final message in _directMessageStore.value)
      if (message.threadId == threadId &&
          message.senderRole != viewerRole &&
          message.readAt == null)
        (() {
          changed = true;
          return message.copyWith(readAt: DateTime.now());
        })()
      else
        message,
  ];
  if (changed) {
    _directMessageStore.value = updated;
  }
}

void _sendDirectMessage({
  required UserRole senderRole,
  required String residentName,
  required String residentMobile,
  String? text,
  Uint8List? imageBytes,
}) {
  final threadId = _directThreadId(residentMobile);
  final senderName = senderRole == UserRole.official
      ? _officialEditableProfile.value.name
      : _displayNameForRole(UserRole.resident);
  final entry = _DirectMessageEntry(
    id: 'dm-${DateTime.now().microsecondsSinceEpoch}',
    threadId: threadId,
    senderRole: senderRole,
    senderName: senderName,
    residentName: residentName,
    residentMobile: residentMobile,
    text: text,
    imageBytes: imageBytes,
    createdAt: DateTime.now(),
  );
  _directMessageStore.value = [..._directMessageStore.value, entry];
  _directMessageStreamController.add(entry);
  final recipientRole =
      senderRole == UserRole.official ? UserRole.resident : UserRole.official;
  _pushSystemNotification(
    recipientRole,
    title: senderRole == UserRole.official
        ? 'Official message received'
        : 'Resident message received',
    body: text?.trim().isNotEmpty == true
        ? text!.trim()
        : 'Image attachment received.',
    category: 'Messages',
    icon: Icons.chat_bubble_outline_rounded,
    priority: 'normal',
    recordId: threadId,
    deepLink: 'barangaymo://message/$threadId',
  );
}

void _sendOfficialBroadcast({
  required String title,
  required String body,
  required String zone,
  required String purok,
  required String residentType,
  required bool emergency,
}) {
  final recipients = _filterBroadcastRecipients(
    zone: zone,
    purok: purok,
    residentType: residentType,
  );
  final audience =
      '${recipients.length} resident(s) | $zone | $purok | $residentType';
  final currentResidentMobile = _currentResidentProfile?.mobile ?? '';
  final shouldDeliverToCurrentResident =
      recipients.isEmpty ||
      recipients.any(
        (entry) =>
            _normalizeMobileForKey(entry.mobile) ==
            _normalizeMobileForKey(currentResidentMobile),
      );
  if (shouldDeliverToCurrentResident) {
    _pushSystemNotification(
      UserRole.resident,
      title: title,
      body: body,
      category: emergency ? 'Emergency Broadcast' : 'Broadcast',
      icon: emergency ? Icons.warning_amber_rounded : Icons.campaign_outlined,
      priority: emergency ? 'emergency' : 'high',
      deepLink: 'barangaymo://broadcast/${DateTime.now().millisecondsSinceEpoch}',
      respectQuietHours: !emergency,
    );
  }
  _pushSystemNotification(
    UserRole.official,
    title: 'Broadcast dispatched',
    body: '$title sent to ${recipients.length} targeted residents.',
    category: 'Broadcast',
    icon: Icons.campaign_rounded,
    priority: emergency ? 'emergency' : 'high',
    deepLink: 'barangaymo://dispatch-log/broadcast',
    respectQuietHours: false,
  );
  _appendDispatchLog(
    role: UserRole.official,
    title: title,
    body: body,
    audience: audience,
    channel: emergency ? 'FCM + SMS' : 'FCM',
    provider: emergency ? 'Semaphore -> Twilio failover' : 'FCM dispatcher',
    status: recipients.isEmpty ? 'No matching audience' : 'Dispatched',
    priority: emergency ? 'emergency' : 'high',
  );
}

ValueNotifier<_AccountDeletionRequest?> _deletionRequestForRole(UserRole role) {
  return role == UserRole.resident
      ? _residentDeletionRequest
      : _officialDeletionRequest;
}

String _displayNameForRole(UserRole role) {
  if (role == UserRole.resident) {
    return _residentDisplayName();
  }
  return _officialEditableProfile.value.name;
}

String _mobileForRole(UserRole role) {
  if (role == UserRole.resident) {
    return _residentMobileDisplay();
  }
  return _officialEditableProfile.value.phone;
}

String _stableMockIpAddress(String seed) {
  final digits = seed.replaceAll(RegExp(r'\D'), '');
  final base = digits.isEmpty ? '09123456789' : digits;
  final numbers = base.codeUnits.fold<List<int>>(
    [10, 20, 30, 40],
    (parts, unit) => [
      (parts[0] + unit) % 200 + 20,
      (parts[1] + unit * 2) % 180 + 20,
      (parts[2] + unit * 3) % 180 + 20,
      (parts[3] + unit * 4) % 180 + 20,
    ],
  );
  return '${numbers[0]}.${numbers[1]}.${numbers[2]}.${numbers[3]}';
}

void _pushSystemNotification(
  UserRole role, {
  required String title,
  required String body,
  required String category,
  required IconData icon,
  String priority = 'normal',
  String? recordId,
  String? deepLink,
  bool marketing = false,
  bool respectQuietHours = true,
}) {
  final preferences = _notificationPreferencesForRole(role).value;
  if (marketing && !preferences.marketingEnabled) {
    _appendDispatchLog(
      role: role,
      title: title,
      body: body,
      audience: _systemRoleLabel(role),
      channel: 'Suppressed',
      provider: 'Preference engine',
      status: 'Blocked by marketing preference',
      priority: priority,
    );
    return;
  }
  if (respectQuietHours &&
      priority != 'emergency' &&
      _isInQuietHours(DateTime.now(), preferences)) {
    _deferredNotifications.value = [
      _DeferredNotificationEnvelope(
        role: role,
        title: title,
        body: body,
        category: category,
        icon: icon,
        priority: priority,
        recordId: recordId,
        deepLink: deepLink,
        marketing: marketing,
      ),
      ..._deferredNotifications.value,
    ];
    _appendDispatchLog(
      role: role,
      title: title,
      body: body,
      audience: _systemRoleLabel(role),
      channel: 'Deferred',
      provider: 'Quiet hours',
      status: 'Queued until quiet hours end',
      priority: priority,
    );
    return;
  }
  final store = _notificationCenterForRole(role);
  final hasToken = _notificationDispatcherTokens.value.any((token) {
    return token.role == role;
  });
  final deliveryChannel = preferences.pushEnabled && hasToken
      ? 'FCM'
      : ((priority == 'high' || priority == 'emergency') && preferences.smsEnabled
            ? 'SMS'
            : 'In-app');
  final provider = deliveryChannel == 'SMS'
      ? 'Semaphore -> Twilio failover'
      : (deliveryChannel == 'FCM' ? 'FCM dispatcher' : 'Local inbox');
  store.value = [
    _AppNotificationItem(
      id: '${role.name}-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: category,
      createdAt: DateTime.now(),
      icon: icon,
      priority: priority,
      recordId: recordId,
      deepLink: deepLink,
      deliveryChannel: deliveryChannel,
      marketing: marketing,
    ),
    ...store.value,
  ];
  _incrementNotificationBadge(role);
  _appendDispatchLog(
    role: role,
    title: title,
    body: body,
    audience: _systemRoleLabel(role),
    channel: deliveryChannel,
    provider: provider,
    status: 'Delivered',
    priority: priority,
  );
}

void _markAllNotificationsRead(UserRole role) {
  final store = _notificationCenterForRole(role);
  for (final item in store.value) {
    item.read = true;
  }
  store.value = [...store.value];
  _resetNotificationBadge(role);
}

void _recordSecurityLog(
  UserRole role, {
  required String mobile,
  required String action,
}) {
  _securityLogFeed.value = [
    _SecurityLogEntry(
      role: role,
      actor: _displayNameForRole(role),
      mobile: mobile,
      ipAddress: _stableMockIpAddress(mobile),
      action: action,
      createdAt: DateTime.now(),
    ),
    ..._securityLogFeed.value,
  ];
}

void _recordTransaction(_SystemTransactionEntry entry) {
  _transactionHistoryFeed.value = [entry, ..._transactionHistoryFeed.value];
}

String _submitHelpDeskTicket(
  UserRole role, {
  required String subject,
  required String message,
  required String contact,
}) {
  final id = 'HD-${DateTime.now().millisecondsSinceEpoch % 100000}';
  _helpDeskFeed.value = [
    _HelpDeskTicketEntry(
      id: id,
      role: role,
      subject: subject,
      message: message,
      contact: contact,
      createdAt: DateTime.now(),
    ),
    ..._helpDeskFeed.value,
  ];
  _pushSystemNotification(
    role,
    title: 'Help desk ticket submitted',
    body: '$subject has been recorded under ticket $id.',
    category: 'Support',
    icon: Icons.support_agent_outlined,
    recordId: id,
    deepLink: 'barangaymo://helpdesk/$id',
  );
  return id;
}

void _scheduleAccountDeletion(UserRole role, String mobile) {
  final requestedAt = DateTime.now();
  _deletionRequestForRole(role).value = _AccountDeletionRequest(
    role: role,
    mobile: mobile,
    requestedAt: requestedAt,
    deleteOn: requestedAt.add(const Duration(days: 30)),
  );
  _pushSystemNotification(
    role,
    title: 'Account deletion scheduled',
    body: 'Your account is now under a 30-day grace period before deletion.',
    category: 'Security',
    icon: Icons.delete_outline,
    deepLink: 'barangaymo://security/deletion',
  );
}

void _cancelScheduledDeletion(UserRole role) {
  _deletionRequestForRole(role).value = null;
  _pushSystemNotification(
    role,
    title: 'Deletion request cancelled',
    body: 'Your account will remain active and accessible.',
    category: 'Security',
    icon: Icons.restore_from_trash_outlined,
    deepLink: 'barangaymo://security/deletion',
  );
}

Future<void> _clearSessionAfterAccountDeletion(UserRole role) async {
  if (role == UserRole.resident) {
    final mobile = _currentResidentProfile?.mobile ?? '';
    if (mobile.isNotEmpty) {
      await _ResidentAuthCacheStore.clear(mobile);
      await _ResidentMpinStore.clear(mobile);
    }
    _currentResidentProfile = null;
  } else {
    final mobile = _currentOfficialMobile ?? _officialEditableProfile.value.phone;
    if (mobile.isNotEmpty) {
      await _OfficialAuthCacheStore.clear(mobile);
      await _OfficialMpinStore.clear(mobile);
    }
    _currentOfficialMobile = null;
    _officialActivationCompleted = false;
  }

  _authToken = null;
  _deletionRequestForRole(role).value = null;
  _scopedBarangayLogoBytes.value = null;
  _scopedBarangayLogoRefresh.value = _scopedBarangayLogoRefresh.value + 1;
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

  static Future<String?> currentPin(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      final value = prefs.getString(_keyFor(variant));
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
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

  static Future<void> clear(String mobile) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      await prefs.remove(_keyFor(variant));
    }
    final last = prefs.getString(_lastMobileKey);
    if (last != null && _mobileKeyVariants(mobile).contains(last)) {
      await prefs.remove(_lastMobileKey);
    }
  }
}

String _currentScopeKeyForBranding() {
  if (_currentOfficialMobile != null && _currentOfficialMobile!.trim().isNotEmpty) {
    final p = _officialBarangaySetup.province.trim().toLowerCase();
    final c = _officialBarangaySetup.city.trim().toLowerCase();
    final b = _officialBarangaySetup.barangay.trim().toLowerCase();
    return '$p|$c|$b';
  }
  final resident = _currentResidentProfile;
  if (resident != null) {
    final p = resident.province.trim().toLowerCase();
    final c = resident.cityMunicipality.trim().toLowerCase();
    final b = resident.barangay.trim().toLowerCase();
    return '$p|$c|$b';
  }
  return '';
}

Future<void> _syncScopedBarangayBranding({bool force = false}) async {
  if (_authToken == null || _authToken!.isEmpty) {
    return;
  }
  final scopeKey = _currentScopeKeyForBranding();
  if (!force && scopeKey.isEmpty) {
    return;
  }
  final paths = <String>[
    'barangay/branding',
    if (_currentOfficialMobile != null && _currentOfficialMobile!.isNotEmpty)
      'official/barangay-setup',
  ];
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
          continue;
        }
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        if (decoded is! Map<String, dynamic>) {
          continue;
        }
        final contentType = (response.headers['content-type'] ?? '').toLowerCase();
        final looksLikeHtml = contentType.contains('text/html') ||
            response.body.trimLeft().toLowerCase().startsWith('<!doctype html') ||
            response.body.trimLeft().toLowerCase().startsWith('<html');
        if (looksLikeHtml) {
          continue;
        }
        final source = decoded['branding'] is Map<String, dynamic>
            ? decoded['branding'] as Map<String, dynamic>
            : (decoded['setup'] is Map<String, dynamic>
                ? decoded['setup'] as Map<String, dynamic>
                : <String, dynamic>{});
        if (source.isEmpty) {
          continue;
        }
        final raw = (source['logo_image_base64'] ?? '').toString().trim();
        Uint8List? logoBytes;
        if (raw.isNotEmpty) {
          try {
            final cleaned = raw.startsWith('data:image/')
                ? raw.split(',').last
                : raw;
            logoBytes = base64Decode(cleaned);
          } catch (_) {
            logoBytes = null;
          }
        }
        _scopedBarangayLogoBytes.value = logoBytes;
        _scopedBarangayLogoRefresh.value = _scopedBarangayLogoRefresh.value + 1;

        if (source['logo_file_name'] != null) {
          final logoName = source['logo_file_name'].toString().trim();
          _officialBarangaySetup.logoFileName = logoName.isEmpty ? null : logoName;
          _officialBarangaySetup.logoBytes = logoBytes;
        }
        return;
      } on TimeoutException {
        continue;
      } catch (_) {
        continue;
      }
    }
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
  static const String _expiresPrefix = 'resident_session_expires_';

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
    await prefs.setInt(
      _key(_expiresPrefix, accountMobile),
      DateTime.now().add(_cachedSessionLifetime).millisecondsSinceEpoch,
    );
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
    final expiresAt = prefs.getInt(_key(_expiresPrefix, keyMobile)) ?? 0;
    if (expiresAt <= DateTime.now().millisecondsSinceEpoch) {
      await clear(keyMobile);
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
      await prefs.remove(_key(_expiresPrefix, variant));
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

  static Future<String?> currentPin(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      final value = prefs.getString(_keyFor(variant));
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
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

  static Future<void> clear(String mobile) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    for (final variant in _mobileKeyVariants(mobile)) {
      await prefs.remove(_keyFor(variant));
    }
    final last = prefs.getString(_lastMobileKey);
    if (last != null && _mobileKeyVariants(mobile).contains(last)) {
      await prefs.remove(_lastMobileKey);
    }
  }
}

class _OfficialAuthCacheStore {
  static const String _tokenPrefix = 'official_session_token_';
  static const String _mobilePrefix = 'official_session_mobile_';
  static const String _activationPrefix = 'official_session_activation_';
  static const String _expiresPrefix = 'official_session_expires_';
  static const String _namePrefix = 'official_session_name_';
  static const String _barangayPrefix = 'official_session_barangay_';
  static const String _cityPrefix = 'official_session_city_';
  static const String _provincePrefix = 'official_session_province_';

  static String _key(String prefix, String mobile) {
    return '$prefix${_normalizeMobileForKey(mobile)}';
  }

  static Future<void> save({
    required String token,
    required String mobile,
    required bool activationCompleted,
    String? name,
    String? barangay,
    String? cityMunicipality,
    String? province,
  }) async {
    final normalized = _normalizeMobileForKey(mobile);
    if (normalized.isEmpty || token.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_tokenPrefix, mobile), token);
    await prefs.setString(_key(_mobilePrefix, mobile), normalized);
    await prefs.setBool(_key(_activationPrefix, mobile), activationCompleted);
    await prefs.setString(_key(_namePrefix, mobile), (name ?? '').trim());
    await prefs.setString(_key(_barangayPrefix, mobile), (barangay ?? '').trim());
    await prefs.setString(_key(_cityPrefix, mobile), (cityMunicipality ?? '').trim());
    await prefs.setString(_key(_provincePrefix, mobile), (province ?? '').trim());
    await prefs.setInt(
      _key(_expiresPrefix, mobile),
      DateTime.now().add(_cachedSessionLifetime).millisecondsSinceEpoch,
    );
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
    final expiresAt = prefs.getInt(_key(_expiresPrefix, keyMobile)) ?? 0;
    if (expiresAt <= DateTime.now().millisecondsSinceEpoch) {
      await clear(keyMobile);
      return false;
    }
    final storedActivation =
        prefs.getBool(_key(_activationPrefix, keyMobile)) ?? false;
    final cachedName = (prefs.getString(_key(_namePrefix, keyMobile)) ?? '').trim();
    final cachedBarangay = (prefs.getString(_key(_barangayPrefix, keyMobile)) ?? '').trim();
    final cachedCity = (prefs.getString(_key(_cityPrefix, keyMobile)) ?? '').trim();
    final cachedProvince = (prefs.getString(_key(_provincePrefix, keyMobile)) ?? '').trim();
    if (cachedBarangay.isEmpty || cachedCity.isEmpty || cachedProvince.isEmpty) {
      return false;
    }
    final localCompleted = await _LocalActivationStore.isCompleted(normalized);
    _authToken = token;
    _currentOfficialMobile = normalized;
    _officialActivationCompleted = storedActivation || localCompleted;
    _officialEditableProfile.value = _officialEditableProfile.value.copyWith(
      name: cachedName.isNotEmpty ? cachedName : null,
      phone: normalized,
      barangay: cachedBarangay,
    );
    _officialBarangaySetup.barangay = cachedBarangay;
    _officialBarangaySetup.city = cachedCity;
    _officialBarangaySetup.province = cachedProvince;
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
      await prefs.remove(_key(_expiresPrefix, variant));
      await prefs.remove(_key(_namePrefix, variant));
      await prefs.remove(_key(_barangayPrefix, variant));
      await prefs.remove(_key(_cityPrefix, variant));
      await prefs.remove(_key(_provincePrefix, variant));
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
  await _syncScopedBarangayBranding(force: true);
  _recordSecurityLog(
    UserRole.resident,
    mobile: normalizedMobile,
    action: 'Signed in',
  );
  _registerNotificationToken(UserRole.resident, normalizedMobile);
  _pushSystemNotification(
    UserRole.resident,
    title: 'New resident session',
    body: 'Your resident account signed in successfully.',
    category: 'Security',
    icon: Icons.verified_user_outlined,
  );
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
  Map<String, dynamic>? user,
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
  String readUser(String key) => ((user ?? const <String, dynamic>{})[key] as String? ?? '').trim();
  final profileName = readUser('name');
  final profileBarangay = readUser('barangay');
  final profileCity = readUser('city_municipality');
  final profileProvince = readUser('province');
  _officialEditableProfile.value = _officialEditableProfile.value.copyWith(
    name: profileName.isNotEmpty ? profileName : null,
    phone: normalized,
    barangay: profileBarangay.isNotEmpty ? profileBarangay : _officialBarangaySetup.barangay,
  );
  if (profileBarangay.isNotEmpty) {
    _officialBarangaySetup.barangay = profileBarangay;
  }
  if (profileCity.isNotEmpty) {
    _officialBarangaySetup.city = profileCity;
  }
  if (profileProvince.isNotEmpty) {
    _officialBarangaySetup.province = profileProvince;
  }
  await _OfficialAuthCacheStore.save(
    token: token,
    mobile: normalized,
    activationCompleted: _officialActivationCompleted,
    name: profileName,
    barangay: _officialBarangaySetup.barangay,
    cityMunicipality: _officialBarangaySetup.city,
    province: _officialBarangaySetup.province,
  );
  if (pin != null && _isValidAppPin(pin)) {
    await _OfficialMpinStore.savePin(normalized, pin);
  }
  await _OfficialMpinStore.rememberMobile(normalized);
  await _FirstRoleAccessStore.markRegistered(UserRole.official);
  await _syncScopedBarangayBranding(force: true);
  _recordSecurityLog(
    UserRole.official,
    mobile: normalized,
    action: 'Signed in',
  );
  _registerNotificationToken(UserRole.official, normalized);
  _pushSystemNotification(
    UserRole.official,
    title: 'Official session active',
    body: 'Official account access was granted on this device.',
    category: 'Security',
    icon: Icons.admin_panel_settings_outlined,
  );
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

class _AddressDirectoryResult {
  final bool success;
  final String message;
  final Map<String, Map<String, List<String>>> location;

  const _AddressDirectoryResult({
    required this.success,
    required this.message,
    this.location = const {},
  });
}

class _AuthRequestOutcome {
  final http.Response? response;
  final Map<String, dynamic> body;
  final bool sawTimeout;
  final bool sawConnectionError;
  final bool sawHtmlFallback;

  const _AuthRequestOutcome({
    required this.response,
    required this.body,
    required this.sawTimeout,
    required this.sawConnectionError,
    required this.sawHtmlFallback,
  });
}

class _AuthApi {
  _AuthApi._();
  static final _AuthApi instance = _AuthApi._();

  static const String _androidPhysicalDeviceBaseUrlHint =
      'http://<YOUR_PC_LOCAL_IP>:8000';
  static const Duration _requestTimeout = Duration(seconds: 5);

  String _normalizeMobile(String input) {
    return input.replaceAll(RegExp(r'\D'), '');
  }

  String _trimTrailingSlash(String input) {
    return input.endsWith('/') ? input.substring(0, input.length - 1) : input;
  }

  String? _validatedBaseUrl(String input) {
    final trimmed = _trimTrailingSlash(input.trim());
    if (trimmed.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return null;
    }
    if (uri.host.isEmpty) {
      return null;
    }
    return trimmed;
  }

  List<String> _baseUrlCandidates() {
    final out = <String>[];

    void add(String baseUrl) {
      final trimmed = _validatedBaseUrl(baseUrl);
      if (trimmed != null && !out.contains(trimmed)) {
        out.add(trimmed);
      }
    }

    final configuredBaseUrl = _validatedBaseUrl(_configuredApiBaseUrl);
    if (configuredBaseUrl != null) {
      add(configuredBaseUrl);
      final configuredUri = Uri.tryParse(configuredBaseUrl);
      if (configuredUri != null) {
        final basePath = configuredUri.path.trim();
        final hasApiPath = basePath.isNotEmpty &&
            basePath != '/' &&
            basePath.toLowerCase().endsWith('/api');
        final pathSegments = hasApiPath ? '/api' : '';

        final explicitPort = configuredUri.hasPort;
        final nonDefaultPort = explicitPort &&
            !((configuredUri.scheme == 'http' && configuredUri.port == 80) ||
                (configuredUri.scheme == 'https' && configuredUri.port == 443));

        String compose({
          required String scheme,
          required bool includePort,
          required bool includeApiPath,
        }) {
          final host = configuredUri.host;
          final portPart = includePort && explicitPort ? ':${configuredUri.port}' : '';
          final pathPart = includeApiPath ? pathSegments : '';
          return '$scheme://$host$portPart$pathPart';
        }

        // Keep configured URL first, then broaden candidates for physical-device reliability.
        add(compose(
          scheme: configuredUri.scheme,
          includePort: true,
          includeApiPath: hasApiPath,
        ));
        add(compose(
          scheme: configuredUri.scheme,
          includePort: true,
          includeApiPath: false,
        ));
        if (nonDefaultPort) {
          add(compose(
            scheme: configuredUri.scheme,
            includePort: false,
            includeApiPath: hasApiPath,
          ));
          add(compose(
            scheme: configuredUri.scheme,
            includePort: false,
            includeApiPath: false,
          ));
        }
        if (configuredUri.scheme == 'http') {
          add(compose(
            scheme: 'https',
            includePort: false,
            includeApiPath: hasApiPath,
          ));
          add(compose(
            scheme: 'https',
            includePort: false,
            includeApiPath: false,
          ));
        }
      }
    }

    if (!bool.fromEnvironment('dart.vm.product')) {
      if (kIsWeb) {
        add('http://127.0.0.1:8000');
        add('http://localhost:8000');
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
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
      add(_configuredApiBaseUrl);
      return out;
    }

    add(_configuredApiBaseUrl);
    return out;
  }

  Uri? _endpoint(String baseUrl, String path) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.tryParse('${_trimTrailingSlash(baseUrl)}/$normalizedPath');
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
      if (uri == null) {
        return;
      }
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
      return 'Cannot connect to any backend. For local Laravel on Android, run `php artisan serve --host=0.0.0.0 --port=8000`, then start Flutter with `--dart-define=API_BASE_URL=$_androidPhysicalDeviceBaseUrlHint`, or use `adb reverse tcp:8000 tcp:8000` over USB.';
    }
    return 'Cannot connect to server. Check backend URL and if Laravel is running.';
  }

  String _htmlFallbackMessage(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return 'Backend reached, but $normalizedPath returned HTML instead of JSON. Check Laravel API routes in routes/api.php and make sure the endpoint returns JSON.';
  }

  bool _looksLikeHtmlFallback(
    http.Response response,
    Map<String, dynamic> decodedBody,
  ) {
    if (decodedBody.isNotEmpty) {
      return false;
    }
    final contentType = (response.headers['content-type'] ?? '').toLowerCase();
    final raw = response.body.trimLeft().toLowerCase();
    return contentType.contains('text/html') ||
        raw.startsWith('<!doctype html') ||
        raw.startsWith('<html');
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
    var sawHtmlFallback = false;
    final endpoints = _endpointCandidates(path);

    for (var i = 0; i < endpoints.length; i++) {
      try {
        final current = await http
            .post(endpoints[i], headers: headers, body: body)
            .timeout(_requestTimeout);
        final decoded = _decodeResponseBody(current.body);
        if (_looksLikeHtmlFallback(current, decoded)) {
          sawHtmlFallback = true;
          continue;
        }
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
      sawHtmlFallback: sawHtmlFallback,
    );
  }

  Future<_AuthApiResult> register({
    required UserRole role,
    required String name,
    String? email,
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
        if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
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
      if (outcome.sawHtmlFallback) {
        return _AuthApiResult(
          success: false,
          message: _htmlFallbackMessage('/api/register'),
        );
      }
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

    if (response.statusCode == 201 || response.statusCode == 200) {
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
      if (outcome.sawHtmlFallback) {
        return _AuthApiResult(
          success: false,
          message: _htmlFallbackMessage('/api/login'),
        );
      }
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
      if (outcome.sawHtmlFallback) {
        return _AuthApiResult(
          success: false,
          message: _htmlFallbackMessage('/api/verify-otp'),
        );
      }
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
      if (outcome.sawHtmlFallback) {
        return _AuthApiResult(
          success: false,
          message: _htmlFallbackMessage('/api/resend-otp'),
        );
      }
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
      if (outcome.sawHtmlFallback) {
        return _AuthApiResult(
          success: false,
          message: _htmlFallbackMessage('/api/activation/complete'),
        );
      }
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

    if (response.statusCode == 404) {
      return _AuthApiResult(
        success: false,
        message: _extractMessage(
          body,
          fallback:
              'Activation endpoint is not available on the server yet. Please update/deploy the API first.',
        ),
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

  Future<_AuthApiResult> deleteAccount({
    required String currentPin,
    required String confirmText,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _AuthApiResult(
        success: false,
        message: 'Missing login session. Please log in again.',
      );
    }

    final payload = jsonEncode({
      'current_pin': currentPin.trim(),
      'confirm_text': confirmText.trim().toUpperCase(),
    });

    final paths = <String>[
      'account',
      'account/delete',
    ];

    for (final path in paths) {
      for (final endpoint in _endpointCandidates(path)) {
        try {
          http.Response response = await http
              .delete(
                endpoint,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $_authToken',
                },
                body: payload,
              )
              .timeout(_requestTimeout);
          if (response.statusCode == 404) {
            response = await http
                .post(
                  endpoint,
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer $_authToken',
                  },
                  body: payload,
                )
                .timeout(_requestTimeout);
          }
          final body = _decodeResponseBody(response.body);
          if (response.statusCode == 404) {
            continue;
          }
          return _AuthApiResult(
            success: response.statusCode >= 200 && response.statusCode < 300,
            message: _extractMessage(
              body,
              fallback: response.statusCode >= 200 && response.statusCode < 300
                  ? 'Account deleted permanently.'
                  : 'Unable to delete account.',
            ),
          );
        } on TimeoutException {
          return const _AuthApiResult(
            success: false,
            message: 'Delete account request timed out.',
          );
        } catch (_) {
          return const _AuthApiResult(
            success: false,
            message: 'Unable to delete account right now.',
          );
        }
      }
    }

    return const _AuthApiResult(
      success: false,
      message: 'Delete account endpoint unavailable on configured API.',
    );
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

  Future<_AddressDirectoryResult> fetchActivationAddressDirectory() async {
    var sawTimeout = false;
    var sawConnectionError = false;
    var sawHtmlFallback = false;
    final attemptedUris = <String>{};
    final paths = <String>[
      'locations/address-directory',
      'locations/directory',
      'locations',
      'address/directory',
      'activation/locations',
      'barangays/directory',
    ];

    for (final path in paths) {
      final endpoints = _endpointCandidates(path);
      for (final endpoint in endpoints) {
        if (!attemptedUris.add(endpoint.toString())) {
          continue;
        }
        try {
          final response = await http
              .get(endpoint, headers: const {'Accept': 'application/json'})
              .timeout(_requestTimeout);
          final decoded = _decodeDynamicJson(response.body);
          final decodedMap = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};

          if (_looksLikeHtmlFallback(response, decodedMap)) {
            sawHtmlFallback = true;
            continue;
          }

          if (response.statusCode == 404) {
            continue;
          }

          if (response.statusCode >= 200 && response.statusCode < 300) {
            final location = _extractLocationDirectory(decoded);
            if (location.isNotEmpty) {
              return _AddressDirectoryResult(
                success: true,
                message: 'Address directory loaded.',
                location: location,
              );
            }
          }
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawHtmlFallback) {
      return _AddressDirectoryResult(
        success: false,
        message: _htmlFallbackMessage('/api/locations'),
      );
    }
    if (sawTimeout || sawConnectionError) {
      return _AddressDirectoryResult(
        success: false,
        message: _connectionHelpMessage(),
      );
    }
    return const _AddressDirectoryResult(
      success: false,
      message: 'Address directory endpoint is not available yet.',
    );
  }

  dynamic _decodeDynamicJson(String raw) {
    if (raw.isEmpty) {
      return null;
    }
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  Map<String, Map<String, List<String>>> _extractLocationDirectory(
    dynamic payload,
  ) {
    final temp = <String, Map<String, Set<String>>>{};

    void addEntry(String province, String city, String barangay) {
      final normalizedProvince = province.trim();
      final normalizedCity = city.trim();
      final normalizedBarangay = barangay.trim();
      if (normalizedProvince.isEmpty ||
          normalizedCity.isEmpty ||
          normalizedBarangay.isEmpty) {
        return;
      }
      temp.putIfAbsent(normalizedProvince, () => <String, Set<String>>{});
      temp[normalizedProvince]!.putIfAbsent(
        normalizedCity,
        () => <String>{},
      );
      temp[normalizedProvince]![normalizedCity]!.add(normalizedBarangay);
    }

    String? readString(
      Map<String, dynamic> node,
      List<String> keys,
    ) {
      for (final key in keys) {
        final value = node[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
      return null;
    }

    void parseFlatList(dynamic source) {
      if (source is! List) {
        return;
      }
      for (final item in source) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final province = readString(item, const [
          'province',
          'province_name',
          'prov_name',
        ]);
        final city = readString(item, const [
          'city_municipality',
          'city',
          'municipality',
          'city_name',
        ]);
        final barangay = readString(item, const [
          'barangay',
          'barangay_name',
          'name',
        ]);
        if (province != null && city != null && barangay != null) {
          addEntry(province, city, barangay);
        }
      }
    }

    void parseMapShape(dynamic source) {
      if (source is! Map<String, dynamic>) {
        return;
      }
      for (final provinceEntry in source.entries) {
        if (provinceEntry.value is! Map<String, dynamic>) {
          continue;
        }
        final cityMap = provinceEntry.value as Map<String, dynamic>;
        for (final cityEntry in cityMap.entries) {
          if (cityEntry.value is! List) {
            continue;
          }
          final barangays = cityEntry.value as List;
          for (final barangay in barangays) {
            if (barangay is String && barangay.trim().isNotEmpty) {
              addEntry(provinceEntry.key, cityEntry.key, barangay);
            } else if (barangay is Map<String, dynamic>) {
              final barangayName = readString(
                barangay,
                const ['name', 'barangay', 'barangay_name'],
              );
              if (barangayName != null) {
                addEntry(provinceEntry.key, cityEntry.key, barangayName);
              }
            }
          }
        }
      }
    }

    void parseHierarchical(dynamic source) {
      if (source is! List) {
        return;
      }
      for (final provinceNode in source) {
        if (provinceNode is! Map<String, dynamic>) {
          continue;
        }
        final provinceName = readString(
          provinceNode,
          const ['name', 'province', 'province_name'],
        );
        if (provinceName == null) {
          continue;
        }
        final cityNodes =
            provinceNode['cities'] ??
            provinceNode['city_municipalities'] ??
            provinceNode['municipalities'];
        if (cityNodes is! List) {
          continue;
        }
        for (final cityNode in cityNodes) {
          if (cityNode is! Map<String, dynamic>) {
            continue;
          }
          final cityName = readString(
            cityNode,
            const ['name', 'city', 'city_municipality', 'municipality'],
          );
          if (cityName == null) {
            continue;
          }
          final barangayNodes = cityNode['barangays'];
          if (barangayNodes is! List) {
            continue;
          }
          for (final barangayNode in barangayNodes) {
            if (barangayNode is String && barangayNode.trim().isNotEmpty) {
              addEntry(provinceName, cityName, barangayNode);
              continue;
            }
            if (barangayNode is Map<String, dynamic>) {
              final barangayName = readString(
                barangayNode,
                const ['name', 'barangay', 'barangay_name'],
              );
              if (barangayName != null) {
                addEntry(provinceName, cityName, barangayName);
              }
            }
          }
        }
      }
    }

    if (payload is Map<String, dynamic>) {
      parseMapShape(payload);
      parseFlatList(payload['data']);
      parseFlatList(payload['locations']);
      parseFlatList(payload['records']);
      parseHierarchical(payload['provinces']);
      if (payload['data'] is Map<String, dynamic>) {
        final data = payload['data'] as Map<String, dynamic>;
        parseMapShape(data);
        parseFlatList(data['locations']);
        parseFlatList(data['records']);
        parseHierarchical(data['provinces']);
      }
    } else {
      parseFlatList(payload);
      parseHierarchical(payload);
    }

    final location = <String, Map<String, List<String>>>{};
    final sortedProvinces = temp.keys.toList()..sort();
    for (final province in sortedProvinces) {
      final cityMap = temp[province]!;
      final sortedCities = cityMap.keys.toList()..sort();
      location[province] = <String, List<String>>{};
      for (final city in sortedCities) {
        final sortedBarangays = cityMap[city]!.toList()..sort();
        location[province]![city] = sortedBarangays;
      }
    }
    return location;
  }
}

