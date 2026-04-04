part of barangaymo_app;

class _ResidentTalentPostData {
  final String profileId;
  final String userId;
  final String fullName;
  final String mobileNumber;
  final String desiredJob;
  final String skills;
  final String preferredSetup;
  final String expectedSalary;
  final String barangayZone;
  final bool availableNow;

  const _ResidentTalentPostData({
    this.profileId = '',
    this.userId = '',
    required this.fullName,
    this.mobileNumber = '',
    required this.desiredJob,
    required this.skills,
    required this.preferredSetup,
    required this.expectedSalary,
    required this.barangayZone,
    this.availableNow = true,
  });
}

class _ResidentJobNotificationData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final DateTime createdAt;
  bool unread;

  _ResidentJobNotificationData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.createdAt,
    this.unread = true,
  });
}

class _ResidentJobApplicationData {
  final String id;
  final String jobId;
  final String jobTitle;
  final String company;
  final String postedBy;
  final String applicantName;
  final String mobileNumber;
  final String coverLetter;
  final String attachmentName;
  final String attachmentPath;
  final String attachmentBase64;
  final DateTime submittedAt;
  final String status;

  const _ResidentJobApplicationData({
    this.id = '',
    this.jobId = '',
    required this.jobTitle,
    required this.company,
    this.postedBy = '',
    required this.applicantName,
    required this.mobileNumber,
    required this.coverLetter,
    required this.attachmentName,
    this.attachmentPath = '',
    this.attachmentBase64 = '',
    required this.submittedAt,
    this.status = 'Submitted',
  });
}

class _ResidentJobInvitationData {
  final String id;
  final String inviterUserId;
  final String talentUserId;
  final String talentProfileId;
  final String talentName;
  final String talentMobile;
  final String talentDesiredJob;
  final String inviterName;
  final String inviterMobile;
  final String message;
  final DateTime createdAt;
  final String status;

  const _ResidentJobInvitationData({
    required this.id,
    this.inviterUserId = '',
    this.talentUserId = '',
    this.talentProfileId = '',
    required this.talentName,
    required this.talentMobile,
    required this.talentDesiredJob,
    required this.inviterName,
    required this.inviterMobile,
    required this.message,
    required this.createdAt,
    this.status = 'Pending',
  });
}

class _ResidentCommercialRegistrationData {
  final String id;
  final String businessName;
  final String ownerName;
  final String businessType;
  final String contactNumber;
  final String address;
  final String meetupSpot;
  final String businessPermitNumber;
  final String businessPermitFileName;
  final bool merchantVerified;
  final String verificationStatus;

  const _ResidentCommercialRegistrationData({
    this.id = '',
    required this.businessName,
    required this.ownerName,
    required this.businessType,
    required this.contactNumber,
    required this.address,
    required this.meetupSpot,
    required this.businessPermitNumber,
    required this.businessPermitFileName,
    this.merchantVerified = false,
    this.verificationStatus = 'Pending Review',
  });
}

class _ResidentMarketplaceBannerData {
  final String title;
  final String subtitle;
  final Color start;
  final Color end;
  final String? attachmentName;

  const _ResidentMarketplaceBannerData({
    required this.title,
    required this.subtitle,
    required this.start,
    required this.end,
    this.attachmentName,
  });
}

class _ResidentMerchantFeedbackData {
  final String sellerName;
  final String authorName;
  final int stars;
  final String comment;
  final DateTime createdAt;

  const _ResidentMerchantFeedbackData({
    required this.sellerName,
    required this.authorName,
    required this.stars,
    required this.comment,
    required this.createdAt,
  });
}

class _ResidentBarangayQuoteData {
  final String id;
  final String productTitle;
  final String sellerName;
  final String contactNumber;
  final double offerAmount;
  final String note;
  final DateTime createdAt;
  final String status;

  const _ResidentBarangayQuoteData({
    required this.id,
    required this.productTitle,
    required this.sellerName,
    required this.contactNumber,
    required this.offerAmount,
    required this.note,
    required this.createdAt,
    this.status = 'Submitted',
  });
}

const _merchantDefaultCategories = <String>[
  'Electronics',
  'Furniture',
  'Emergency',
  'Retail',
  'Food',
  'Services',
];

const _marketDeliveryZones = <String>[
  'Zone 1',
  'Zone 2',
  'Zone 3',
  'Zone 4',
  'Zone 5',
];

const _marketDeliveryPuroks = <String>[
  'Purok 1',
  'Purok 2',
  'Purok 3',
  'Purok 4',
];

double _marketDeliveryFeeFor(
  String fulfillment,
  String zone,
  String purok,
) {
  if (fulfillment == 'Pickup at Brgy Hall') {
    return 0;
  }
  final zoneIndex = _marketDeliveryZones.indexOf(zone);
  final purokIndex = _marketDeliveryPuroks.indexOf(purok);
  final safeZone = zoneIndex < 0 ? 0 : zoneIndex;
  final safePurok = purokIndex < 0 ? 0 : purokIndex;
  return 35 + (safeZone * 10) + (safePurok * 5);
}

class _ResidentCommercialSellerHub {
  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  static _ResidentCommercialRegistrationData? registration;
  static final List<_ResidentProductData> inventoryProducts = [];
  static final List<String> managedCategories = [..._merchantDefaultCategories];
  static final List<_ResidentMarketplaceBannerData> banners = [
    const _ResidentMarketplaceBannerData(
      title: 'Seller Boost Week',
      subtitle: 'Launch your products and get featured placement today.',
      start: Color(0xFF2F42BA),
      end: Color(0xFF6077EF),
    ),
  ];
  static final List<_ResidentMerchantFeedbackData> feedback = [
    _ResidentMerchantFeedbackData(
      sellerName: 'L. Nadong Electronics',
      authorName: 'Resident Buyer',
      stars: 5,
      comment: 'Fast meetup and responsive seller.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    _ResidentMerchantFeedbackData(
      sellerName: 'Cabalan Office Depot',
      authorName: 'Barangay Admin Desk',
      stars: 4,
      comment: 'Printer was delivered with complete supplies.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];
  static final List<_ResidentBarangayQuoteData> bidRequests = [];

  static bool get hasBusinessRegistration => registration != null;

  static void _emit() => refresh.value++;

  static void registerBusiness(_ResidentCommercialRegistrationData data) {
    registration = data;
    _emit();
  }

  static void replaceBusinessRegistration(_ResidentCommercialRegistrationData? data) {
    registration = data;
    _emit();
  }

  static double ratingForSeller(String sellerName, {double fallback = 4.8}) {
    final items = feedback.where((item) => item.sellerName == sellerName).toList();
    if (items.isEmpty) {
      return fallback;
    }
    final total = items.fold<int>(0, (sum, item) => sum + item.stars);
    return total / items.length;
  }

  static int feedbackCountForSeller(String sellerName, {int fallback = 0}) {
    final count = feedback.where((item) => item.sellerName == sellerName).length;
    return count == 0 ? fallback : count;
  }

  static int salesCountForSeller(String sellerName) {
    var total = 0;
    for (final product in inventoryProducts.where((item) => item.seller == sellerName)) {
      total += product.sold;
    }
    return total;
  }

  static double salesValueForSeller(String sellerName) {
    var total = 0.0;
    for (final product in inventoryProducts.where((item) => item.seller == sellerName)) {
      total += product.price * product.sold;
    }
    return total;
  }

  static int orderCountForSeller(String sellerName) {
    var total = 0;
    for (final order in _ResidentCartHub.orders) {
      if (order.items.any((item) => item.seller == sellerName)) {
        total++;
      }
    }
    return total;
  }

  static void addCategory(String category) {
    final clean = category.trim();
    if (clean.isEmpty || managedCategories.contains(clean)) {
      return;
    }
    managedCategories.add(clean);
    _emit();
  }

  static void removeCategory(String category) {
    if (_merchantDefaultCategories.contains(category)) {
      return;
    }
    managedCategories.remove(category);
    _emit();
  }

  static void addBanner(_ResidentMarketplaceBannerData banner) {
    banners.insert(0, banner);
    _emit();
  }

  static void removeBanner(int index) {
    if (index < 0 || index >= banners.length) {
      return;
    }
    if (banners.length == 1) {
      return;
    }
    banners.removeAt(index);
    _emit();
  }

  static void addFeedback(_ResidentMerchantFeedbackData entry) {
    feedback.insert(0, entry);
    _emit();
  }

  static void addBidRequest(_ResidentBarangayQuoteData bid) {
    bidRequests.insert(0, bid);
    _emit();
  }

  static void saveInventoryProduct(
    _ResidentProductData product, {
    int? editIndex,
  }) {
    if (editIndex != null &&
        editIndex >= 0 &&
        editIndex < inventoryProducts.length) {
      inventoryProducts[editIndex] = product;
    } else {
      inventoryProducts.insert(0, product);
    }
    _emit();
  }

  static void deleteInventoryProduct(int index) {
    if (index < 0 || index >= inventoryProducts.length) {
      return;
    }
    inventoryProducts.removeAt(index);
    _emit();
  }

  static void replaceInventoryProducts(List<_ResidentProductData> incoming) {
    inventoryProducts
      ..clear()
      ..addAll(incoming);
    _emit();
  }
}

String _residentJobKey(_ResidentJobData job) {
  final id = job.id.trim();
  if (id.isNotEmpty) {
    return 'id:$id';
  }
  return '${job.title}|${job.company}';
}

String _merchantProductAsset(String category) {
  final normalized = category.trim().toLowerCase();
  if (normalized.contains('furn') || normalized.contains('table')) {
    return 'public/item-table.jpg';
  }
  if (normalized.contains('emerg') || normalized.contains('bag')) {
    return 'public/item-gobag.jpg';
  }
  if (normalized.contains('print')) {
    return 'public/item-printer.jpg';
  }
  return 'public/item-laptop.jpg';
}

IconData _merchantProductIcon(String category) {
  final normalized = category.trim().toLowerCase();
  if (normalized.contains('furn') || normalized.contains('table')) {
    return Icons.table_restaurant;
  }
  if (normalized.contains('print')) {
    return Icons.print;
  }
  if (normalized.contains('emerg') || normalized.contains('bag')) {
    return Icons.backpack;
  }
  if (normalized.contains('food') || normalized.contains('grocery')) {
    return Icons.storefront_rounded;
  }
  return Icons.inventory_2_rounded;
}

class _ResidentJobsHub {
  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  static const String _savedJobsStoragePrefix = 'resident_saved_jobs_v1_';
  static const String _applicationsStoragePrefix = 'resident_job_apps_v1_';
  static const String _globalApplicationsStorageKey = 'resident_job_apps_global_v1';
  static const String _ownedJobsStoragePrefix = 'resident_owned_jobs_v1_';
  static const String _globalInvitationsStorageKey = 'resident_job_invites_global_v1';

  static final List<_ResidentJobData> jobs = [];

  static final List<_ResidentTalentPostData> talents = [];

  static final List<_ResidentJobNotificationData> notifications = [
    _ResidentJobNotificationData(
      title: 'Jobs board is active',
      subtitle: 'You can now post hiring needs or job hunter profiles.',
      icon: Icons.campaign_rounded,
      accent: const Color(0xFF4A64FF),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      unread: false,
    ),
  ];

  static final Set<String> savedJobKeys = <String>{};
  static final Set<String> ownedJobKeys = <String>{};
  static final List<_ResidentJobData> _savedJobs = [];
  static final List<_ResidentJobApplicationData> applications = [];
  static final List<_ResidentJobApplicationData> _allApplications = [];
  static final List<_ResidentJobInvitationData> _allInvitations = [];

  static String _savedJobsStorageKey() {
    final mobile = _normalizeMobileForKey(_currentResidentProfile?.mobile ?? '');
    return '$_savedJobsStoragePrefix${mobile.isEmpty ? 'guest' : mobile}';
  }

  static String _applicationsStorageKey() {
    final mobile = _normalizeMobileForKey(_currentResidentProfile?.mobile ?? '');
    return '$_applicationsStoragePrefix${mobile.isEmpty ? 'guest' : mobile}';
  }

  static String _ownedJobsStorageKey() {
    final mobile = _normalizeMobileForKey(_currentResidentProfile?.mobile ?? '');
    return '$_ownedJobsStoragePrefix${mobile.isEmpty ? 'guest' : mobile}';
  }

  static String _applicationUniqueKey(_ResidentJobApplicationData application) {
    return '${application.jobTitle}|${application.company}|${application.mobileNumber}|${application.submittedAt.millisecondsSinceEpoch}';
  }

  static String _normalizedIdentityName(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static Map<String, dynamic> _jobToJson(_ResidentJobData job) {
    return <String, dynamic>{
      'id': job.id,
      'title': job.title,
      'company': job.company,
      'location': job.location,
      'salary': job.salary,
      'schedule': job.schedule,
      'urgent': job.urgent,
      'posted_by': job.postedBy,
      'requirements': job.requirements,
    };
  }

  static _ResidentJobData? _jobFromJson(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }
    String read(String key) {
      final value = raw[key];
      return value is String ? value.trim() : '';
    }

    final title = read('title');
    final company = read('company');
    if (title.isEmpty || company.isEmpty) {
      return null;
    }
    return _ResidentJobData(
      id: read('id'),
      title: title,
      company: company,
      location: read('location'),
      salary: read('salary'),
      schedule: read('schedule'),
      urgent: raw['urgent'] == true || raw['urgent'] == 1 || raw['urgent'] == '1',
      postedBy: read('posted_by'),
      requirements: read('requirements'),
    );
  }

  static Future<void> loadSavedJobsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_savedJobsStorageKey());
    final loaded = <_ResidentJobData>[];
    final keys = <String>{};

    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final item in decoded) {
            final job = _jobFromJson(item);
            if (job == null) {
              continue;
            }
            final key = _residentJobKey(job);
            if (keys.add(key)) {
              loaded.add(job);
            }
          }
        }
      } catch (_) {}
    }

    _savedJobs
      ..clear()
      ..addAll(loaded);
    savedJobKeys
      ..clear()
      ..addAll(keys);
    _emit();
  }

  static Future<void> _persistSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(_savedJobs.map(_jobToJson).toList());
    await prefs.setString(_savedJobsStorageKey(), payload);
  }

  static Map<String, dynamic> _applicationToJson(
    _ResidentJobApplicationData application,
  ) {
    return <String, dynamic>{
      'id': application.id,
      'job_id': application.jobId,
      'job_title': application.jobTitle,
      'company': application.company,
      'posted_by': application.postedBy,
      'applicant_name': application.applicantName,
      'mobile_number': application.mobileNumber,
      'cover_letter': application.coverLetter,
      'attachment_name': application.attachmentName,
      'attachment_path': application.attachmentPath,
      'attachment_base64': application.attachmentBase64,
      'submitted_at': application.submittedAt.toIso8601String(),
      'status': application.status,
    };
  }

  static _ResidentJobApplicationData? _applicationFromJson(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }

    String read(String key) {
      final value = raw[key];
      return value is String ? value.trim() : '';
    }

    final title = read('job_title');
    final company = read('company');
    if (title.isEmpty || company.isEmpty) {
      return null;
    }

    final submittedRaw = read('submitted_at');
    final submittedAt =
        DateTime.tryParse(submittedRaw) ??
        DateTime.now().subtract(const Duration(seconds: 1));

    return _ResidentJobApplicationData(
      id: read('id'),
      jobId: read('job_id'),
      jobTitle: title,
      company: company,
      postedBy: read('posted_by'),
      applicantName: read('applicant_name'),
      mobileNumber: read('mobile_number'),
      coverLetter: read('cover_letter'),
      attachmentName: read('attachment_name'),
      attachmentPath: read('attachment_path'),
      attachmentBase64: read('attachment_base64'),
      submittedAt: submittedAt,
      status: read('status').isEmpty ? 'Submitted' : read('status'),
    );
  }

  static Future<void> loadApplicationsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final loaded = <_ResidentJobApplicationData>[];
    final loadedGlobal = <_ResidentJobApplicationData>[];
    final personalRaw = prefs.getString(_applicationsStorageKey());
    final globalRaw = prefs.getString(_globalApplicationsStorageKey);

    void parseInto(
      String? raw,
      List<_ResidentJobApplicationData> target, {
      bool allowMultiplePerJob = false,
    }) {
      if (raw == null || raw.isEmpty) {
        return;
      }
      try {
        final decoded = jsonDecode(raw);
        if (decoded is! List) {
          return;
        }
        final keys = <String>{};
        for (final item in decoded) {
          final application = _applicationFromJson(item);
          if (application == null) {
            continue;
          }
          final key = allowMultiplePerJob
              ? _applicationUniqueKey(application)
              : '${application.jobTitle}|${application.company}';
          if (!keys.add(key)) {
            continue;
          }
          target.add(application);
        }
      } catch (_) {}
    }

    parseInto(personalRaw, loaded);
    parseInto(globalRaw, loadedGlobal, allowMultiplePerJob: true);
    applications
      ..clear()
      ..addAll(loaded);
    _allApplications
      ..clear()
      ..addAll(loadedGlobal);
    _emit();
  }

  static Future<void> _persistApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(applications.map(_applicationToJson).toList());
    await prefs.setString(_applicationsStorageKey(), payload);
  }

  static Future<void> _persistGlobalApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(_allApplications.map(_applicationToJson).toList());
    await prefs.setString(_globalApplicationsStorageKey, payload);
  }

  static Future<void> loadOwnedJobsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_ownedJobsStorageKey()) ?? const <String>[];
    ownedJobKeys
      ..clear()
      ..addAll(values.where((item) => item.trim().isNotEmpty));
    _emit();
  }

  static Future<void> _persistOwnedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_ownedJobsStorageKey(), ownedJobKeys.toList());
  }

  static Map<String, dynamic> _invitationToJson(_ResidentJobInvitationData invite) {
    return <String, dynamic>{
      'id': invite.id,
      'inviter_user_id': invite.inviterUserId,
      'talent_user_id': invite.talentUserId,
      'talent_profile_id': invite.talentProfileId,
      'talent_name': invite.talentName,
      'talent_mobile': invite.talentMobile,
      'talent_desired_job': invite.talentDesiredJob,
      'inviter_name': invite.inviterName,
      'inviter_mobile': invite.inviterMobile,
      'message': invite.message,
      'created_at': invite.createdAt.toIso8601String(),
      'status': invite.status,
    };
  }

  static _ResidentJobInvitationData? _invitationFromJson(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }
    String read(String key) {
      final value = raw[key];
      return value is String ? value.trim() : '';
    }
    final id = read('id');
    final talentName = read('talent_name');
    if (id.isEmpty || talentName.isEmpty) {
      return null;
    }
    final createdAt = DateTime.tryParse(read('created_at')) ?? DateTime.now();
    return _ResidentJobInvitationData(
      id: id,
      inviterUserId: read('inviter_user_id'),
      talentUserId: read('talent_user_id'),
      talentProfileId: read('talent_profile_id'),
      talentName: talentName,
      talentMobile: read('talent_mobile'),
      talentDesiredJob: read('talent_desired_job'),
      inviterName: read('inviter_name'),
      inviterMobile: read('inviter_mobile'),
      message: read('message'),
      createdAt: createdAt,
      status: read('status').isEmpty ? 'Pending' : read('status'),
    );
  }

  static Future<void> loadInvitationsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_globalInvitationsStorageKey);
    final loaded = <_ResidentJobInvitationData>[];
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          final seen = <String>{};
          for (final item in decoded) {
            final invite = _invitationFromJson(item);
            if (invite == null) {
              continue;
            }
            if (!seen.add(invite.id)) {
              continue;
            }
            loaded.add(invite);
          }
        }
      } catch (_) {}
    }
    _allInvitations
      ..clear()
      ..addAll(loaded);
    _emit();
  }

  static void replaceInvitations(List<_ResidentJobInvitationData> incoming) {
    final dedup = <String, _ResidentJobInvitationData>{};
    for (final invite in incoming) {
      dedup[invite.id] = invite;
    }
    _allInvitations
      ..clear()
      ..addAll(dedup.values);
    _emit();
  }

  static void replaceApplications(List<_ResidentJobApplicationData> incoming) {
    final currentMobile = _normalizeMobileForKey(_currentResidentProfile?.mobile ?? '');
    final currentName = _normalizedIdentityName(
      (_currentResidentProfile?.displayName ?? '').trim(),
    );
    final personal = incoming.where((entry) {
      final appMobile = _normalizeMobileForKey(entry.mobileNumber);
      if (currentMobile.isNotEmpty && appMobile.isNotEmpty) {
        return appMobile == currentMobile;
      }
      if (currentName.isNotEmpty) {
        return _normalizedIdentityName(entry.applicantName.trim()) == currentName;
      }
      return false;
    }).toList();
    applications
      ..clear()
      ..addAll(personal);
    _allApplications
      ..clear()
      ..addAll(incoming);
    unawaited(_persistApplications());
    unawaited(_persistGlobalApplications());
    _emit();
  }

  static void mergeInvitation(_ResidentJobInvitationData invite) {
    final existingIndex = _allInvitations.indexWhere((item) => item.id == invite.id);
    if (existingIndex >= 0) {
      _allInvitations[existingIndex] = invite;
    } else {
      _allInvitations.insert(0, invite);
    }
    _emit();
  }

  static Future<void> _persistInvitations() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(_allInvitations.map(_invitationToJson).toList());
    await prefs.setString(_globalInvitationsStorageKey, payload);
  }

  static int get unreadCount =>
      notifications.where((item) => item.unread).length;

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }

  static void _emit() {
    refresh.value++;
  }

  static void markAllRead() {
    for (final item in notifications) {
      item.unread = false;
    }
    _emit();
  }

  static void addHiringPost({
    required String title,
    required String company,
    required String location,
    required String salary,
    required String schedule,
    required String requirements,
    required String postedBy,
    required bool urgent,
  }) {
    jobs.insert(
      0,
      _ResidentJobData(
        title: title,
        company: company,
        location: location,
        salary: salary,
        schedule: schedule,
        urgent: urgent,
        postedBy: postedBy,
        requirements: requirements,
      ),
    );
    notifications.insert(
      0,
      _ResidentJobNotificationData(
        title: 'New job post: $title',
        subtitle: '$company posted a $schedule role in $location.',
        icon: Icons.work_outline_rounded,
        accent: const Color(0xFF3860D8),
        createdAt: DateTime.now(),
      ),
    );
    _emit();
  }

  static bool _containsJob(_ResidentJobData job) {
    final key = _residentJobKey(job);
    return jobs.any((entry) => _residentJobKey(entry) == key);
  }

  static void mergeHiringPosts(List<_ResidentJobData> incoming) {
    var changed = false;
    for (final job in incoming) {
      if (_containsJob(job)) {
        continue;
      }
      jobs.insert(0, job);
      changed = true;
    }
    if (changed) {
      _emit();
    }
  }

  static void replaceHiringPosts(List<_ResidentJobData> incoming) {
    jobs
      ..clear()
      ..addAll(incoming);
    _refreshSavedJobsFromKeys();
    _emit();
  }

  static void addTalentPost({
    required String fullName,
    required String desiredJob,
    required String skills,
    required String preferredSetup,
    required String expectedSalary,
    required String zone,
    required bool availableNow,
  }) {
    talents.insert(
      0,
      _ResidentTalentPostData(
        fullName: fullName,
        desiredJob: desiredJob,
        skills: skills,
        preferredSetup: preferredSetup,
        expectedSalary: expectedSalary,
        barangayZone: zone,
        availableNow: availableNow,
      ),
    );
    notifications.insert(
      0,
      _ResidentJobNotificationData(
        title: 'New job hunter profile posted',
        subtitle: '$fullName is looking for "$desiredJob".',
        icon: Icons.person_search_rounded,
        accent: const Color(0xFF8B4FD8),
        createdAt: DateTime.now(),
      ),
    );
    _emit();
  }

  static bool _containsTalent(_ResidentTalentPostData talent) {
    return talents.any(
      (entry) =>
          entry.fullName == talent.fullName &&
          entry.desiredJob == talent.desiredJob &&
          entry.barangayZone == talent.barangayZone,
    );
  }

  static void mergeTalentPosts(List<_ResidentTalentPostData> incoming) {
    var changed = false;
    for (final talent in incoming) {
      if (_containsTalent(talent)) {
        continue;
      }
      talents.insert(0, talent);
      changed = true;
    }
    if (changed) {
      _emit();
    }
  }

  static void replaceTalentPosts(List<_ResidentTalentPostData> incoming) {
    talents
      ..clear()
      ..addAll(incoming);
    _emit();
  }

  static bool isSaved(_ResidentJobData job) {
    return savedJobKeys.contains(_residentJobKey(job));
  }

  static void replaceSavedJobKeys(Set<String> keys) {
    savedJobKeys
      ..clear()
      ..addAll(keys);
    _refreshSavedJobsFromKeys();
    unawaited(_persistSavedJobs());
    _emit();
  }

  static List<_ResidentJobData> get savedJobs =>
      List<_ResidentJobData>.unmodifiable(_savedJobs);

  static void toggleSaved(_ResidentJobData job) {
    final key = _residentJobKey(job);
    final saved = savedJobKeys.contains(key);
    if (saved) {
      savedJobKeys.remove(key);
      _savedJobs.removeWhere((entry) => _residentJobKey(entry) == key);
    } else {
      savedJobKeys.add(key);
      final alreadySaved = _savedJobs.any(
        (entry) => _residentJobKey(entry) == key,
      );
      if (!alreadySaved) {
        _savedJobs.insert(0, job);
      }
      notifications.insert(
        0,
        _ResidentJobNotificationData(
          title: 'Saved job for later',
          subtitle: '${job.title} from ${job.company} was added to Saved Jobs.',
          icon: Icons.favorite_border_rounded,
          accent: const Color(0xFFB24B87),
          createdAt: DateTime.now(),
        ),
      );
    }
    unawaited(_persistSavedJobs());
    _emit();
  }

  static void _refreshSavedJobsFromKeys() {
    final byKey = <String, _ResidentJobData>{};
    for (final job in jobs) {
      final key = _residentJobKey(job);
      if (savedJobKeys.contains(key)) {
        byKey[key] = job;
      }
    }
    for (final saved in _savedJobs) {
      final key = _residentJobKey(saved);
      if (savedJobKeys.contains(key) && !byKey.containsKey(key)) {
        byKey[key] = saved;
      }
    }
    _savedJobs
      ..clear()
      ..addAll(byKey.values);
  }

  static void submitApplication({
    required _ResidentJobData job,
    required String applicantName,
    required String mobileNumber,
    required String coverLetter,
    required String attachmentName,
    String attachmentPath = '',
    String attachmentBase64 = '',
  }) {
    final application = _ResidentJobApplicationData(
      id: 'app-${DateTime.now().microsecondsSinceEpoch}',
      jobId: job.id,
      jobTitle: job.title,
      company: job.company,
      postedBy: job.postedBy,
      applicantName: applicantName,
      mobileNumber: mobileNumber,
      coverLetter: coverLetter,
      attachmentName: attachmentName,
      attachmentPath: attachmentPath,
      attachmentBase64: attachmentBase64,
      submittedAt: DateTime.now(),
    );
    final matchKey = job.id.trim().isNotEmpty
        ? job.id.trim()
        : '${job.title}|${job.company}';
    final alreadyInPersonal = applications.any(
      (entry) =>
          (entry.jobId.trim().isNotEmpty ? entry.jobId.trim() : '${entry.jobTitle}|${entry.company}') ==
          matchKey,
    );
    if (!alreadyInPersonal) {
      applications.insert(0, application);
    } else {
      applications.removeWhere(
        (entry) =>
            (entry.jobId.trim().isNotEmpty ? entry.jobId.trim() : '${entry.jobTitle}|${entry.company}') ==
            matchKey,
      );
      applications.insert(0, application);
    }
    final unique = _applicationUniqueKey(application);
    final alreadyInGlobal = _allApplications.any(
      (entry) => _applicationUniqueKey(entry) == unique,
    );
    if (!alreadyInGlobal) {
      _allApplications.insert(0, application);
    }
    notifications.insert(
      0,
      _ResidentJobNotificationData(
        title: 'Application submitted',
        subtitle: 'Your application for ${job.title} is now under review.',
        icon: Icons.mark_email_read_outlined,
        accent: const Color(0xFF3C63D8),
        createdAt: DateTime.now(),
      ),
    );
    unawaited(_persistApplications());
    unawaited(_persistGlobalApplications());
    _emit();
  }

  static bool isTalentOwnedByCurrentUser(_ResidentTalentPostData talent) {
    final currentMobile = _normalizeMobileForKey(_currentResidentProfile?.mobile ?? '');
    final talentMobile = _normalizeMobileForKey(talent.mobileNumber);
    if (currentMobile.isNotEmpty && talentMobile.isNotEmpty) {
      return currentMobile == talentMobile;
    }
    final currentName =
        (_currentResidentProfile?.displayName ?? '').trim().toLowerCase();
    return currentName.isNotEmpty &&
        talent.fullName.trim().toLowerCase() == currentName;
  }

  static void sendInvitation({
    required _ResidentTalentPostData talent,
    required String message,
  }) {
    final inviterName = (_currentResidentProfile?.displayName ?? '').trim();
    final inviterMobile = (_currentResidentProfile?.mobile ?? '').trim();
    final normalizedMessage = message.trim();
    if (normalizedMessage.isEmpty || inviterName.isEmpty) {
      return;
    }
    final invitation = _ResidentJobInvitationData(
      id: 'inv-${DateTime.now().microsecondsSinceEpoch}',
      talentUserId: talent.userId.trim(),
      talentProfileId: talent.profileId.trim(),
      talentName: talent.fullName.trim(),
      talentMobile: talent.mobileNumber.trim(),
      talentDesiredJob: talent.desiredJob.trim(),
      inviterName: inviterName,
      inviterMobile: inviterMobile,
      message: normalizedMessage,
      createdAt: DateTime.now(),
    );
    _allInvitations.insert(0, invitation);
    notifications.insert(
      0,
      _ResidentJobNotificationData(
        title: 'Invitation sent',
        subtitle: 'You invited ${talent.fullName} for ${talent.desiredJob}.',
        icon: Icons.mail_outline_rounded,
        accent: const Color(0xFF5A62D6),
        createdAt: DateTime.now(),
      ),
    );
    unawaited(_persistInvitations());
    _emit();
  }

  static List<_ResidentJobInvitationData> invitationsForTalent(
    _ResidentTalentPostData talent,
  ) {
    final talentProfileId = talent.profileId.trim();
    final talentUserId = talent.userId.trim();
    final normalizedTalentMobile = _normalizeMobileForKey(talent.mobileNumber);
    final normalizedTalentName = _normalizedIdentityName(talent.fullName.trim());
    return _allInvitations.where((invite) {
      if (talentProfileId.isNotEmpty && invite.talentProfileId.trim().isNotEmpty) {
        return invite.talentProfileId.trim() == talentProfileId;
      }
      if (talentUserId.isNotEmpty && invite.talentUserId.trim().isNotEmpty) {
        return invite.talentUserId.trim() == talentUserId;
      }
      final inviteMobile = _normalizeMobileForKey(invite.talentMobile);
      if (normalizedTalentMobile.isNotEmpty && inviteMobile.isNotEmpty) {
        return inviteMobile == normalizedTalentMobile;
      }
      return _normalizedIdentityName(invite.talentName.trim()) ==
          normalizedTalentName;
    }).toList();
  }

  static List<_ResidentJobInvitationData> invitationsForCurrentResident() {
    final currentMobile = _normalizeMobileForKey(_currentResidentProfile?.mobile ?? '');
    final currentName = _normalizedIdentityName(
      (_currentResidentProfile?.displayName ?? '').trim(),
    );
    if (currentMobile.isEmpty && currentName.isEmpty) {
      return const <_ResidentJobInvitationData>[];
    }
    return _allInvitations.where((invite) {
      final inviteMobile = _normalizeMobileForKey(invite.talentMobile);
      final mobileMatch =
          currentMobile.isNotEmpty &&
          inviteMobile.isNotEmpty &&
          inviteMobile == currentMobile;
      final nameMatch =
          currentName.isNotEmpty &&
          _normalizedIdentityName(invite.talentName.trim()) == currentName;
      return mobileMatch || nameMatch;
    }).toList();
  }

  static bool hasCurrentUserInvitedTalent(_ResidentTalentPostData talent) {
    final currentMobile = _normalizeMobileForKey(_currentResidentProfile?.mobile ?? '');
    final currentName = _normalizedIdentityName(
      (_currentResidentProfile?.displayName ?? '').trim(),
    );
    if (currentMobile.isEmpty && currentName.isEmpty) {
      return false;
    }
    final talentMobile = _normalizeMobileForKey(talent.mobileNumber);
    final talentName = _normalizedIdentityName(talent.fullName.trim());
    final talentProfileId = talent.profileId.trim();
    final talentUserId = talent.userId.trim();
    return _allInvitations.any((invite) {
      final inviterMobile = _normalizeMobileForKey(invite.inviterMobile);
      final inviterName = _normalizedIdentityName(invite.inviterName.trim());
      final inviterMatch =
          (currentMobile.isNotEmpty &&
              inviterMobile.isNotEmpty &&
              inviterMobile == currentMobile) ||
          (currentName.isNotEmpty && inviterName == currentName);
      if (!inviterMatch) {
        return false;
      }
      if (talentProfileId.isNotEmpty && invite.talentProfileId.trim().isNotEmpty) {
        return invite.talentProfileId.trim() == talentProfileId;
      }
      if (talentUserId.isNotEmpty && invite.talentUserId.trim().isNotEmpty) {
        return invite.talentUserId.trim() == talentUserId;
      }
      final inviteTalentMobile = _normalizeMobileForKey(invite.talentMobile);
      final inviteTalentName = _normalizedIdentityName(invite.talentName.trim());
      final talentMatch =
          (talentMobile.isNotEmpty &&
              inviteTalentMobile.isNotEmpty &&
              inviteTalentMobile == talentMobile) ||
          inviteTalentName == talentName;
      return talentMatch;
    });
  }

  static bool hasApplied(_ResidentJobData job) {
    final key = _residentJobKey(job);
    final jobId = job.id.trim();
    return applications.any(
      (entry) {
        final entryJobId = entry.jobId.trim();
        if (jobId.isNotEmpty && entryJobId.isNotEmpty) {
          return entryJobId == jobId;
        }
        return '${entry.jobTitle}|${entry.company}' == key;
      },
    );
  }

  static void markOwnedJob(_ResidentJobData job) {
    final key = _residentJobKey(job);
    if (ownedJobKeys.add(key)) {
      unawaited(_persistOwnedJobs());
      _emit();
    }
  }

  static bool isOwnedByCurrentUser(_ResidentJobData job) {
    final key = _residentJobKey(job);
    if (ownedJobKeys.contains(key)) {
      return true;
    }
    final owner = job.postedBy.trim().toLowerCase();
    final currentName =
        (_currentResidentProfile?.displayName ?? '').trim().toLowerCase();
    return owner.isNotEmpty && currentName.isNotEmpty && owner == currentName;
  }

  static List<_ResidentJobApplicationData> submissionsForJob(_ResidentJobData job) {
    final key = _residentJobKey(job);
    final jobId = job.id.trim();
    return _allApplications
        .where((entry) {
          final entryJobId = entry.jobId.trim();
          if (jobId.isNotEmpty && entryJobId.isNotEmpty) {
            return entryJobId == jobId;
          }
          return '${entry.jobTitle}|${entry.company}' == key;
        })
        .toList();
  }

  static int submissionCountForJob(_ResidentJobData job) {
    return submissionsForJob(job).length;
  }
}
