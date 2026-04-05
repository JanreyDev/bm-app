part of barangaymo_app;

bool get _hasOfficialEmergencyAccess =>
    (_currentOfficialMobile?.trim().isNotEmpty ?? false);

class _EmergencyContactItem {
  final int id;
  final String label;
  final String phoneNumber;
  final String description;
  final bool quickDial;
  final int sortOrder;

  const _EmergencyContactItem({
    this.id = 0,
    required this.label,
    required this.phoneNumber,
    required this.description,
    this.quickDial = false,
    this.sortOrder = 0,
  });
}

List<_EmergencyContactItem> _defaultEmergencyContacts() {
  return const <_EmergencyContactItem>[
    _EmergencyContactItem(
      label: 'BPAT',
      phoneNumber: '0917-800-1001',
      description: 'Barangay patrol and neighborhood security response',
      quickDial: true,
      sortOrder: 1,
    ),
    _EmergencyContactItem(
      label: 'Police',
      phoneNumber: '117',
      description: 'PNP rapid response and incident dispatch',
      quickDial: true,
      sortOrder: 2,
    ),
    _EmergencyContactItem(
      label: 'Fire Department',
      phoneNumber: '160',
      description: 'BFP fire suppression and rescue',
      quickDial: true,
      sortOrder: 3,
    ),
    _EmergencyContactItem(
      label: 'Ambulance',
      phoneNumber: '911',
      description: 'Emergency medical support and patient transport',
      quickDial: true,
      sortOrder: 4,
    ),
  ];
}

final ValueNotifier<List<_EmergencyContactItem>> _emergencyContacts =
    ValueNotifier<List<_EmergencyContactItem>>(_defaultEmergencyContacts());
bool _emergencyContactsLoaded = false;
bool _emergencyContactsLoading = false;

List<_EmergencyContactItem> _activeEmergencyContacts() {
  final contacts = _emergencyContacts.value;
  if (contacts.isNotEmpty) return contacts;
  return _defaultEmergencyContacts();
}

Future<void> _syncEmergencyContacts({bool force = false}) async {
  if (_emergencyContactsLoading) return;
  if (_emergencyContactsLoaded && !force) return;
  _emergencyContactsLoading = true;
  try {
    final result = await _EmergencyContactsApi.instance.fetchContacts();
    if (result.success) {
      _emergencyContacts.value = result.contacts;
      _emergencyContactsLoaded = true;
    } else if (result.message.toLowerCase().contains('unavailable')) {
      _emergencyContacts.value = _defaultEmergencyContacts();
    }
  } finally {
    _emergencyContactsLoading = false;
  }
}

IconData _emergencyIconForLabel(String label) {
  final key = label.trim().toLowerCase();
  if (key.contains('fire') || key.contains('bfp')) {
    return Icons.local_fire_department_rounded;
  }
  if (key.contains('ambulance') || key.contains('medical') || key.contains('ems')) {
    return Icons.medical_services_rounded;
  }
  if (key.contains('police') || key.contains('pnp') || key.contains('bpat')) {
    return Icons.local_police_rounded;
  }
  return Icons.shield_outlined;
}

Color _emergencyColorForLabel(String label) {
  final key = label.trim().toLowerCase();
  if (key.contains('fire') || key.contains('bfp')) return const Color(0xFFD84B3F);
  if (key.contains('ambulance') || key.contains('medical') || key.contains('ems')) {
    return const Color(0xFF2A8D62);
  }
  if (key.contains('police') || key.contains('pnp') || key.contains('bpat')) {
    return const Color(0xFF2F6BC8);
  }
  return const Color(0xFF6B6F7C);
}

String _quickDialLabelFromName(String label) {
  final key = label.trim().toLowerCase();
  if (key.contains('police')) return 'PNP';
  if (key.contains('fire')) return 'BFP';
  return label.trim();
}

List<_EmergencyContactItem> _quickDialContacts(List<_EmergencyContactItem> source) {
  final prioritized = source.where((entry) => entry.quickDial).toList();
  final list = prioritized.isNotEmpty ? prioritized : source;
  return list.take(3).toList();
}

Map<String, String> _emergencyScopePayload() {
  final profile = _currentResidentProfile;
  final province = (profile?.province ?? _officialBarangaySetup.province).trim();
  final city = (profile?.cityMunicipality ?? _officialBarangaySetup.city).trim();
  final barangay = (profile?.barangay ?? _officialBarangaySetup.barangay).trim();
  final payload = <String, String>{};
  if (province.isNotEmpty) payload['province'] = province;
  if (city.isNotEmpty) payload['city_municipality'] = city;
  if (barangay.isNotEmpty) payload['barangay'] = barangay;
  return payload;
}

String _pathWithScopeQuery(String path) {
  final scope = _emergencyScopePayload();
  debugPrint('API Scope request: $scope');
  if (scope.isEmpty) return path;
  final normalized = path.startsWith('/') ? path.substring(1) : path;
  final parsed = Uri.parse(normalized);
  final merged = <String, String>{
    ...parsed.queryParameters,
    ...scope,
  };
  final rebuilt = Uri(
    path: parsed.path,
    queryParameters: merged.isEmpty ? null : merged,
  );
  return rebuilt.toString();
}

class _EmergencyLiveLocationApiResult {
  final bool success;
  final String message;
  final _EmergencySharedLocation? location;

  const _EmergencyLiveLocationApiResult({
    required this.success,
    required this.message,
    this.location,
  });
}

class _EmergencyLiveLocationFeedApiResult {
  final bool success;
  final String message;
  final List<_EmergencySharedLocationFeedEntry> locations;

  const _EmergencyLiveLocationFeedApiResult({
    required this.success,
    required this.message,
    this.locations = const <_EmergencySharedLocationFeedEntry>[],
  });
}

class _EmergencyLiveLocationApi {
  _EmergencyLiveLocationApi._();
  static final instance = _EmergencyLiveLocationApi._();

  Future<_EmergencyLiveLocationApiResult> fetchLatest() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _EmergencyLiveLocationApiResult(
        success: false,
        message: 'Login required.',
      );
    }
    final path = _pathWithScopeQuery('emergency/shared-location');
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
          return _EmergencyLiveLocationApiResult(
            success: false,
            message: _extractMessage(response.body, 'Unable to load live location.'),
          );
        }
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        if (decoded is! Map<String, dynamic>) {
          return const _EmergencyLiveLocationApiResult(
            success: false,
            message: 'Invalid live location response.',
          );
        }
        final raw = decoded['location'];
        final location = (raw is Map<String, dynamic>) ? _mapLocation(raw) : null;
        return _EmergencyLiveLocationApiResult(
          success: true,
          message: _extractMessage(response.body, 'Live location loaded.'),
          location: location,
        );
      } on TimeoutException {
        return const _EmergencyLiveLocationApiResult(
          success: false,
          message: 'Live location request timed out.',
        );
      } catch (_) {
        return const _EmergencyLiveLocationApiResult(
          success: false,
          message: 'Unable to load live location.',
        );
      }
    }
    return const _EmergencyLiveLocationApiResult(
      success: false,
      message: 'Live location endpoint unavailable.',
    );
  }

  Future<_EmergencyLiveLocationApiResult> share({
    required LatLng point,
    required String address,
    required bool highAccuracy,
    required bool includeLandmark,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _EmergencyLiveLocationApiResult(
        success: false,
        message: 'Login required.',
      );
    }
    const path = 'emergency/shared-location';
    final body = jsonEncode({
      'address': address.trim(),
      'latitude': point.latitude,
      'longitude': point.longitude,
      'high_accuracy': highAccuracy,
      'include_landmark': includeLandmark,
      ..._emergencyScopePayload(),
    });
    for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
      try {
        final response = await http
            .post(
              endpoint,
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 8));
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode < 200 || response.statusCode >= 300) {
          return _EmergencyLiveLocationApiResult(
            success: false,
            message: _extractMessage(response.body, 'Unable to share live location.'),
          );
        }
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final raw = decoded is Map<String, dynamic> ? decoded['location'] : null;
        final location = raw is Map<String, dynamic> ? _mapLocation(raw) : null;
        return _EmergencyLiveLocationApiResult(
          success: true,
          message: _extractMessage(response.body, 'Live location shared successfully.'),
          location: location,
        );
      } on TimeoutException {
        return const _EmergencyLiveLocationApiResult(
          success: false,
          message: 'Share location request timed out.',
        );
      } catch (_) {
        return const _EmergencyLiveLocationApiResult(
          success: false,
          message: 'Unable to share live location.',
        );
      }
    }
    return const _EmergencyLiveLocationApiResult(
      success: false,
      message: 'Live location endpoint unavailable.',
    );
  }

  Future<_EmergencyLiveLocationFeedApiResult> fetchFeed({int limit = 20}) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _EmergencyLiveLocationFeedApiResult(
        success: false,
        message: 'Login required.',
      );
    }
    final safeLimit = limit.clamp(1, 100);
    final path = _pathWithScopeQuery('emergency/shared-locations?limit=$safeLimit');
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
          return _EmergencyLiveLocationFeedApiResult(
            success: false,
            message: _extractMessage(
              response.body,
              'Unable to load shared locations.',
            ),
          );
        }
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        if (decoded is! Map<String, dynamic>) {
          return const _EmergencyLiveLocationFeedApiResult(
            success: false,
            message: 'Invalid shared locations response.',
          );
        }
        final raw = decoded['locations'];
        final items = <_EmergencySharedLocationFeedEntry>[];
        if (raw is List) {
          for (final entry in raw) {
            if (entry is! Map<String, dynamic>) continue;
            final mapped = _mapFeedEntry(entry);
            if (mapped != null) items.add(mapped);
          }
        }
        return _EmergencyLiveLocationFeedApiResult(
          success: true,
          message: _extractMessage(response.body, 'Shared locations loaded.'),
          locations: items,
        );
      } on TimeoutException {
        return const _EmergencyLiveLocationFeedApiResult(
          success: false,
          message: 'Shared locations request timed out.',
        );
      } catch (_) {
        return const _EmergencyLiveLocationFeedApiResult(
          success: false,
          message: 'Unable to load shared locations.',
        );
      }
    }
    return const _EmergencyLiveLocationFeedApiResult(
      success: false,
      message: 'Shared locations endpoint unavailable.',
    );
  }

  _EmergencySharedLocation? _mapLocation(Map<String, dynamic> json) {
    double? readDouble(String key) {
      final value = json[key];
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value.trim());
      return null;
    }

    bool readBool(String key, [bool fallback = false]) {
      final value = json[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final text = value.trim().toLowerCase();
        return text == '1' || text == 'true' || text == 'yes';
      }
      return fallback;
    }

    final latitude = readDouble('latitude');
    final longitude = readDouble('longitude');
    if (latitude == null || longitude == null) {
      return null;
    }
    final address = (json['address'] as String? ?? '').trim();
    final sharedAtRaw = (json['shared_at'] as String? ?? '').trim();
    final sharedAt = DateTime.tryParse(sharedAtRaw)?.toLocal() ?? DateTime.now();
    return _EmergencySharedLocation(
      point: LatLng(latitude, longitude),
      address: address.isEmpty ? 'Pinned location' : address,
      updatedAt: sharedAt,
      highAccuracy: readBool('high_accuracy', true),
      includeLandmark: readBool('include_landmark', true),
    );
  }

  _EmergencySharedLocationFeedEntry? _mapFeedEntry(Map<String, dynamic> json) {
    double? readDouble(String key) {
      final value = json[key];
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value.trim());
      return null;
    }

    int readInt(String key, [int fallback = 0]) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value.trim()) ?? fallback;
      return fallback;
    }

    bool readBool(String key, [bool fallback = false]) {
      final value = json[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final text = value.trim().toLowerCase();
        return text == '1' || text == 'true' || text == 'yes';
      }
      return fallback;
    }

    final latitude = readDouble('latitude');
    final longitude = readDouble('longitude');
    if (latitude == null || longitude == null) return null;

    final address = (json['address'] as String? ?? '').trim();
    final sharedAtRaw = (json['shared_at'] as String? ?? '').trim();
    final sharedAt = DateTime.tryParse(sharedAtRaw)?.toLocal() ?? DateTime.now();
    final name = (json['user_name'] as String? ?? '').trim();
    final mobile = (json['user_mobile'] as String? ?? '').trim();

    return _EmergencySharedLocationFeedEntry(
      id: readInt('id'),
      point: LatLng(latitude, longitude),
      address: address.isEmpty ? 'Pinned location' : address,
      updatedAt: sharedAt,
      highAccuracy: readBool('high_accuracy', true),
      includeLandmark: readBool('include_landmark', true),
      residentName: name.isEmpty ? 'Resident' : name,
      residentMobile: mobile,
    );
  }

  String _extractMessage(String body, String fallback) {
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

bool _emergencySharedFeedLoading = false;
bool _emergencySharedFeedLoaded = false;
bool _emergencyOpsDataLoading = false;
bool _emergencyOpsDataLoaded = false;

Future<void> _syncEmergencySharedLocationFeed({bool force = false}) async {
  if (_emergencySharedFeedLoading) return;
  if (_emergencySharedFeedLoaded && !force) return;
  _emergencySharedFeedLoading = true;
  try {
    final result = await _EmergencyLiveLocationApi.instance.fetchFeed(limit: 30);
    debugPrint('fetchFeed result: success=${result.success}, msg=${result.message}, locations=${result.locations.length}');
    if (result.success) {
      _emergencyOpsStore.setSharedLocationFeed(result.locations);
      _emergencySharedFeedLoaded = true;
      if (result.locations.isNotEmpty) {
        final latest = result.locations.first;
        _emergencyOpsStore.sharedLocation.value = _EmergencySharedLocation(
          point: latest.point,
          address: latest.address,
          updatedAt: latest.updatedAt,
          highAccuracy: latest.highAccuracy,
          includeLandmark: latest.includeLandmark,
        );
      }
    }
  } finally {
    _emergencySharedFeedLoading = false;
  }
}

Future<void> _syncEmergencyOpsData({bool force = false}) async {
  if (_emergencyOpsDataLoading) return;
  if (_emergencyOpsDataLoaded && !force) return;
  _emergencyOpsDataLoading = true;
  try {
    await _syncEmergencyContacts(force: force);
    final requests = await _ServiceRequestApi.instance.fetchRequests();
    if (!requests.success) {
      return;
    }

    final incidents = <_EmergencyIncident>[];
    final patrols = <_PatrolRequestEntry>[];
    for (final item in requests.entries) {
      final category = item.category.trim().toLowerCase();
      final title = item.title.trim().toLowerCase();
      final purpose = item.purpose.trim().toLowerCase();
      final isEmergency = category.contains('responder') ||
          category.contains('bpat') ||
          category.contains('police') ||
          category.contains('health') ||
          title.contains('responder') ||
          title.contains('bpat') ||
          title.contains('patrol') ||
          title.contains('emergency');
      if (!isEmergency) continue;

      final createdAt = item.submittedAt ?? DateTime.now();
      final location = _emergencyLocationFromRequest(item);
      final details = item.purpose.trim().isNotEmpty
          ? item.purpose.trim()
          : item.title.trim();
      final requestRef = item.requestId.trim().isEmpty
          ? 'REQ-${item.id}'
          : item.requestId.trim();
      final requesterName = item.requesterName.trim().isEmpty
          ? 'Resident'
          : item.requesterName.trim();
      final status = item.status.trim().isEmpty ? 'Pending' : item.status.trim();

      incidents.add(
        _EmergencyIncident(
          reference: requestRef,
          type: _emergencyTypeFromRequest(item),
          status: status,
          priority: _emergencyPriorityFromRequest(item),
          location: location,
          details: details,
          victimName: requesterName,
          reporterName: requesterName,
          reporterMobile: item.requesterMobile.trim(),
          createdAt: createdAt,
          point: _defaultEmergencyPoint(),
          channel: 'Service Request',
        ),
      );

      final isPatrol = category.contains('bpat') ||
          title.contains('patrol') ||
          purpose.contains('patrol');
      if (isPatrol) {
        patrols.add(
          _PatrolRequestEntry(
            reference: requestRef,
            location: location,
            reason: item.title.trim().isEmpty ? 'Patrol request' : item.title.trim(),
            requestedBy: requesterName,
            scheduledAt: createdAt,
            notes: details,
            status: status,
          ),
        );
      }
    }

    final contacts = _activeEmergencyContacts();
    final tanods = contacts
        .where((entry) {
          final label = entry.label.trim().toLowerCase();
          return label.contains('bpat') ||
              label.contains('tanod') ||
              label.contains('police');
        })
        .map(
          (entry) => _TanodDutyEntry(
            name: '${entry.label.trim()} Desk',
            zone: 'Barangay',
            shift: '24/7',
            online: true,
            assignment: entry.description.trim().isEmpty
                ? 'Emergency response'
                : entry.description.trim(),
          ),
        )
        .toList();

    _emergencyOpsStore.setIncidents(incidents);
    _emergencyOpsStore.setPatrolRequests(patrols);
    _emergencyOpsStore.setTanods(tanods);
    _emergencyOpsDataLoaded = true;
  } finally {
    _emergencyOpsDataLoading = false;
  }
}

String _emergencyLocationFromRequest(_ResidentRequestEntry item) {
  final purpose = item.purpose.trim();
  if (purpose.isNotEmpty) {
    final firstLine = purpose.split('\n').first.trim();
    if (firstLine.length >= 4 && firstLine.length <= 72) {
      return firstLine;
    }
  }
  final category = item.category.trim();
  return category.isEmpty ? 'Reported via Responder' : 'Reported via $category';
}

String _emergencyTypeFromRequest(_ResidentRequestEntry item) {
  final text = '${item.category} ${item.title} ${item.purpose}'.toLowerCase();
  if (text.contains('fire')) return 'Fire';
  if (text.contains('medical') || text.contains('ambulance') || text.contains('health')) {
    return 'Medical';
  }
  if (text.contains('noise')) return 'Noise';
  if (text.contains('patrol') || text.contains('bpat')) return 'Patrol';
  if (text.contains('theft') || text.contains('rob') || text.contains('stolen')) {
    return 'Theft';
  }
  return 'Incident';
}

String _emergencyPriorityFromRequest(_ResidentRequestEntry item) {
  final text = '${item.category} ${item.title} ${item.purpose}'.toLowerCase();
  if (text.contains('urgent') || text.contains('critical') || text.contains('emergency')) {
    return 'Urgent';
  }
  if (item.status.trim().toLowerCase() == 'pending') return 'High';
  return 'Normal';
}

class _EmergencyContactsApiResult {
  final bool success;
  final String message;
  final List<_EmergencyContactItem> contacts;

  const _EmergencyContactsApiResult({
    required this.success,
    required this.message,
    this.contacts = const <_EmergencyContactItem>[],
  });
}

class _EmergencyContactsActionResult {
  final bool success;
  final String message;

  const _EmergencyContactsActionResult({
    required this.success,
    required this.message,
  });
}

class _EmergencyContactsApi {
  _EmergencyContactsApi._();
  static final instance = _EmergencyContactsApi._();

  Map<String, String> _scopePayload() {
    final province = _officialBarangaySetup.province.trim();
    final city = _officialBarangaySetup.city.trim();
    final barangay = _officialBarangaySetup.barangay.trim();
    final payload = <String, String>{};
    if (province.isNotEmpty) payload['province'] = province;
    if (city.isNotEmpty) payload['city_municipality'] = city;
    if (barangay.isNotEmpty) payload['barangay'] = barangay;
    return payload;
  }

  String _withScopeQuery(String path) {
    final scope = _scopePayload();
    if (scope.isEmpty) return path;
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    final query = Uri(queryParameters: scope).query;
    return '$normalized?$query';
  }

  Future<_EmergencyContactsApiResult> fetchContacts() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _EmergencyContactsApiResult(
        success: false,
        message: 'Login required.',
      );
    }
    final paths = <String>[_withScopeQuery('emergency/contacts')];
    final attempted = <String>[];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        attempted.add(endpoint.toString());
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
            return _EmergencyContactsApiResult(
              success: false,
              message: _extractMessage(response.body, 'Unable to load contacts.'),
            );
          }
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          if (decoded is! Map<String, dynamic>) {
            return const _EmergencyContactsApiResult(
              success: false,
              message: 'Invalid contacts response.',
            );
          }
          final raw = decoded['contacts'];
          if (raw is! List) {
            return _EmergencyContactsApiResult(
              success: true,
              message: _extractMessage(response.body, 'No contacts yet.'),
              contacts: const <_EmergencyContactItem>[],
            );
          }
          final contacts = <_EmergencyContactItem>[];
          for (final item in raw) {
            if (item is! Map<String, dynamic>) continue;
            contacts.add(_fromJson(item));
          }
          contacts.sort((a, b) {
            final bySort = a.sortOrder.compareTo(b.sortOrder);
            if (bySort != 0) return bySort;
            return a.label.toLowerCase().compareTo(b.label.toLowerCase());
          });
          return _EmergencyContactsApiResult(
            success: true,
            message: _extractMessage(response.body, 'Contacts loaded.'),
            contacts: contacts,
          );
        } on TimeoutException {
          return const _EmergencyContactsApiResult(
            success: false,
            message: 'Contacts request timed out.',
          );
        } catch (_) {
          return const _EmergencyContactsApiResult(
            success: false,
            message: 'Unable to load contacts.',
          );
        }
      }
    }
    return _EmergencyContactsApiResult(
      success: false,
      message:
          'Contacts endpoint unavailable on configured API base URL ($_configuredApiBaseUrl). Tried: ${attempted.isEmpty ? "none" : attempted.first}',
    );
  }

  Future<_EmergencyContactsActionResult> createContact({
    required String label,
    required String phoneNumber,
    required String description,
    required bool quickDial,
    required int sortOrder,
  }) {
    return _upsertContact(
      contactId: null,
      label: label,
      phoneNumber: phoneNumber,
      description: description,
      quickDial: quickDial,
      sortOrder: sortOrder,
    );
  }

  Future<_EmergencyContactsActionResult> updateContact({
    required int contactId,
    required String label,
    required String phoneNumber,
    required String description,
    required bool quickDial,
    required int sortOrder,
  }) {
    return _upsertContact(
      contactId: contactId,
      label: label,
      phoneNumber: phoneNumber,
      description: description,
      quickDial: quickDial,
      sortOrder: sortOrder,
    );
  }

  Future<_EmergencyContactsActionResult> _upsertContact({
    required int? contactId,
    required String label,
    required String phoneNumber,
    required String description,
    required bool quickDial,
    required int sortOrder,
  }) async {
    final normalizedContactId =
        (contactId != null && contactId > 0) ? contactId : null;
    if (_authToken == null || _authToken!.isEmpty) {
      return const _EmergencyContactsActionResult(
        success: false,
        message: 'Login required.',
      );
    }
    final body = jsonEncode({
      'label': label.trim(),
      'phone_number': phoneNumber.trim(),
      'description': description.trim(),
      'quick_dial': quickDial,
      'sort_order': sortOrder,
      ..._scopePayload(),
    });
    final path = normalizedContactId == null
        ? 'emergency/contacts'
        : 'emergency/contacts/$normalizedContactId';
    final attempted = <String>[];
    for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
      attempted.add(endpoint.toString());
      try {
        final response = normalizedContactId == null
            ? await http
                  .post(
                    endpoint,
                    headers: {
                      'Accept': 'application/json',
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $_authToken',
                    },
                    body: body,
                  )
                  .timeout(const Duration(seconds: 8))
            : await http
                  .patch(
                    endpoint,
                    headers: {
                      'Accept': 'application/json',
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $_authToken',
                    },
                    body: body,
                  )
                  .timeout(const Duration(seconds: 8));
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return _EmergencyContactsActionResult(
            success: true,
            message: _extractMessage(
              response.body,
              normalizedContactId == null
                  ? 'Emergency contact added.'
                  : 'Emergency contact updated.',
            ),
          );
        }
        return _EmergencyContactsActionResult(
          success: false,
          message: _extractMessage(response.body, 'Unable to save contact.'),
        );
      } on TimeoutException {
        return const _EmergencyContactsActionResult(
          success: false,
          message: 'Contact request timed out.',
        );
      } catch (_) {
        return const _EmergencyContactsActionResult(
          success: false,
          message: 'Unable to save contact.',
        );
      }
    }
    return _EmergencyContactsActionResult(
      success: false,
      message:
          'Contacts endpoint unavailable on configured API base URL ($_configuredApiBaseUrl). Tried: ${attempted.isEmpty ? "none" : attempted.first}',
    );
  }

  Future<_EmergencyContactsActionResult> deleteContact(int contactId) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _EmergencyContactsActionResult(
        success: false,
        message: 'Login required.',
      );
    }
    final path = _withScopeQuery('emergency/contacts/$contactId');
    final attempted = <String>[];
    for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
      attempted.add(endpoint.toString());
      try {
        final response = await http.delete(
          endpoint,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
        ).timeout(const Duration(seconds: 8));
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return _EmergencyContactsActionResult(
            success: true,
            message: _extractMessage(response.body, 'Emergency contact deleted.'),
          );
        }
        return _EmergencyContactsActionResult(
          success: false,
          message: _extractMessage(response.body, 'Unable to delete contact.'),
        );
      } on TimeoutException {
        return const _EmergencyContactsActionResult(
          success: false,
          message: 'Delete request timed out.',
        );
      } catch (_) {
        return const _EmergencyContactsActionResult(
          success: false,
          message: 'Unable to delete contact.',
        );
      }
    }
    return _EmergencyContactsActionResult(
      success: false,
      message:
          'Contacts endpoint unavailable on configured API base URL ($_configuredApiBaseUrl). Tried: ${attempted.isEmpty ? "none" : attempted.first}',
    );
  }

  _EmergencyContactItem _fromJson(Map<String, dynamic> json) {
    String readString(String key, [String fallback = '']) {
      final value = json[key];
      if (value is String) return value.trim();
      if (value != null) return value.toString().trim();
      return fallback;
    }

    int readInt(String key, [int fallback = 0]) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value.trim()) ?? fallback;
      return fallback;
    }

    bool readBool(String key, [bool fallback = false]) {
      final value = json[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final text = value.trim().toLowerCase();
        return text == '1' || text == 'true' || text == 'yes';
      }
      return fallback;
    }

    return _EmergencyContactItem(
      id: readInt('id'),
      label: readString('label', 'Emergency'),
      phoneNumber: readString('phone_number', 'N/A'),
      description: readString('description', ''),
      quickDial: readBool('quick_dial'),
      sortOrder: readInt('sort_order'),
    );
  }

  String _extractMessage(String body, String fallback) {
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

class _EmergencyIncident {
  final String reference;
  final String type;
  final String status;
  final String priority;
  final String location;
  final String details;
  final String victimName;
  final String reporterName;
  final String reporterMobile;
  final String? personInvolved;
  final String channel;
  final String? attachmentLabel;
  final DateTime createdAt;
  final LatLng point;

  const _EmergencyIncident({
    required this.reference,
    required this.type,
    required this.status,
    required this.priority,
    required this.location,
    required this.details,
    required this.victimName,
    required this.reporterName,
    required this.reporterMobile,
    required this.createdAt,
    required this.point,
    this.personInvolved,
    this.channel = 'Resident App',
    this.attachmentLabel,
  });
}

class _PatrolRequestEntry {
  final String reference;
  final String location;
  final String reason;
  final String requestedBy;
  final DateTime scheduledAt;
  final String notes;
  final String status;

  const _PatrolRequestEntry({
    required this.reference,
    required this.location,
    required this.reason,
    required this.requestedBy,
    required this.scheduledAt,
    required this.notes,
    required this.status,
  });
}

class _EmergencyChatMessage {
  final String sender;
  final String kind;
  final String text;
  final bool outbound;
  final DateTime createdAt;
  final String? attachmentLabel;
  final int? voiceDurationSeconds;

  const _EmergencyChatMessage({
    required this.sender,
    required this.kind,
    required this.text,
    required this.outbound,
    required this.createdAt,
    this.attachmentLabel,
    this.voiceDurationSeconds,
  });
}

class _TanodDutyEntry {
  final String name;
  final String zone;
  final String shift;
  final bool online;
  final String assignment;

  const _TanodDutyEntry({
    required this.name,
    required this.zone,
    required this.shift,
    required this.online,
    required this.assignment,
  });

  _TanodDutyEntry copyWith({bool? online, String? assignment}) {
    return _TanodDutyEntry(
      name: name,
      zone: zone,
      shift: shift,
      online: online ?? this.online,
      assignment: assignment ?? this.assignment,
    );
  }
}

class _EmergencySharedLocation {
  final LatLng point;
  final String address;
  final DateTime updatedAt;
  final bool highAccuracy;
  final bool includeLandmark;

  const _EmergencySharedLocation({
    required this.point,
    required this.address,
    required this.updatedAt,
    required this.highAccuracy,
    required this.includeLandmark,
  });
}

class _EmergencySharedLocationFeedEntry {
  final int id;
  final LatLng point;
  final String address;
  final DateTime updatedAt;
  final bool highAccuracy;
  final bool includeLandmark;
  final String residentName;
  final String residentMobile;

  const _EmergencySharedLocationFeedEntry({
    required this.id,
    required this.point,
    required this.address,
    required this.updatedAt,
    required this.highAccuracy,
    required this.includeLandmark,
    required this.residentName,
    required this.residentMobile,
  });
}

class _LuponCaseEntry {
  final String caseNo;
  final String complainant;
  final String respondent;
  final DateTime hearingDate;
  final String status;
  final String issueSummary;
  final String encryptedVictimData;
  final DateTime createdAt;
  final String luponOfficer;
  final String venue;

  const _LuponCaseEntry({
    required this.caseNo,
    required this.complainant,
    required this.respondent,
    required this.hearingDate,
    required this.status,
    required this.issueSummary,
    required this.encryptedVictimData,
    required this.createdAt,
    required this.luponOfficer,
    required this.venue,
  });

  _LuponCaseEntry copyWith({
    String? caseNo,
    String? complainant,
    String? respondent,
    DateTime? hearingDate,
    String? status,
    String? issueSummary,
    String? encryptedVictimData,
    DateTime? createdAt,
    String? luponOfficer,
    String? venue,
  }) {
    return _LuponCaseEntry(
      caseNo: caseNo ?? this.caseNo,
      complainant: complainant ?? this.complainant,
      respondent: respondent ?? this.respondent,
      hearingDate: hearingDate ?? this.hearingDate,
      status: status ?? this.status,
      issueSummary: issueSummary ?? this.issueSummary,
      encryptedVictimData: encryptedVictimData ?? this.encryptedVictimData,
      createdAt: createdAt ?? this.createdAt,
      luponOfficer: luponOfficer ?? this.luponOfficer,
      venue: venue ?? this.venue,
    );
  }
}

class _SafetyCalendarEntry {
  final String title;
  final DateTime scheduledAt;
  final String reference;
  final String venue;
  final String type;

  const _SafetyCalendarEntry({
    required this.title,
    required this.scheduledAt,
    required this.reference,
    required this.venue,
    required this.type,
  });
}

class _PatrolCheckpoint {
  final String id;
  final String label;
  final String zone;
  final LatLng point;
  final String qrCode;
  final DateTime? lastScannedAt;
  final String? lastScannedBy;

  const _PatrolCheckpoint({
    required this.id,
    required this.label,
    required this.zone,
    required this.point,
    required this.qrCode,
    this.lastScannedAt,
    this.lastScannedBy,
  });

  _PatrolCheckpoint copyWith({
    DateTime? lastScannedAt,
    String? lastScannedBy,
  }) {
    return _PatrolCheckpoint(
      id: id,
      label: label,
      zone: zone,
      point: point,
      qrCode: qrCode,
      lastScannedAt: lastScannedAt ?? this.lastScannedAt,
      lastScannedBy: lastScannedBy ?? this.lastScannedBy,
    );
  }
}

class _SafetyBroadcastEntry {
  final String title;
  final String body;
  final String severity;
  final DateTime createdAt;
  final bool active;

  const _SafetyBroadcastEntry({
    required this.title,
    required this.body,
    required this.severity,
    required this.createdAt,
    this.active = true,
  });
}

class _FirstAidGuide {
  final String title;
  final String format;
  final String category;
  final String summary;
  final IconData icon;
  final Color accent;
  final List<String> steps;

  const _FirstAidGuide({
    required this.title,
    required this.format,
    required this.category,
    required this.summary,
    required this.icon,
    required this.accent,
    required this.steps,
  });
}

String _encryptSensitiveValue(String value) {
  final bytes = value.codeUnits;
  return bytes
      .map((item) => (item + 7).toRadixString(16).padLeft(2, '0'))
      .join();
}

String _decryptSensitiveValue(String value) {
  if (value.length.isOdd || value.isEmpty) {
    return value;
  }
  final chars = <int>[];
  for (var index = 0; index < value.length; index += 2) {
    final hex = value.substring(index, index + 2);
    final parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) {
      return value;
    }
    chars.add(parsed - 7);
  }
  return String.fromCharCodes(chars);
}

String _protectSensitiveValue(String encryptedValue) {
  if (_hasOfficialEmergencyAccess) {
    return _decryptSensitiveValue(encryptedValue);
  }
  return 'Encrypted - Lupon / police only';
}

String _maskedVictimName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty || _hasOfficialEmergencyAccess) {
    return trimmed;
  }
  final parts = trimmed.split(RegExp(r'\s+'));
  return parts
      .map(
        (part) => part.length <= 1
            ? '*'
            : '${part.substring(0, 1)}${'*' * math.min(4, part.length - 1)}',
      )
      .join(' ');
}

String _formatEmergencyDateTime(DateTime value) {
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
  final hour = value.hour == 0
      ? 12
      : value.hour > 12
      ? value.hour - 12
      : value.hour;
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  final minute = value.minute.toString().padLeft(2, '0');
  return '${months[value.month - 1]} ${value.day}, ${value.year} $hour:$minute $suffix';
}

Color _emergencyStatusColor(String status) {
  switch (status) {
    case 'Resolved':
      return const Color(0xFF2D8A57);
    case 'Dispatched':
      return const Color(0xFF245AC7);
    case 'Rejected':
      return const Color(0xFF9A2E2E);
    default:
      return const Color(0xFFB36A00);
  }
}

Color _incidentTypeColor(String type) {
  switch (type) {
    case 'Fire':
      return const Color(0xFFD43B3B);
    case 'Medical':
      return const Color(0xFF2877C7);
    case 'Noise':
      return const Color(0xFF9B6C17);
    case 'Patrol':
      return const Color(0xFF4B5BB7);
    default:
      return const Color(0xFF8E4E45);
  }
}

LatLng _defaultEmergencyPoint() => const LatLng(14.8386, 120.2865);

class _EmergencyOpsStore {
  final ValueNotifier<List<_EmergencyIncident>> incidents = ValueNotifier(
    [
      _EmergencyIncident(
        reference: 'BPAT-2026-1042',
        type: 'Theft',
        status: 'Pending',
        priority: 'High',
        location: 'Rizal Avenue corner 19th Street, West Tapinac',
        details: 'Motorcycle side mirror stolen near sari-sari store.',
        victimName: 'John Andrew Dela Cruz',
        reporterName: 'Marissa Dela Cruz',
        reporterMobile: '09171234567',
        createdAt: DateTime(2026, 3, 14, 15, 10),
        point: LatLng(14.8389, 120.2869),
        personInvolved: 'Unidentified male in black jacket',
      ),
      _EmergencyIncident(
        reference: 'BPAT-2026-1038',
        type: 'Noise',
        status: 'Dispatched',
        priority: 'Normal',
        location: 'Zone 3 Basketball Court, East Tapinac',
        details: 'Loud speakers still active past curfew.',
        victimName: 'Liza Fernandez',
        reporterName: 'Nico Ramos',
        reporterMobile: '09172345678',
        createdAt: DateTime(2026, 3, 14, 14, 32),
        point: LatLng(14.8377, 120.2874),
      ),
      _EmergencyIncident(
        reference: 'BPAT-2026-1031',
        type: 'Fire',
        status: 'Resolved',
        priority: 'Urgent',
        location: 'Magsaysay Drive rear alley, Barretto',
        details: 'Small electrical fire contained before spread.',
        victimName: 'Alvin Navarro',
        reporterName: 'BPAT Unit 2',
        reporterMobile: '09170001001',
        createdAt: DateTime(2026, 3, 14, 11, 16),
        point: LatLng(14.8393, 120.2858),
        channel: 'Responder Desk',
      ),
    ],
  );

  final ValueNotifier<List<_PatrolRequestEntry>> patrolRequests = ValueNotifier(
    [
      _PatrolRequestEntry(
        reference: 'PATROL-2026-208',
        location: 'Purok 4, New Cabalan footbridge',
        reason: 'Late-night loitering near closed stores',
        requestedBy: 'Mia Lopez',
        scheduledAt: DateTime(2026, 3, 14, 22, 0),
        notes: 'Focus between 10 PM and midnight.',
        status: 'Scheduled',
      ),
      _PatrolRequestEntry(
        reference: 'PATROL-2026-203',
        location: 'West Tapinac market perimeter',
        reason: 'Weekend crowd management',
        requestedBy: 'Barangay Desk',
        scheduledAt: DateTime(2026, 3, 15, 18, 30),
        notes: 'Coordinate with tanods assigned to Zone 1.',
        status: 'Queued',
      ),
    ],
  );

  final ValueNotifier<List<_EmergencyChatMessage>> chatMessages = ValueNotifier(
    [
      _EmergencyChatMessage(
        sender: 'Responder Desk',
        kind: 'text',
        text: 'Describe the emergency and share your nearest landmark.',
        outbound: false,
        createdAt: DateTime(2026, 3, 14, 15, 0),
      ),
      _EmergencyChatMessage(
        sender: 'Resident',
        kind: 'text',
        text: 'Two men are arguing near the alley behind the mini mart.',
        outbound: true,
        createdAt: DateTime(2026, 3, 14, 15, 1),
      ),
    ],
  );

  final ValueNotifier<List<_TanodDutyEntry>> tanods = ValueNotifier(
    const [
      _TanodDutyEntry(
        name: 'Tanod Joel Ramos',
        zone: 'Zone 1',
        shift: '6:00 PM - 2:00 AM',
        online: true,
        assignment: 'Market perimeter',
      ),
      _TanodDutyEntry(
        name: 'Tanod Grace Padilla',
        zone: 'Zone 2',
        shift: '2:00 PM - 10:00 PM',
        online: true,
        assignment: 'School approach road',
      ),
      _TanodDutyEntry(
        name: 'Tanod Mark Dizon',
        zone: 'Zone 3',
        shift: '8:00 PM - 4:00 AM',
        online: false,
        assignment: 'Off duty',
      ),
    ],
  );

  final ValueNotifier<List<_LuponCaseEntry>> luponCases = ValueNotifier(
    [
      _LuponCaseEntry(
        caseNo: 'KP-2026-014',
        complainant: 'Marissa Dela Cruz',
        respondent: 'Rene Bautista',
        hearingDate: DateTime(2026, 3, 16, 14, 0),
        status: 'Settled',
        issueSummary: 'Boundary and driveway obstruction complaint.',
        encryptedVictimData: _encryptSensitiveValue(
          'Complainant requested private handling due to prior threats.',
        ),
        createdAt: DateTime(2026, 3, 10, 9, 30),
        luponOfficer: 'Lupon Chair Maria Cortez',
        venue: 'Barangay Session Hall',
      ),
      _LuponCaseEntry(
        caseNo: 'KP-2026-018',
        complainant: 'Liza Fernandez',
        respondent: 'Carlo Mendez',
        hearingDate: DateTime(2026, 3, 18, 10, 30),
        status: 'Forwarded to Court',
        issueSummary: 'Repeated disturbance and non-compliance with settlement.',
        encryptedVictimData: _encryptSensitiveValue(
          'Respondent linked to prior blotter BPAT-2026-1038.',
        ),
        createdAt: DateTime(2026, 3, 12, 11, 45),
        luponOfficer: 'Lupon Secretary Danica Reyes',
        venue: 'Lupon Mediation Room',
      ),
    ],
  );

  final ValueNotifier<List<_SafetyCalendarEntry>> legalCalendar = ValueNotifier(
    [
      _SafetyCalendarEntry(
        title: 'Mediation Hearing',
        scheduledAt: DateTime(2026, 3, 16, 14, 0),
        reference: 'KP-2026-014',
        venue: 'Barangay Session Hall',
        type: 'Lupon',
      ),
      _SafetyCalendarEntry(
        title: 'Katarungang Pambarangay Conference',
        scheduledAt: DateTime(2026, 3, 18, 10, 30),
        reference: 'KP-2026-018',
        venue: 'Lupon Mediation Room',
        type: 'Lupon',
      ),
    ],
  );

  final ValueNotifier<List<_PatrolCheckpoint>> patrolCheckpoints = ValueNotifier(
    const [
      _PatrolCheckpoint(
        id: 'CHK-001',
        label: 'West Tapinac Covered Court',
        zone: 'Zone 1',
        point: LatLng(14.8387, 120.2866),
        qrCode: 'QR-WTCC-001',
      ),
      _PatrolCheckpoint(
        id: 'CHK-002',
        label: 'Old Cabalan Footbridge',
        zone: 'Zone 2',
        point: LatLng(14.8378, 120.2871),
        qrCode: 'QR-OCFB-002',
      ),
      _PatrolCheckpoint(
        id: 'CHK-003',
        label: 'Barangay Hall Gate',
        zone: 'Zone 3',
        point: LatLng(14.8391, 120.2859),
        qrCode: 'QR-BHG-003',
      ),
    ],
  );

  final ValueNotifier<List<_SafetyBroadcastEntry>> broadcasts = ValueNotifier(
    [
      _SafetyBroadcastEntry(
        title: 'Late-night patrol advisory',
        body:
            'Additional tanods are assigned near the market perimeter from 10 PM to 2 AM.',
        severity: 'Watch',
        createdAt: DateTime(2026, 3, 14, 18, 0),
      ),
    ],
  );

  final ValueNotifier<_EmergencySharedLocation?> sharedLocation = ValueNotifier(
    _EmergencySharedLocation(
      point: _defaultEmergencyPoint(),
      address:
          _currentResidentProfile?.locationSummary ?? 'West Tapinac, Olongapo City',
      updatedAt: DateTime(2026, 3, 14, 15, 2),
      highAccuracy: true,
      includeLandmark: true,
    ),
  );

  final ValueNotifier<List<_EmergencySharedLocationFeedEntry>> sharedLocationFeed =
      ValueNotifier(const <_EmergencySharedLocationFeedEntry>[]);

  List<_EmergencyIncident> get sortedIncidents {
    final list = [...incidents.value];
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void addIncident(_EmergencyIncident entry) {
    incidents.value = [entry, ...sortedIncidents];
  }

  void setIncidents(List<_EmergencyIncident> entries) {
    final sorted = [...entries]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    incidents.value = sorted;
  }

  void addPatrolRequest(_PatrolRequestEntry entry) {
    final next = [...patrolRequests.value, entry];
    next.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    patrolRequests.value = next;
  }

  void setPatrolRequests(List<_PatrolRequestEntry> entries) {
    final sorted = [...entries]..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    patrolRequests.value = sorted;
  }

  void addChatMessage(_EmergencyChatMessage entry) {
    chatMessages.value = [...chatMessages.value, entry];
  }

  void shareLocation({
    required LatLng point,
    required String address,
    required bool highAccuracy,
    required bool includeLandmark,
  }) {
    sharedLocation.value = _EmergencySharedLocation(
      point: point,
      address: address,
      updatedAt: DateTime.now(),
      highAccuracy: highAccuracy,
      includeLandmark: includeLandmark,
    );
    addChatMessage(
      _EmergencyChatMessage(
        sender: 'Resident',
        kind: 'location',
        text: 'Shared live location: $address',
        outbound: true,
        createdAt: DateTime.now(),
      ),
    );
    final currentName = _residentDisplayName().trim();
    final currentMobile = (_currentResidentProfile?.mobile ?? '').trim();
    final entry = _EmergencySharedLocationFeedEntry(
      id: 0,
      point: point,
      address: address,
      updatedAt: DateTime.now(),
      highAccuracy: highAccuracy,
      includeLandmark: includeLandmark,
      residentName: currentName.isEmpty ? 'Resident' : currentName,
      residentMobile: currentMobile,
    );
    final next = <_EmergencySharedLocationFeedEntry>[entry, ...sharedLocationFeed.value];
    sharedLocationFeed.value = next.take(50).toList();
  }

  void setSharedLocationFeed(List<_EmergencySharedLocationFeedEntry> entries) {
    sharedLocationFeed.value = [...entries]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  void setTanods(List<_TanodDutyEntry> entries) {
    tanods.value = [...entries];
  }

  void toggleTanod(int index) {
    final rows = [...tanods.value];
    final item = rows[index];
    rows[index] = item.copyWith(
      online: !item.online,
      assignment: item.online ? 'Off duty' : 'Available for dispatch',
    );
    tanods.value = rows;
  }

  void addLuponCase(_LuponCaseEntry entry) {
    final next = [entry, ...luponCases.value]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    luponCases.value = next;
    addCalendarEntry(
      _SafetyCalendarEntry(
        title: 'Mediation Hearing',
        scheduledAt: entry.hearingDate,
        reference: entry.caseNo,
        venue: entry.venue,
        type: 'Lupon',
      ),
    );
  }

  void updateLuponCaseStatus(String caseNo, String status) {
    final next = [
      for (final entry in luponCases.value)
        if (entry.caseNo == caseNo) entry.copyWith(status: status) else entry,
    ];
    luponCases.value = next;
  }

  void addCalendarEntry(_SafetyCalendarEntry entry) {
    final next = [...legalCalendar.value, entry]
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    legalCalendar.value = next;
  }

  void addBroadcast(_SafetyBroadcastEntry entry) {
    broadcasts.value = [entry, ...broadcasts.value];
  }

  void scanPatrolCheckpoint(int index, String tanodName) {
    final rows = [...patrolCheckpoints.value];
    if (index < 0 || index >= rows.length) {
      return;
    }
    rows[index] = rows[index].copyWith(
      lastScannedAt: DateTime.now(),
      lastScannedBy: tanodName,
    );
    patrolCheckpoints.value = rows;
  }
}

final _emergencyOpsStore = _EmergencyOpsStore();

const List<_FirstAidGuide> _firstAidGuides = [
  _FirstAidGuide(
    title: 'Burn Care Quick Sheet',
    format: 'PDF Guide',
    category: 'Fire',
    summary: 'Immediate cooling, clean covering, and burn severity checks.',
    icon: Icons.picture_as_pdf_rounded,
    accent: Color(0xFFD74A35),
    steps: [
      'Remove the person from heat or electrical source if safe.',
      'Cool the burn under clean running water for 20 minutes.',
      'Cover lightly with clean cloth or sterile dressing.',
      'Do not apply ice, toothpaste, or oil on the wound.',
    ],
  ),
  _FirstAidGuide(
    title: 'CPR Response Card',
    format: 'Image Guide',
    category: 'Medical',
    summary: 'Adult CPR sequence with compression rhythm reminders.',
    icon: Icons.image_outlined,
    accent: Color(0xFF2C77C8),
    steps: [
      'Check responsiveness and call for help immediately.',
      'Begin chest compressions at the center of the chest.',
      'Push hard and fast at 100 to 120 compressions per minute.',
      'Continue until trained responders arrive.',
    ],
  ),
  _FirstAidGuide(
    title: 'Earthquake Grab Bag Checklist',
    format: 'PDF Guide',
    category: 'Disaster',
    summary: 'Preparedness checklist for family evacuation kits.',
    icon: Icons.picture_as_pdf_rounded,
    accent: Color(0xFF6B59C9),
    steps: [
      'Store water, flashlight, radio, medicines, and IDs in one bag.',
      'Keep emergency contacts and barangay numbers inside the kit.',
      'Review the kit every six months and replace expired items.',
    ],
  ),
  _FirstAidGuide(
    title: 'Bleeding Control Steps',
    format: 'Image Guide',
    category: 'Trauma',
    summary: 'Direct pressure and escalation steps for severe bleeding.',
    icon: Icons.image_outlined,
    accent: Color(0xFF2D8A57),
    steps: [
      'Apply firm direct pressure using clean cloth or gauze.',
      'Raise the injured area if it does not cause more pain.',
      'Do not remove soaked cloth; add more layers on top.',
      'Seek urgent medical support if bleeding does not stop.',
    ],
  ),
];

class ResponderPage extends StatelessWidget {
  const ResponderPage({super.key});

  @override
  Widget build(BuildContext context) {
    _syncEmergencyContacts();
    _syncEmergencyOpsData();
    final isOfficialView = _hasOfficialEmergencyAccess;
    const emergencyTips = [
      (
        'How to Use a Fire Extinguisher',
        'Learn to operate a fire extinguisher',
        Icons.fire_extinguisher,
      ),
      (
        'Basic First Aid',
        'Essential first aid steps',
        Icons.medical_services_outlined,
      ),
    ];
    const safetyTips = [
      ('Earthquake Safety', 'Drop, cover, and hold', Icons.crisis_alert),
      ('Flood Safety', 'Move to higher ground', Icons.flood),
      (
        'Fire Safety',
        'Exit early and avoid smoke',
        Icons.local_fire_department,
      ),
    ];
    const responderCenter = LatLng(14.8386, 120.2865);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barangay Emergency'),
        backgroundColor: isOfficialView
            ? const Color(0xFFD70000)
            : const Color(0xFFF7F8FF),
        foregroundColor: isOfficialView ? Colors.white : const Color(0xFF2F3248),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isOfficialView
                ? const [Color(0xFFFFF5F5), Color(0xFFFFF0EE)]
                : const [Color(0xFFF7F8FF), Color(0xFFF8F0EE)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ValueListenableBuilder<List<_EmergencyIncident>>(
              valueListenable: _emergencyOpsStore.incidents,
              builder: (_, incidents, __) {
                final active = incidents
                    .where((entry) => entry.status != 'Resolved')
                    .length;
                final urgent = incidents
                    .where((entry) => entry.priority == 'Urgent')
                    .length;
                final tanodsOnline = _emergencyOpsStore.tanods.value
                    .where((entry) => entry.online)
                    .length;
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isOfficialView
                          ? const [Color(0xFFD70000), Color(0xFF8E1212)]
                          : const [Color(0xFF3948D1), Color(0xFF6787FF)],
                    ),
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
                                  isOfficialView
                                      ? 'Responder Dashboard'
                                      : 'Emergency Response Hub',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isOfficialView
                                      ? 'Monitor incidents, shared locations, and tanod coverage from one place.'
                                      : 'Reach barangay responders quickly, submit reports, and share your location.',
                                  style: const TextStyle(
                                    color: Color(0xFFECEFFF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              isOfficialView
                                  ? Icons.local_police_rounded
                                  : Icons.emergency_share_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _EmergencyHeroStat(
                              label: 'Active Incidents',
                              value: '$active',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _EmergencyHeroStat(
                              label: 'Urgent Calls',
                              value: '$urgent',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _EmergencyHeroStat(
                              label: 'Tanods Online',
                              value: '$tanodsOnline',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _sectionTitle('Quick Dial'),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<_EmergencyContactItem>>(
              valueListenable: _emergencyContacts,
              builder: (_, __, ___) {
                final contacts = _quickDialContacts(_activeEmergencyContacts());
                if (contacts.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Row(
                  children: contacts.indexed.map((entry) {
                    final index = entry.$1;
                    final contact = entry.$2;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                        child: _EmergencyQuickDialButton(
                          label: _quickDialLabelFromName(contact.label),
                          number: contact.phoneNumber,
                          icon: _emergencyIconForLabel(contact.label),
                          color: _emergencyColorForLabel(contact.label),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            _sectionTitle('Emergency Contacts'),
            ValueListenableBuilder<List<_EmergencyContactItem>>(
              valueListenable: _emergencyContacts,
              builder: (_, __, ___) {
                final contacts = _activeEmergencyContacts();
                if (contacts.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7F3)),
                    ),
                    child: const Text(
                      'No emergency contacts configured yet.',
                      style: TextStyle(
                        color: Color(0xFF646B84),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return Column(
                  children: contacts.map((contact) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7F3)),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1EBEC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _emergencyIconForLabel(contact.label),
                            color: const Color(0xFF5D4C52),
                          ),
                        ),
                        title: Text(
                          contact.label,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          '${contact.phoneNumber} | ${contact.description}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF6A6E84)),
                        ),
                        trailing: FilledButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmergencyContactActionPage(
                                contactName: contact.label,
                                phoneNumber: contact.phoneNumber,
                                description: contact.description,
                              ),
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF7C818C),
                          ),
                          child: const Text('Call'),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmergencyContactActionPage(
                              contactName: contact.label,
                              phoneNumber: contact.phoneNumber,
                              description: contact.description,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            _sectionTitle('Quick Actions'),
            _goTile(
              context,
              'Share Live Location',
              const EmergencyLocationSharePage(),
            ),
            _goTile(
              context,
              'Responder Dashboard',
              const EmergencyResponderDashboardPage(),
            ),
            _goTile(
              context,
              'Emergency Hotlines',
              const EmergencyHotlinesPage(),
            ),
            _goTile(context, 'Emergency Chat', const EmergencyMessagePage()),
            _goTile(context, 'First Aid Library', const FirstAidLibraryPage()),
            _goTile(context, 'BPAT Operations', const BpatPage()),
            const SizedBox(height: 10),
            _sectionTitle('Active Incident Feed'),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<_EmergencyIncident>>(
              valueListenable: _emergencyOpsStore.incidents,
              builder: (_, incidents, __) {
                final rows = [...incidents]
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                return Column(
                  children: rows.take(3).map((incident) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE4E7F3)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _incidentTypeColor(incident.type)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            incident.type == 'Fire'
                                ? Icons.local_fire_department_rounded
                                : incident.type == 'Medical'
                                    ? Icons.health_and_safety_rounded
                                    : Icons.report_gmailerrorred_rounded,
                            color: _incidentTypeColor(incident.type),
                          ),
                        ),
                        title: Text(
                          '${incident.type} • ${incident.location}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF2F3248),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${_maskedVictimName(incident.victimName)} • ${incident.reference}\n${_formatEmergencyDateTime(incident.createdAt)}',
                            style: const TextStyle(
                              color: Color(0xFF646B84),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        trailing: _EmergencyStatusPill(
                          label: incident.status,
                          color: _emergencyStatusColor(incident.status),
                        ),
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          showDragHandle: true,
                          builder: (_) =>
                              _EmergencyIncidentDetailSheet(incident: incident),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            _sectionTitle('Emergency Tips'),
            ...emergencyTips.map(
              (tip) => _EmergencyInfoTile(
                icon: tip.$3,
                title: tip.$1,
                subtitle: tip.$2,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmergencySafetyDetailPage(
                      title: tip.$1,
                      summary: tip.$2,
                      guide: tip.$1 == 'How to Use a Fire Extinguisher'
                          ? const [
                              'Pull the pin and point the nozzle at the base of the fire.',
                              'Squeeze the handle and sweep side-to-side.',
                              'Keep a safe distance and call emergency responders.',
                            ]
                          : const [
                              'Check scene safety before giving aid.',
                              'Control bleeding with direct pressure and clean cloth.',
                              'Keep patient calm while waiting for medical response.',
                            ],
                    ),
                  ),
                ),
              ),
            ),

            _sectionTitle('Safety Tips'),
            ...safetyTips.map(
              (tip) => _EmergencyInfoTile(
                icon: tip.$3,
                title: tip.$1,
                subtitle: tip.$2,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmergencySafetyDetailPage(
                      title: tip.$1,
                      summary: tip.$2,
                      guide: tip.$1 == 'Earthquake Safety'
                          ? const [
                              'Drop to your hands and knees immediately.',
                              'Cover your head and neck under sturdy furniture.',
                              'Hold on until shaking stops, then evacuate safely.',
                            ]
                          : tip.$1 == 'Flood Safety'
                          ? const [
                              'Move to higher ground immediately.',
                              'Avoid crossing flowing water by foot or vehicle.',
                              'Turn off electricity if floodwater reaches outlets.',
                            ]
                          : const [
                              'Stay low to avoid smoke inhalation.',
                              'Use nearest safe exit and avoid elevators.',
                              'Call emergency responders once outside.',
                            ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE4E7F3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More Information',
                    style: TextStyle(
                      color: Color(0xFF2F3248),
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sa oras ng sakuna, mahalaga ang manatiling kalmado at sundin ang '
                    'mga tagubilin ng lokal na awtoridad. Siguraduhin may first aid kit, '
                    'emergency contacts, at evacuation plan para sa buong pamilya.',
                    style: TextStyle(
                      color: Color(0xFF565D77),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE4E7F3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.route_outlined),
                          title: Text('Evacuation Routes'),
                        ),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmergencyLeafletMapPage(
                              showShelters: false,
                            ),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB11E1E),
                        ),
                        child: const Text('View'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Expanded(
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.home_work_outlined),
                          title: Text('Emergency Shelters'),
                        ),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmergencyLeafletMapPage(
                              showShelters: true,
                            ),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB11E1E),
                        ),
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            _sectionTitle('Map'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _FullscreenMapPage(
                      title: 'Responder Map',
                      initialCenter: responderCenter,
                      initialZoom: 16,
                      pins: [
                        _MapPin(
                          point: responderCenter,
                          icon: Icons.location_on,
                          color: Color(0xFFB11E1E),
                          label: 'Barangay Emergency Response Point',
                        ),
                      ],
                    ),
                  ),
                ),
                icon: const Icon(Icons.fullscreen),
                label: const Text('Full View'),
              ),
            ),
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: responderCenter,
                    initialZoom: 14.4,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.barangaymo_app',
                    ),
                    const MarkerLayer(
                      markers: [
                        Marker(
                          point: responderCenter,
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.location_on,
                            color: Color(0xFFB11E1E),
                            size: 38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            _sectionTitle('Medical Info'),
            const MedicalInfoAccordions(),
          ],
        ),
      ),
    );
  }
}

class _MapPin {
  final LatLng point;
  final IconData icon;
  final Color color;
  final String label;

  const _MapPin({
    required this.point,
    required this.icon,
    required this.color,
    required this.label,
  });
}

class _FullscreenMapPage extends StatelessWidget {
  final String title;
  final LatLng initialCenter;
  final double initialZoom;
  final List<_MapPin> pins;

  const _FullscreenMapPage({
    required this.title,
    required this.initialCenter,
    required this.initialZoom,
    required this.pins,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: initialZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.barangaymo_app',
              ),
              MarkerLayer(
                markers: pins
                    .map(
                      (pin) => Marker(
                        point: pin.point,
                        width: 46,
                        height: 46,
                        child: Icon(pin.icon, color: pin.color, size: 36),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          if (pins.isNotEmpty)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE4E7F3)),
                ),
                child: Text(
                  pins.map((pin) => pin.label).join(' | '),
                  style: const TextStyle(
                    color: Color(0xFF2F3248),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmergencyInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _EmergencyInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E7F3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF6A6F86)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2F3248),
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF6A6E84),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFB11E1E)),
        onTap: onTap,
      ),
    );
  }
}

class EmergencySafetyDetailPage extends StatelessWidget {
  final String title;
  final String summary;
  final List<String> guide;
  const EmergencySafetyDetailPage({
    super.key,
    required this.title,
    required this.summary,
    required this.guide,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE4E7F3)),
            ),
            child: Text(
              summary,
              style: const TextStyle(
                color: Color(0xFF4F5672),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...guide.map(
            (step) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E7F3)),
              ),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.check_circle_outline),
                title: Text(
                  step,
                  style: const TextStyle(
                    color: Color(0xFF2F3248),
                    fontWeight: FontWeight.w600,
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

class EmergencyLeafletMapPage extends StatelessWidget {
  final bool showShelters;
  const EmergencyLeafletMapPage({super.key, required this.showShelters});

  @override
  Widget build(BuildContext context) {
    final title = showShelters ? 'Emergency Shelters' : 'Evacuation Routes';
    final markers = showShelters
        ? const [
            (
              LatLng(14.8391, 120.2860),
              Icons.home_work_rounded,
              'West Tapinac Gym Shelter',
            ),
            (
              LatLng(14.8379, 120.2877),
              Icons.school_rounded,
              'Old Cabalan School Shelter',
            ),
          ]
        : const [
            (
              LatLng(14.8382, 120.2856),
              Icons.alt_route_rounded,
              'Route A - Church Road',
            ),
            (
              LatLng(14.8390, 120.2872),
              Icons.alt_route_rounded,
              'Route B - Highway Exit',
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(14.8386, 120.2865),
                initialZoom: 14.6,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.barangaymo_app',
                ),
                MarkerLayer(
                  markers: markers
                      .map(
                        (item) => Marker(
                          point: item.$1,
                          width: 48,
                          height: 48,
                          child: Icon(
                            item.$2,
                            color: const Color(0xFFB11E1E),
                            size: 36,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E7F3))),
            ),
            child: Column(
              children: markers
                  .map(
                    (item) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.place_outlined),
                      title: Text(item.$3),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalInfoAccordions extends StatelessWidget {
  const MedicalInfoAccordions({super.key});
  @override
  Widget build(BuildContext context) {
    const items = [
      (
        'How to perform CPR',
        'Check scene safety, call emergency services, begin chest compressions, and give rescue breaths if trained.',
      ),
      (
        'How to deal with choking',
        'For severe choking, perform back blows and abdominal thrusts. Call emergency services immediately.',
      ),
      (
        'How to treat burns',
        'Cool the burn under clean water for 10-20 minutes, avoid ice, and cover with sterile cloth.',
      ),
      (
        'How to handle fractures',
        'Immobilize the injured area, avoid moving the limb, and seek urgent medical care.',
      ),
      (
        'How to stop bleeding',
        'Apply direct pressure with clean cloth and elevate wound if possible.',
      ),
    ];
    return Column(
      children: items
          .map(
            (e) => Card(
              child: ExpansionTile(
                title: Text(e.$1),
                children: [
                  Padding(padding: const EdgeInsets.all(12), child: Text(e.$2)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class EmergencyHotlinesPage extends StatelessWidget {
  const EmergencyHotlinesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final data = [
      ('Actionline Against Human Trafficking', '1343'),
      ('PDEA', '(02) 8929-6672'),
      ('Bantay Bata 163', '163'),
      ('Lifeline Ambulance Rescue', '16-911'),
      ('DSWD', '(02) 8931-8101'),
      ('Philippine Coast Guard', '(02) 8527-8481'),
      ('MMDA', '(02) 8822-4151'),
      ('DOH', '(02) 8942-6843'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Hotlines'),
        backgroundColor: const Color(0xFFD70000),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: data
            .map(
              (e) => Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.local_phone)),
                  title: Text(e.$1),
                  subtitle: Text(e.$2),
                  trailing: const Icon(Icons.phone),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ScanQrPage extends StatelessWidget {
  const ScanQrPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR ID Scanner'),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F7FF), Color(0xFFF8F1ED)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF082A46), Color(0xFF021728)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33042A49),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 30,
                      right: 26,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.24),
                          ),
                        ),
                        child: Stack(
                          children: const [
                            _QrCorner(top: true, left: true),
                            _QrCorner(top: true, left: false),
                            _QrCorner(top: false, left: true),
                            _QrCorner(top: false, left: false),
                            Center(
                              child: Icon(
                                Icons.qr_code_scanner_rounded,
                                size: 84,
                                color: Color(0xFFE3E9F8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE3E7F4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.qr_code_2_rounded, color: Color(0xFFD74637)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan Resident Barangay ID',
                          style: TextStyle(
                            color: Color(0xFF2F334A),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Position the ID within the frame for scanning',
                          style: TextStyle(
                            color: Color(0xFF646C88),
                            fontWeight: FontWeight.w600,
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

class _QrCorner extends StatelessWidget {
  final bool top;
  final bool left;
  const _QrCorner({required this.top, required this.left});

  @override
  Widget build(BuildContext context) {
    const cornerSize = 38.0;
    return Positioned(
      top: top ? 10 : null,
      bottom: top ? null : 10,
      left: left ? 10 : null,
      right: left ? null : 10,
      child: Container(
        width: cornerSize,
        height: cornerSize,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? const BorderSide(color: Color(0xFFE0E8FF), width: 5)
                : BorderSide.none,
            bottom: top
                ? BorderSide.none
                : const BorderSide(color: Color(0xFFE0E8FF), width: 5),
            left: left
                ? const BorderSide(color: Color(0xFFE0E8FF), width: 5)
                : BorderSide.none,
            right: left
                ? BorderSide.none
                : const BorderSide(color: Color(0xFFE0E8FF), width: 5),
          ),
        ),
      ),
    );
  }
}

class AssistancePage extends StatelessWidget {
  const AssistancePage({super.key});
  @override
  Widget build(BuildContext context) {
    const items = [
      (
        'Burial Assistance',
        'Funeral aid and urgent family support',
        Icons.volunteer_activism,
        Color(0xFFFFE2D8),
      ),
      (
        'Educational Assistance',
        'School supplies, tuition and scholarship referrals',
        Icons.school,
        Color(0xFFDDE6FF),
      ),
      (
        'Financial Assistance',
        'Emergency cash support for qualified residents',
        Icons.account_balance_wallet,
        Color(0xFFE0F3E8),
      ),
      (
        'Medical Assistance',
        'Hospital endorsement and treatment support',
        Icons.local_hospital,
        Color(0xFFFFE6E2),
      ),
      (
        'Medicine Assistance',
        'Prescription medicine access and subsidy',
        Icons.medication,
        Color(0xFFE7EEFF),
      ),
      (
        'Sponsorship Assistance',
        'Program and event sponsorship endorsements',
        Icons.card_giftcard,
        Color(0xFFFFE9D9),
      ),
      (
        'Venue Assistance',
        'Barangay venue usage and reservation support',
        Icons.location_city,
        Color(0xFFE7F1FF),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistance'),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFD94646), Color(0xFFEF6767)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29D74637),
                    blurRadius: 14,
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
                          'What type of assistance do you need?',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Select a program to start your request and review eligibility requirements.',
                          style: TextStyle(color: Color(0xFFFFDFDF)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.handshake_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: const Color(0xFFE6E8F4)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: e.$4,
                    ),
                    child: Icon(e.$3, color: const Color(0xFF4A4F6A)),
                  ),
                  title: Text(
                    e.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F3248),
                    ),
                  ),
                  subtitle: Text(
                    e.$2,
                    style: const TextStyle(
                      color: Color(0xFF686C86),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AssistanceRequestPage(
                        assistanceType: e.$1,
                        assistanceDescription: e.$2,
                        assistanceIcon: e.$3,
                        accentColor: e.$4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BpatPage extends StatelessWidget {
  const BpatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BPAT Assistance'),
          backgroundColor: const Color(0xFFF7F8FF),
          bottom: TabBar(
            indicatorColor: Colors.transparent,
            indicator: BoxDecoration(
              color: const Color(0xFFE6DBDB),
              borderRadius: BorderRadius.circular(999),
            ),
            dividerColor: const Color(0xFFDDCFCF),
            labelColor: const Color(0xFF8E4E45),
            unselectedLabelColor: const Color(0xFF5F647D),
            labelStyle: const TextStyle(fontWeight: FontWeight.w800),
            tabs: const [
              Tab(text: 'Call'),
              Tab(text: 'Blotter'),
              Tab(text: 'Records'),
              Tab(text: 'Duty'),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF6F8FF), Color(0xFFF9F1ED)],
            ),
          ),
          child: TabBarView(
            children: [
              ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF8E4E45), Color(0xFFB86B5E)],
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Barangay Peace & Security',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Fast contact for patrol requests, blotter lookup, and incident records.',
                                style: TextStyle(
                                  color: Color(0xFFFFE2DC),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0x33FFFFFF),
                          child: Icon(
                            Icons.shield_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _bpatAction(
                    context: context,
                    title: 'Call BPAT Emergency Line',
                    subtitle: 'Direct access to available patrol team.',
                    icon: Icons.call_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EmergencyContactActionPage(
                          contactName: 'BPAT',
                          phoneNumber: '0917-800-1001',
                          description:
                              'Barangay patrol and neighborhood security response',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _bpatAction(
                    context: context,
                    title: 'Report an Incident',
                    subtitle:
                        'Submit report details for validation and response.',
                    icon: Icons.report_gmailerrorred_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BpatReportPage()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _bpatAction(
                    context: context,
                    title: 'Request Patrol',
                    subtitle: 'Schedule area monitoring for your location.',
                    icon: Icons.directions_walk_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BpatPatrolPage()),
                    ),
                  ),
                ],
              ),
              const BpatBlotterPage(),
              const BpatRecordsPage(),
              const _BpatDutyPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bpatAction({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3E7F4)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF4E8E5),
                ),
                child: Icon(icon, color: const Color(0xFF8E4E45)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF2F334A),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF646C88),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF8E4E45)),
            ],
          ),
        ),
      ),
    );
  }
}

class BpatReportPage extends StatefulWidget {
  const BpatReportPage({super.key});

  @override
  State<BpatReportPage> createState() => _BpatReportPageState();
}

class _BpatReportPageState extends State<BpatReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController(
    text: _currentResidentProfile?.locationSummary ?? 'West Tapinac, Olongapo City',
  );
  final _detailsController = TextEditingController();
  final _victimController = TextEditingController(text: _residentDisplayName());
  final _reporterController = TextEditingController(text: _residentDisplayName());
  final _mobileController = TextEditingController(
    text: _mobileForRole(UserRole.resident),
  );
  final _personInvolvedController = TextEditingController();
  String _type = 'Theft';
  String _priority = 'High';
  DateTime _incidentAt = DateTime.now();
  String? _photoName;

  @override
  void dispose() {
    _locationController.dispose();
    _detailsController.dispose();
    _victimController.dispose();
    _reporterController.dispose();
    _mobileController.dispose();
    _personInvolvedController.dispose();
    super.dispose();
  }

  Future<void> _pickEvidence(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null || !mounted) {
      return;
    }
    setState(() => _photoName = image.name);
  }

  Future<void> _pickIncidentTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _incidentAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_incidentAt),
    );
    if (time == null || !mounted) {
      return;
    }
    setState(() {
      _incidentAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Incident Report')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Incident Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                'Theft',
                'Noise',
                'Fire',
                'Medical',
                'Suspicious Activity',
                'Domestic Dispute',
                'Accident',
              ]
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _type = value ?? _type),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: const ['Urgent', 'High', 'Normal']
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _priority = value ?? _priority),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _pickIncidentTime,
              icon: const Icon(Icons.schedule_outlined),
              label: Text('Incident Time: ${_formatEmergencyDateTime(_incidentAt)}'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Incident Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter the incident location.' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _victimController,
              decoration: const InputDecoration(
                labelText: 'Victim / Affected Resident',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter the resident name.' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _reporterController,
              decoration: const InputDecoration(
                labelText: 'Reporter Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter the reporter name.' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'Reporter Mobile',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                return digits.length < 10 ? 'Enter a valid mobile number.' : null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _personInvolvedController,
              decoration: const InputDecoration(
                labelText: 'Person Involved / Suspect Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _detailsController,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Incident Details',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().length < 8)
                  ? 'Provide more incident details.'
                  : null,
            ),
            const SizedBox(height: 10),
            Container(
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
                    'Evidence Attachment',
                    style: TextStyle(
                      color: Color(0xFF2F3248),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickEvidence(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Capture Photo'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickEvidence(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Upload Image'),
                        ),
                      ),
                    ],
                  ),
                  if (_photoName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Attached: $_photoName',
                      style: const TextStyle(
                        color: Color(0xFF646B84),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              final reference =
                  'BPAT-${DateTime.now().year}-${1000 + _emergencyOpsStore.incidents.value.length + 1}';
              final base = _emergencyOpsStore.sharedLocation.value?.point ??
                  _defaultEmergencyPoint();
              final point = LatLng(
                double.parse((base.latitude + 0.0005).toStringAsFixed(6)),
                double.parse((base.longitude + 0.0003).toStringAsFixed(6)),
              );
              _emergencyOpsStore.addIncident(
                _EmergencyIncident(
                  reference: reference,
                  type: _type,
                  status: 'Pending',
                  priority: _priority,
                  location: _locationController.text.trim(),
                  details: _detailsController.text.trim(),
                  victimName: _victimController.text.trim(),
                  reporterName: _reporterController.text.trim(),
                  reporterMobile: _mobileController.text.trim(),
                  createdAt: _incidentAt,
                  point: point,
                  personInvolved: _personInvolvedController.text.trim().isEmpty
                      ? null
                      : _personInvolvedController.text.trim(),
                  attachmentLabel: _photoName,
                ),
              );
              _showFeature(context, 'Incident report submitted. Ref: $reference');
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD70000),
            ),
            child: const Text('SUBMIT REPORT'),
          ),
        ),
      ),
    );
  }
}

class BpatPatrolPage extends StatefulWidget {
  const BpatPatrolPage({super.key});

  @override
  State<BpatPatrolPage> createState() => _BpatPatrolPageState();
}

class _BpatPatrolPageState extends State<BpatPatrolPage> {
  final _formKey = GlobalKey<FormState>();
  late final _locationController = TextEditingController(
    text: _currentResidentProfile?.locationSummary ?? '',
  );
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _scheduledAt = DateTime.now().add(const Duration(hours: 4));

  @override
  void dispose() {
    _locationController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickSchedule() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null || !mounted) {
      return;
    }
    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Patrol')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location for Patrol',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter the patrol area.' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Patrol Request',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter the patrol reason.' : null,
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _pickSchedule,
              icon: const Icon(Icons.event_available_outlined),
              label: Text('Scheduled Date/Time: ${_formatEmergencyDateTime(_scheduledAt)}'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Additional Comments',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              final reference =
                  'PATROL-${DateTime.now().year}-${200 + _emergencyOpsStore.patrolRequests.value.length + 1}';
              _emergencyOpsStore.addPatrolRequest(
                _PatrolRequestEntry(
                  reference: reference,
                  location: _locationController.text.trim(),
                  reason: _reasonController.text.trim(),
                  requestedBy: _residentDisplayName(),
                  scheduledAt: _scheduledAt,
                  notes: _notesController.text.trim(),
                  status: 'Queued',
                ),
              );
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Submitted'),
                  content: Text(
                    'Your patrol request has been received.\nReference: $reference',
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD70000),
            ),
            child: const Text('SUBMIT PATROL REQUEST'),
          ),
        ),
      ),
    );
  }
}

class BpatBlotterPage extends StatefulWidget {
  const BpatBlotterPage({super.key});

  @override
  State<BpatBlotterPage> createState() => _BpatBlotterPageState();
}

class _BpatBlotterPageState extends State<BpatBlotterPage> {
  String _query = '';
  String _status = 'All';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_EmergencyIncident>>(
      valueListenable: _emergencyOpsStore.incidents,
      builder: (_, incidents, __) {
        final rows = [...incidents]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final filtered = rows.where((entry) {
          final matchesQuery =
              entry.reference.toLowerCase().contains(_query.toLowerCase()) ||
              entry.location.toLowerCase().contains(_query.toLowerCase()) ||
              entry.type.toLowerCase().contains(_query.toLowerCase()) ||
              _maskedVictimName(entry.victimName)
                  .toLowerCase()
                  .contains(_query.toLowerCase());
          final matchesStatus = _status == 'All' || entry.status == _status;
          return matchesQuery && matchesStatus;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E6F2)),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Search blotter name, location, or reference...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  const items = ['All', 'Pending', 'Dispatched', 'Resolved'];
                  final item = items[index];
                  final selected = item == _status;
                  return ChoiceChip(
                    label: Text(item),
                    selected: selected,
                    onSelected: (_) => setState(() => _status = item),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            if (filtered.isEmpty)
              const ListTile(
                leading: Icon(Icons.search_off_rounded),
                title: Text('No blotter matches found'),
              ),
            ...filtered.map(
              (entry) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E6F2)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  title: Text(
                    '${entry.type} • ${_maskedVictimName(entry.victimName)}',
                    style: const TextStyle(
                      color: Color(0xFF332F35),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    '${entry.reference}\n${entry.location}\n${_formatEmergencyDateTime(entry.createdAt)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: _EmergencyStatusPill(
                    label: entry.status,
                    color: _emergencyStatusColor(entry.status),
                  ),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    builder: (_) => _EmergencyIncidentDetailSheet(incident: entry),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BpatRecordsPage extends StatefulWidget {
  const BpatRecordsPage({super.key});

  @override
  State<BpatRecordsPage> createState() => _BpatRecordsPageState();
}

class _BpatRecordsPageState extends State<BpatRecordsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_EmergencyIncident>>(
      valueListenable: _emergencyOpsStore.incidents,
      builder: (_, incidents, __) {
        return ValueListenableBuilder<List<_PatrolRequestEntry>>(
          valueListenable: _emergencyOpsStore.patrolRequests,
          builder: (_, patrols, __) {
            final incidentRows = incidents.where((item) {
              final haystack = [
                item.reference,
                item.type,
                item.location,
                item.reporterName,
                item.createdAt.toIso8601String(),
              ].join(' ').toLowerCase();
              return haystack.contains(_query.toLowerCase());
            }).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            final patrolRows = patrols.where((item) {
              final haystack = [
                item.reference,
                item.location,
                item.reason,
                item.requestedBy,
                item.scheduledAt.toIso8601String(),
              ].join(' ').toLowerCase();
              return haystack.contains(_query.toLowerCase());
            }).toList()
              ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E6F2)),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Search incident, patrol, resident, or date...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _sectionTitle('Incident Reports'),
                const SizedBox(height: 8),
                if (incidentRows.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.search_off_rounded),
                    title: Text('No incident records matched'),
                  ),
                ...incidentRows.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E6F2)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
                      title: Text(
                        '${item.reference} • ${item.type}',
                        style: const TextStyle(
                          color: Color(0xFF332F35),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${item.location}\n${_formatEmergencyDateTime(item.createdAt)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: FilledButton(
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          showDragHandle: true,
                          builder: (_) =>
                              _EmergencyIncidentDetailSheet(incident: item),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD70000),
                        ),
                        child: const Text('DETAILS'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _sectionTitle('Patrol Requests'),
                const SizedBox(height: 8),
                ...patrolRows.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E6F2)),
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
                        '${item.reason}\n${_formatEmergencyDateTime(item.scheduledAt)} • ${item.status}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _BpatDutyPage extends StatelessWidget {
  const _BpatDutyPage();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_TanodDutyEntry>>(
      valueListenable: _emergencyOpsStore.tanods,
      builder: (_, tanods, __) {
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E6F2)),
              ),
              child: Text(
                _hasOfficialEmergencyAccess
                    ? 'Tanod status can be updated live here for duty scheduling.'
                    : 'Residents can view which tanods are currently on duty for faster coordination.',
                style: const TextStyle(
                  color: Color(0xFF646B84),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...tanods.asMap().entries.map((entry) {
              final index = entry.key;
              final tanod = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E6F2)),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tanod.online
                        ? const Color(0x1F2D8A57)
                        : const Color(0x1FA16B6B),
                    child: Icon(
                      tanod.online ? Icons.check_circle : Icons.remove_circle,
                      color: tanod.online
                          ? const Color(0xFF2D8A57)
                          : const Color(0xFF9A2E2E),
                    ),
                  ),
                  title: Text(
                    tanod.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${tanod.zone} • ${tanod.shift}\n${tanod.assignment}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: _hasOfficialEmergencyAccess
                      ? Switch(
                          value: tanod.online,
                          activeColor: const Color(0xFFD70000),
                          onChanged: (_) => _emergencyOpsStore.toggleTanod(index),
                        )
                      : _EmergencyStatusPill(
                          label: tanod.online ? 'Online' : 'Offline',
                          color: tanod.online
                              ? const Color(0xFF2D8A57)
                              : const Color(0xFF9A2E2E),
                        ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class KatarungangPambarangayPage extends StatelessWidget {
  const KatarungangPambarangayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Legal Records & Lupon'),
          backgroundColor: const Color(0xFFD70000),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Cases'),
              Tab(text: 'Heatmap'),
              Tab(text: 'Patrol'),
              Tab(text: 'Report'),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF6F8FF), Color(0xFFF9F1ED)],
            ),
          ),
          child: const TabBarView(
            children: [
              _LuponOverviewTab(),
              _LuponCasesTab(),
              _LegalHeatmapTab(),
              _ChiefTanodDashboardTab(),
              _AnnualPeaceOrderTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LuponOverviewTab extends StatelessWidget {
  const _LuponOverviewTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_LuponCaseEntry>>(
      valueListenable: _emergencyOpsStore.luponCases,
      builder: (_, cases, __) {
        return ValueListenableBuilder<List<_SafetyCalendarEntry>>(
          valueListenable: _emergencyOpsStore.legalCalendar,
          builder: (_, calendar, __) {
            return ValueListenableBuilder<List<_SafetyBroadcastEntry>>(
              valueListenable: _emergencyOpsStore.broadcasts,
              builder: (_, broadcasts, __) {
                final nextHearing = calendar.isEmpty ? null : calendar.first;
                return ListView(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Katarungang Pambarangay Desk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Track Lupon cases, schedule mediation, issue summons, and monitor peace and order operations.',
                            style: TextStyle(
                              color: Color(0xFFFFE8E8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _EmergencyHeroStat(
                                  label: 'Active Cases',
                                  value: '${cases.length}',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _EmergencyHeroStat(
                                  label: 'Broadcasts',
                                  value: '${broadcasts.length}',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _EmergencyHeroStat(
                                  label: 'Next Hearing',
                                  value: nextHearing == null
                                      ? '--'
                                      : '${nextHearing.scheduledAt.month}/${nextHearing.scheduledAt.day}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const _LuponCaseEntryPage(),
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFD70000),
                            ),
                            icon: const Icon(Icons.playlist_add_rounded),
                            label: const Text('New Case'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openSafetyBroadcastComposer(context),
                            icon: const Icon(Icons.campaign_rounded),
                            label: const Text('Broadcast'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _sectionTitle('Mediation Calendar'),
                    ...calendar.take(4).map(
                      (entry) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E6F2)),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFFFE5E5),
                            child: Icon(
                              Icons.calendar_today_outlined,
                              color: Color(0xFFD70000),
                            ),
                          ),
                          title: Text(
                            '${entry.title} - ${entry.reference}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '${entry.venue}\n${_formatEmergencyDateTime(entry.scheduledAt)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _sectionTitle('Public Safety Broadcasts'),
                    ...broadcasts.take(3).map(
                      (entry) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E6F2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF2F3248),
                                    ),
                                  ),
                                ),
                                _EmergencyStatusPill(
                                  label: entry.severity,
                                  color: entry.severity == 'Critical'
                                      ? const Color(0xFFD70000)
                                      : const Color(0xFF8E4E45),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              entry.body,
                              style: const TextStyle(
                                color: Color(0xFF666D86),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _LuponCasesTab extends StatelessWidget {
  const _LuponCasesTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_LuponCaseEntry>>(
      valueListenable: _emergencyOpsStore.luponCases,
      builder: (_, cases, __) {
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ...cases.map(
              (entry) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E6F2)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                  leading: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE7E4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.balance_rounded,
                      color: Color(0xFFD70000),
                    ),
                  ),
                  title: Text(
                    '${entry.caseNo} - ${entry.complainant} vs ${entry.respondent}',
                    style: const TextStyle(
                      color: Color(0xFF2F3248),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: Text(
                    '${entry.issueSummary}\nHearing: ${_formatEmergencyDateTime(entry.hearingDate)}\nSensitive: ${_protectSensitiveValue(entry.encryptedVictimData)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Summons') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                _LuponSummonsPreviewPage(caseEntry: entry),
                          ),
                        );
                        return;
                      }
                      _emergencyOpsStore.updateLuponCaseStatus(entry.caseNo, value);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'Settled', child: Text('Settled')),
                      PopupMenuItem(
                        value: 'Repudiated',
                        child: Text('Repudiated'),
                      ),
                      PopupMenuItem(
                        value: 'Forwarded to Court',
                        child: Text('Forwarded to Court'),
                      ),
                      PopupMenuItem(
                        value: 'Summons',
                        child: Text('Generate Summons'),
                      ),
                    ],
                    child: _EmergencyStatusPill(
                      label: entry.status,
                      color: _legalStatusColor(entry.status),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LegalHeatmapTab extends StatelessWidget {
  const _LegalHeatmapTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_EmergencyIncident>>(
      valueListenable: _emergencyOpsStore.incidents,
      builder: (_, incidents, __) {
        final markers = <Marker>[
          for (final incident in incidents)
            Marker(
              point: incident.point,
              width: 50,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: _incidentTypeColor(incident.type).withValues(alpha: 0.28),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _incidentTypeColor(incident.type),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    incident.type.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
        ];
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E6F2)),
              ),
              child: const Text(
                'Leaflet incident heatmap view for blotter concentration and legal hotspots. Larger markers indicate repeated incident locations.',
                style: TextStyle(
                  color: Color(0xFF666D86),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _defaultEmergencyPoint(),
                    initialZoom: 14.6,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.barangaymo_app',
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...incidents.take(5).map(
              (incident) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E6F2)),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        _incidentTypeColor(incident.type).withValues(alpha: 0.12),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: _incidentTypeColor(incident.type),
                    ),
                  ),
                  title: Text(
                    '${incident.type} - ${incident.location}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${incident.reference}\n${_formatEmergencyDateTime(incident.createdAt)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChiefTanodDashboardTab extends StatelessWidget {
  const _ChiefTanodDashboardTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_TanodDutyEntry>>(
      valueListenable: _emergencyOpsStore.tanods,
      builder: (_, tanods, __) {
        return ValueListenableBuilder<List<_PatrolRequestEntry>>(
          valueListenable: _emergencyOpsStore.patrolRequests,
          builder: (_, patrols, __) {
            return ValueListenableBuilder<List<_PatrolCheckpoint>>(
              valueListenable: _emergencyOpsStore.patrolCheckpoints,
              builder: (_, checkpoints, __) {
                final onlineCount = tanods.where((entry) => entry.online).length;
                return ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8E4E45), Color(0xFFB86B5E)],
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chief Tanod Dashboard',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Track active patrols, scan checkpoints, and review safety logs in one view.',
                                  style: TextStyle(
                                    color: Color(0xFFFFE2DC),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.security_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _CommercialMetric(
                            icon: Icons.check_circle_rounded,
                            label: 'Online Tanods',
                            value: '$onlineCount',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _CommercialMetric(
                            icon: Icons.route_rounded,
                            label: 'Patrol Queue',
                            value: '${patrols.length}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _CommercialMetric(
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'QR Points',
                            value: '${checkpoints.length}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _sectionTitle('QR Patrol Points'),
                    ...checkpoints.asMap().entries.map((entry) {
                      final index = entry.key;
                      final checkpoint = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E6F2)),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4E8E5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.qr_code_2_rounded,
                              color: Color(0xFF8E4E45),
                            ),
                          ),
                          title: Text(
                            checkpoint.label,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '${checkpoint.zone} - ${checkpoint.qrCode}\n${checkpoint.lastScannedAt == null ? 'Not scanned yet' : 'Last scan: ${_formatEmergencyDateTime(checkpoint.lastScannedAt!)} by ${checkpoint.lastScannedBy}'}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: FilledButton(
                            onPressed: () {
                              final scanner = tanods.firstWhere(
                                (tanod) => tanod.online,
                                orElse: () => const _TanodDutyEntry(
                                  name: 'Chief Tanod',
                                  zone: 'Zone Command',
                                  shift: '',
                                  online: true,
                                  assignment: '',
                                ),
                              );
                              _emergencyOpsStore.scanPatrolCheckpoint(
                                index,
                                scanner.name,
                              );
                              _showFeature(
                                context,
                                '${checkpoint.label} patrol point verified.',
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFD70000),
                            ),
                            child: const Text('SCAN'),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _AnnualPeaceOrderTab extends StatelessWidget {
  const _AnnualPeaceOrderTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_EmergencyIncident>>(
      valueListenable: _emergencyOpsStore.incidents,
      builder: (_, incidents, __) {
        return ValueListenableBuilder<List<_LuponCaseEntry>>(
          valueListenable: _emergencyOpsStore.luponCases,
          builder: (_, cases, __) {
            final resolved = incidents.where((item) => item.status == 'Resolved').length;
            final forwarded = cases
                .where((item) => item.status == 'Forwarded to Court')
                .length;
            final settled =
                cases.where((item) => item.status == 'Settled').length;
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E6F2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Annual Peace and Order Report',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2F3248),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Incidents logged: ${incidents.length}\nResolved incidents: $resolved\nLupon cases: ${cases.length}\nSettled cases: $settled\nForwarded to court: $forwarded',
                        style: const TextStyle(
                          color: Color(0xFF666D86),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...[
                  'Top incident type: ${_topIncidentType(incidents)}',
                  'Highest risk zone: ${_topIncidentZone(incidents)}',
                  'Most active checkpoint: ${_topCheckpointLabel(_emergencyOpsStore.patrolCheckpoints.value)}',
                  'Current report year: ${DateTime.now().year}',
                ].map(
                  (line) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E6F2)),
                    ),
                    child: Text(
                      line,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const _AnnualPeaceAndOrderReportPage(),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFD70000),
                  ),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Auto-Export APOC'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _LuponCaseEntryPage extends StatefulWidget {
  const _LuponCaseEntryPage();

  @override
  State<_LuponCaseEntryPage> createState() => _LuponCaseEntryPageState();
}

class _LuponCaseEntryPageState extends State<_LuponCaseEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _complainantController = TextEditingController();
  final _respondentController = TextEditingController();
  final _summaryController = TextEditingController();
  final _sensitiveController = TextEditingController();
  final _venueController = TextEditingController(text: 'Barangay Session Hall');
  DateTime _hearingDate = DateTime.now().add(const Duration(days: 3));
  String _status = 'Settled';

  @override
  void dispose() {
    _complainantController.dispose();
    _respondentController.dispose();
    _summaryController.dispose();
    _sensitiveController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  Future<void> _pickHearingDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _hearingDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_hearingDate),
    );
    if (time == null || !mounted) {
      return;
    }
    setState(() {
      _hearingDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final caseNo =
        'KP-${DateTime.now().year}-${100 + _emergencyOpsStore.luponCases.value.length + 1}';
    _emergencyOpsStore.addLuponCase(
      _LuponCaseEntry(
        caseNo: caseNo,
        complainant: _complainantController.text.trim(),
        respondent: _respondentController.text.trim(),
        hearingDate: _hearingDate,
        status: _status,
        issueSummary: _summaryController.text.trim(),
        encryptedVictimData: _encryptSensitiveValue(
          _sensitiveController.text.trim(),
        ),
        createdAt: DateTime.now(),
        luponOfficer: 'Lupon Chair Maria Cortez',
        venue: _venueController.text.trim(),
      ),
    );
    Navigator.pop(context);
    _showFeature(
      context,
      'Lupon case $caseNo created and mediation date synced to calendar.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Case Entry')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            TextFormField(
              initialValue:
                  'KP-${DateTime.now().year}-${100 + _emergencyOpsStore.luponCases.value.length + 1}',
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Case No',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _complainantController,
              decoration: const InputDecoration(
                labelText: 'Complainant',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter complainant.' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _respondentController,
              decoration: const InputDecoration(
                labelText: 'Respondent',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter respondent.' : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Case Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Settled', child: Text('Settled')),
                DropdownMenuItem(value: 'Repudiated', child: Text('Repudiated')),
                DropdownMenuItem(
                  value: 'Forwarded to Court',
                  child: Text('Forwarded to Court'),
                ),
              ],
              onChanged: (value) => setState(() => _status = value ?? _status),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _pickHearingDate,
              icon: const Icon(Icons.calendar_month_outlined),
              label: Text('Mediation schedule: ${_formatEmergencyDateTime(_hearingDate)}'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _venueController,
              decoration: const InputDecoration(
                labelText: 'Venue',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _summaryController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Issue Summary',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().length < 8)
                  ? 'Provide case summary.'
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _sensitiveController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Victim / Sensitive Notes',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter protected notes.'
                  : null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD70000),
            ),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Case'),
          ),
        ),
      ),
    );
  }
}

class _LuponSummonsPreviewPage extends StatelessWidget {
  final _LuponCaseEntry caseEntry;

  const _LuponSummonsPreviewPage({required this.caseEntry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summons Generator')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E6F2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Barangay Summons',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2F3248),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Case No: ${caseEntry.caseNo}'),
                Text('Respondent: ${caseEntry.respondent}'),
                Text('Complainant: ${caseEntry.complainant}'),
                Text('Mediation Date: ${_formatEmergencyDateTime(caseEntry.hearingDate)}'),
                Text('Venue: ${caseEntry.venue}'),
                const SizedBox(height: 12),
                Text(
                  'You are hereby summoned to appear before the Lupong Tagapamayapa regarding the complaint on ${caseEntry.issueSummary.toLowerCase()}.',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _showFeature(
              context,
              'Summons generated for ${caseEntry.respondent}.',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD70000),
            ),
            icon: const Icon(Icons.print_outlined),
            label: const Text('Generate Summons'),
          ),
        ],
      ),
    );
  }
}

class _AnnualPeaceAndOrderReportPage extends StatelessWidget {
  const _AnnualPeaceAndOrderReportPage();

  @override
  Widget build(BuildContext context) {
    final incidents = _emergencyOpsStore.incidents.value;
    final cases = _emergencyOpsStore.luponCases.value;
    final broadcasts = _emergencyOpsStore.broadcasts.value;
    return Scaffold(
      appBar: AppBar(title: const Text('APOC Exporter')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E6F2)),
            ),
            child: Text(
              'APOC ${DateTime.now().year}\n\n'
              'Total incidents: ${incidents.length}\n'
              'Resolved incidents: ${incidents.where((item) => item.status == 'Resolved').length}\n'
              'Total Lupon cases: ${cases.length}\n'
              'Settled Lupon cases: ${cases.where((item) => item.status == 'Settled').length}\n'
              'Repudiated cases: ${cases.where((item) => item.status == 'Repudiated').length}\n'
              'Forwarded to court: ${cases.where((item) => item.status == 'Forwarded to Court').length}\n'
              'Broadcast advisories released: ${broadcasts.length}\n'
              'Patrol checkpoints: ${_emergencyOpsStore.patrolCheckpoints.value.length}',
              style: const TextStyle(
                color: Color(0xFF2F3248),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _showFeature(
              context,
              'Annual Peace and Order Report exported.',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD70000),
            ),
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Export Report'),
          ),
        ],
      ),
    );
  }
}

Color _legalStatusColor(String status) {
  switch (status) {
    case 'Settled':
      return const Color(0xFF2D8A57);
    case 'Repudiated':
      return const Color(0xFFB36A00);
    case 'Forwarded to Court':
      return const Color(0xFF7B2CBF);
    default:
      return const Color(0xFFD70000);
  }
}

String _topIncidentType(List<_EmergencyIncident> incidents) {
  if (incidents.isEmpty) {
    return 'No incidents';
  }
  final counts = <String, int>{};
  for (final incident in incidents) {
    counts[incident.type] = (counts[incident.type] ?? 0) + 1;
  }
  return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

String _topIncidentZone(List<_EmergencyIncident> incidents) {
  if (incidents.isEmpty) {
    return 'Undetermined';
  }
  final counts = <String, int>{};
  for (final incident in incidents) {
    final zone = incident.location.split(',').last.trim();
    counts[zone] = (counts[zone] ?? 0) + 1;
  }
  return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

String _topCheckpointLabel(List<_PatrolCheckpoint> checkpoints) {
  if (checkpoints.isEmpty) {
    return 'No checkpoints';
  }
  final rows = [...checkpoints]
    ..sort((a, b) {
      final left = a.lastScannedAt ?? DateTime(2000);
      final right = b.lastScannedAt ?? DateTime(2000);
      return right.compareTo(left);
    });
  return rows.first.label;
}

Future<void> _openSafetyBroadcastComposer(BuildContext context) async {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  var severity = 'Watch';
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(sheetContext).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Public Safety Broadcast',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Broadcast title'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: severity,
                  decoration: const InputDecoration(labelText: 'Severity'),
                  items: const [
                    DropdownMenuItem(value: 'Watch', child: Text('Watch')),
                    DropdownMenuItem(value: 'Alert', child: Text('Alert')),
                    DropdownMenuItem(value: 'Critical', child: Text('Critical')),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setSheetState(() => severity = value);
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: bodyController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Message'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (titleController.text.trim().isEmpty ||
                          bodyController.text.trim().isEmpty) {
                        return;
                      }
                      _emergencyOpsStore.addBroadcast(
                        _SafetyBroadcastEntry(
                          title: titleController.text.trim(),
                          body: bodyController.text.trim(),
                          severity: severity,
                          createdAt: DateTime.now(),
                        ),
                      );
                      Navigator.pop(sheetContext);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD70000),
                    ),
                    child: const Text('Send Broadcast'),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
  titleController.dispose();
  bodyController.dispose();
}

