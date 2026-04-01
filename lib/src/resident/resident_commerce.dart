part of barangaymo_app;

class _ResidentTalentPostData {
  final String fullName;
  final String desiredJob;
  final String skills;
  final String preferredSetup;
  final String expectedSalary;
  final String barangayZone;
  final bool availableNow;

  const _ResidentTalentPostData({
    required this.fullName,
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
  final String jobTitle;
  final String company;
  final String applicantName;
  final String mobileNumber;
  final String coverLetter;
  final String attachmentName;
  final DateTime submittedAt;
  final String status;

  const _ResidentJobApplicationData({
    required this.jobTitle,
    required this.company,
    required this.applicantName,
    required this.mobileNumber,
    required this.coverLetter,
    required this.attachmentName,
    required this.submittedAt,
    this.status = 'Submitted',
  });
}

class _ResidentCommercialRegistrationData {
  final String businessName;
  final String ownerName;
  final String businessType;
  final String contactNumber;
  final String address;
  final String meetupSpot;
  final String businessPermitNumber;
  final String businessPermitFileName;
  final bool merchantVerified;

  const _ResidentCommercialRegistrationData({
    required this.businessName,
    required this.ownerName,
    required this.businessType,
    required this.contactNumber,
    required this.address,
    required this.meetupSpot,
    required this.businessPermitNumber,
    required this.businessPermitFileName,
    this.merchantVerified = false,
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
}

String _residentJobKey(_ResidentJobData job) => '${job.title}|${job.company}';

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
  static final List<_ResidentJobApplicationData> applications = [];

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

  static List<_ResidentJobData> get savedJobs =>
      jobs.where((job) => isSaved(job)).toList();

  static void toggleSaved(_ResidentJobData job) {
    final key = _residentJobKey(job);
    final saved = savedJobKeys.contains(key);
    if (saved) {
      savedJobKeys.remove(key);
    } else {
      savedJobKeys.add(key);
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
    _emit();
  }

  static void submitApplication({
    required _ResidentJobData job,
    required String applicantName,
    required String mobileNumber,
    required String coverLetter,
    required String attachmentName,
  }) {
    applications.insert(
      0,
      _ResidentJobApplicationData(
        jobTitle: job.title,
        company: job.company,
        applicantName: applicantName,
        mobileNumber: mobileNumber,
        coverLetter: coverLetter,
        attachmentName: attachmentName,
        submittedAt: DateTime.now(),
      ),
    );
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
    _emit();
  }
}
