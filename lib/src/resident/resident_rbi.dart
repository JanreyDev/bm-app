part of barangaymo_app;

class _ResidentFamilyEntry {
  final String name;
  final String relationship;
  final String livingStatus;

  const _ResidentFamilyEntry({
    required this.name,
    required this.relationship,
    required this.livingStatus,
  });
}

class _ResidentVehicleEntry {
  final String kind;
  final String plateNumber;

  const _ResidentVehicleEntry({
    required this.kind,
    required this.plateNumber,
  });
}

class _ResidentVaccinationEntry {
  final String vaccine;
  final String doseLabel;
  final DateTime administeredAt;
  final String status;

  const _ResidentVaccinationEntry({
    required this.vaccine,
    required this.doseLabel,
    required this.administeredAt,
    required this.status,
  });
}

class _ResidentNutritionEntry {
  final DateTime recordedAt;
  final double heightCm;
  final double weightKg;

  const _ResidentNutritionEntry({
    required this.recordedAt,
    required this.heightCm,
    required this.weightKg,
  });

  double get bmi {
    final meters = heightCm / 100;
    if (meters <= 0) {
      return 0;
    }
    return weightKg / (meters * meters);
  }
}

class _RbiTransactionEntry {
  final String title;
  final String date;
  final String status;

  const _RbiTransactionEntry({
    required this.title,
    required this.date,
    required this.status,
  });
}

class _ResidentRbiRecord {
  final String rbiId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String suffix;
  final String barangay;
  final String municipality;
  final String province;
  final String streetName;
  final String zonePurok;
  final int yearOfResidency;
  final DateTime birthDate;
  final String gender;
  final String disabilityTag;
  final List<_ResidentFamilyEntry> familyMembers;
  final List<_ResidentVehicleEntry> vehicles;
  final List<_ResidentVaccinationEntry> vaccinations;
  final List<_ResidentNutritionEntry> nutritionEntries;
  final bool bloodDonorOptIn;
  final String bloodType;
  final String educationAidStatus;
  final String latestGradeAverage;
  final int verificationStep;
  final List<_RbiTransactionEntry> transactions;
  final DateTime updatedAt;

  const _ResidentRbiRecord({
    required this.rbiId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.suffix,
    required this.barangay,
    required this.municipality,
    required this.province,
    required this.streetName,
    required this.zonePurok,
    required this.yearOfResidency,
    required this.birthDate,
    required this.gender,
    required this.disabilityTag,
    required this.familyMembers,
    required this.vehicles,
    required this.vaccinations,
    required this.nutritionEntries,
    required this.bloodDonorOptIn,
    required this.bloodType,
    required this.educationAidStatus,
    required this.latestGradeAverage,
    required this.verificationStep,
    required this.transactions,
    required this.updatedAt,
  });

  String get fullName {
    final parts = [
      firstName.trim(),
      middleName.trim(),
      lastName.trim(),
      suffix == 'N/A' ? '' : suffix.trim(),
    ].where((part) => part.isNotEmpty).toList();
    return parts.join(' ');
  }

  String get addressSummary {
    return [streetName, zonePurok, barangay, municipality, province]
        .where((part) => part.trim().isNotEmpty)
        .join(', ');
  }

  int get age => _residentAgeFromBirthDate(birthDate);

  bool get isSeniorCitizen => age >= 60;

  bool get isPwd => disabilityTag.trim().isNotEmpty && disabilityTag != 'None';

  _ResidentNutritionEntry? get latestNutritionEntry =>
      nutritionEntries.isEmpty ? null : nutritionEntries.first;

  _ResidentRbiRecord copyWith({
    int? verificationStep,
    List<_RbiTransactionEntry>? transactions,
    DateTime? updatedAt,
  }) {
    return _ResidentRbiRecord(
      rbiId: rbiId,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      suffix: suffix,
      barangay: barangay,
      municipality: municipality,
      province: province,
      streetName: streetName,
      zonePurok: zonePurok,
      yearOfResidency: yearOfResidency,
      birthDate: birthDate,
      gender: gender,
      disabilityTag: disabilityTag,
      familyMembers: familyMembers,
      vehicles: vehicles,
      vaccinations: vaccinations,
      nutritionEntries: nutritionEntries,
      bloodDonorOptIn: bloodDonorOptIn,
      bloodType: bloodType,
      educationAidStatus: educationAidStatus,
      latestGradeAverage: latestGradeAverage,
      verificationStep: verificationStep ?? this.verificationStep,
      transactions: transactions ?? this.transactions,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class _ResidentRbiStore {
  static final ValueNotifier<_ResidentRbiRecord?> current =
      ValueNotifier<_ResidentRbiRecord?>(null);
  static final ValueNotifier<List<_ResidentRbiRecord>> all =
      ValueNotifier<List<_ResidentRbiRecord>>(<_ResidentRbiRecord>[]);

  static final Set<String> _submittedNames = <String>{
    'JUAN DELA CRUZ',
    'MARIA SANTOS',
    'PEDRO REYES',
  };

  static bool isDuplicateName(String fullName, {String? except}) {
    final normalized = fullName.trim().toUpperCase();
    if (normalized.isEmpty) {
      return false;
    }
    final ignored = except?.trim().toUpperCase();
    return _submittedNames.any(
      (entry) => entry == normalized && entry != ignored,
    );
  }

  static void save(_ResidentRbiRecord record, {String? previousName}) {
    if (previousName != null && previousName.trim().isNotEmpty) {
      _submittedNames.remove(previousName.trim().toUpperCase());
    }
    _submittedNames.add(record.fullName.trim().toUpperCase());
    current.value = record;
    all.value = [
      record,
      for (final entry in all.value)
        if (entry.rbiId != record.rbiId) entry,
    ];
  }
}

class ResidentRbiCardPage extends StatefulWidget {
  const ResidentRbiCardPage({super.key});

  @override
  State<ResidentRbiCardPage> createState() => _ResidentRbiCardPageState();
}

class _ResidentRbiCardPageState extends State<ResidentRbiCardPage> {
  static const _suffixes = ['N/A', 'Jr.', 'Sr.', 'III'];
  static const _relationships = [
    'Spouse',
    'Child',
    'Parent',
    'Sibling',
    'Grandparent',
    'Relative',
  ];
  static const _livingStatuses = ['Living Here', 'Temporary Away', 'Deceased'];
  static const _vehicleKinds = ['Motorcycle', 'Sedan', 'SUV'];
  static const _genders = ['Female', 'Male', 'Non-binary', 'Prefer not to say'];
  static const _disabilityTags = [
    'None',
    'Visual Impairment',
    'Hearing Impairment',
    'Orthopedic Disability',
    'Psychosocial Disability',
    'Learning Disability',
    'Chronic Illness',
  ];
  static const _bloodTypes = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  static const _educationAidStatuses = [
    'Not Enrolled',
    'Applicant',
    'Scholar',
    'For Grade Submission',
  ];

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _streetNameController = TextEditingController();
  final _zonePurokController = TextEditingController();
  final _yearResidencyController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _latestGradeController = TextEditingController();

  String _suffix = 'N/A';
  String _gender = _genders.first;
  String _disabilityTag = _disabilityTags.first;
  String _bloodType = _bloodTypes.first;
  String _educationAidStatus = _educationAidStatuses.first;
  List<_ResidentFamilyEntry> _familyMembers = const [];
  List<_ResidentVehicleEntry> _vehicles = const [];
  List<_ResidentVaccinationEntry> _vaccinations = const [];
  List<_ResidentNutritionEntry> _nutritionEntries = const [];
  bool _bloodDonorOptIn = false;
  bool _initialized = false;
  bool _profileHydrated = false;
  bool _rbiHydrated = false;
  bool _savingToApi = false;
  bool _serverSynced = false;
  bool _autoSyncAttempted = false;

  @override
  void initState() {
    super.initState();
    _hydrateFromStore();
    unawaited(_hydrateFromBackendProfile());
    unawaited(_hydrateFromBackendRbi());
  }

  void _hydrateFromStore() {
    if (_initialized) {
      return;
    }
    _initialized = true;
    final existing = _ResidentRbiStore.current.value;
    if (existing != null) {
      _firstNameController.text = existing.firstName;
      _middleNameController.text = existing.middleName;
      _lastNameController.text = existing.lastName;
      _streetNameController.text = existing.streetName;
      _zonePurokController.text = existing.zonePurok;
      _yearResidencyController.text = existing.yearOfResidency.toString();
      _birthDateController.text = _formatShortDate(existing.birthDate);
      _latestGradeController.text = existing.latestGradeAverage;
      _suffix = existing.suffix;
      _gender = existing.gender;
      _disabilityTag = existing.disabilityTag;
      _bloodType = existing.bloodType;
      _educationAidStatus = existing.educationAidStatus;
      _familyMembers = existing.familyMembers;
      _vehicles = existing.vehicles;
      _vaccinations = existing.vaccinations;
      _nutritionEntries = existing.nutritionEntries;
      _bloodDonorOptIn = existing.bloodDonorOptIn;
      return;
    }

    final parts = _residentDisplayName().trim().split(RegExp(r'\s+'));
    if (parts.isNotEmpty) {
      _firstNameController.text = parts.first;
      if (parts.length > 2) {
        _middleNameController.text = parts.sublist(1, parts.length - 1).join(' ');
      }
      if (parts.length > 1) {
        _lastNameController.text = parts.last;
      }
    }
    _streetNameController.text = 'Purok 3 Main Road';
    _zonePurokController.text = 'Zone 2';
    _yearResidencyController.text = '2018';
    _birthDateController.text = 'Mar 14, 1998';
  }

  Future<void> _hydrateFromBackendProfile() async {
    if (_profileHydrated) {
      return;
    }
    _profileHydrated = true;
    await _ResidentProfileStore.ensureLoaded();
    if (!mounted) {
      return;
    }
    final profile = _ResidentProfileStore.profile;
    if (_ResidentRbiStore.current.value != null) {
      return;
    }
    final parts = _splitName(profile.name);
    if (_firstNameController.text.trim().isEmpty && parts.$1.isNotEmpty) {
      _firstNameController.text = parts.$1;
    }
    if (_middleNameController.text.trim().isEmpty && parts.$2.isNotEmpty) {
      _middleNameController.text = parts.$2;
    }
    if (_lastNameController.text.trim().isEmpty && parts.$3.isNotEmpty) {
      _lastNameController.text = parts.$3;
    }
    if (_middleNameController.text.trim().isEmpty &&
        profile.middleName.trim().isNotEmpty) {
      _middleNameController.text = profile.middleName.trim();
    }
    if (_suffix == 'N/A' && profile.suffix.trim().isNotEmpty) {
      final next = profile.suffix.trim();
      if (_suffixes.contains(next)) {
        _suffix = next;
      }
    }
    if (_bloodType.trim().isEmpty && profile.bloodType.trim().isNotEmpty) {
      final nextBlood = profile.bloodType.trim().toUpperCase();
      if (_bloodTypes.contains(nextBlood)) {
        _bloodType = nextBlood;
      }
    } else if (profile.bloodType.trim().isNotEmpty) {
      final nextBlood = profile.bloodType.trim().toUpperCase();
      if (_bloodTypes.contains(nextBlood)) {
        _bloodType = nextBlood;
      }
    }
    if (_nutritionEntries.isEmpty &&
        profile.heightCm != null &&
        profile.weightKg != null) {
      _nutritionEntries = [
        _ResidentNutritionEntry(
          recordedAt: DateTime.now(),
          heightCm: profile.heightCm!,
          weightKg: profile.weightKg!,
        ),
      ];
    }
    setState(() {});
  }

  Future<void> _hydrateFromBackendRbi() async {
    if (_rbiHydrated) {
      return;
    }
    _rbiHydrated = true;
    final result = await _ResidentRbiApi.instance.fetchMyRecord();
    if (!mounted) {
      return;
    }
    if (!result.success || result.record == null) {
      final local = _ResidentRbiStore.current.value;
      if (local != null && !_autoSyncAttempted) {
        _autoSyncAttempted = true;
        await _syncRecordToBackend(local, silent: true);
      }
      return;
    }
    final remote = result.record!;
    _serverSynced = true;
    _ResidentRbiStore.save(remote, previousName: _ResidentRbiStore.current.value?.fullName);
    if (_ResidentRbiStore.current.value == null) {
      return;
    }
    _firstNameController.text = remote.firstName;
    _middleNameController.text = remote.middleName;
    _lastNameController.text = remote.lastName;
    _streetNameController.text = remote.streetName;
    _zonePurokController.text = remote.zonePurok;
    _yearResidencyController.text = remote.yearOfResidency.toString();
    _birthDateController.text = _formatShortDate(remote.birthDate);
    _latestGradeController.text = remote.latestGradeAverage;
    _suffix = remote.suffix;
    _gender = remote.gender;
    _disabilityTag = remote.disabilityTag;
    _bloodType = remote.bloodType;
    _educationAidStatus = remote.educationAidStatus;
    _familyMembers = remote.familyMembers;
    _vehicles = remote.vehicles;
    _vaccinations = remote.vaccinations;
    _nutritionEntries = remote.nutritionEntries;
    _bloodDonorOptIn = remote.bloodDonorOptIn;
    setState(() {});
  }

  Future<void> _syncRecordToBackend(
    _ResidentRbiRecord record, {
    bool silent = false,
  }) async {
    setState(() => _savingToApi = true);
    final result = await _ResidentRbiApi.instance.upsertRecord(record);
    if (!mounted) return;
    setState(() {
      _savingToApi = false;
      _serverSynced = result.success;
    });
    if (result.success && result.record != null) {
      _ResidentRbiStore.save(
        result.record!,
        previousName: _ResidentRbiStore.current.value?.fullName,
      );
      if (!silent) {
        _showFeature(
          context,
          'RBI form saved and synced.',
          tone: _ToastTone.success,
        );
      }
      return;
    }
    if (!silent) {
      _showFeature(
        context,
        'RBI saved locally. ${result.message}',
        tone: _ToastTone.warning,
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _streetNameController.dispose();
    _zonePurokController.dispose();
    _yearResidencyController.dispose();
    _birthDateController.dispose();
    _latestGradeController.dispose();
    super.dispose();
  }

  String get _residentBarangay =>
      _currentResidentProfile?.barangay.trim().isNotEmpty == true
      ? _currentResidentProfile!.barangay
      : 'West Tapinac';

  String get _residentCity =>
      _currentResidentProfile?.cityMunicipality.trim().isNotEmpty == true
      ? _currentResidentProfile!.cityMunicipality
      : 'City of Olongapo';

  String get _residentProvince =>
      _currentResidentProfile?.province.trim().isNotEmpty == true
      ? _currentResidentProfile!.province
      : 'Zambales';

  String _composeFullName() {
    final parts = [
      _firstNameController.text.trim(),
      _middleNameController.text.trim(),
      _lastNameController.text.trim(),
      _suffix == 'N/A' ? '' : _suffix,
    ].where((part) => part.isNotEmpty).toList();
    return parts.join(' ');
  }

  String _generateRbiId() {
    final cleanBarangay = _residentBarangay
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
        .toUpperCase();
    final barangayCode = cleanBarangay.isEmpty
        ? 'BRGY'
        : cleanBarangay.substring(
            0,
            cleanBarangay.length > 6 ? 6 : cleanBarangay.length,
          );
    final year = DateTime.now().year;
    final random = 100000 + math.Random().nextInt(900000);
    return 'RBI-$barangayCode-$year-$random';
  }

  DateTime? get _parsedBirthDate => _tryParseShortDate(_birthDateController.text);

  Future<void> _captureResidentPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      imageQuality: 90,
    );
    if (picked == null) {
      return;
    }
    final bytes = await picked.readAsBytes();
    _ResidentProfilePhotoStore.photo.value = _ResidentProfilePhotoValue(
      bytes: bytes,
      fileName: picked.name,
    );
    if (!mounted) {
      return;
    }
    _showFeature(context, 'Resident profile photo captured.');
  }

  Future<void> _copyRbiId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('RBI ID copied to clipboard.')));
  }

  Future<void> _addFamilyMember() async {
    final nameController = TextEditingController();
    var relationship = _relationships.first;
    var livingStatus = _livingStatuses.first;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return AlertDialog(
              title: const Text('Add Family Member'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: relationship,
                    decoration: const InputDecoration(labelText: 'Relationship'),
                    items: _relationships
                        .map(
                          (value) =>
                              DropdownMenuItem(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModal(() => relationship = value);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: livingStatus,
                    decoration: const InputDecoration(labelText: 'Living Status'),
                    items: _livingStatuses
                        .map(
                          (value) =>
                              DropdownMenuItem(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModal(() => livingStatus = value);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      _showFeature(dialogContext, 'Family member name is required.');
                      return;
                    }
                    setState(() {
                      _familyMembers = [
                        ..._familyMembers,
                        _ResidentFamilyEntry(
                          name: nameController.text.trim(),
                          relationship: relationship,
                          livingStatus: livingStatus,
                        ),
                      ];
                    });
                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
    nameController.dispose();
  }

  Future<void> _addVehicle() async {
    final plateController = TextEditingController();
    var kind = _vehicleKinds.first;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return AlertDialog(
              title: const Text('Add Vehicle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: kind,
                    decoration: const InputDecoration(labelText: 'Vehicle Kind'),
                    items: _vehicleKinds
                        .map(
                          (value) =>
                              DropdownMenuItem(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModal(() => kind = value);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: plateController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(labelText: 'Plate Number'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (plateController.text.trim().isEmpty) {
                      _showFeature(dialogContext, 'Plate number is required.');
                      return;
                    }
                    setState(() {
                      _vehicles = [
                        ..._vehicles,
                        _ResidentVehicleEntry(
                          kind: kind,
                          plateNumber: plateController.text.trim().toUpperCase(),
                        ),
                      ];
                    });
                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
    plateController.dispose();
  }

  Future<void> _pickBirthDate() async {
    final initial =
        _parsedBirthDate ?? DateTime(DateTime.now().year - 25, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _birthDateController.text = _formatShortDate(picked);
    });
  }

  Future<void> _addVaccinationEntry() async {
    final vaccineController = TextEditingController();
    var doseLabel = '1st Dose';
    var status = 'Completed';
    DateTime administeredAt = DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return AlertDialog(
              title: const Text('Add Vaccination Record'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: vaccineController,
                    decoration: const InputDecoration(labelText: 'Vaccine Name'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: doseLabel,
                    decoration: const InputDecoration(labelText: 'Dose'),
                    items: const [
                      DropdownMenuItem(value: '1st Dose', child: Text('1st Dose')),
                      DropdownMenuItem(value: '2nd Dose', child: Text('2nd Dose')),
                      DropdownMenuItem(value: 'Booster', child: Text('Booster')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setModal(() => doseLabel = value);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                      DropdownMenuItem(value: 'Scheduled', child: Text('Scheduled')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setModal(() => status = value);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Date Administered'),
                    subtitle: Text(_formatShortDate(administeredAt)),
                    trailing: const Icon(Icons.calendar_today_rounded),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: administeredAt,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setModal(() => administeredAt = picked);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (vaccineController.text.trim().isEmpty) {
                      _showFeature(dialogContext, 'Vaccine name is required.');
                      return;
                    }
                    setState(() {
                      _vaccinations = [
                        _ResidentVaccinationEntry(
                          vaccine: vaccineController.text.trim(),
                          doseLabel: doseLabel,
                          administeredAt: administeredAt,
                          status: status,
                        ),
                        ..._vaccinations,
                      ];
                    });
                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
    vaccineController.dispose();
  }

  Future<void> _addNutritionEntry() async {
    final heightController = TextEditingController();
    final weightController = TextEditingController();
    DateTime recordedAt = DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return AlertDialog(
              title: const Text('Add Nutrition Log'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                    ],
                    decoration: const InputDecoration(labelText: 'Height (cm)'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                    ],
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Record Date'),
                    subtitle: Text(_formatShortDate(recordedAt)),
                    trailing: const Icon(Icons.calendar_today_rounded),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: recordedAt,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setModal(() => recordedAt = picked);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final height = double.tryParse(heightController.text.trim());
                    final weight = double.tryParse(weightController.text.trim());
                    if (height == null || height <= 0 || weight == null || weight <= 0) {
                      _showFeature(dialogContext, 'Enter valid height and weight.');
                      return;
                    }
                    setState(() {
                      _nutritionEntries = [
                        _ResidentNutritionEntry(
                          recordedAt: recordedAt,
                          heightCm: height,
                          weightKg: weight,
                        ),
                        ..._nutritionEntries,
                      ];
                    });
                    Navigator.pop(dialogContext);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E35D3),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    heightController.dispose();
    weightController.dispose();
  }

  void _removeFamilyAt(int index) {
    setState(() {
      _familyMembers = [
        for (var i = 0; i < _familyMembers.length; i++)
          if (i != index) _familyMembers[i],
      ];
    });
  }

  void _removeVehicleAt(int index) {
    setState(() {
      _vehicles = [
        for (var i = 0; i < _vehicles.length; i++)
          if (i != index) _vehicles[i],
      ];
    });
  }

  void _removeVaccinationAt(int index) {
    setState(() {
      _vaccinations = [
        for (var i = 0; i < _vaccinations.length; i++)
          if (i != index) _vaccinations[i],
      ];
    });
  }

  void _removeNutritionAt(int index) {
    setState(() {
      _nutritionEntries = [
        for (var i = 0; i < _nutritionEntries.length; i++)
          if (i != index) _nutritionEntries[i],
      ];
    });
  }

  Future<void> _submitRbiProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final birthDate = _parsedBirthDate;
    if (birthDate == null) {
      _showFeature(context, 'Birth date is required.');
      return;
    }

    final fullName = _composeFullName();
    final current = _ResidentRbiStore.current.value;
    if (_ResidentRbiStore.isDuplicateName(fullName, except: current?.fullName)) {
      _showFeature(
        context,
        'A resident with the same full name already exists in the RBI database.',
      );
      return;
    }

    final residencyYear = int.parse(_yearResidencyController.text.trim());
    final now = DateTime.now();
    final id = current?.rbiId ?? _generateRbiId();
    final transactions = [
      const _RbiTransactionEntry(
        title: 'Form Sent',
        date: 'Today',
        status: 'Completed',
      ),
      const _RbiTransactionEntry(
        title: 'Pending Review',
        date: 'Today',
        status: 'Pending',
      ),
    ];

    final record = _ResidentRbiRecord(
      rbiId: id,
      firstName: _firstNameController.text.trim(),
      middleName: _middleNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      suffix: _suffix,
      barangay: _residentBarangay,
      municipality: _residentCity,
      province: _residentProvince,
      streetName: _streetNameController.text.trim(),
      zonePurok: _zonePurokController.text.trim(),
      yearOfResidency: residencyYear,
      birthDate: birthDate,
      gender: _gender,
      disabilityTag: _disabilityTag,
      familyMembers: _familyMembers,
      vehicles: _vehicles,
      vaccinations: _vaccinations,
      nutritionEntries: _nutritionEntries,
      bloodDonorOptIn: _bloodDonorOptIn,
      bloodType: _bloodType,
      educationAidStatus: _educationAidStatus,
      latestGradeAverage: _latestGradeController.text.trim(),
      verificationStep: 1,
      transactions: transactions,
      updatedAt: now,
    );
    _ResidentRbiStore.save(record, previousName: current?.fullName);
    await _syncRecordToBackend(record);
  }

  Future<void> _markVerified() async {
    final current = _ResidentRbiStore.current.value;
    if (current == null || current.verificationStep >= 2) {
      return;
    }
    final verified = current.copyWith(
      verificationStep: 2,
      updatedAt: DateTime.now(),
      transactions: [
        ...current.transactions,
        _RbiTransactionEntry(
          title: 'Verified by Barangay Records Office',
          date: _formatShortDate(DateTime.now()),
          status: 'Completed',
        ),
      ],
    );
    _ResidentRbiStore.save(verified, previousName: current.fullName);
    await _syncRecordToBackend(verified);
  }

  String _formatShortDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildResidentPhoto(double size) {
    return ValueListenableBuilder<_ResidentProfilePhotoValue>(
      valueListenable: _ResidentProfilePhotoStore.photo,
      builder: (context, photo, _) {
        if (photo.bytes != null) {
          return ClipOval(
            child: Image.memory(
              photo.bytes!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          );
        }
        if ((photo.url ?? '').isNotEmpty) {
          return ClipOval(
            child: Image.network(
              photo.url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPhotoPlaceholder(size),
            ),
          );
        }
        return _buildPhotoPlaceholder(size);
      },
    );
  }

  Widget _buildPhotoPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE8ECFA),
      ),
      child: Icon(Icons.person, size: size * 0.52, color: const Color(0xFF6070A8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RBI CARD'),
          backgroundColor: const Color(0xFFF7F8FF),
          bottom: const TabBar(
            indicatorColor: Color(0xFF3D53C8),
            indicatorWeight: 3,
            labelColor: Color(0xFF8B4E46),
            unselectedLabelColor: Color(0xFF616783),
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            tabs: [
              Tab(text: 'My Card'),
              Tab(text: 'Profile'),
              Tab(text: 'Transaction'),
            ],
          ),
        ),
        body: ValueListenableBuilder<int>(
          valueListenable: _ResidentProfileStore.refresh,
          builder: (context, __, ___) {
            final backendProfile = _ResidentProfileStore.profile;
            return ValueListenableBuilder<_ResidentRbiRecord?>(
              valueListenable: _ResidentRbiStore.current,
              builder: (context, record, _) {
                final displayRecord = record ?? _recordFromBackendProfile(backendProfile);
                return TabBarView(
              children: [
                _RbiMyCard(
                  record: displayRecord,
                  onCopyId: displayRecord == null
                      ? null
                      : () => _copyRbiId(displayRecord.rbiId),
                  residentPhoto: _buildResidentPhoto(76),
                  isSaving: _savingToApi,
                  isServerSynced: _serverSynced,
                ),
                _RbiProfileForm(
                  formKey: _formKey,
                  firstNameController: _firstNameController,
                  middleNameController: _middleNameController,
                  lastNameController: _lastNameController,
                  streetNameController: _streetNameController,
                  zonePurokController: _zonePurokController,
                  yearResidencyController: _yearResidencyController,
                  birthDateController: _birthDateController,
                  latestGradeController: _latestGradeController,
                  suffix: _suffix,
                  suffixes: _suffixes,
                  onSuffixChanged: (value) => setState(() => _suffix = value ?? 'N/A'),
                  gender: _gender,
                  genders: _genders,
                  onGenderChanged: (value) =>
                      setState(() => _gender = value ?? _genders.first),
                  onPickBirthDate: _pickBirthDate,
                  disabilityTag: _disabilityTag,
                  disabilityTags: _disabilityTags,
                  onDisabilityTagChanged: (value) => setState(
                    () => _disabilityTag = value ?? _disabilityTags.first,
                  ),
                  familyMembers: _familyMembers,
                  vehicles: _vehicles,
                  vaccinations: _vaccinations,
                  nutritionEntries: _nutritionEntries,
                  residentBarangay: _residentBarangay,
                  residentCity: _residentCity,
                  residentProvince: _residentProvince,
                  residentPhoto: _buildResidentPhoto(68),
                  onCapturePhoto: _captureResidentPhoto,
                  onAddFamilyMember: _addFamilyMember,
                  onRemoveFamilyMember: _removeFamilyAt,
                  onAddVehicle: _addVehicle,
                  onRemoveVehicle: _removeVehicleAt,
                  onAddVaccination: _addVaccinationEntry,
                  onRemoveVaccination: _removeVaccinationAt,
                  onAddNutrition: _addNutritionEntry,
                  onRemoveNutrition: _removeNutritionAt,
                  bloodDonorOptIn: _bloodDonorOptIn,
                  onBloodDonorChanged: (value) =>
                      setState(() => _bloodDonorOptIn = value),
                  bloodType: _bloodType,
                  bloodTypes: _bloodTypes,
                  onBloodTypeChanged: (value) =>
                      setState(() => _bloodType = value ?? _bloodTypes.first),
                  educationAidStatus: _educationAidStatus,
                  educationAidStatuses: _educationAidStatuses,
                  onEducationAidStatusChanged: (value) => setState(
                    () => _educationAidStatus =
                        value ?? _educationAidStatuses.first,
                  ),
                  onSubmit: () {
                    unawaited(_submitRbiProfile());
                  },
                  existingRecord: record,
                ),
                _RbiTransactions(
                  record: displayRecord,
                  onMarkVerified: () {
                    unawaited(_markVerified());
                  },
                ),
              ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  _ResidentRbiRecord? _recordFromBackendProfile(_ResidentProfileData profile) {
    final fallbackName = _residentDisplayName().trim();
    final resolvedName = profile.name.trim().isNotEmpty
        ? profile.name.trim()
        : fallbackName;
    final nameParts = _splitName(resolvedName);
    final hasAnyProfileData =
        resolvedName.isNotEmpty ||
        profile.bloodType.trim().isNotEmpty ||
        _residentBarangay.trim().isNotEmpty;
    if (!hasAnyProfileData) {
      return null;
    }
    final latestNutrition =
        profile.heightCm != null && profile.weightKg != null
        ? <_ResidentNutritionEntry>[
            _ResidentNutritionEntry(
              recordedAt: DateTime.now(),
              heightCm: profile.heightCm!,
              weightKg: profile.weightKg!,
            ),
          ]
        : const <_ResidentNutritionEntry>[];
    final now = DateTime.now();
    return _ResidentRbiRecord(
      rbiId: _residentProfileCode(),
      firstName: nameParts.$1.isNotEmpty ? nameParts.$1 : 'Resident',
      middleName: profile.middleName.trim().isNotEmpty
          ? profile.middleName.trim()
          : nameParts.$2,
      lastName: nameParts.$3,
      suffix: profile.suffix.trim().isNotEmpty ? profile.suffix.trim() : 'N/A',
      barangay: _residentBarangay,
      municipality: _residentCity,
      province: _residentProvince,
      streetName: _streetNameController.text.trim().isNotEmpty
          ? _streetNameController.text.trim()
          : 'Not provided',
      zonePurok: _zonePurokController.text.trim().isNotEmpty
          ? _zonePurokController.text.trim()
          : 'Not provided',
      yearOfResidency: int.tryParse(_yearResidencyController.text.trim()) ??
          (now.year - 5),
      birthDate: _parsedBirthDate ?? DateTime(now.year - 25, 1, 1),
      gender: _gender,
      disabilityTag: _disabilityTag,
      familyMembers: _familyMembers,
      vehicles: _vehicles,
      vaccinations: _vaccinations,
      nutritionEntries: _nutritionEntries.isNotEmpty
          ? _nutritionEntries
          : latestNutrition,
      bloodDonorOptIn: _bloodDonorOptIn,
      bloodType: profile.bloodType.trim().isNotEmpty
          ? profile.bloodType.trim().toUpperCase()
          : _bloodType,
      educationAidStatus: _educationAidStatus,
      latestGradeAverage: _latestGradeController.text.trim(),
      verificationStep: profile.isVerified
          ? 2
          : (profile.profileCompletion > 0 ? 1 : 0),
      transactions: <_RbiTransactionEntry>[
        _RbiTransactionEntry(
          title: profile.isVerified ? 'Profile Verified' : 'Profile Draft',
          date: _formatShortDate(now),
          status: profile.isVerified ? 'Completed' : 'Pending',
        ),
      ],
      updatedAt: now,
    );
  }

  (String, String, String) _splitName(String full) {
    final parts = full
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.trim().isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return ('', '', '');
    }
    if (parts.length == 1) {
      return (parts.first, '', '');
    }
    if (parts.length == 2) {
      return (parts.first, '', parts.last);
    }
    return (
      parts.first,
      parts.sublist(1, parts.length - 1).join(' '),
      parts.last,
    );
  }
}

class _RbiMyCard extends StatelessWidget {
  final _ResidentRbiRecord? record;
  final VoidCallback? onCopyId;
  final Widget residentPhoto;
  final bool isSaving;
  final bool isServerSynced;

  const _RbiMyCard({
    required this.record,
    required this.onCopyId,
    required this.residentPhoto,
    required this.isSaving,
    required this.isServerSynced,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFCF8F8), Color(0xFFF0ECF7)],
              ),
              border: Border.all(color: const Color(0xFFE3E1EC)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: record == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Digital RBI Card',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1F1A22),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Complete the RBI profile form first to generate your resident RBI ID, QR card, and verification status.',
                          style: TextStyle(
                            color: Color(0xFF5A607A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 210,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: const Color(0xFFF4F6FF),
                            border: Border.all(color: const Color(0xFFE1E6FA)),
                          ),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.badge_outlined, size: 54, color: Color(0xFF4A55B8)),
                              SizedBox(height: 10),
                              Text(
                                'RBI card not generated yet',
                                style: TextStyle(
                                  color: Color(0xFF303656),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                record!.fullName,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1F1A22),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: onCopyId,
                              icon: const Icon(Icons.copy_rounded),
                              tooltip: 'Copy RBI ID',
                            ),
                          ],
                        ),
                        Text(
                          record!.rbiId,
                          style: const TextStyle(
                            color: Color(0xFF595569),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isSaving
                                  ? Icons.sync_rounded
                                  : (isServerSynced
                                      ? Icons.cloud_done_rounded
                                      : Icons.cloud_off_rounded),
                              size: 14,
                              color: isSaving
                                  ? const Color(0xFF4A55B8)
                                  : (isServerSynced
                                      ? const Color(0xFF1F8A55)
                                      : const Color(0xFFB1762B)),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isSaving
                                  ? 'Syncing...'
                                  : (isServerSynced ? 'Synced to server' : 'Local only'),
                              style: const TextStyle(
                                color: Color(0xFF5D647E),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFE8ECFF), Color(0xFFF1F4FF)],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFD6DCF8),
                                    width: 3,
                                  ),
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: residentPhoto,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _RbiMiniStat(
                                      label: 'Status',
                                      value: _stepLabel(record!.verificationStep),
                                      icon: record!.verificationStep >= 2
                                          ? Icons.verified
                                          : Icons.timelapse_rounded,
                                    ),
                                    const SizedBox(height: 8),
                                    _RbiMiniStat(
                                      label: 'Address',
                                      value: record!.barangay,
                                      icon: Icons.location_on,
                                    ),
                                    const SizedBox(height: 8),
                                    _RbiMiniStat(
                                      label: 'Age',
                                      value: '${record!.age}',
                                      icon: Icons.cake_outlined,
                                    ),
                                    const SizedBox(height: 8),
                                    _RbiMiniStat(
                                      label: 'Residency Since',
                                      value: '${record!.yearOfResidency}',
                                      icon: Icons.home_work_outlined,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 168,
                              height: 168,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFFE7E7EF)),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: CustomPaint(
                                painter: _RbiQrPainter(record!.rbiId),
                                child: const SizedBox.expand(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Digital RBI Card',
                                    style: TextStyle(
                                      color: Color(0xFF2D3047),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    record!.addressSummary,
                                    style: const TextStyle(
                                      color: Color(0xFF5D647E),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _RbiMiniStat(
                                    label: 'Vehicles',
                                    value: '${record!.vehicles.length}',
                                    icon: Icons.directions_car_filled_outlined,
                                  ),
                                  const SizedBox(height: 8),
                                  _RbiMiniStat(
                                    label: 'Family',
                                    value: '${record!.familyMembers.length}',
                                    icon: Icons.family_restroom_outlined,
                                  ),
                                  const SizedBox(height: 8),
                                  _RbiMiniStat(
                                    label: 'Vaccines',
                                    value: '${record!.vaccinations.length}',
                                    icon: Icons.vaccines_outlined,
                                  ),
                                  const SizedBox(height: 8),
                                  _RbiMiniStat(
                                    label: 'Donor',
                                    value: record!.bloodDonorOptIn
                                        ? record!.bloodType
                                        : 'Not enrolled',
                                    icon: Icons.bloodtype_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE4E8F4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified_user_rounded,
                                color: Color(0xFF3E56C8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Verification: ${_stepLabel(record!.verificationStep)} • Last sync ${_formatLongDate(record!.updatedAt)}',
                                  style: const TextStyle(
                                    color: Color(0xFF59607B),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          onPressed: () =>
                              _showFeature(context, 'Digital RBI card shared.'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2E35D3),
                          ),
                          icon: const Icon(Icons.share),
                          label: const Text('Share Digital Card'),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  static String _stepLabel(int step) {
    switch (step) {
      case 0:
        return 'Form Sent';
      case 1:
        return 'Pending';
      case 2:
        return 'Verified';
      default:
        return 'Pending';
    }
  }

  static String _formatLongDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _ResidentRbiApiResult {
  final bool success;
  final String message;
  final _ResidentRbiRecord? record;

  const _ResidentRbiApiResult({
    required this.success,
    required this.message,
    this.record,
  });
}

class _ResidentRbiApi {
  _ResidentRbiApi._();
  static final instance = _ResidentRbiApi._();

  Future<_ResidentRbiApiResult> fetchMyRecord() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ResidentRbiApiResult(
        success: false,
        message: 'Login required.',
      );
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
            return _ResidentRbiApiResult(
              success: false,
              message: _extractApiMessage(response.body, 'Unable to load RBI record.'),
            );
          }
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          if (decoded is! Map<String, dynamic>) {
            return const _ResidentRbiApiResult(
              success: false,
              message: 'Invalid RBI response.',
            );
          }
          final recordsRaw = decoded['records'];
          if (recordsRaw is List && recordsRaw.isNotEmpty) {
            final first = recordsRaw.first;
            if (first is Map<String, dynamic>) {
              return _ResidentRbiApiResult(
                success: true,
                message: _extractApiMessage(response.body, 'RBI record loaded.'),
                record: _fromApiMap(first),
              );
            }
          }
          final recordRaw = decoded['record'];
          if (recordRaw is Map<String, dynamic>) {
            return _ResidentRbiApiResult(
              success: true,
              message: _extractApiMessage(response.body, 'RBI record loaded.'),
              record: _fromApiMap(recordRaw),
            );
          }
          return _ResidentRbiApiResult(
            success: true,
            message: _extractApiMessage(response.body, 'No RBI record yet.'),
          );
        } on TimeoutException {
          return const _ResidentRbiApiResult(
            success: false,
            message: 'RBI request timed out.',
          );
        } catch (_) {
          return const _ResidentRbiApiResult(
            success: false,
            message: 'Unable to load RBI record.',
          );
        }
      }
    }
    return const _ResidentRbiApiResult(
      success: false,
      message: 'RBI endpoint unavailable.',
    );
  }

  Future<_ResidentRbiApiResult> upsertRecord(_ResidentRbiRecord record) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ResidentRbiApiResult(
        success: false,
        message: 'Login required.',
      );
    }
    final latestBmi = record.latestNutritionEntry?.bmi;
    final payload = jsonEncode({
      'rbi_id': record.rbiId,
      'first_name': record.firstName,
      'middle_name': record.middleName,
      'last_name': record.lastName,
      'suffix': record.suffix == 'N/A' ? '' : record.suffix,
      'province': record.province,
      'city_municipality': record.municipality,
      'barangay': record.barangay,
      'street_name': record.streetName,
      'zone_purok': record.zonePurok,
      'year_of_residency': record.yearOfResidency,
      'birth_date': record.birthDate.toIso8601String().split('T').first,
      'gender': record.gender,
      'disability_tag': record.disabilityTag,
      'blood_donor_opt_in': record.bloodDonorOptIn,
      'blood_type': record.bloodType,
      'education_aid_status': record.educationAidStatus,
      'latest_grade_average': record.latestGradeAverage,
      'family_count': record.familyMembers.length,
      'vehicle_count': record.vehicles.length,
      'vaccination_count': record.vaccinations.length,
      'latest_bmi': latestBmi == null ? null : double.parse(latestBmi.toStringAsFixed(2)),
      'verification_step': record.verificationStep,
    });

    const paths = <String>['rbi/records'];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http.post(
            endpoint,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_authToken',
            },
            body: payload,
          ).timeout(const Duration(seconds: 8));
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode < 200 || response.statusCode >= 300) {
            return _ResidentRbiApiResult(
              success: false,
              message: _extractApiMessage(response.body, 'Unable to save RBI record.'),
            );
          }
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          if (decoded is! Map<String, dynamic>) {
            return const _ResidentRbiApiResult(
              success: false,
              message: 'Invalid RBI save response.',
            );
          }
          final recordRaw = decoded['record'];
          return _ResidentRbiApiResult(
            success: true,
            message: _extractApiMessage(response.body, 'RBI record saved.'),
            record: recordRaw is Map<String, dynamic> ? _fromApiMap(recordRaw) : record,
          );
        } on TimeoutException {
          return const _ResidentRbiApiResult(
            success: false,
            message: 'RBI save timed out.',
          );
        } catch (_) {
          return const _ResidentRbiApiResult(
            success: false,
            message: 'Unable to save RBI record.',
          );
        }
      }
    }

    return const _ResidentRbiApiResult(
      success: false,
      message: 'RBI endpoint unavailable.',
    );
  }

  _ResidentRbiRecord _fromApiMap(Map<String, dynamic> json) {
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
        final lowered = value.trim().toLowerCase();
        return lowered == '1' || lowered == 'true' || lowered == 'yes';
      }
      return fallback;
    }

    DateTime readDate(String key, DateTime fallback) {
      final value = readString(key);
      if (value.isEmpty) return fallback;
      return DateTime.tryParse(value) ?? fallback;
    }

    final firstName = readString('first_name');
    final middleName = readString('middle_name');
    final lastName = readString('last_name');
    final now = DateTime.now();
    final verificationStep = readInt('verification_step', 1).clamp(1, 5);

    return _ResidentRbiRecord(
      rbiId: readString('rbi_id', _residentProfileCode()),
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      suffix: readString('suffix', 'N/A').isEmpty ? 'N/A' : readString('suffix'),
      barangay: readString('barangay', 'West Tapinac'),
      municipality: readString('city_municipality', 'City of Olongapo'),
      province: readString('province', 'Zambales'),
      streetName: readString('street_name', 'Purok 3 Main Road'),
      zonePurok: readString('zone_purok', 'Zone 2'),
      yearOfResidency: readInt('year_of_residency', 2018),
      birthDate: readDate('birth_date', DateTime(1998, 3, 14)),
      gender: readString('gender', 'Prefer not to say'),
      disabilityTag: readString('disability_tag', 'None').isEmpty
          ? 'None'
          : readString('disability_tag'),
      familyMembers: const [],
      vehicles: const [],
      vaccinations: const [],
      nutritionEntries: const [],
      bloodDonorOptIn: readBool('blood_donor_opt_in'),
      bloodType: readString('blood_type', 'O+').isEmpty ? 'O+' : readString('blood_type'),
      educationAidStatus: readString('education_aid_status', 'Not Enrolled').isEmpty
          ? 'Not Enrolled'
          : readString('education_aid_status'),
      latestGradeAverage: readString('latest_grade_average'),
      verificationStep: verificationStep,
      transactions: verificationStep >= 2
          ? const <_RbiTransactionEntry>[
              _RbiTransactionEntry(
                title: 'Form Sent',
                date: 'Synced',
                status: 'Completed',
              ),
              _RbiTransactionEntry(
                title: 'Verified by Barangay Records Office',
                date: 'Synced',
                status: 'Completed',
              ),
            ]
          : const <_RbiTransactionEntry>[
              _RbiTransactionEntry(
                title: 'Form Sent',
                date: 'Synced',
                status: 'Completed',
              ),
              _RbiTransactionEntry(
                title: 'Pending Review',
                date: 'In Queue',
                status: 'Pending',
              ),
            ],
      updatedAt: readDate('updated_at', now),
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

class _RbiProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final TextEditingController lastNameController;
  final TextEditingController streetNameController;
  final TextEditingController zonePurokController;
  final TextEditingController yearResidencyController;
  final TextEditingController birthDateController;
  final TextEditingController latestGradeController;
  final String suffix;
  final List<String> suffixes;
  final ValueChanged<String?> onSuffixChanged;
  final String gender;
  final List<String> genders;
  final ValueChanged<String?> onGenderChanged;
  final Future<void> Function() onPickBirthDate;
  final String disabilityTag;
  final List<String> disabilityTags;
  final ValueChanged<String?> onDisabilityTagChanged;
  final List<_ResidentFamilyEntry> familyMembers;
  final List<_ResidentVehicleEntry> vehicles;
  final List<_ResidentVaccinationEntry> vaccinations;
  final List<_ResidentNutritionEntry> nutritionEntries;
  final String residentBarangay;
  final String residentCity;
  final String residentProvince;
  final Widget residentPhoto;
  final Future<void> Function() onCapturePhoto;
  final Future<void> Function() onAddFamilyMember;
  final void Function(int index) onRemoveFamilyMember;
  final Future<void> Function() onAddVehicle;
  final void Function(int index) onRemoveVehicle;
  final Future<void> Function() onAddVaccination;
  final void Function(int index) onRemoveVaccination;
  final Future<void> Function() onAddNutrition;
  final void Function(int index) onRemoveNutrition;
  final bool bloodDonorOptIn;
  final ValueChanged<bool> onBloodDonorChanged;
  final String bloodType;
  final List<String> bloodTypes;
  final ValueChanged<String?> onBloodTypeChanged;
  final String educationAidStatus;
  final List<String> educationAidStatuses;
  final ValueChanged<String?> onEducationAidStatusChanged;
  final VoidCallback onSubmit;
  final _ResidentRbiRecord? existingRecord;

  const _RbiProfileForm({
    required this.formKey,
    required this.firstNameController,
    required this.middleNameController,
    required this.lastNameController,
    required this.streetNameController,
    required this.zonePurokController,
    required this.yearResidencyController,
    required this.birthDateController,
    required this.latestGradeController,
    required this.suffix,
    required this.suffixes,
    required this.onSuffixChanged,
    required this.gender,
    required this.genders,
    required this.onGenderChanged,
    required this.onPickBirthDate,
    required this.disabilityTag,
    required this.disabilityTags,
    required this.onDisabilityTagChanged,
    required this.familyMembers,
    required this.vehicles,
    required this.vaccinations,
    required this.nutritionEntries,
    required this.residentBarangay,
    required this.residentCity,
    required this.residentProvince,
    required this.residentPhoto,
    required this.onCapturePhoto,
    required this.onAddFamilyMember,
    required this.onRemoveFamilyMember,
    required this.onAddVehicle,
    required this.onRemoveVehicle,
    required this.onAddVaccination,
    required this.onRemoveVaccination,
    required this.onAddNutrition,
    required this.onRemoveNutrition,
    required this.bloodDonorOptIn,
    required this.onBloodDonorChanged,
    required this.bloodType,
    required this.bloodTypes,
    required this.onBloodTypeChanged,
    required this.educationAidStatus,
    required this.educationAidStatuses,
    required this.onEducationAidStatusChanged,
    required this.onSubmit,
    required this.existingRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F8FF), Color(0xFFF8F0EE)],
        ),
      ),
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          children: [
            _RbiSectionCard(
              title: 'Personal Information',
              icon: Icons.badge_outlined,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFDCE2F5),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: residentPhoto,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Resident Profile Photo',
                              style: TextStyle(
                                color: Color(0xFF2E3045),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Capture a live profile photo for RBI verification.',
                              style: TextStyle(
                                color: Color(0xFF676C86),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FilledButton.icon(
                              onPressed: onCapturePhoto,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF2E35D3),
                              ),
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: const Text('Open Camera'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: middleNameController,
                    decoration: const InputDecoration(labelText: 'Middle Name'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: suffix,
                    decoration: const InputDecoration(labelText: 'Suffix'),
                    items: suffixes
                        .map(
                          (value) =>
                              DropdownMenuItem(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: onSuffixChanged,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: birthDateController,
                    readOnly: true,
                    onTap: onPickBirthDate,
                    decoration: const InputDecoration(
                      labelText: 'Birth Date',
                      suffixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Birth date is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: gender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: genders
                        .map(
                          (value) =>
                              DropdownMenuItem(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: onGenderChanged,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: disabilityTag,
                    decoration: const InputDecoration(
                      labelText: 'PWD / Disability Tag',
                    ),
                    items: disabilityTags
                        .map(
                          (value) =>
                              DropdownMenuItem(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: onDisabilityTagChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _RbiSectionCard(
              title: 'Address Verification',
              icon: Icons.home_work_outlined,
              child: Column(
                children: [
                  _RbiStaticInfoRow(
                    label: 'Barangay',
                    value: residentBarangay,
                    icon: Icons.location_city_outlined,
                  ),
                  _RbiStaticInfoRow(
                    label: 'Municipality / City',
                    value: residentCity,
                    icon: Icons.place_outlined,
                  ),
                  _RbiStaticInfoRow(
                    label: 'Province',
                    value: residentProvince,
                    icon: Icons.map_outlined,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: streetNameController,
                    decoration: const InputDecoration(labelText: 'Street Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Street name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: zonePurokController,
                    decoration: const InputDecoration(labelText: 'Zone / Purok'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Zone / Purok is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: yearResidencyController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Year of Residency'),
                    validator: (value) {
                      final parsed = int.tryParse(value?.trim() ?? '');
                      if (parsed == null) {
                        return 'Year of residency is required.';
                      }
                      if (parsed < 1900 || parsed > DateTime.now().year) {
                        return 'Enter a valid year of residency.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _RbiSectionCard(
              title: 'Family Information',
              icon: Icons.family_restroom_outlined,
              trailing: TextButton.icon(
                onPressed: onAddFamilyMember,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
              child: familyMembers.isEmpty
                  ? const Text(
                      'No family members added yet.',
                      style: TextStyle(
                        color: Color(0xFF676C86),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Relationship')),
                          DataColumn(label: Text('Living Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: [
                          for (var i = 0; i < familyMembers.length; i++)
                            DataRow(
                              cells: [
                                DataCell(Text(familyMembers[i].name)),
                                DataCell(Text(familyMembers[i].relationship)),
                                DataCell(Text(familyMembers[i].livingStatus)),
                                DataCell(
                                  IconButton(
                                    onPressed: () => onRemoveFamilyMember(i),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            _RbiSectionCard(
              title: 'Vehicle Details',
              icon: Icons.directions_car_filled_outlined,
              trailing: TextButton.icon(
                onPressed: onAddVehicle,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
              child: vehicles.isEmpty
                  ? const Text(
                      'No vehicle records added yet.',
                      style: TextStyle(
                        color: Color(0xFF676C86),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Column(
                      children: [
                        for (var i = 0; i < vehicles.length; i++)
                          Container(
                            margin: EdgeInsets.only(
                              bottom: i == vehicles.length - 1 ? 0 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFF),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE5E8F4)),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.local_shipping_outlined,
                                color: Color(0xFF4A55B8),
                              ),
                              title: Text(
                                vehicles[i].kind,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(vehicles[i].plateNumber),
                              trailing: IconButton(
                                onPressed: () => onRemoveVehicle(i),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            _RbiSectionCard(
              title: 'Vaccination Tracker',
              icon: Icons.vaccines_outlined,
              trailing: TextButton.icon(
                onPressed: onAddVaccination,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
              child: vaccinations.isEmpty
                  ? const Text(
                      'No vaccination records added yet.',
                      style: TextStyle(
                        color: Color(0xFF676C86),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Column(
                      children: [
                        for (var i = 0; i < vaccinations.length; i++)
                          Container(
                            margin: EdgeInsets.only(
                              bottom: i == vaccinations.length - 1 ? 0 : 8,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFF),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE5E8F4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.health_and_safety_outlined,
                                  color: Color(0xFF4A55B8),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${vaccinations[i].vaccine} - ${vaccinations[i].doseLabel}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF2E3045),
                                        ),
                                      ),
                                      Text(
                                        '${vaccinations[i].status} - ${_formatShortDate(vaccinations[i].administeredAt)}',
                                        style: const TextStyle(
                                          color: Color(0xFF676C86),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => onRemoveVaccination(i),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            _RbiSectionCard(
              title: 'Nutrition Monitoring',
              icon: Icons.monitor_weight_outlined,
              trailing: TextButton.icon(
                onPressed: onAddNutrition,
                icon: const Icon(Icons.add),
                label: const Text('Log'),
              ),
              child: nutritionEntries.isEmpty
                  ? const Text(
                      'No height and weight logs yet.',
                      style: TextStyle(
                        color: Color(0xFF676C86),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Column(
                      children: [
                        for (var i = 0; i < nutritionEntries.length; i++)
                          Container(
                            margin: EdgeInsets.only(
                              bottom: i == nutritionEntries.length - 1 ? 0 : 8,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFF),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE5E8F4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.straighten_rounded,
                                  color: Color(0xFF4A55B8),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Height ${nutritionEntries[i].heightCm.toStringAsFixed(1)} cm - Weight ${nutritionEntries[i].weightKg.toStringAsFixed(1)} kg',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF2E3045),
                                        ),
                                      ),
                                      Text(
                                        'BMI ${nutritionEntries[i].bmi.toStringAsFixed(1)} - ${_formatShortDate(nutritionEntries[i].recordedAt)}',
                                        style: const TextStyle(
                                          color: Color(0xFF676C86),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => onRemoveNutrition(i),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            _RbiSectionCard(
              title: 'Health and Assistance Tags',
              icon: Icons.favorite_border_rounded,
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: bloodDonorOptIn,
                    onChanged: onBloodDonorChanged,
                    title: const Text(
                      'Include me in the blood donor directory',
                      style: TextStyle(
                        color: Color(0xFF2E3045),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: const Text(
                      'Opt in so responders can contact you during emergencies.',
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: bloodType,
                    decoration: const InputDecoration(labelText: 'Blood Type'),
                    items: bloodTypes
                        .map(
                          (value) =>
                              DropdownMenuItem(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: onBloodTypeChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _RbiSectionCard(
              title: 'Education Aid Tracking',
              icon: Icons.school_outlined,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: educationAidStatus,
                    decoration: const InputDecoration(
                      labelText: 'Education Aid Status',
                    ),
                    items: educationAidStatuses
                        .map(
                          (value) =>
                              DropdownMenuItem(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: onEducationAidStatusChanged,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: latestGradeController,
                    decoration: const InputDecoration(
                      labelText: 'Latest Grade / GWA',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2E35D3),
                minimumSize: const Size.fromHeight(48),
              ),
              icon: const Icon(Icons.send_outlined),
              label: Text(
                existingRecord == null ? 'Submit RBI Form' : 'Update RBI Form',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RbiTransactions extends StatelessWidget {
  final _ResidentRbiRecord? record;
  final VoidCallback onMarkVerified;

  const _RbiTransactions({
    required this.record,
    required this.onMarkVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3F4EC8), Color(0xFF7181F2)],
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0x33FFFFFF),
                  child: Icon(Icons.history_rounded, color: Colors.white),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Track every RBI submission, review, and verification event in one place.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _RbiSectionCard(
            title: 'Verification Status',
            icon: Icons.rule_folder_outlined,
            child: Column(
              children: [
                Stepper(
                  currentStep: record?.verificationStep ?? 0,
                  controlsBuilder: (_, __) => const SizedBox.shrink(),
                  physics: const NeverScrollableScrollPhysics(),
                  steps: const [
                    Step(
                      title: Text('Form Sent'),
                      content: Text('Your RBI form has been submitted.'),
                      isActive: true,
                    ),
                    Step(
                      title: Text('Pending'),
                      content: Text('Barangay records office is reviewing the submission.'),
                      isActive: true,
                    ),
                    Step(
                      title: Text('Verified'),
                      content: Text('RBI profile has been approved and verified.'),
                      isActive: true,
                    ),
                  ],
                ),
                if (record != null && record!.verificationStep < 2)
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: onMarkVerified,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E35D3),
                      ),
                      child: const Text('Mark Verified'),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (record == null)
            const _RbiTxnCard(
              title: 'RBI form not submitted',
              date: 'Waiting for submission',
              status: 'Draft',
            )
          else ...[
            for (final entry in record!.transactions)
              _RbiTxnCard(
                title: entry.title,
                date: entry.date,
                status: entry.status,
              ),
          ],
        ],
      ),
    );
  }
}

class _RbiSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _RbiSectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E8F4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE4E8FF), Color(0xFFF2F4FF)],
                  ),
                ),
                child: Icon(icon, color: const Color(0xFF4A55B8)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E3045),
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _RbiStaticInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _RbiStaticInfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E8F4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A55B8), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF676C86),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF2E3045),
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

int _residentAgeFromBirthDate(DateTime birthDate) {
  final now = DateTime.now();
  var age = now.year - birthDate.year;
  final birthdayThisYear = DateTime(now.year, birthDate.month, birthDate.day);
  if (birthdayThisYear.isAfter(now)) {
    age--;
  }
  return age;
}

DateTime? _tryParseShortDate(String value) {
  if (value.trim().isEmpty) {
    return null;
  }
  final parts = value.trim().split(RegExp(r'\s+'));
  if (parts.length < 3) {
    return null;
  }
  const months = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };
  final month = months[parts[0]];
  final day = int.tryParse(parts[1].replaceAll(',', ''));
  final year = int.tryParse(parts[2]);
  if (month == null || day == null || year == null) {
    return null;
  }
  return DateTime(year, month, day);
}

String _formatShortDate(DateTime date) {
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
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

class _RbiMiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _RbiMiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E7F2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: const Color(0xFF4A55B8)),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF646A86),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3047),
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

class _RbiTxnCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;

  const _RbiTxnCard({
    required this.title,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = status.toLowerCase() == 'completed';
    final isPending = status.toLowerCase() == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE6E8F4)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE4E8FF),
            child: Icon(Icons.receipt_long, color: Color(0xFF4A55B8)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E3045),
                  ),
                ),
                Text(date, style: const TextStyle(color: Color(0xFF676C86))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFFE8F8EE)
                  : isPending
                  ? const Color(0xFFFFF1DE)
                  : const Color(0xFFF0F1F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isDone
                    ? const Color(0xFF2D8E55)
                    : isPending
                    ? const Color(0xFFB46A0F)
                    : const Color(0xFF6A7088),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RbiQrPainter extends CustomPainter {
  final String data;

  const _RbiQrPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF23263A);
    final background = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, background);

    const grid = 21;
    final cell = size.width / grid;
    final random = math.Random(data.hashCode);

    for (var row = 0; row < grid; row++) {
      for (var col = 0; col < grid; col++) {
        final inFinder = (row < 5 && col < 5) ||
            (row < 5 && col > grid - 6) ||
            (row > grid - 6 && col < 5);
        final shouldFill = inFinder || random.nextBool();
        if (!shouldFill) {
          continue;
        }
        canvas.drawRect(
          Rect.fromLTWH(col * cell, row * cell, cell - 0.5, cell - 0.5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RbiQrPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
