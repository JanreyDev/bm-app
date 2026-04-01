part of barangaymo_app;

class _CommunityLiveSignal {
  final String message;
  final DateTime createdAt;

  const _CommunityLiveSignal({
    required this.message,
    required this.createdAt,
  });
}

class _CommunityAnnouncement {
  final int id;
  final String title;
  final String summary;
  final String audienceLabel;
  final DateTime postedAt;
  final bool pinned;
  final bool hasVideo;
  final String videoTitle;
  final String durationLabel;
  final Color accent;
  final Color accentSoft;

  const _CommunityAnnouncement({
    required this.id,
    required this.title,
    required this.summary,
    required this.audienceLabel,
    required this.postedAt,
    required this.pinned,
    required this.hasVideo,
    required this.videoTitle,
    required this.durationLabel,
    required this.accent,
    required this.accentSoft,
  });
}

class _CommunityCalendarEvent {
  final int id;
  final String title;
  final String type;
  final String description;
  final DateTime startAt;
  final String venue;
  final bool isOfficial;
  final bool isHoliday;

  const _CommunityCalendarEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.startAt,
    required this.venue,
    this.isOfficial = true,
    this.isHoliday = false,
  });
}

class _VolunteerOpportunity {
  final int id;
  final String title;
  final String category;
  final String description;
  final DateTime scheduleAt;
  final String venue;
  final String coordinator;
  final String benefit;
  final int targetVolunteers;
  int joinedVolunteers;
  bool joinedByMe;

  _VolunteerOpportunity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.scheduleAt,
    required this.venue,
    required this.coordinator,
    required this.benefit,
    required this.targetVolunteers,
    required this.joinedVolunteers,
    this.joinedByMe = false,
  });

  int get remainingSlots => math.max(0, targetVolunteers - joinedVolunteers);

  void toggleJoined() {
    if (joinedByMe) {
      joinedByMe = false;
      if (joinedVolunteers > 0) {
        joinedVolunteers -= 1;
      }
      return;
    }
    joinedByMe = true;
    joinedVolunteers += 1;
  }
}

class _CommunityHub {
  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  static final StreamController<_CommunityLiveSignal> liveUpdates =
      StreamController<_CommunityLiveSignal>.broadcast();

  static bool _seeded = false;
  static int _pulseCursor = 0;
  static final List<_CommunityPost> _posts = <_CommunityPost>[];
  static final List<_CommunityAnnouncement> _announcements =
      <_CommunityAnnouncement>[];
  static final List<_CommunityCalendarEvent> _events =
      <_CommunityCalendarEvent>[];
  static final List<_VolunteerOpportunity> _volunteerPrograms =
      <_VolunteerOpportunity>[];

  static void ensureSeeded() {
    if (_seeded) {
      return;
    }
    _seeded = true;
    _posts.addAll([
      _CommunityPost(
        author: 'Barangay West Tapinac',
        message:
            'Clean-up drive this Saturday at 7:00 AM. Bring gloves, water, and meet at the covered court. Volunteers will receive meal packs after the activity.',
        postedAt: DateTime.now().subtract(const Duration(minutes: 26)),
        hasPhoto: true,
        photoAsset: 'public/item-laptop.jpg',
        photoLabel: 'Community clean-up volunteers',
        likes: 38,
        comments: 6,
        isOfficial: true,
        badgeLabel: 'Pinned Announcement',
      ),
      _CommunityPost(
        author: 'Maria Santos',
        message:
            'Verified residents from Purok 3 are collecting school supplies for Sunday\'s literacy drive. Drop-off point is the barangay hall lobby until 5:00 PM.',
        postedAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
        likes: 21,
        comments: 4,
        isVerifiedResident: true,
        neighborhood: 'Purok 3',
      ),
      _CommunityPost(
        author: 'Youth Council',
        message:
            'Basketball league registration is now open. Submit your team roster before Friday, 5:00 PM at the SK office.',
        postedAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 8)),
        hasPhoto: true,
        photoAsset: 'public/market-basket.jpg',
        photoLabel: 'Youth sports registration',
        likes: 17,
        comments: 5,
        isOfficial: true,
        badgeLabel: 'SK Program',
      ),
      _CommunityPost(
        author: 'Carlo Reyes',
        message:
            'Streetlights near Zone 4 have been fixed. Thanks to everyone who reported it quickly through the app.',
        postedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        likes: 32,
        comments: 3,
        isVerifiedResident: true,
        neighborhood: 'Zone 4',
      ),
    ]);
    _announcements.addAll([
      _CommunityAnnouncement(
        id: 1,
        title: 'Barangay Assembly this Monday',
        summary:
            'Council budget updates, drainage project timeline, and public forum agenda for all residents.',
        audienceLabel: 'All residents',
        postedAt: DateTime.now().subtract(const Duration(hours: 4)),
        pinned: true,
        hasVideo: true,
        videoTitle: 'Assembly Invitation Clip',
        durationLabel: '01:18',
        accent: const Color(0xFFCB1010),
        accentSoft: const Color(0xFFFFE3E3),
      ),
      _CommunityAnnouncement(
        id: 2,
        title: 'Weekend Job Fair and Livelihood Booths',
        summary:
            'Hiring partners, TESDA orientation, and resume screening at the covered court from 9:00 AM to 4:00 PM.',
        audienceLabel: 'Workers and students',
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
        pinned: true,
        hasVideo: false,
        videoTitle: 'Job Fair Preview',
        durationLabel: '00:00',
        accent: const Color(0xFFE96A24),
        accentSoft: const Color(0xFFFFE7D7),
      ),
      _CommunityAnnouncement(
        id: 3,
        title: 'Rainy Season Safety Advisory',
        summary:
            'Emergency hotlines, evacuation reminders, and house-to-house flood prep schedule for riverside zones.',
        audienceLabel: 'High-risk areas',
        postedAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
        pinned: false,
        hasVideo: true,
        videoTitle: 'Flood Preparedness Briefing',
        durationLabel: '02:04',
        accent: const Color(0xFF335CF3),
        accentSoft: const Color(0xFFE8EEFF),
      ),
    ]);
    _events.addAll([
      _CommunityCalendarEvent(
        id: 1,
        title: 'Barangay Assembly',
        type: 'Meeting',
        description: 'Quarterly public meeting with council updates and open forum.',
        startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 18),
        venue: 'Barangay Hall Covered Court',
      ),
      _CommunityCalendarEvent(
        id: 2,
        title: 'Community Clean-up Drive',
        type: 'Volunteer',
        description: 'Street sweeping, canal clearing, and solid waste sorting activity.',
        startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3, 7),
        venue: 'West Tapinac Main Road',
      ),
      _CommunityCalendarEvent(
        id: 3,
        title: 'Araw ng Kagitingan Observance',
        type: 'Holiday',
        description: 'Flag ceremony and wreath laying with youth council and senior citizens.',
        startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 5, 8),
        venue: 'Barangay Plaza',
        isHoliday: true,
      ),
      _CommunityCalendarEvent(
        id: 4,
        title: 'Job Fair',
        type: 'Livelihood',
        description: 'Hiring booths, TESDA orientation, and local seller registration help desk.',
        startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 6, 9),
        venue: 'Covered Court',
      ),
    ]);
    _volunteerPrograms.addAll([
      _VolunteerOpportunity(
        id: 1,
        title: 'Weekend Clean-up Brigade',
        category: 'Environment',
        description:
            'Support waste segregation, canal cleaning, and tree line maintenance across Zone 2 and Zone 4.',
        scheduleAt: DateTime.now().add(const Duration(days: 3, hours: 7)),
        venue: 'Assembly point at Barangay Hall',
        coordinator: 'Environmental Desk',
        benefit: 'Meal packs and service certificate',
        targetVolunteers: 30,
        joinedVolunteers: 18,
      ),
      _VolunteerOpportunity(
        id: 2,
        title: 'Reading Tutors for Kids',
        category: 'Education',
        description:
            'Volunteer mentors for Saturday reading circles for elementary pupils and out-of-school youth.',
        scheduleAt: DateTime.now().add(const Duration(days: 4, hours: 8)),
        venue: 'Barangay Learning Center',
        coordinator: 'Youth Council',
        benefit: 'Volunteer hours and barangay recognition',
        targetVolunteers: 12,
        joinedVolunteers: 7,
      ),
      _VolunteerOpportunity(
        id: 3,
        title: 'Disaster Relief Packing Team',
        category: 'Emergency',
        description:
            'Prepare family food packs and hygiene kits before the rainy season response window.',
        scheduleAt: DateTime.now().add(const Duration(days: 5, hours: 9)),
        venue: 'Operations Room',
        coordinator: 'BDRRM Team',
        benefit: 'Training credit and emergency response orientation',
        targetVolunteers: 20,
        joinedVolunteers: 11,
      ),
    ]);
  }

  static List<_CommunityPost> get posts {
    ensureSeeded();
    final sorted = [..._posts]
      ..sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return sorted;
  }

  static List<_CommunityAnnouncement> get announcements {
    ensureSeeded();
    final sorted = [..._announcements]
      ..sort((a, b) {
        if (a.pinned != b.pinned) {
          return a.pinned ? -1 : 1;
        }
        return b.postedAt.compareTo(a.postedAt);
      });
    return sorted;
  }

  static List<_CommunityAnnouncement> get pinnedAnnouncements =>
      announcements.where((entry) => entry.pinned).toList();

  static List<_CommunityCalendarEvent> get events {
    ensureSeeded();
    final sorted = [..._events]..sort((a, b) => a.startAt.compareTo(b.startAt));
    return sorted;
  }

  static List<_VolunteerOpportunity> get volunteerPrograms {
    ensureSeeded();
    return [..._volunteerPrograms];
  }

  static List<_CommunityCalendarEvent> eventsForDay(DateTime day) {
    return events.where((entry) => _sameCalendarDay(entry.startAt, day)).toList();
  }

  static void addPost(_CommunityPost post) {
    ensureSeeded();
    _posts.insert(0, post);
    _emit('Live feed updated: ${post.author} posted a new community update.');
  }

  static void updatePost(_CommunityPost post) {
    ensureSeeded();
    final index = _posts.indexWhere((entry) => entry.id == post.id);
    if (index < 0) {
      return;
    }
    _posts[index] = post;
    refresh.value += 1;
  }

  static void removePost(int postId) {
    ensureSeeded();
    _posts.removeWhere((entry) => entry.id == postId);
    refresh.value += 1;
  }

  static void replacePosts(List<_CommunityPost> posts) {
    ensureSeeded();
    _posts
      ..clear()
      ..addAll(posts);
    refresh.value += 1;
  }

  static void toggleLike(_CommunityPost post) {
    post.toggleLike();
    _emit(post.likedByMe
        ? 'Live reaction: you liked ${post.author}\'s post.'
        : 'Live reaction removed from ${post.author}\'s post.');
  }

  static void addComment(_CommunityPost post, String message) {
    post.addComment(message);
    _emit('Live comment: new reply on ${post.author}\'s post.');
  }

  static void reportPost(_CommunityPost post, String reason) {
    post.reportReasons.insert(0, reason);
    post.reports += 1;
    _emit('Moderation queue updated for ${post.author}\'s post.');
  }

  static void toggleVolunteer(_VolunteerOpportunity opportunity) {
    opportunity.toggleJoined();
    _emit(opportunity.joinedByMe
        ? 'Volunteer queue updated: you joined ${opportunity.title}.'
        : 'Volunteer queue updated: you left ${opportunity.title}.');
  }

  static void simulateRemotePulse() {
    ensureSeeded();
    if (_posts.isEmpty) {
      return;
    }
    final post = _posts[_pulseCursor % _posts.length];
    if (_pulseCursor.isEven) {
      post.likes += 1;
      _emit('Live sync: ${post.author} received a new like.');
    } else {
      const liveComments = [
        'Copy. Sharing this in our purok group.',
        'Will attend with my family.',
        'Thanks for the update from Zone 4.',
        'Noted. Please post the follow-up schedule too.',
      ];
      post.addComment(
        liveComments[_pulseCursor % liveComments.length],
        author: 'Verified Resident',
        isMine: false,
      );
      _emit('Live sync: a new comment came in on ${post.author}\'s post.');
    }
    _pulseCursor += 1;
  }

  static void _emit(String message) {
    refresh.value += 1;
    liveUpdates.add(
      _CommunityLiveSignal(
        message: message,
        createdAt: DateTime.now(),
      ),
    );
  }
}

class _CommunityGuidelinesStore {
  static const _guidelineKey = 'community_guidelines_acknowledged';

  static Future<bool> isAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guidelineKey) ?? false;
  }

  static Future<void> markAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guidelineKey, true);
  }
}

class _CommunityPostsFetchResult {
  final bool success;
  final String message;
  final List<_CommunityPost> posts;

  const _CommunityPostsFetchResult({
    required this.success,
    required this.message,
    this.posts = const <_CommunityPost>[],
  });
}

class _CommunityPostCreateResult {
  final bool success;
  final String message;
  final _CommunityPost? post;

  const _CommunityPostCreateResult({
    required this.success,
    required this.message,
    this.post,
  });
}

class _CommunityPostDeleteResult {
  final bool success;
  final String message;

  const _CommunityPostDeleteResult({
    required this.success,
    required this.message,
  });
}

class _CommunityPostFetchResult {
  final bool success;
  final String message;
  final _CommunityPost? post;

  const _CommunityPostFetchResult({
    required this.success,
    required this.message,
    this.post,
  });
}

class _CommunityApi {
  _CommunityApi._();
  static final _CommunityApi instance = _CommunityApi._();
  static const Duration _requestTimeout = Duration(seconds: 6);

  Future<_CommunityPostsFetchResult> fetchPosts() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _CommunityPostsFetchResult(
        success: false,
        message: 'Please log in again to load community posts.',
      );
    }

    var sawConnectionError = false;
    var sawTimeout = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('community/posts')) {
      try {
        final response = await http
            .get(
              endpoint,
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
            )
            .timeout(_requestTimeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawPosts = body['posts'];
          if (rawPosts is! List) {
            return const _CommunityPostsFetchResult(
              success: false,
              message: 'Community feed is not available yet.',
            );
          }
          final posts = <_CommunityPost>[];
          for (final item in rawPosts) {
            if (item is! Map<String, dynamic>) {
              continue;
            }
            posts.add(_fromApiPost(item));
          }
          return _CommunityPostsFetchResult(
            success: true,
            message: _extractApiMessage(
              body,
              fallback: posts.isEmpty
                  ? 'No community posts yet in your barangay.'
                  : 'Community posts loaded.',
            ),
            posts: posts,
          );
        }
        return _CommunityPostsFetchResult(
          success: false,
          message: _extractApiMessage(
            body,
            fallback: 'Unable to load community posts.',
          ),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _CommunityPostsFetchResult(
        success: false,
        message: 'Loading community posts timed out. Please try again.',
      );
    }
    if (sawConnectionError) {
      return const _CommunityPostsFetchResult(
        success: false,
        message: 'Cannot connect to server to load community posts.',
      );
    }
    return const _CommunityPostsFetchResult(
      success: false,
      message: 'Community endpoint is not available yet.',
    );
  }

  Future<_CommunityPostCreateResult> createPost({
    required String message,
    Uint8List? imageBytes,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Please log in again before publishing a post.',
      );
    }

    var sawConnectionError = false;
    var sawTimeout = false;
    final imagePayload = imageBytes == null ? null : base64Encode(imageBytes);
    for (final endpoint in _AuthApi.instance._endpointCandidates('community/posts')) {
      try {
        final response = await http
            .post(
              endpoint,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
              body: jsonEncode({
                'message': message,
                if (imagePayload != null && imagePayload.isNotEmpty)
                  'image_base64': imagePayload,
              }),
            )
            .timeout(_requestTimeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawPost = body['post'];
          if (rawPost is! Map<String, dynamic>) {
            return _CommunityPostCreateResult(
              success: false,
              message: _extractApiMessage(
                body,
                fallback: 'Post was accepted but no post payload was returned.',
              ),
            );
          }
          return _CommunityPostCreateResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Post published.'),
            post: _fromApiPost(rawPost),
          );
        }
        return _CommunityPostCreateResult(
          success: false,
          message: _extractApiMessage(
            body,
            fallback: 'Unable to publish post right now.',
          ),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Publish request timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Cannot connect to server to publish the post.',
      );
    }
    return const _CommunityPostCreateResult(
      success: false,
      message: 'Community posting endpoint is not available yet.',
    );
  }

  Future<_CommunityPostCreateResult> updatePost({
    required int postId,
    required String message,
    Uint8List? imageBytes,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Please log in again before editing a post.',
      );
    }

    var sawConnectionError = false;
    var sawTimeout = false;
    final imagePayload = imageBytes == null ? null : base64Encode(imageBytes);
    for (final endpoint in _AuthApi.instance._endpointCandidates('community/posts/$postId')) {
      try {
        final response = await http
            .patch(
              endpoint,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
              body: jsonEncode({
                'message': message,
                if (imagePayload != null && imagePayload.isNotEmpty)
                  'image_base64': imagePayload,
              }),
            )
            .timeout(_requestTimeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawPost = body['post'];
          if (rawPost is! Map<String, dynamic>) {
            return _CommunityPostCreateResult(
              success: false,
              message: _extractApiMessage(
                body,
                fallback: 'Post updated but no payload was returned.',
              ),
            );
          }
          return _CommunityPostCreateResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Post updated.'),
            post: _fromApiPost(rawPost),
          );
        }
        return _CommunityPostCreateResult(
          success: false,
          message: _extractApiMessage(
            body,
            fallback: 'Unable to update post right now.',
          ),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Update request timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Cannot connect to server to update the post.',
      );
    }
    return const _CommunityPostCreateResult(
      success: false,
      message: 'Community update endpoint is not available yet.',
    );
  }

  Future<_CommunityPostDeleteResult> deletePost({
    required int postId,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _CommunityPostDeleteResult(
        success: false,
        message: 'Please log in again before deleting a post.',
      );
    }

    var sawConnectionError = false;
    var sawTimeout = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('community/posts/$postId')) {
      try {
        final response = await http
            .delete(
              endpoint,
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
            )
            .timeout(_requestTimeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return _CommunityPostDeleteResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Post deleted.'),
          );
        }
        return _CommunityPostDeleteResult(
          success: false,
          message: _extractApiMessage(
            body,
            fallback: 'Unable to delete post right now.',
          ),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _CommunityPostDeleteResult(
        success: false,
        message: 'Delete request timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _CommunityPostDeleteResult(
        success: false,
        message: 'Cannot connect to server to delete the post.',
      );
    }
    return const _CommunityPostDeleteResult(
      success: false,
      message: 'Community delete endpoint is not available yet.',
    );
  }

  Future<_CommunityPostFetchResult> fetchPost({
    required int postId,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _CommunityPostFetchResult(
        success: false,
        message: 'Please log in again to load this post.',
      );
    }

    var sawConnectionError = false;
    var sawTimeout = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('community/posts/$postId')) {
      try {
        final response = await http
            .get(
              endpoint,
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
            )
            .timeout(_requestTimeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawPost = body['post'];
          if (rawPost is! Map<String, dynamic>) {
            return _CommunityPostFetchResult(
              success: false,
              message: _extractApiMessage(
                body,
                fallback: 'Post loaded with an invalid payload.',
              ),
            );
          }
          return _CommunityPostFetchResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Post loaded.'),
            post: _fromApiPost(rawPost),
          );
        }
        return _CommunityPostFetchResult(
          success: false,
          message: _extractApiMessage(body, fallback: 'Unable to load this post.'),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _CommunityPostFetchResult(
        success: false,
        message: 'Loading post timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _CommunityPostFetchResult(
        success: false,
        message: 'Cannot connect to server to load this post.',
      );
    }
    return const _CommunityPostFetchResult(
      success: false,
      message: 'Community post endpoint is not available yet.',
    );
  }

  Future<_CommunityPostCreateResult> addComment({
    required int postId,
    required String message,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Please log in again before adding a comment.',
      );
    }

    var sawConnectionError = false;
    var sawTimeout = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('community/posts/$postId/comments')) {
      try {
        final response = await http
            .post(
              endpoint,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
              body: jsonEncode({'message': message}),
            )
            .timeout(_requestTimeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawPost = body['post'];
          if (rawPost is! Map<String, dynamic>) {
            return _CommunityPostCreateResult(
              success: false,
              message: _extractApiMessage(
                body,
                fallback: 'Comment added but no post payload was returned.',
              ),
            );
          }
          return _CommunityPostCreateResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Comment added.'),
            post: _fromApiPost(rawPost),
          );
        }
        return _CommunityPostCreateResult(
          success: false,
          message: _extractApiMessage(
            body,
            fallback: 'Unable to add comment right now.',
          ),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Comment request timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Cannot connect to server to add your comment.',
      );
    }
    return const _CommunityPostCreateResult(
      success: false,
      message: 'Community comments endpoint is not available yet.',
    );
  }

  Future<_CommunityPostCreateResult> toggleLike({
    required int postId,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Please log in again before liking a post.',
      );
    }

    var sawConnectionError = false;
    var sawTimeout = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('community/posts/$postId/likes/toggle')) {
      try {
        final response = await http
            .post(
              endpoint,
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',
              },
            )
            .timeout(_requestTimeout);
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawPost = body['post'];
          if (rawPost is! Map<String, dynamic>) {
            return _CommunityPostCreateResult(
              success: false,
              message: _extractApiMessage(
                body,
                fallback: 'Like action completed but no post payload was returned.',
              ),
            );
          }
          return _CommunityPostCreateResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Post reaction updated.'),
            post: _fromApiPost(rawPost),
          );
        }
        return _CommunityPostCreateResult(
          success: false,
          message: _extractApiMessage(
            body,
            fallback: 'Unable to update like right now.',
          ),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Like request timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _CommunityPostCreateResult(
        success: false,
        message: 'Cannot connect to server to like this post.',
      );
    }
    return const _CommunityPostCreateResult(
      success: false,
      message: 'Community likes endpoint is not available yet.',
    );
  }

  _CommunityPost _fromApiPost(Map<String, dynamic> raw) {
    int parseInt(dynamic value, {int fallback = 0}) {
      if (value is int) {
        return value;
      }
      if (value is String) {
        return int.tryParse(value) ?? fallback;
      }
      return fallback;
    }

    bool parseBool(dynamic value) {
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    final postedRaw = raw['posted_at'];
    final postedAt = postedRaw is String
        ? DateTime.tryParse(postedRaw)?.toLocal()
        : null;
    final message = ((raw['message'] as String?) ?? '').trim();
    final author = ((raw['author'] as String?) ?? '').trim();
    final barangay = ((raw['barangay'] as String?) ?? '').trim();
    final official = parseBool(raw['is_official']);
    final canManage = parseBool(raw['can_manage']);
    final imageBase64 = ((raw['image_base64'] as String?) ?? '').trim();
    final decodedImage = _decodeImageBase64(imageBase64);
    final rawLikesCount = raw['likes_count'];
    final likesCount = parseInt(rawLikesCount, fallback: parseInt(raw['likes']));
    final likedByMe = parseBool(raw['liked_by_me']) || parseBool(raw['likedByMe']);
    final rawCommentsCount = raw['comments_count'];
    final commentsCount = parseInt(rawCommentsCount);
    final rawComments = raw['comments'];

    final commentEntries = <_CommunityComment>[];
    if (rawComments is List) {
      for (final item in rawComments) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final parsed = _parseComment(item);
        if (parsed != null) {
          commentEntries.add(parsed);
        }
      }
    } else {
      final latestRaw = raw['latest_comment'];
      if (latestRaw is Map<String, dynamic>) {
        final parsed = _parseComment(latestRaw);
        if (parsed != null) {
          commentEntries.add(parsed);
        }
      }
    }

    return _CommunityPost(
      id: parseInt(raw['id'], fallback: DateTime.now().millisecondsSinceEpoch),
      author: author.isEmpty
          ? (official ? 'Barangay Update' : 'Verified Resident')
          : author,
      message: message,
      postedAt: postedAt ?? DateTime.now(),
      hasPhoto: decodedImage != null,
      photoBytes: decodedImage,
      isOfficial: official,
      isVerifiedResident: !official,
      canManage: canManage,
      neighborhood: barangay.isEmpty ? null : barangay,
      likes: likesCount,
      likedByMe: likedByMe,
      comments: commentsCount,
      commentEntries: commentEntries,
      commentCount: commentsCount,
    );
  }

  String _extractApiMessage(
    Map<String, dynamic> body, {
    required String fallback,
  }) {
    final message = body['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
    return fallback;
  }

  Uint8List? _decodeImageBase64(String value) {
    if (value.isEmpty) {
      return null;
    }

    String normalized = value;
    final commaIndex = normalized.indexOf(',');
    if (normalized.startsWith('data:image/') && commaIndex >= 0) {
      normalized = normalized.substring(commaIndex + 1);
    }
    normalized = normalized.replaceAll(RegExp(r'\s+'), '');
    if (normalized.isEmpty) {
      return null;
    }

    try {
      return base64Decode(normalized);
    } catch (_) {
      return null;
    }
  }

  _CommunityComment? _parseComment(Map<String, dynamic> raw) {
    final author = ((raw['author'] as String?) ?? '').trim();
    final message = ((raw['message'] as String?) ?? '').trim();
    if (message.isEmpty) {
      return null;
    }
    final postedRaw = raw['posted_at'];
    final postedAt = postedRaw is String
        ? DateTime.tryParse(postedRaw)?.toLocal()
        : null;
    final isMine = raw['is_mine'] == true || raw['is_mine'] == 1 || raw['is_mine'] == '1';

    return _CommunityComment(
      author: author.isEmpty ? 'Resident' : author,
      message: message,
      postedAt: postedAt ?? DateTime.now(),
      isMine: isMine,
    );
  }
}

Future<bool> _ensureCommunityPostingGuidelines(
  BuildContext context, {
  required bool officialView,
}) async {
  if (officialView || await _CommunityGuidelinesStore.isAccepted()) {
    return true;
  }
  final accepted = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            title: const Text('Community Guidelines'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Before your first post, confirm that you will:',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text('- Post only verified resident updates or real barangay concerns.'),
                SizedBox(height: 6),
                Text('- Avoid personal attacks, doxxing, or false emergency claims.'),
                SizedBox(height: 6),
                Text('- Respect moderation and report harmful content instead of escalating.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Not now'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFCB1010),
                ),
                child: const Text('I Understand'),
              ),
            ],
          );
        },
      ) ??
      false;
  if (accepted) {
    await _CommunityGuidelinesStore.markAccepted();
  }
  return accepted;
}

Future<_CommunityPost?> _showCommunityCreatePostSheet(
  BuildContext context, {
  required bool officialView,
}) async {
  final allowed = await _ensureCommunityPostingGuidelines(
    context,
    officialView: officialView,
  );
  if (!allowed || !context.mounted) {
    return null;
  }
  return showModalBottomSheet<_CommunityPost>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _CommunityComposerSheet(officialView: officialView);
    },
  );
}

bool _sameCalendarDay(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

Widget _communityDetailRow({
  required IconData icon,
  required String label,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFCB1010)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5B637D),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _showVolunteerDetailsSheet(
  BuildContext context, {
  required _VolunteerOpportunity opportunity,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(sheetContext).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opportunity.title,
                style: const TextStyle(
                  color: Color(0xFF2E344C),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                opportunity.description,
                style: const TextStyle(
                  color: Color(0xFF59627D),
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              _communityDetailRow(
                icon: Icons.schedule_rounded,
                label:
                    '${opportunity.scheduleAt.month}/${opportunity.scheduleAt.day}/${opportunity.scheduleAt.year}',
              ),
              _communityDetailRow(
                icon: Icons.place_outlined,
                label: opportunity.venue,
              ),
              _communityDetailRow(
                icon: Icons.support_agent_rounded,
                label: 'Coordinator: ${opportunity.coordinator}',
              ),
              _communityDetailRow(
                icon: Icons.workspace_premium_outlined,
                label: opportunity.benefit,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  StreamSubscription<_CommunityLiveSignal>? _liveSubscription;
  String _liveBanner = 'Live community updates ready.';
  bool _loading = true;

  bool get _isOfficialView => _currentOfficialMobile?.trim().isNotEmpty ?? false;

  @override
  void initState() {
    super.initState();
    _CommunityHub.ensureSeeded();
    _CommunityHub.replacePosts(const <_CommunityPost>[]);
    _tabController = TabController(length: 4, vsync: this);
    _CommunityHub.refresh.addListener(_handleHubRefresh);
    _liveSubscription = _CommunityHub.liveUpdates.stream.listen((signal) {
      if (!mounted) {
        return;
      }
      setState(() => _liveBanner = signal.message);
    });
    unawaited(_refreshCommunity(showToast: false));
  }

  @override
  void dispose() {
    _liveSubscription?.cancel();
    _CommunityHub.refresh.removeListener(_handleHubRefresh);
    _tabController.dispose();
    super.dispose();
  }

  void _handleHubRefresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _refreshCommunity({bool showToast = true}) async {
    setState(() => _loading = true);
    final result = await _CommunityApi.instance.fetchPosts();
    if (!mounted) {
      return;
    }
    if (result.success) {
      _CommunityHub.replacePosts(result.posts);
    }
    setState(() => _loading = false);
    if (showToast) {
      _showFeature(context, result.message, tone: result.success ? _ToastTone.success : _ToastTone.warning);
    }
  }

  Future<void> _openCreatePost() async {
    final createdPost = await _showCommunityCreatePostSheet(
      context,
      officialView: _isOfficialView,
    );
    if (createdPost == null || !mounted) {
      return;
    }
    final result = await _CommunityApi.instance.createPost(
      message: createdPost.message,
      imageBytes: createdPost.photoBytes,
    );
    if (!mounted) {
      return;
    }
    if (!result.success || result.post == null) {
      _showFeature(context, result.message, tone: _ToastTone.error);
      return;
    }
    _CommunityHub.addPost(result.post!);
    _tabController.animateTo(0);
    _showFeature(context, result.message, tone: _ToastTone.success);
  }

  Future<void> _openPost(_CommunityPost post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _CommunityPostDetailPage(post: post)),
    );
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _watchClip(_CommunityAnnouncement announcement) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CommunityAnnouncementClipPage(
          announcement: announcement,
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _shareAnnouncementToFacebook(_CommunityAnnouncement announcement) {
    _showFeature(
      context,
      'Facebook SDK is not configured in this build. ${announcement.title} is queued for manual cross-post.',
    );
  }

  Future<void> _showPostActions(_CommunityPost post) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(sheetContext).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2E344C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.canManage
                      ? 'Manage your community post.'
                      : 'Choose a moderation action for this community post.',
                  style: TextStyle(
                    color: Color(0xFF69708A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (post.canManage)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.edit_outlined, color: Color(0xFF335CF3)),
                    title: const Text(
                      'Edit post',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: const Text('Update your post message'),
                    onTap: () => Navigator.pop(sheetContext, 'edit'),
                  )
                else
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.flag_outlined, color: Color(0xFFCB1010)),
                    title: const Text(
                      'Report content',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: const Text('Send this post to the moderation queue'),
                    onTap: () => Navigator.pop(sheetContext, 'report'),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.copy_all_rounded, color: Color(0xFF335CF3)),
                  title: const Text(
                    'Copy post text',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text('Copy this update to the clipboard'),
                  onTap: () => Navigator.pop(sheetContext, 'copy'),
                ),
                if (post.canManage)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFB42318)),
                    title: const Text(
                      'Delete post',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: const Text('Remove this post from the community feed'),
                    onTap: () => Navigator.pop(sheetContext, 'delete'),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted || action == null) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 16));
    if (!mounted) {
      return;
    }
    switch (action) {
      case 'edit':
        await _editPost(post);
        break;
      case 'delete':
        await _deletePost(post);
        break;
      case 'report':
        await _showReportContentSheet(context, post: post);
        break;
      case 'copy':
        await Clipboard.setData(ClipboardData(text: post.message));
        if (mounted) {
          _showFeature(context, 'Post text copied.');
        }
        break;
    }
  }

  Future<void> _editPost(_CommunityPost post) async {
    final editedMessage = await _promptEditCommunityPost(
      context,
      initialMessage: post.message,
    );
    if (editedMessage == null || !mounted) {
      return;
    }

    final result = await _CommunityApi.instance.updatePost(
      postId: post.id,
      message: editedMessage,
      imageBytes: post.photoBytes,
    );
    if (!mounted) {
      return;
    }
    if (!result.success || result.post == null) {
      _showFeature(context, result.message, tone: _ToastTone.error);
      return;
    }
    _CommunityHub.updatePost(result.post!);
    _showFeature(context, result.message, tone: _ToastTone.success);
  }

  Future<void> _deletePost(_CommunityPost post) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Delete Post?'),
              content: const Text('This will permanently remove your post from the feed.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFB42318)),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!confirmed || !mounted) {
      return;
    }

    final result = await _CommunityApi.instance.deletePost(postId: post.id);
    if (!mounted) {
      return;
    }
    if (!result.success) {
      _showFeature(context, result.message, tone: _ToastTone.error);
      return;
    }
    _CommunityHub.removePost(post.id);
    _showFeature(context, result.message, tone: _ToastTone.success);
  }

  Widget _composerCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: _openCreatePost,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4E7F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFFFEAEA),
              child: Icon(Icons.person, color: Color(0xFFCB1010)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isOfficialView
                        ? 'Publish an official barangay update'
                        : 'Share with verified residents in your barangay',
                    style: const TextStyle(
                      color: Color(0xFF2E344C),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Text post + gallery image picker',
                    style: TextStyle(
                      color: Color(0xFF6B738E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.post_add_rounded, color: Color(0xFFCB1010)),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleLike(_CommunityPost post) async {
    final result = await _CommunityApi.instance.toggleLike(postId: post.id);
    if (!mounted) {
      return;
    }
    if (!result.success || result.post == null) {
      _showFeature(context, result.message, tone: _ToastTone.error);
      return;
    }
    _CommunityHub.updatePost(result.post!);
    _showFeature(context, result.message, tone: _ToastTone.success);
  }

  Future<void> _addComment(_CommunityPost post) async {
    final comment = await _promptCommunityComment(context);
    if (comment == null || !mounted) {
      return;
    }
    final result = await _CommunityApi.instance.addComment(
      postId: post.id,
      message: comment,
    );
    if (!mounted) {
      return;
    }
    if (!result.success || result.post == null) {
      _showFeature(context, result.message, tone: _ToastTone.error);
      return;
    }
    _CommunityHub.updatePost(result.post!);
    _showFeature(context, result.message, tone: _ToastTone.success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appText('Community Hub', 'Community Hub')),
        backgroundColor: const Color(0xFFCB1010),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFFFD7D7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900),
          tabs: const [
            Tab(text: 'Social Wall'),
            Tab(text: 'Announcements'),
            Tab(text: 'Events'),
            Tab(text: 'Volunteer'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FD), Color(0xFFF5F1F1)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFEF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF3D1D1)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCB1010),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.wifi_tethering_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Live community sync',
                            style: TextStyle(
                              color: Color(0xFF8C1B1B),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _liveBanner,
                            style: const TextStyle(
                              color: Color(0xFF6B4751),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Chip(
                      label: Text('Session Live'),
                      backgroundColor: Color(0xFFFFFFFF),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const _AppListSkeleton(count: 4)
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _CommunityWallTab(
                            composer: _composerCard(),
                            posts: _CommunityHub.posts,
                            onRefresh: _refreshCommunity,
                            onOpen: _openPost,
                            onToggleLike: _toggleLike,
                            onAddComment: _addComment,
                            onMore: _showPostActions,
                          ),
                          _CommunityAnnouncementsTab(
                            announcements: _CommunityHub.announcements,
                            onWatchClip: _watchClip,
                            onShareFacebook: _shareAnnouncementToFacebook,
                          ),
                          _CommunityCalendarTab(events: _CommunityHub.events),
                          _CommunityVolunteerTab(
                            opportunities: _CommunityHub.volunteerPrograms,
                            onToggleVolunteer: (opportunity) {
                              _CommunityHub.toggleVolunteer(opportunity);
                              if (mounted) {
                                _showFeature(
                                  context,
                                  opportunity.joinedByMe
                                      ? 'You joined ${opportunity.title}.'
                                      : 'You left ${opportunity.title}.',
                                  tone: _ToastTone.success,
                                );
                              }
                            },
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
}

class _CommunityFeedCard extends StatelessWidget {
  final _CommunityPost post;
  final VoidCallback onOpen;
  final VoidCallback onToggleLike;
  final VoidCallback onAddComment;
  final VoidCallback onMore;

  const _CommunityFeedCard({
    super.key,
    required this.post,
    required this.onOpen,
    required this.onToggleLike,
    required this.onAddComment,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final latestComment = post.latestComment;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E5EF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFFFEAEA),
                  child: Icon(
                    post.isOfficial
                        ? Icons.campaign_rounded
                        : Icons.verified_user_rounded,
                    color: const Color(0xFFCB1010),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author,
                        style: const TextStyle(
                          color: Color(0xFF2F3248),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _CommunityMetaChip(
                            label: post.isOfficial
                                ? (post.badgeLabel ?? 'Official Update')
                                : 'Verified Resident',
                            color: post.isOfficial
                                ? const Color(0xFFCB1010)
                                : const Color(0xFF19A565),
                          ),
                          if (post.neighborhood != null &&
                              post.neighborhood!.isNotEmpty)
                            _CommunityMetaChip(
                              label: post.neighborhood!,
                              color: const Color(0xFF335CF3),
                            ),
                          _CommunityMetaChip(
                            label: _relativeTime(post.postedAt),
                            color: const Color(0xFF6A738F),
                            light: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onMore,
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: Color(0xFF8A8FA8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.message,
              style: const TextStyle(
                color: Color(0xFF32374E),
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            if (post.hasPhoto) ...[
              const SizedBox(height: 10),
              _CommunityPhotoPreview(
                height: 176,
                photoAsset: post.photoAsset,
                photoBytes: post.photoBytes,
                label: post.photoLabel,
              ),
              const SizedBox(height: 8),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${post.likes} likes',
                  style: const TextStyle(
                    color: Color(0xFF60657E),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${post.comments} comments',
                  style: const TextStyle(
                    color: Color(0xFF60657E),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (latestComment != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E8F2)),
                ),
                child: Text(
                  latestComment.isMine
                      ? 'You: ${latestComment.message}'
                      : '${latestComment.author}: ${latestComment.message}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF474D66),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (post.underReview) ...[
              const SizedBox(height: 8),
              const _CommunityMetaChip(
                label: 'Under moderation review',
                color: Color(0xFFE88800),
              ),
            ],
            const Divider(height: 18),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onToggleLike,
                  icon: Icon(
                    post.likedByMe
                        ? Icons.thumb_up_alt_rounded
                        : Icons.thumb_up_alt_outlined,
                    size: 18,
                    color: post.likedByMe
                        ? const Color(0xFFCB1010)
                        : const Color(0xFF6E738D),
                  ),
                  label: Text(
                    post.likedByMe ? 'Liked' : 'Like',
                    style: TextStyle(
                      color: post.likedByMe
                          ? const Color(0xFFCB1010)
                          : const Color(0xFF6E738D),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddComment,
                  icon: const Icon(Icons.add_comment_outlined, size: 18),
                  label: const Text('Comment'),
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: onOpen,
                  child: const Text(
                    'Open',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityCreatePostPage extends StatelessWidget {
  const CommunityCreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final officialView = _currentOfficialMobile?.trim().isNotEmpty ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Community Post'),
        backgroundColor: const Color(0xFFCB1010),
        foregroundColor: Colors.white,
      ),
      body: _CommunityComposerSheet(
        officialView: officialView,
        pageMode: true,
      ),
    );
  }
}

class _CommunityComposerSheet extends StatefulWidget {
  final bool officialView;
  final bool pageMode;

  const _CommunityComposerSheet({
    required this.officialView,
    this.pageMode = false,
  });

  @override
  State<_CommunityComposerSheet> createState() => _CommunityComposerSheetState();
}

class _CommunityComposerSheetState extends State<_CommunityComposerSheet> {
  final _messageController = TextEditingController();
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _submitting = false;

  String get _authorLabel => widget.officialView
      ? 'Barangay ${_officialBarangaySetup.barangay}'
      : _residentDisplayName();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final bytes = await image.readAsBytes();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedImageBytes = bytes;
      _selectedImageName = image.name;
    });
  }

  Future<void> _submit() async {
    final message = _messageController.text.trim();
    if (message.length < 5) {
      _showFeature(context, 'Please enter a meaningful post message.');
      return;
    }
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) {
      return;
    }
    final post = _CommunityPost(
      author: _authorLabel,
      message: message,
      postedAt: DateTime.now(),
      hasPhoto: _selectedImageBytes != null,
      photoBytes: _selectedImageBytes,
      photoLabel: _selectedImageName,
      likes: 0,
      isOfficial: widget.officialView,
      isVerifiedResident: !widget.officialView,
      neighborhood: widget.officialView
          ? _officialBarangaySetup.barangay
          : _residentLocationSummary(fallback: ''),
    );
    Navigator.pop(context, post);
  }

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + (widget.pageMode ? 0 : MediaQuery.of(context).viewInsets.bottom),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (!widget.pageMode)
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DCE8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            if (!widget.pageMode) const SizedBox(height: 14),
            Text(
              widget.officialView ? 'Official Post Creation' : 'Create a Community Post',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2C3147),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.officialView
                  ? 'Publish official barangay updates and announcement images.'
                  : 'Text update plus one image from your gallery for the community social wall.',
              style: const TextStyle(
                color: Color(0xFF646A84),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.officialView
                    ? const Color(0xFFFFF0F0)
                    : const Color(0xFFF4F7FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.officialView
                        ? Icons.campaign_rounded
                        : Icons.verified_user_rounded,
                    color: widget.officialView
                        ? const Color(0xFFCB1010)
                        : const Color(0xFF2D58F1),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.officialView
                          ? 'Posting as ${_officialBarangaySetup.barangay}'
                          : 'Posting as verified resident ${_residentDisplayName()}',
                      style: const TextStyle(
                        color: Color(0xFF39415B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Type your community update...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E5F0)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library_rounded),
                    label: const Text('Pick from Gallery'),
                  ),
                ),
                if (_selectedImageBytes != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => setState(() {
                      _selectedImageBytes = null;
                      _selectedImageName = null;
                    }),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            if (_selectedImageBytes != null)
              _CommunityPhotoPreview(
                height: 190,
                photoBytes: _selectedImageBytes,
                label: _selectedImageName,
              )
            else
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE3E7F1)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'No image selected yet',
                  style: TextStyle(
                    color: Color(0xFF6C738D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFCB1010),
                minimumSize: const Size.fromHeight(52),
              ),
              child: Text(_submitting ? 'Posting...' : 'Publish Post'),
            ),
          ],
        ),
      ),
    );
    if (widget.pageMode) {
      return body;
    }
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: body,
    );
  }
}

class _CommunityPostDetailPage extends StatefulWidget {
  final _CommunityPost post;
  const _CommunityPostDetailPage({required this.post});

  @override
  State<_CommunityPostDetailPage> createState() =>
      _CommunityPostDetailPageState();
}

class _CommunityPostDetailPageState extends State<_CommunityPostDetailPage> {
  late _CommunityPost _post;

  void _handleHubRefresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _CommunityHub.refresh.addListener(_handleHubRefresh);
    unawaited(_loadPost());
  }

  @override
  void dispose() {
    _CommunityHub.refresh.removeListener(_handleHubRefresh);
    super.dispose();
  }

  Future<void> _toggleLike() async {
    final result = await _CommunityApi.instance.toggleLike(postId: _post.id);
    if (!mounted) {
      return;
    }
    if (!result.success || result.post == null) {
      _showFeature(context, result.message, tone: _ToastTone.error);
      return;
    }
    _CommunityHub.updatePost(result.post!);
    setState(() => _post = result.post!);
    _showFeature(context, result.message, tone: _ToastTone.success);
  }

  Future<void> _addComment() async {
    final comment = await _promptCommunityComment(context);
    if (comment == null || !mounted) {
      return;
    }
    final result = await _CommunityApi.instance.addComment(
      postId: _post.id,
      message: comment,
    );
    if (!mounted) {
      return;
    }
    if (!result.success || result.post == null) {
      _showFeature(context, result.message, tone: _ToastTone.error);
      return;
    }
    _CommunityHub.updatePost(result.post!);
    setState(() => _post = result.post!);
    _showFeature(context, result.message, tone: _ToastTone.success);
  }

  Future<void> _reportPost() async {
    await _showReportContentSheet(context, post: _post);
  }

  Future<void> _loadPost() async {
    final result = await _CommunityApi.instance.fetchPost(postId: _post.id);
    if (!mounted || !result.success || result.post == null) {
      return;
    }
    _CommunityHub.updatePost(result.post!);
    setState(() => _post = result.post!);
  }

  @override
  Widget build(BuildContext context) {
    final post = _post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: const Color(0xFFCB1010),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _reportPost,
            icon: const Icon(Icons.flag_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFFFEAEA),
              child: Icon(
                post.isOfficial
                    ? Icons.campaign_rounded
                    : Icons.verified_user_rounded,
                color: const Color(0xFFCB1010),
              ),
            ),
            title: Text(
              post.author,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              _relativeTime(post.postedAt),
              style: const TextStyle(color: Color(0xFFCB1010)),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CommunityMetaChip(
                label: post.isOfficial
                    ? (post.badgeLabel ?? 'Official Update')
                    : 'Verified Resident',
                color: post.isOfficial
                    ? const Color(0xFFCB1010)
                    : const Color(0xFF19A565),
              ),
              if (post.neighborhood != null && post.neighborhood!.isNotEmpty)
                _CommunityMetaChip(
                  label: post.neighborhood!,
                  color: const Color(0xFF335CF3),
                ),
              if (post.underReview)
                const _CommunityMetaChip(
                  label: 'Under moderation review',
                  color: Color(0xFFE88800),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.message,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF32374E),
              height: 1.35,
            ),
          ),
          if (post.hasPhoto) ...[
            const SizedBox(height: 10),
            _CommunityPhotoPreview(
              height: 220,
              photoAsset: post.photoAsset,
              photoBytes: post.photoBytes,
              label: post.photoLabel,
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${post.likes} likes'),
              Text('${post.comments} comments'),
            ],
          ),
          const Divider(),
          Row(
            children: [
              TextButton.icon(
                onPressed: _toggleLike,
                icon: Icon(
                  post.likedByMe
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_alt_outlined,
                  size: 18,
                  color: post.likedByMe
                      ? const Color(0xFFCB1010)
                      : const Color(0xFF6E738D),
                ),
                label: Text(
                  post.likedByMe ? 'Liked' : 'Like',
                  style: TextStyle(
                    color: post.likedByMe
                        ? const Color(0xFFCB1010)
                        : const Color(0xFF6E738D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addComment,
                icon: const Icon(Icons.add_comment_outlined, size: 18),
                label: const Text('Add a comment'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (post.commentEntries.isEmpty)
            const Text(
              'No comments yet.',
              style: TextStyle(
                color: Color(0xFF6A7088),
                fontWeight: FontWeight.w600,
              ),
            )
          else ...[
            const Text(
              'Comments',
              style: TextStyle(
                color: Color(0xFF2E344C),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ...post.commentEntries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                decoration: BoxDecoration(
                  color: entry.isMine
                      ? const Color(0xFFFFF4F4)
                      : const Color(0xFFF7F8FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E8F2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.author,
                            style: const TextStyle(
                              color: Color(0xFF2E344C),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          _relativeTime(entry.postedAt),
                          style: const TextStyle(
                            color: Color(0xFF79809A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.message,
                      style: const TextStyle(
                        color: Color(0xFF3B4058),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _CommunityPhotoPreview extends StatelessWidget {
  final double height;
  final Uint8List? photoBytes;
  final String? photoAsset;
  final String? label;

  const _CommunityPhotoPreview({
    required this.height,
    this.photoBytes,
    this.photoAsset,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (photoBytes != null) {
      child = Image.memory(
        photoBytes!,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    } else {
      child = Image.asset(
        photoAsset ?? 'public/item-laptop.jpg',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, _, _) => Container(
          color: const Color(0xFFE8ECFA),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF7A809A),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _CommunityImageLightboxPage(
                photoBytes: photoBytes,
                photoAsset: photoAsset,
                label: label,
              ),
            ),
          ),
          child: Stack(
            children: [
              SizedBox(
                height: height,
                width: double.infinity,
                child: child,
              ),
              if (label != null && label!.trim().isNotEmpty)
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.54),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      label!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.46),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _appText('Tap to zoom', 'I-tap para i-zoom'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityImageLightboxPage extends StatelessWidget {
  final Uint8List? photoBytes;
  final String? photoAsset;
  final String? label;

  const _CommunityImageLightboxPage({
    this.photoBytes,
    this.photoAsset,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final image = photoBytes != null
        ? Image.memory(photoBytes!, fit: BoxFit.contain)
        : Image.asset(
            photoAsset ?? 'public/item-laptop.jpg',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white70,
              size: 42,
            ),
          );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(label ?? _appText('Image Preview', 'Preview ng Imahe')),
      ),
      body: InteractiveViewer(
        minScale: 0.9,
        maxScale: 4,
        child: Center(child: image),
      ),
    );
  }
}

class _CommunityPost {
  static int _nextId = 1;

  final int id;
  final String author;
  final String message;
  final DateTime postedAt;
  final bool hasPhoto;
  final Uint8List? photoBytes;
  final String? photoAsset;
  final String? photoLabel;
  int likes;
  bool likedByMe;
  final List<_CommunityComment> commentEntries;
  final bool isOfficial;
  final bool isVerifiedResident;
  final bool canManage;
  final String? neighborhood;
  final String? badgeLabel;
  int commentCount;
  int reports;
  final List<String> reportReasons;

  int get comments => math.max(commentCount, commentEntries.length);
  bool get underReview => reports > 0;
  _CommunityComment? get latestComment =>
      commentEntries.isEmpty ? null : commentEntries.first;

  _CommunityPost({
    int? id,
    required this.author,
    required this.message,
    required this.postedAt,
    this.hasPhoto = false,
    this.photoBytes,
    this.photoAsset,
    this.photoLabel,
    this.likes = 0,
    this.likedByMe = false,
    int comments = 0,
    List<_CommunityComment>? commentEntries,
    this.isOfficial = false,
    this.isVerifiedResident = false,
    this.canManage = false,
    this.neighborhood,
    this.badgeLabel,
    int? commentCount,
    this.reports = 0,
    List<String>? reportReasons,
  }) : id = id ?? _nextId++,
       commentEntries =
           commentEntries ??
           List<_CommunityComment>.generate(
             comments,
             (index) => _CommunityComment.seed(index, postedAt),
            ),
       commentCount = commentCount ?? comments,
       reportReasons = reportReasons ?? <String>[];

  void toggleLike() {
    if (likedByMe) {
      likedByMe = false;
      if (likes > 0) {
        likes -= 1;
      }
      return;
    }
    likedByMe = true;
    likes += 1;
  }

  void addComment(
    String message, {
    String author = 'You',
    bool isMine = true,
  }) {
    commentEntries.insert(
      0,
      _CommunityComment(
        author: author,
        message: message,
        postedAt: DateTime.now(),
        isMine: isMine,
      ),
    );
    commentCount += 1;
  }
}

Future<void> _showReportContentSheet(
  BuildContext context, {
  required _CommunityPost post,
}) async {
  String reason = 'False information';
  final notesController = TextEditingController();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report Content',
                  style: TextStyle(
                    color: Color(0xFF2E344C),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Report ${post.author}\'s post for moderation review.',
                  style: const TextStyle(
                    color: Color(0xFF69708A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: reason,
                  decoration: InputDecoration(
                    labelText: 'Reason',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'False information',
                      child: Text('False information'),
                    ),
                    DropdownMenuItem(
                      value: 'Harassment or hate speech',
                      child: Text('Harassment or hate speech'),
                    ),
                    DropdownMenuItem(
                      value: 'Graphic or sensitive content',
                      child: Text('Graphic or sensitive content'),
                    ),
                    DropdownMenuItem(
                      value: 'Spam or unrelated advertising',
                      child: Text('Spam or unrelated advertising'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setSheetState(() => reason = value);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Add notes for moderators (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          _CommunityHub.reportPost(post, reason);
                          Navigator.pop(sheetContext);
                          _showFeature(
                            context,
                            'Report sent for moderation review.',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFCB1010),
                        ),
                        child: const Text('Submit Report'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );
  notesController.dispose();
}

class _CommunityAnnouncementClipPage extends StatefulWidget {
  final _CommunityAnnouncement announcement;

  const _CommunityAnnouncementClipPage({required this.announcement});

  @override
  State<_CommunityAnnouncementClipPage> createState() =>
      _CommunityAnnouncementClipPageState();
}

class _CommunityAnnouncementClipPageState
    extends State<_CommunityAnnouncementClipPage> {
  Timer? _playbackTimer;
  double _progress = 0.0;
  bool _playing = false;

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _togglePlayback() {
    if (_playing) {
      _playbackTimer?.cancel();
      setState(() => _playing = false);
      return;
    }
    setState(() => _playing = true);
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 280), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _progress += 0.04;
        if (_progress >= 1) {
          _progress = 1;
          _playing = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.announcement;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.videoTitle),
        backgroundColor: const Color(0xFFCB1010),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [item.accent, item.accent.withValues(alpha: 0.82)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.summary,
                          style: const TextStyle(
                            color: Color(0xFFFFEAEA),
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: _togglePlayback,
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white.withValues(alpha: 0.16),
                      child: Icon(
                        _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE4E8F1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.videoTitle,
                  style: const TextStyle(
                    color: Color(0xFF2E344C),
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _progress,
                  onChanged: (value) => setState(() => _progress = value),
                  activeColor: const Color(0xFFCB1010),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _playing ? 'Playing preview' : 'Preview paused',
                      style: const TextStyle(
                        color: Color(0xFF5B637D),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.durationLabel,
                      style: const TextStyle(
                        color: Color(0xFF5B637D),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'This build uses an in-app announcement preview player. Real media playback needs a dedicated video package in the app.',
                  style: TextStyle(
                    color: Color(0xFF6A728D),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _showFeature(
                    context,
                    'Facebook SDK is not configured in this build. Announcement queued for manual cross-post.',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFCB1010),
                  ),
                  icon: const Icon(Icons.facebook_rounded),
                  label: const Text('Cross-post Announcement'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityMetaChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool light;

  const _CommunityMetaChip({
    required this.label,
    required this.color,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    final background =
        light ? const Color(0xFFF3F5FA) : color.withValues(alpha: 0.12);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _CommunityWallTab extends StatelessWidget {
  final Widget composer;
  final List<_CommunityPost> posts;
  final Future<void> Function() onRefresh;
  final ValueChanged<_CommunityPost> onOpen;
  final ValueChanged<_CommunityPost> onToggleLike;
  final ValueChanged<_CommunityPost> onAddComment;
  final ValueChanged<_CommunityPost> onMore;

  const _CommunityWallTab({
    required this.composer,
    required this.posts,
    required this.onRefresh,
    required this.onOpen,
    required this.onToggleLike,
    required this.onAddComment,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 18),
        children: [
          composer,
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4E8F1)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user_rounded, color: Color(0xFF19A565)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Only official posts and updates from verified residents appear in the social wall.',
                    style: TextStyle(
                      color: Color(0xFF56607B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (posts.isEmpty)
            _AppEmptyState(
              icon: Icons.campaign_outlined,
              title: _appText(
                'No community posts available',
                'Wala pang community posts',
              ),
              subtitle: _appText(
                'Pull to refresh or create the first verified community update.',
                'I-pull para mag-refresh o gumawa ng unang verified na community update.',
              ),
            )
          else
            ...posts.map(
              (post) => _CommunityFeedCard(
                key: ValueKey(post.id),
                post: post,
                onOpen: () => onOpen(post),
                onToggleLike: () => onToggleLike(post),
                onAddComment: () => onAddComment(post),
                onMore: () => onMore(post),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommunityAnnouncementsTab extends StatefulWidget {
  final List<_CommunityAnnouncement> announcements;
  final ValueChanged<_CommunityAnnouncement> onWatchClip;
  final ValueChanged<_CommunityAnnouncement> onShareFacebook;

  const _CommunityAnnouncementsTab({
    required this.announcements,
    required this.onWatchClip,
    required this.onShareFacebook,
  });

  @override
  State<_CommunityAnnouncementsTab> createState() =>
      _CommunityAnnouncementsTabState();
}

class _CommunityAnnouncementsTabState extends State<_CommunityAnnouncementsTab> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinned = widget.announcements.where((entry) => entry.pinned).toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: 18),
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pinned.length,
            onPageChanged: (value) => setState(() => _pageIndex = value),
            itemBuilder: (context, index) {
              final item = pinned[index];
              return Padding(
                padding: EdgeInsets.only(right: index == pinned.length - 1 ? 0 : 10),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [item.accent, item.accent.withValues(alpha: 0.86)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: item.accent.withValues(alpha: 0.24),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Pinned Announcement',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (item.hasVideo)
                            const Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.summary,
                        style: const TextStyle(
                          color: Color(0xFFFFE9E9),
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed:
                                item.hasVideo ? () => widget.onWatchClip(item) : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: item.accent,
                            ),
                            icon: const Icon(Icons.ondemand_video_rounded),
                            label: Text(item.hasVideo ? 'Watch Clip' : 'No Video'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => widget.onShareFacebook(item),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                            ),
                            icon: const Icon(Icons.facebook_rounded),
                            label: const Text('Cross-post'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            pinned.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: index == _pageIndex ? 22 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: index == _pageIndex
                    ? const Color(0xFFCB1010)
                    : const Color(0xFFD7DBE8),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...widget.announcements.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: item.accentSoft),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
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
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.accentSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        item.hasVideo
                            ? Icons.play_circle_outline_rounded
                            : Icons.campaign_rounded,
                        color: item.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Color(0xFF2C3148),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${item.audienceLabel} | ${_relativeTime(item.postedAt)}',
                            style: TextStyle(
                              color: item.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.summary,
                  style: const TextStyle(
                    color: Color(0xFF5C637E),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (item.hasVideo)
                      FilledButton.icon(
                        onPressed: () => widget.onWatchClip(item),
                        style: FilledButton.styleFrom(
                          backgroundColor: item.accent,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text('Play ${item.durationLabel}'),
                      ),
                    OutlinedButton.icon(
                      onPressed: () => widget.onShareFacebook(item),
                      icon: const Icon(Icons.facebook_rounded),
                      label: const Text('Cross-post to Facebook'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _CommunityCalendarTab extends StatefulWidget {
  final List<_CommunityCalendarEvent> events;

  const _CommunityCalendarTab({required this.events});

  @override
  State<_CommunityCalendarTab> createState() => _CommunityCalendarTabState();
}

class _CommunityCalendarTabState extends State<_CommunityCalendarTab> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final events = _CommunityHub.eventsForDay(_selectedDay);
    return ListView(
      padding: const EdgeInsets.only(bottom: 18),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE3E6EF)),
          ),
          child: CalendarDatePicker(
            initialDate: _selectedDay,
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 2),
            onDateChanged: (value) => setState(() => _selectedDay = value),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE4E8F1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events on ${_selectedDay.month}/${_selectedDay.day}/${_selectedDay.year}',
                style: const TextStyle(
                  color: Color(0xFF2E344C),
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              if (events.isEmpty)
                const Text(
                  'No barangay meetings, programs, or holidays scheduled for this day.',
                  style: TextStyle(
                    color: Color(0xFF69708A),
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                ...events.map((event) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: event.isHoliday
                          ? const Color(0xFFFFF4E8)
                          : const Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: event.isHoliday
                            ? const Color(0xFFFFD8A5)
                            : const Color(0xFFE3E6EF),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: event.isHoliday
                                ? const Color(0xFFFFE6BF)
                                : const Color(0xFFFFEAEA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            event.isHoliday
                                ? Icons.celebration_rounded
                                : Icons.event_available_rounded,
                            color: event.isHoliday
                                ? const Color(0xFFE08B00)
                                : const Color(0xFFCB1010),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  color: Color(0xFF2E344C),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${event.type} | ${event.startAt.hour.toString().padLeft(2, '0')}:${event.startAt.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Color(0xFFCB1010),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                event.description,
                                style: const TextStyle(
                                  color: Color(0xFF606884),
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place_outlined,
                                    size: 16,
                                    color: Color(0xFF7A839E),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      event.venue,
                                      style: const TextStyle(
                                        color: Color(0xFF6C738D),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommunityVolunteerTab extends StatelessWidget {
  final List<_VolunteerOpportunity> opportunities;
  final ValueChanged<_VolunteerOpportunity> onToggleVolunteer;

  const _CommunityVolunteerTab({
    required this.opportunities,
    required this.onToggleVolunteer,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 18),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFCB1010), Color(0xFFE16F20)],
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volunteer Recruitment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Join barangay programs, reserve volunteer slots, and coordinate directly with the assigned desk.',
                style: TextStyle(
                  color: Color(0xFFFFE8E8),
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...opportunities.map((opportunity) {
          final progress = opportunity.targetVolunteers == 0
              ? 0.0
              : (opportunity.joinedVolunteers / opportunity.targetVolunteers)
                  .clamp(0.0, 1.0);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE4E7F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
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
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.volunteer_activism_rounded,
                        color: Color(0xFFCB1010),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opportunity.title,
                            style: const TextStyle(
                              color: Color(0xFF2E344C),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${opportunity.category} | ${_relativeTime(opportunity.scheduleAt)}',
                            style: const TextStyle(
                              color: Color(0xFFCB1010),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  opportunity.description,
                  style: const TextStyle(
                    color: Color(0xFF5C637E),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFF1F3F8),
                  color: const Color(0xFFCB1010),
                  borderRadius: BorderRadius.circular(999),
                ),
                const SizedBox(height: 8),
                Text(
                  '${opportunity.joinedVolunteers}/${opportunity.targetVolunteers} volunteers confirmed | ${opportunity.remainingSlots} slots left',
                  style: const TextStyle(
                    color: Color(0xFF6A728D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(opportunity.venue),
                      avatar: const Icon(Icons.place_outlined, size: 18),
                    ),
                    Chip(
                      label: Text(opportunity.benefit),
                      avatar: const Icon(Icons.workspace_premium_outlined, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showVolunteerDetailsSheet(
                          context,
                          opportunity: opportunity,
                        ),
                        icon: const Icon(Icons.info_outline_rounded),
                        label: const Text('Program Details'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => onToggleVolunteer(opportunity),
                        style: FilledButton.styleFrom(
                          backgroundColor: opportunity.joinedByMe
                              ? const Color(0xFF2D7D46)
                              : const Color(0xFFCB1010),
                        ),
                        icon: Icon(
                          opportunity.joinedByMe
                              ? Icons.check_circle_rounded
                              : Icons.group_add_rounded,
                        ),
                        label: Text(
                          opportunity.joinedByMe ? 'Joined' : 'Join Program',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _CommunityComment {
  final String author;
  final String message;
  final DateTime postedAt;
  final bool isMine;

  const _CommunityComment({
    required this.author,
    required this.message,
    required this.postedAt,
    this.isMine = false,
  });

  factory _CommunityComment.seed(int index, DateTime postTime) {
    final seededMessages = [
      'Thanks for the update.',
      'Will share this with our neighbors.',
      'Copy. We will coordinate with the team.',
      'Noted. Keep us posted on next steps.',
    ];
    return _CommunityComment(
      author: 'Resident ${index + 1}',
      message: seededMessages[index % seededMessages.length],
      postedAt: postTime.add(Duration(minutes: (index + 1) * 6)),
    );
  }
}

Future<String?> _promptCommunityComment(BuildContext context) async {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      builder: (_) => const _CommunityCommentComposerPage(),
    ),
  );
}

class _CommunityCommentComposerPage extends StatefulWidget {
  const _CommunityCommentComposerPage();

  @override
  State<_CommunityCommentComposerPage> createState() =>
      _CommunityCommentComposerPageState();
}

class _CommunityCommentComposerPageState
    extends State<_CommunityCommentComposerPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Comment'),
        backgroundColor: const Color(0xFFF7F8FF),
        foregroundColor: const Color(0xFF2F3248),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controller,
                  minLines: 4,
                  maxLines: 8,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Write your comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Please enter at least 2 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFCB1010),
                        ),
                        child: const Text('Post'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> _promptEditCommunityPost(
  BuildContext context, {
  required String initialMessage,
}) async {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      builder: (_) => _CommunityEditPostPage(initialMessage: initialMessage),
    ),
  );
}

class _CommunityEditPostPage extends StatefulWidget {
  final String initialMessage;

  const _CommunityEditPostPage({
    required this.initialMessage,
  });

  @override
  State<_CommunityEditPostPage> createState() => _CommunityEditPostPageState();
}

class _CommunityEditPostPageState extends State<_CommunityEditPostPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialMessage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        backgroundColor: const Color(0xFFF7F8FF),
        foregroundColor: const Color(0xFF2F3248),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controller,
                  minLines: 6,
                  maxLines: 12,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Update your post...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 5) {
                      return 'Please enter at least 5 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFCB1010),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _relativeTime(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
  if (diff.inHours < 24) return '${diff.inHours} hours ago';
  return '${diff.inDays} days ago';
}

Widget _sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
    ),
  );
}

Widget _goTile(BuildContext context, String label, Widget page) {
  return Card(
    child: ListTile(
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    ),
  );
}

void _showFeature(
  BuildContext context,
  String message, {
  _ToastTone tone = _ToastTone.info,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  final (background, icon) = switch (tone) {
    _ToastTone.success => (const Color(0xFF166534), Icons.check_circle_rounded),
    _ToastTone.warning => (const Color(0xFFB45309), Icons.warning_amber_rounded),
    _ToastTone.error => (const Color(0xFFB42318), Icons.error_outline_rounded),
    _ToastTone.info => (const Color(0xFF1F3A8A), Icons.info_outline_rounded),
  };
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: background,
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}

void _showSuccess(BuildContext context, String message) {
  _showFeature(context, message, tone: _ToastTone.success);
}

void _showWarning(BuildContext context, String message) {
  _showFeature(context, message, tone: _ToastTone.warning);
}

void _showError(BuildContext context, String message) {
  _showFeature(context, message, tone: _ToastTone.error);
}

class _StepTabs extends StatelessWidget {
  final String active;
  const _StepTabs({required this.active});

  @override
  Widget build(BuildContext context) {
    String mark(String label) => label == active ? '___' : '__';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Address ${mark('Address')}'),
        Text('Details ${mark('Details')}'),
        Text('Photo ${mark('Photo')}'),
      ],
    );
  }
}
