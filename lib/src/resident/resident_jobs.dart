part of barangaymo_app;

class _JobsFetchResult {
  final bool success;
  final String message;
  final List<_ResidentJobData> jobs;

  const _JobsFetchResult({
    required this.success,
    required this.message,
    this.jobs = const <_ResidentJobData>[],
  });
}

class _JobsPublishResult {
  final bool success;
  final String message;
  final _ResidentJobData? job;

  const _JobsPublishResult({
    required this.success,
    required this.message,
    this.job,
  });
}

class _JobHunterFetchResult {
  final bool success;
  final String message;
  final List<_ResidentTalentPostData> profiles;

  const _JobHunterFetchResult({
    required this.success,
    required this.message,
    this.profiles = const <_ResidentTalentPostData>[],
  });
}

class _JobHunterPublishResult {
  final bool success;
  final String message;
  final _ResidentTalentPostData? profile;

  const _JobHunterPublishResult({
    required this.success,
    required this.message,
    this.profile,
  });
}

class _InvitationsFetchResult {
  final bool success;
  final String message;
  final List<_ResidentJobInvitationData> invitations;

  const _InvitationsFetchResult({
    required this.success,
    required this.message,
    this.invitations = const <_ResidentJobInvitationData>[],
  });
}

class _InvitationSendResult {
  final bool success;
  final String message;
  final _ResidentJobInvitationData? invitation;

  const _InvitationSendResult({
    required this.success,
    required this.message,
    this.invitation,
  });
}

class _ApplicationsFetchResult {
  final bool success;
  final String message;
  final List<_ResidentJobApplicationData> applications;

  const _ApplicationsFetchResult({
    required this.success,
    required this.message,
    this.applications = const <_ResidentJobApplicationData>[],
  });
}

class _ApplicationSendResult {
  final bool success;
  final String message;
  final _ResidentJobApplicationData? application;

  const _ApplicationSendResult({
    required this.success,
    required this.message,
    this.application,
  });
}

class _SavedJobsFetchResult {
  final bool success;
  final String message;
  final Set<String> savedKeys;

  const _SavedJobsFetchResult({
    required this.success,
    required this.message,
    this.savedKeys = const <String>{},
  });
}

class _SavedToggleResult {
  final bool success;
  final String message;
  final bool? saved;

  const _SavedToggleResult({
    required this.success,
    required this.message,
    this.saved,
  });
}

class _JobsApi {
  _JobsApi._();
  static final _JobsApi instance = _JobsApi._();
  static const Duration _requestTimeout = Duration(seconds: 6);

  Future<_JobsFetchResult> fetchHiringPosts() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _JobsFetchResult(
        success: false,
        message: 'Please log in again to load hiring posts.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('jobs/hiring-posts')) {
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
          final rawJobs = body['jobs'];
          if (rawJobs is! List) {
            return const _JobsFetchResult(
              success: false,
              message: 'Jobs payload is invalid.',
            );
          }
          final out = <_ResidentJobData>[];
          for (final item in rawJobs) {
            if (item is! Map<String, dynamic>) {
              continue;
            }
            out.add(_mapJob(item));
          }
          return _JobsFetchResult(
            success: true,
            message: out.isEmpty ? 'No hiring posts yet.' : 'Hiring posts loaded.',
            jobs: out,
          );
        }
        return _JobsFetchResult(
          success: false,
          message: _extractApiMessage(body, fallback: 'Unable to load hiring posts.'),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _JobsFetchResult(
        success: false,
        message: 'Loading hiring posts timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _JobsFetchResult(
        success: false,
        message: 'Cannot connect to server to load hiring posts.',
      );
    }
    return const _JobsFetchResult(
      success: false,
      message: 'Hiring posts endpoint is not available yet.',
    );
  }

  Future<_JobsPublishResult> createHiringPost({
    required String title,
    required String company,
    required String location,
    required String salary,
    required String schedule,
    required String requirements,
    required String postedBy,
    required bool urgent,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _JobsPublishResult(
        success: false,
        message: 'Please log in again before publishing a hiring post.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final payload = jsonEncode({
      'title': title,
      'company': company,
      'location': location,
      'salary': salary,
      'schedule': schedule,
      'requirements': requirements,
      'posted_by': postedBy,
      'urgent': urgent,
    });

    for (final endpoint in _AuthApi.instance._endpointCandidates('jobs/hiring-posts')) {
      try {
        final response = await http
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
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawJob = body['job'];
          if (rawJob is! Map<String, dynamic>) {
            return _JobsPublishResult(
              success: false,
              message: _extractApiMessage(
                body,
                fallback: 'Hiring post saved but no payload returned.',
              ),
            );
          }
          return _JobsPublishResult(
            success: true,
            message: _extractApiMessage(
              body,
              fallback: 'Hiring post published. Residents are notified.',
            ),
            job: _mapJob(rawJob),
          );
        }
        return _JobsPublishResult(
          success: false,
          message: _extractApiMessage(body, fallback: 'Unable to publish hiring post.'),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _JobsPublishResult(
        success: false,
        message: 'Publish request timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _JobsPublishResult(
        success: false,
        message: 'Cannot connect to server to publish hiring post.',
      );
    }
    return const _JobsPublishResult(
      success: false,
      message: 'Hiring post endpoint is not available yet.',
    );
  }

  Future<_JobHunterFetchResult> fetchHunterProfiles() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _JobHunterFetchResult(
        success: false,
        message: 'Please log in again to load job hunter profiles.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    for (final endpoint in _AuthApi.instance._endpointCandidates('jobs/hunter-profiles')) {
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
          final rawProfiles = body['profiles'];
          if (rawProfiles is! List) {
            return const _JobHunterFetchResult(
              success: false,
              message: 'Job hunter profiles payload is invalid.',
            );
          }
          final out = <_ResidentTalentPostData>[];
          for (final item in rawProfiles) {
            if (item is! Map<String, dynamic>) {
              continue;
            }
            out.add(_mapHunterProfile(item));
          }
          return _JobHunterFetchResult(
            success: true,
            message: out.isEmpty
                ? 'No job hunter profiles yet.'
                : 'Job hunter profiles loaded.',
            profiles: out,
          );
        }
        return _JobHunterFetchResult(
          success: false,
          message: _extractApiMessage(
            body,
            fallback: 'Unable to load job hunter profiles.',
          ),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _JobHunterFetchResult(
        success: false,
        message: 'Loading job hunter profiles timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _JobHunterFetchResult(
        success: false,
        message: 'Cannot connect to server to load job hunter profiles.',
      );
    }
    return const _JobHunterFetchResult(
      success: false,
      message: 'Job hunter profiles endpoint is not available yet.',
    );
  }

  Future<_JobHunterPublishResult> createHunterProfile({
    required String fullName,
    required String mobileNumber,
    required String desiredJob,
    required String skills,
    required String preferredSetup,
    required String expectedSalary,
    required String barangayZone,
    required bool availableNow,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _JobHunterPublishResult(
        success: false,
        message: 'Please log in again before publishing your profile.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final payload = jsonEncode({
      'full_name': fullName,
      'mobile': mobileNumber,
      'contact_number': mobileNumber,
      'desired_job': desiredJob,
      'skills': skills,
      'preferred_setup': preferredSetup,
      'expected_salary': expectedSalary,
      'barangay_zone': barangayZone,
      'available_now': availableNow,
    });

    for (final endpoint in _AuthApi.instance._endpointCandidates('jobs/hunter-profiles')) {
      try {
        final response = await http
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
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode == 404) {
          continue;
        }
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final rawProfile = body['profile'];
          if (rawProfile is! Map<String, dynamic>) {
            return _JobHunterPublishResult(
              success: false,
              message: _extractApiMessage(
                body,
                fallback: 'Job hunter profile saved but no payload returned.',
              ),
            );
          }
          return _JobHunterPublishResult(
            success: true,
            message: _extractApiMessage(
              body,
              fallback: 'Job hunter profile published.',
            ),
            profile: _mapHunterProfile(
              rawProfile,
              fallbackMobile: mobileNumber,
            ),
          );
        }
        return _JobHunterPublishResult(
          success: false,
          message: _extractApiMessage(
            body,
            fallback: 'Unable to publish job hunter profile.',
          ),
        );
      } on TimeoutException {
        sawTimeout = true;
      } catch (_) {
        sawConnectionError = true;
      }
    }

    if (sawTimeout) {
      return const _JobHunterPublishResult(
        success: false,
        message: 'Publish request timed out. Please retry.',
      );
    }
    if (sawConnectionError) {
      return const _JobHunterPublishResult(
        success: false,
        message: 'Cannot connect to server to publish job hunter profile.',
      );
    }
    return const _JobHunterPublishResult(
      success: false,
      message: 'Job hunter profile endpoint is not available yet.',
    );
  }

  Future<_InvitationsFetchResult> fetchInvitations() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _InvitationsFetchResult(
        success: false,
        message: 'Please log in again to load invitations.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>[
      'jobs/invitations',
      'invitations',
      'jobs/invites',
      'invites',
    ];

    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
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
            final rawList = body['invitations'] ?? body['invites'] ?? body['data'];
            if (rawList is! List) {
              return const _InvitationsFetchResult(
                success: false,
                message: 'Invitations payload is invalid.',
              );
            }
            final out = <_ResidentJobInvitationData>[];
            for (final item in rawList) {
              if (item is! Map<String, dynamic>) {
                continue;
              }
              final mapped = _mapInvitation(item);
              if (mapped != null) {
                out.add(mapped);
              }
            }
            return _InvitationsFetchResult(
              success: true,
              message: 'Invitations loaded.',
              invitations: out,
            );
          }
          return _InvitationsFetchResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to load invitations.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _InvitationsFetchResult(
        success: false,
        message: 'Loading invitations timed out.',
      );
    }
    if (sawConnectionError) {
      return const _InvitationsFetchResult(
        success: false,
        message: 'Cannot connect to server to load invitations.',
      );
    }
    return const _InvitationsFetchResult(
      success: false,
      message: 'Invitations endpoint is not available yet.',
    );
  }

  Future<_InvitationSendResult> sendInvitation({
    required _ResidentTalentPostData talent,
    required String message,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _InvitationSendResult(
        success: false,
        message: 'Please log in again before sending an invitation.',
      );
    }
    final inviterName = (_currentResidentProfile?.displayName ?? '').trim();
    final inviterMobile = (_currentResidentProfile?.mobile ?? '').trim();
    final payload = jsonEncode({
      'talent_user_id': int.tryParse(talent.userId.trim()),
      'talent_profile_id': int.tryParse(talent.profileId.trim()),
      'talent_name': talent.fullName.trim(),
      'talent_mobile': talent.mobileNumber.trim(),
      'talent_desired_job': talent.desiredJob.trim(),
      'inviter_name': inviterName,
      'inviter_mobile': inviterMobile,
      'message': message.trim(),
    });

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>[
      'jobs/invitations',
      'invitations',
      'jobs/invites',
      'invites',
    ];

    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http
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
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          final body = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final rawInvite = body['invitation'] ?? body['invite'] ?? body['data'];
            _ResidentJobInvitationData? mapped;
            if (rawInvite is Map<String, dynamic>) {
              mapped = _mapInvitation(rawInvite);
            }
            return _InvitationSendResult(
              success: true,
              message: _extractApiMessage(
                body,
                fallback: 'Invitation sent successfully.',
              ),
              invitation: mapped,
            );
          }
          return _InvitationSendResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to send invitation.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _InvitationSendResult(
        success: false,
        message: 'Sending invitation timed out.',
      );
    }
    if (sawConnectionError) {
      return const _InvitationSendResult(
        success: false,
        message: 'Cannot connect to server to send invitation.',
      );
    }
    return const _InvitationSendResult(
      success: false,
      message: 'Invitations endpoint is not available yet.',
    );
  }

  Future<_ApplicationsFetchResult> fetchApplications() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ApplicationsFetchResult(
        success: false,
        message: 'Please log in again to load applications.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>[
      'jobs/applications',
      'applications',
      'jobs/submissions',
      'submissions',
    ];

    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
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
            final rawList =
                body['applications'] ?? body['submissions'] ?? body['data'];
            if (rawList is! List) {
              return const _ApplicationsFetchResult(
                success: false,
                message: 'Applications payload is invalid.',
              );
            }
            final out = <_ResidentJobApplicationData>[];
            for (final item in rawList) {
              if (item is! Map<String, dynamic>) {
                continue;
              }
              final mapped = _mapApplication(item);
              if (mapped != null) {
                out.add(mapped);
              }
            }
            return _ApplicationsFetchResult(
              success: true,
              message: 'Applications loaded.',
              applications: out,
            );
          }
          return _ApplicationsFetchResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to load applications.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _ApplicationsFetchResult(
        success: false,
        message: 'Loading applications timed out.',
      );
    }
    if (sawConnectionError) {
      return const _ApplicationsFetchResult(
        success: false,
        message: 'Cannot connect to server to load applications.',
      );
    }
    return const _ApplicationsFetchResult(
      success: false,
      message: 'Applications endpoint is not available yet.',
    );
  }

  Future<_ApplicationSendResult> sendApplication({
    required _ResidentJobData job,
    required String applicantName,
    required String mobileNumber,
    required String coverLetter,
    required String attachmentName,
    String attachmentBase64 = '',
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _ApplicationSendResult(
        success: false,
        message: 'Please log in again before submitting application.',
      );
    }

    final payload = jsonEncode({
      'job_id': int.tryParse(job.id),
      'job_title': job.title.trim(),
      'company': job.company.trim(),
      'posted_by': job.postedBy.trim(),
      'applicant_name': applicantName.trim(),
      'mobile_number': mobileNumber.trim(),
      'cover_letter': coverLetter.trim(),
      'attachment_name': attachmentName.trim(),
      if (attachmentBase64.trim().isNotEmpty)
        'attachment_base64': attachmentBase64.trim(),
    });

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>[
      'jobs/applications',
      'applications',
      'jobs/submissions',
      'submissions',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http
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
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          final body = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final rawItem = body['application'] ?? body['submission'] ?? body['data'];
            _ResidentJobApplicationData? mapped;
            if (rawItem is Map<String, dynamic>) {
              mapped = _mapApplication(rawItem);
            }
            return _ApplicationSendResult(
              success: true,
              message: _extractApiMessage(
                body,
                fallback: 'Application submitted successfully.',
              ),
              application: mapped,
            );
          }
          return _ApplicationSendResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to submit application.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _ApplicationSendResult(
        success: false,
        message: 'Submitting application timed out.',
      );
    }
    if (sawConnectionError) {
      return const _ApplicationSendResult(
        success: false,
        message: 'Cannot connect to server to submit application.',
      );
    }
    return const _ApplicationSendResult(
      success: false,
      message: 'Applications endpoint is not available yet.',
    );
  }

  Future<_SavedJobsFetchResult> fetchSavedJobs() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _SavedJobsFetchResult(
        success: false,
        message: 'Please log in again to load saved jobs.',
      );
    }

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>['jobs/saved', 'saved-jobs', 'jobs/saved-jobs', 'saved'];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
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
            final rawList = body['saved_jobs'] ?? body['saved'] ?? body['data'];
            if (rawList is! List) {
              return const _SavedJobsFetchResult(
                success: false,
                message: 'Saved jobs payload is invalid.',
              );
            }
            final keys = <String>{};
            for (final item in rawList) {
              if (item is! Map<String, dynamic>) {
                continue;
              }
              final key = _savedJobKeyFromRaw(item);
              if (key.isNotEmpty) {
                keys.add(key);
              }
            }
            return _SavedJobsFetchResult(
              success: true,
              message: 'Saved jobs loaded.',
              savedKeys: keys,
            );
          }
          return _SavedJobsFetchResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to load saved jobs.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _SavedJobsFetchResult(
        success: false,
        message: 'Loading saved jobs timed out.',
      );
    }
    if (sawConnectionError) {
      return const _SavedJobsFetchResult(
        success: false,
        message: 'Cannot connect to server to load saved jobs.',
      );
    }
    return const _SavedJobsFetchResult(
      success: false,
      message: 'Saved jobs endpoint is not available yet.',
    );
  }

  Future<_SavedToggleResult> toggleSavedJob(_ResidentJobData job) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _SavedToggleResult(
        success: false,
        message: 'Please log in again before saving jobs.',
      );
    }

    final payload = jsonEncode({
      'job_id': int.tryParse(job.id),
      'job_title': job.title.trim(),
      'company': job.company.trim(),
    });

    var sawTimeout = false;
    var sawConnectionError = false;
    final paths = <String>[
      'jobs/saved/toggle',
      'saved-jobs/toggle',
      'jobs/saved',
      'saved',
    ];
    for (final path in paths) {
      for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
        try {
          final response = await http
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
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          final body = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};
          if (response.statusCode == 404) {
            continue;
          }
          if (response.statusCode >= 200 && response.statusCode < 300) {
            final savedRaw = body['saved'];
            bool? saved;
            if (savedRaw is bool) {
              saved = savedRaw;
            } else if (savedRaw is num) {
              saved = savedRaw != 0;
            } else if (savedRaw is String) {
              final normalized = savedRaw.trim().toLowerCase();
              if (normalized == 'true' || normalized == '1') {
                saved = true;
              } else if (normalized == 'false' || normalized == '0') {
                saved = false;
              }
            }
            return _SavedToggleResult(
              success: true,
              message: _extractApiMessage(body, fallback: 'Saved jobs updated.'),
              saved: saved,
            );
          }
          return _SavedToggleResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to update saved job.'),
          );
        } on TimeoutException {
          sawTimeout = true;
        } catch (_) {
          sawConnectionError = true;
        }
      }
    }

    if (sawTimeout) {
      return const _SavedToggleResult(
        success: false,
        message: 'Updating saved job timed out.',
      );
    }
    if (sawConnectionError) {
      return const _SavedToggleResult(
        success: false,
        message: 'Cannot connect to server to update saved job.',
      );
    }
    return const _SavedToggleResult(
      success: false,
      message: 'Saved jobs endpoint is not available yet.',
    );
  }

  String _savedJobKeyFromRaw(Map<String, dynamic> raw) {
    String read(String key) {
      final value = raw[key];
      if (value == null) {
        return '';
      }
      if (value is String) {
        return value.trim();
      }
      return value.toString().trim();
    }

    final id = read('job_id');
    if (id.isNotEmpty) {
      return 'id:$id';
    }
    final title = read('job_title');
    final company = read('company');
    if (title.isEmpty || company.isEmpty) {
      return '';
    }
    return '$title|$company';
  }

  _ResidentJobData _mapJob(Map<String, dynamic> raw) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
      }
      return fallback;
    }

    String dynamicId(dynamic value) {
      if (value == null) {
        return '';
      }
      if (value is String) {
        return value.trim();
      }
      return value.toString();
    }

    return _ResidentJobData(
      id: dynamicId(raw['id']),
      title: read('title', fallback: 'Hiring Role'),
      company: read('company', fallback: 'Barangay Employer'),
      location: read('location', fallback: _residentLocationSummary(fallback: 'Barangay')),
      salary: read('salary', fallback: 'Negotiable'),
      schedule: read('schedule', fallback: 'Full-time'),
      postedBy: read('posted_by', fallback: 'Barangay Employer'),
      requirements: read('requirements', fallback: 'See job details'),
      urgent: raw['urgent'] == true || raw['urgent'] == 1 || raw['urgent'] == '1',
    );
  }

  _ResidentTalentPostData _mapHunterProfile(
    Map<String, dynamic> raw, {
    String fallbackMobile = '',
  }) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
      }
      return fallback;
    }

    String dynamicId(dynamic value) {
      if (value == null) {
        return '';
      }
      if (value is String) {
        return value.trim();
      }
      return value.toString();
    }

    final fullName = read('full_name', fallback: 'Resident');
    var mobileNumber = read(
      'mobile',
      fallback: read(
        'contact_number',
        fallback: read('phone', fallback: fallbackMobile.trim()),
      ),
    );
    if (mobileNumber.isEmpty) {
      final currentName = (_currentResidentProfile?.displayName ?? '')
          .trim()
          .toLowerCase();
      if (currentName.isNotEmpty && fullName.trim().toLowerCase() == currentName) {
        mobileNumber = _currentResidentProfile?.mobile ?? '';
      }
    }

    return _ResidentTalentPostData(
      profileId: dynamicId(raw['id']),
      userId: dynamicId(raw['user_id']),
      fullName: fullName,
      mobileNumber: mobileNumber,
      desiredJob: read('desired_job', fallback: 'Job seeker'),
      skills: read('skills', fallback: 'General skills'),
      preferredSetup: read('preferred_setup', fallback: 'On-site'),
      expectedSalary: read('expected_salary', fallback: 'Negotiable'),
      barangayZone: read('barangay_zone', fallback: 'Zone 1'),
      availableNow:
          raw['available_now'] == true ||
          raw['available_now'] == 1 ||
          raw['available_now'] == '1',
    );
  }

  _ResidentJobApplicationData? _mapApplication(Map<String, dynamic> raw) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value == null) {
        return fallback;
      }
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
        return fallback;
      }
      final asText = value.toString().trim();
      return asText.isEmpty ? fallback : asText;
    }

    final jobTitle = read('job_title', fallback: read('title'));
    final company = read('company');
    if (jobTitle.isEmpty || company.isEmpty) {
      return null;
    }
    final submittedRaw = read(
      'submitted_at',
      fallback: read('created_at', fallback: read('createdAt')),
    );
    final submittedAt = DateTime.tryParse(submittedRaw) ?? DateTime.now();

    return _ResidentJobApplicationData(
      id: read('id'),
      jobId: read('job_id'),
      jobTitle: jobTitle,
      company: company,
      postedBy: read('posted_by'),
      applicantName: read('applicant_name', fallback: read('name')),
      mobileNumber: read('mobile_number', fallback: read('applicant_mobile')),
      coverLetter: read('cover_letter', fallback: read('message')),
      attachmentName: read('attachment_name'),
      attachmentPath: read('attachment_path'),
      attachmentBase64: read('attachment_base64'),
      submittedAt: submittedAt,
      status: read('status', fallback: 'Submitted'),
    );
  }

  _ResidentJobInvitationData? _mapInvitation(Map<String, dynamic> raw) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value == null) {
        return fallback;
      }
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
        return fallback;
      }
      final asText = value.toString().trim();
      return asText.isEmpty ? fallback : asText;
    }

    final id = read(
      'id',
      fallback: read('uuid', fallback: 'inv-${DateTime.now().microsecondsSinceEpoch}'),
    );
    final talentName = read('talent_name', fallback: read('job_hunter_name'));
    if (talentName.isEmpty) {
      return null;
    }
    final createdAtRaw = read('created_at', fallback: read('createdAt'));
    final createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    return _ResidentJobInvitationData(
      id: id,
      inviterUserId: read('inviter_user_id'),
      talentUserId: read('talent_user_id'),
      talentProfileId: read('talent_profile_id'),
      talentName: talentName,
      talentMobile: read('talent_mobile', fallback: read('job_hunter_mobile')),
      talentDesiredJob: read('talent_desired_job', fallback: read('desired_job')),
      inviterName: read('inviter_name'),
      inviterMobile: read('inviter_mobile'),
      message: read('message'),
      createdAt: createdAt,
      status: read('status', fallback: 'Pending'),
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
}

class ResidentJobsPage extends StatefulWidget {
  const ResidentJobsPage({super.key});

  @override
  State<ResidentJobsPage> createState() => _ResidentJobsPageState();
}

class _ResidentJobsPageState extends State<ResidentJobsPage> {
  static const _filters = ['All', 'Full-time', 'Part-time', 'Contract'];

  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    unawaited(_ResidentJobsHub.loadSavedJobsFromStorage());
    unawaited(_ResidentJobsHub.loadApplicationsFromStorage());
    unawaited(_ResidentJobsHub.loadOwnedJobsFromStorage());
    unawaited(_ResidentJobsHub.loadInvitationsFromStorage());
    unawaited(_syncSavedJobsFromApi(showToast: false));
    unawaited(_syncApplicationsFromApi(showToast: false));
    unawaited(_syncInvitationsFromApi(showToast: false));
    unawaited(_syncJobsBoardFromApi(showToast: false));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _syncJobsBoardFromApi({bool showToast = false}) async {
    final hiringResult = await _JobsApi.instance.fetchHiringPosts();
    final hunterResult = await _JobsApi.instance.fetchHunterProfiles();
    if (!mounted) {
      return;
    }
    if (hiringResult.success) {
      _ResidentJobsHub.replaceHiringPosts(hiringResult.jobs);
    }
    if (hunterResult.success) {
      _ResidentJobsHub.replaceTalentPosts(hunterResult.profiles);
    }
    if (showToast) {
      final allGood = hiringResult.success && hunterResult.success;
      final message = allGood
          ? 'Jobs board updated.'
          : !hiringResult.success
          ? hiringResult.message
          : hunterResult.message;
      _showFeature(
        context,
        message,
        tone: allGood ? _ToastTone.success : _ToastTone.warning,
      );
    }
  }

  List<_ResidentJobData> _filteredJobs() {
    final q = _searchController.text.trim().toLowerCase();
    return _ResidentJobsHub.jobs.where((job) {
      final byFilter =
          _selectedFilter == 'All' ||
          job.schedule.toLowerCase() == _selectedFilter.toLowerCase();
      final haystack =
          '${job.title} ${job.company} ${job.location} ${job.schedule} ${job.requirements}'
              .toLowerCase();
      final byQuery = q.isEmpty || haystack.contains(q);
      return byFilter && byQuery;
    }).toList();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD7DEF0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD7DEF0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF4A64FF), width: 1.3),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(hint),
    );
  }

  void _openPostHiringSheet(BuildContext context) {
    final pageContext = this.context;
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final locationController = TextEditingController();
    final salaryController = TextEditingController();
    final requirementsController = TextEditingController();
    final postedByController = TextEditingController(
      text: _currentResidentProfile?.displayName ?? 'Barangay Employer',
    );
    String schedule = 'Full-time';
    bool urgent = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFF9FAFF),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3049C7), Color(0xFF4E6DF2)],
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.post_add_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'Post Hiring Job',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _field(titleController, 'Job title'),
                      const SizedBox(height: 8),
                      _field(companyController, 'Company / Office'),
                      const SizedBox(height: 8),
                      _field(locationController, 'Location'),
                      const SizedBox(height: 8),
                      _field(salaryController, 'Salary / Offer'),
                      const SizedBox(height: 8),
                      _field(
                        requirementsController,
                        'Skills and requirements',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      _field(postedByController, 'Posted by'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: schedule,
                        decoration: _inputDecoration('Schedule'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Full-time',
                            child: Text('Full-time'),
                          ),
                          DropdownMenuItem(
                            value: 'Part-time',
                            child: Text('Part-time'),
                          ),
                          DropdownMenuItem(
                            value: 'Contract',
                            child: Text('Contract'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setModal(() => schedule = value);
                        },
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: urgent,
                        onChanged: (value) => setModal(() => urgent = value),
                        title: const Text(
                          'Mark this post as urgent hiring',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () async {
                            final title = titleController.text.trim();
                            final company = companyController.text.trim();
                            final location = locationController.text.trim();
                            final salary = salaryController.text.trim();
                            final requirements = requirementsController.text
                                .trim();
                            final postedBy = postedByController.text.trim();

                            if (title.isEmpty ||
                                company.isEmpty ||
                                location.isEmpty ||
                                salary.isEmpty ||
                                requirements.isEmpty ||
                                postedBy.isEmpty) {
                                _showFeature(
                                  pageContext,
                                  'Complete all fields before posting.',
                                );
                                return;
                              }

                            final result = await _JobsApi.instance
                                .createHiringPost(
                                  title: title,
                                  company: company,
                                  location: location,
                                  salary: salary,
                                  schedule: schedule,
                                  requirements: requirements,
                                  postedBy: postedBy,
                                  urgent: urgent,
                                );
                            if (!this.context.mounted) {
                              return;
                            }
                            if (!result.success || result.job == null) {
                              _showFeature(
                                pageContext,
                                result.message,
                                tone: _ToastTone.error,
                              );
                              return;
                            }
                            _ResidentJobsHub.mergeHiringPosts([result.job!]);
                            _ResidentJobsHub.markOwnedJob(result.job!);
                            FocusScope.of(sheetContext).unfocus();
                            if (sheetContext.mounted) {
                              Navigator.of(sheetContext).pop();
                            }
                            await Future<void>.delayed(
                              const Duration(milliseconds: 220),
                            );
                            if (!this.context.mounted) {
                              return;
                            }
                            _showFeature(pageContext, result.message);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF3758DD),
                          ),
                          icon: const Icon(Icons.publish_rounded),
                          label: const Text('Publish Hiring Post'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _disposeSheetControllers([
        titleController,
        companyController,
        locationController,
        salaryController,
        requirementsController,
        postedByController,
      ]);
    });
  }

  Future<void> _syncInvitationsFromApi({bool showToast = false}) async {
    final result = await _JobsApi.instance.fetchInvitations();
    if (!mounted) {
      return;
    }
    if (result.success) {
      _ResidentJobsHub.replaceInvitations(result.invitations);
      if (showToast) {
        _showFeature(
          context,
          result.message,
          tone: _ToastTone.success,
        );
      }
      return;
    }
    if (showToast) {
      _showFeature(context, result.message, tone: _ToastTone.warning);
    }
  }

  Future<void> _syncApplicationsFromApi({bool showToast = false}) async {
    final result = await _JobsApi.instance.fetchApplications();
    if (!mounted) {
      return;
    }
    if (result.success) {
      _ResidentJobsHub.replaceApplications(result.applications);
      if (showToast) {
        _showFeature(
          context,
          result.message,
          tone: _ToastTone.success,
        );
      }
      return;
    }
    if (showToast) {
      _showFeature(context, result.message, tone: _ToastTone.warning);
    }
  }

  Future<void> _syncSavedJobsFromApi({bool showToast = false}) async {
    final result = await _JobsApi.instance.fetchSavedJobs();
    if (!mounted) {
      return;
    }
    if (result.success) {
      _ResidentJobsHub.replaceSavedJobKeys(result.savedKeys);
      if (showToast) {
        _showFeature(context, result.message, tone: _ToastTone.success);
      }
      return;
    }
    if (showToast) {
      _showFeature(context, result.message, tone: _ToastTone.warning);
    }
  }

  void _disposeSheetControllers(List<TextEditingController> controllers) {
    // Dispose after close animation so text-field listeners detach first.
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        for (final controller in controllers) {
          controller.dispose();
        }
      }),
    );
  }

  void _openJobHunterSheet(BuildContext context) {
    final pageContext = this.context;
    final nameController = TextEditingController();
    final desiredController = TextEditingController();
    final skillsController = TextEditingController();
    final salaryController = TextEditingController();
    final zoneController = TextEditingController(text: 'Zone 1');
    String setup = 'On-site';
    bool availableNow = true;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFFDF9FF),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF6A3ACB), Color(0xFF9C5BE5)],
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.badge_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'Post Job Hunter Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _field(nameController, 'Full name / display name'),
                      const SizedBox(height: 8),
                      _field(desiredController, 'Desired job role'),
                      const SizedBox(height: 8),
                      _field(skillsController, 'Skills (comma separated)'),
                      const SizedBox(height: 8),
                      _field(salaryController, 'Expected salary'),
                      const SizedBox(height: 8),
                      _field(zoneController, 'Barangay zone'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: setup,
                        decoration: _inputDecoration('Preferred setup'),
                        items: const [
                          DropdownMenuItem(
                            value: 'On-site',
                            child: Text('On-site'),
                          ),
                          DropdownMenuItem(
                            value: 'Remote',
                            child: Text('Remote'),
                          ),
                          DropdownMenuItem(
                            value: 'Field-based',
                            child: Text('Field-based'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setModal(() => setup = value);
                        },
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: availableNow,
                        onChanged: (value) =>
                            setModal(() => availableNow = value),
                        title: const Text(
                          'Available to start immediately',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () async {
                            final fullName = nameController.text.trim();
                            final desiredJob = desiredController.text.trim();
                            final skills = skillsController.text.trim();
                            final expectedSalary = salaryController.text.trim();
                            final zone = zoneController.text.trim();
                            if (fullName.isEmpty ||
                                desiredJob.isEmpty ||
                                skills.isEmpty ||
                                expectedSalary.isEmpty ||
                                zone.isEmpty) {
                                _showFeature(
                                  pageContext,
                                  'Complete all fields before posting.',
                                );
                                return;
                              }
                            final result = await _JobsApi.instance
                                .createHunterProfile(
                                  fullName: fullName,
                                  mobileNumber:
                                      _currentResidentProfile?.mobile ?? '',
                                  desiredJob: desiredJob,
                                  skills: skills,
                                  preferredSetup: setup,
                                  expectedSalary: expectedSalary,
                                  barangayZone: zone,
                                  availableNow: availableNow,
                                );
                            if (!this.context.mounted) {
                              return;
                            }
                            if (!result.success || result.profile == null) {
                              _showFeature(
                                pageContext,
                                result.message,
                                tone: _ToastTone.error,
                              );
                              return;
                            }
                            _ResidentJobsHub.mergeTalentPosts([result.profile!]);
                            FocusScope.of(sheetContext).unfocus();
                            if (sheetContext.mounted) {
                              Navigator.of(sheetContext).pop();
                            }
                            await Future<void>.delayed(
                              const Duration(milliseconds: 220),
                            );
                            if (!this.context.mounted) {
                              return;
                            }
                            _showFeature(pageContext, result.message);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF7E46D7),
                          ),
                          icon: const Icon(Icons.rocket_launch_rounded),
                          label: const Text('Publish Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _disposeSheetControllers([
        nameController,
        desiredController,
        skillsController,
        salaryController,
        zoneController,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final clampedMedia = media.copyWith(
      textScaler: const TextScaler.linear(1.0),
    );

    final content = MediaQuery(
      data: clampedMedia,
      child: Material(
        color: Colors.transparent,
        child: ValueListenableBuilder<int>(
          valueListenable: _ResidentJobsHub.refresh,
          builder: (_, __, ___) {
            final jobs = _filteredJobs();
            final talents = _ResidentJobsHub.talents;
            final unread = _ResidentJobsHub.unreadCount;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF6F8FF), Color(0xFFF9F0F0)],
                ),
              ),
              child: RefreshIndicator(
                onRefresh: () => _syncJobsBoardFromApi(showToast: false),
                child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Jobs & Skills Board',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2C2F45),
                          ),
                        ),
                      ),
                      _badgeIconButton(
                        icon: Icons.notifications_none_rounded,
                        count: unread,
                        onTap: () {
                          _ResidentJobsHub.markAllRead();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResidentNotificationsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResidentSavedJobsPage(),
                            ),
                          ),
                          icon: const Icon(Icons.favorite_border_rounded),
                          label: Text(
                            'Saved Jobs (${_ResidentJobsHub.savedJobs.length})',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResidentJobApplicationsPage(),
                            ),
                          ),
                          icon: const Icon(Icons.assignment_turned_in_outlined),
                          label: Text(
                            'Applications (${_ResidentJobsHub.applications.length})',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2F46C9), Color(0xFF5878F5)],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x262E35D3),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -20,
                          right: -8,
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hiring + Job Hunter Posting',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Employers can post openings. Job hunters can post skills and desired roles.',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFFDDE1FF),
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Color(0x33FFFFFF),
                              child: Icon(
                                Icons.groups_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _actionTile(
                          title: 'Post Hiring',
                          subtitle: 'For employers',
                          icon: Icons.business_center_rounded,
                          start: const Color(0xFFD8E4FF),
                          end: const Color(0xFFEFF4FF),
                          onTap: () => _openPostHiringSheet(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _actionTile(
                          title: 'Post Skills',
                          subtitle: 'For job hunters',
                          icon: Icons.person_search_rounded,
                          start: const Color(0xFFEBD9FF),
                          end: const Color(0xFFF7EEFF),
                          onTap: () => _openJobHunterSheet(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFE5E6F2)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: const Icon(Icons.search),
                        hintText:
                            'Search by title, company, location, or skill',
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _filters.map((f) {
                      final selected = _selectedFilter == f;
                      return ChoiceChip(
                        label: Text(f),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedFilter = f),
                        selectedColor: const Color(0xFFE2E6FF),
                        side: BorderSide(
                          color: selected
                              ? const Color(0xFF4A57BF)
                              : const Color(0xFFD1D3E4),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF2E35D3)
                              : const Color(0xFF5A5E74),
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hiring Posts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E3044),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (jobs.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7F3)),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 36,
                            color: Color(0xFF7A7F9A),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No jobs match your search.',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF3B3F57),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try another keyword or change the filter.',
                            style: TextStyle(color: Color(0xFF666B86)),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _selectedFilter = 'All');
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    )
                  else
                    ...jobs.map((job) => _jobCard(context, job)),
                  const SizedBox(height: 8),
                  const Text(
                    'Job Hunter Profiles',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E3044),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...talents.map((talent) => _talentCard(context, talent)),
                ],
              ),
              ),
            );
          },
        ),
      ),
    );

    if (Scaffold.maybeOf(context) == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Jobs')),
        body: content,
      );
    }

    return content;
  }

  Widget _badgeIconButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE6E8F4)),
            ),
            child: Icon(icon, color: const Color(0xFF4251B2)),
          ),
          if (count > 0)
            Positioned(
              top: -5,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFE44937),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color start,
    required Color end,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [start, end],
          ),
          border: Border.all(color: const Color(0xFFE5E8F5)),
        ),
        child: Row(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: const Color(0xFF3F4DB5)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E3248),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF626883),
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

  Widget _jobCard(BuildContext context, _ResidentJobData job) {
    final isSaved = _ResidentJobsHub.isSaved(job);
    final isApplied = _ResidentJobsHub.hasApplied(job);
    final isOwner = _ResidentJobsHub.isOwnedByCurrentUser(job);
    final submissionCount = _ResidentJobsHub.submissionCountForJob(job);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E7F1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E3044),
                    ),
                  ),
                ),
                if (job.urgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFFFE6E0),
                    ),
                    child: const Text(
                      'URGENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB5442E),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${job.company} - Posted by ${job.postedBy}',
              style: const TextStyle(
                color: Color(0xFF6A6E87),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: Color(0xFF6B6E84),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.location,
                    style: const TextStyle(color: Color(0xFF61657D)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Color(0xFF6B6E84)),
                const SizedBox(width: 4),
                Text(
                  job.schedule,
                  style: const TextStyle(
                    color: Color(0xFF555973),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  job.salary,
                  style: const TextStyle(
                    color: Color(0xFF3340B6),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            if (job.requirements.isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(
                'Requirements: ${job.requirements}',
                style: const TextStyle(
                  color: Color(0xFF565D77),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final result = await _JobsApi.instance.toggleSavedJob(job);
                      if (!context.mounted) {
                        return;
                      }
                      if (result.success) {
                        await _syncSavedJobsFromApi(showToast: false);
                        if (!context.mounted) {
                          return;
                        }
                        final nowSaved = result.saved ?? _ResidentJobsHub.isSaved(job);
                        _showFeature(
                          context,
                          nowSaved
                              ? 'Saved "${job.title}" to Saved Jobs.'
                              : 'Removed "${job.title}" from Saved Jobs.',
                        );
                        return;
                      }
                      _ResidentJobsHub.toggleSaved(job);
                      _showFeature(
                        context,
                        'Saved locally only: ${result.message}',
                        tone: _ToastTone.warning,
                      );
                    },
                    icon: Icon(
                      isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: isSaved ? const Color(0xFFC34B7D) : null,
                    ),
                    label: Text(isSaved ? 'Saved' : 'Save'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: isOwner
                        ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResidentJobSubmissionsPage(job: job),
                            ),
                          )
                        : isApplied
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResidentJobApplicationPage(job: job),
                            ),
                          ),
                    style: FilledButton.styleFrom(
                      backgroundColor: isOwner
                          ? const Color(0xFF3555A7)
                          : isApplied
                          ? const Color(0xFF7B86B8)
                          : const Color(0xFF3946BD),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Text(
                      isOwner
                          ? 'Submissions ($submissionCount)'
                          : isApplied
                          ? 'Applied'
                          : 'Apply',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _talentCard(BuildContext context, _ResidentTalentPostData talent) {
    final chips = talent.skills
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .take(4)
        .toList();

    final isOwnProfile =
        talent.fullName.trim().toLowerCase() ==
        (_currentResidentProfile?.displayName ?? '').trim().toLowerCase();
    final fallbackMobile = isOwnProfile ? (_currentResidentProfile?.mobile ?? '') : '';
    final mobileForSms = (talent.mobileNumber.isNotEmpty
            ? talent.mobileNumber
            : fallbackMobile)
        .replaceAll(RegExp(r'\s+'), '')
        .trim();
    final isTalentOwner = _ResidentJobsHub.isTalentOwnedByCurrentUser(talent);
    List<_ResidentJobInvitationData> invitationsForCard() {
      if (!isTalentOwner) {
        return _ResidentJobsHub.invitationsForTalent(talent);
      }
      final byTalent = _ResidentJobsHub.invitationsForTalent(talent);
      final byCurrent = _ResidentJobsHub.invitationsForCurrentResident();
      final map = <String, _ResidentJobInvitationData>{};
      for (final invite in [...byTalent, ...byCurrent]) {
        map[invite.id] = invite;
      }
      return map.values.toList();
    }

    final invitationCount = invitationsForCard().length;
    final hasInvited = !isTalentOwner &&
        _ResidentJobsHub.hasCurrentUserInvitedTalent(talent);

    Future<void> openSmsComposer() async {
      if (mobileForSms.isEmpty) {
        _showFeature(
          context,
          'No mobile number available for ${talent.fullName}.',
          tone: _ToastTone.warning,
        );
        return;
      }
      final messageBody =
          'Hello ${talent.fullName}, I would like to discuss your ${talent.desiredJob} profile on BarangayMo.';
      final smsUri = Uri(
        scheme: 'sms',
        path: mobileForSms,
        queryParameters: <String, String>{'body': messageBody},
      );
      final launched = await launchUrl(
        smsUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showFeature(
          context,
          'Unable to open SMS app for $mobileForSms.',
          tone: _ToastTone.error,
        );
      }
    }

    Future<void> openInviteModal() async {
      final controller = TextEditingController();
      final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F8FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite ${talent.fullName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2F334A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Write your invitation message for ${talent.desiredJob}.',
                    style: const TextStyle(
                      color: Color(0xFF626B88),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Invitation message / cover note',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        final message = controller.text.trim();
                        if (message.isEmpty) {
                          _showFeature(
                            sheetContext,
                            'Please enter your invitation message.',
                            tone: _ToastTone.warning,
                          );
                          return;
                        }
                        Navigator.of(sheetContext).pop(message);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF7E46D7),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Send Invite'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 300), () {
          controller.dispose();
        }),
      );
      if (result == null || result.trim().isEmpty || !mounted) {
        return;
      }
      final apiResult = await _JobsApi.instance.sendInvitation(
        talent: talent,
        message: result.trim(),
      );
      if (!mounted) {
        return;
      }
      if (apiResult.success) {
        if (apiResult.invitation != null) {
          _ResidentJobsHub.mergeInvitation(apiResult.invitation!);
        } else {
          // If backend does not return payload, fetch latest invitations.
          await _syncInvitationsFromApi(showToast: false);
        }
        _showFeature(
          context,
          apiResult.message,
          tone: _ToastTone.success,
        );
        return;
      }

      // Fallback to local mode when backend invitation endpoint is unavailable.
      _ResidentJobsHub.sendInvitation(talent: talent, message: result.trim());
      _showFeature(
        context,
        'Invitation saved locally (backend sync unavailable).',
        tone: _ToastTone.warning,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF7EEFF), Color(0xFFFDF8FF)],
        ),
        border: Border.all(color: const Color(0xFFEBDDFF)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8D8FF),
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF6D42C9)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        talent.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2E3044),
                        ),
                      ),
                      Text(
                        talent.desiredJob,
                        style: const TextStyle(
                          color: Color(0xFF675D7C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: talent.availableNow
                        ? const Color(0xFFE2F6E7)
                        : const Color(0xFFEDEEF5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    talent.availableNow ? 'AVAILABLE' : 'NOT AVAILABLE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: talent.availableNow
                          ? const Color(0xFF1E7F39)
                          : const Color(0xFF616681),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: chips
                  .map(
                    (chip) => Chip(
                      label: Text(chip),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: const Color(0xFFEFE6FF),
                      side: const BorderSide(color: Color(0xFFDCC8FF)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.map_rounded,
                  size: 16,
                  color: Color(0xFF6D6A82),
                ),
                const SizedBox(width: 4),
                Text(
                  talent.barangayZone,
                  style: const TextStyle(
                    color: Color(0xFF5F5B74),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.work_outline,
                  size: 16,
                  color: Color(0xFF6D6A82),
                ),
                const SizedBox(width: 4),
                Text(
                  talent.preferredSetup,
                  style: const TextStyle(
                    color: Color(0xFF5F5B74),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  talent.expectedSalary,
                  style: const TextStyle(
                    color: Color(0xFF6D42C9),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (!isTalentOwner) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: openSmsComposer,
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 16,
                      ),
                      label: const Text('Message'),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isTalentOwner
                        ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ResidentTalentInvitationsPage(talent: talent),
                            ),
                          )
                        : hasInvited
                        ? null
                        : openInviteModal,
                    style: FilledButton.styleFrom(
                      backgroundColor: hasInvited
                          ? const Color(0xFF9D96BB)
                          : const Color(0xFF7E46D7),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                    label: Text(
                      isTalentOwner
                          ? 'Invitations ($invitationCount)'
                          : hasInvited
                          ? 'Invited'
                          : 'Invite',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
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

class ResidentTalentInvitationsPage extends StatelessWidget {
  final _ResidentTalentPostData talent;

  const ResidentTalentInvitationsPage({super.key, required this.talent});

  String _formatDateTime(DateTime value) {
    final hour = value.hour == 0
        ? 12
        : value.hour > 12
        ? value.hour - 12
        : value.hour;
    final minute = value.minute.toString().padLeft(2, '0');
    final meridiem = value.hour >= 12 ? 'PM' : 'AM';
    return '${value.month}/${value.day}/${value.year} $hour:$minute $meridiem';
  }

  @override
  Widget build(BuildContext context) {
    List<_ResidentJobInvitationData> _mergedInvitations() {
      final isOwner = _ResidentJobsHub.isTalentOwnedByCurrentUser(talent);
      if (!isOwner) {
        return _ResidentJobsHub.invitationsForTalent(talent);
      }
      final byTalent = _ResidentJobsHub.invitationsForTalent(talent);
      final byCurrent = _ResidentJobsHub.invitationsForCurrentResident();
      final map = <String, _ResidentJobInvitationData>{};
      for (final invite in [...byTalent, ...byCurrent]) {
        map[invite.id] = invite;
      }
      return map.values.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_appText('Invitations', 'Invitations')),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _ResidentJobsHub.refresh,
        builder: (_, __, ___) {
          final scopedInvitations = _mergedInvitations();
          if (scopedInvitations.isEmpty) {
            return _AppEmptyState(
              icon: Icons.mail_outline_rounded,
              title: _appText('No invitations yet', 'Wala pang invitations'),
              subtitle: _appText(
                'Invitations sent to this profile will appear here.',
                'Lalabas dito ang mga invitation para sa profile na ito.',
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            itemCount: scopedInvitations.length,
            itemBuilder: (_, i) {
              final invitation = scopedInvitations[i];
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResidentInvitationReviewPage(
                      invitation: invitation,
                      dateLabel: _formatDateTime(invitation.createdAt),
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE4E7F3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              invitation.inviterName.isEmpty
                                  ? 'Unknown inviter'
                                  : invitation.inviterName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2F334A),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF7D86A6),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invitation.inviterMobile.isEmpty
                            ? 'No mobile number'
                            : invitation.inviterMobile,
                        style: const TextStyle(
                          color: Color(0xFF5F6784),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatDateTime(invitation.createdAt),
                        style: const TextStyle(
                          color: Color(0xFF666E89),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        invitation.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF575F79),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ResidentInvitationReviewPage extends StatelessWidget {
  final _ResidentJobInvitationData invitation;
  final String dateLabel;

  const ResidentInvitationReviewPage({
    super.key,
    required this.invitation,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appText('Invitation Review', 'Invitation Review')),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6A3ACB), Color(0xFF9C5BE5)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.talentName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  invitation.talentDesiredJob,
                  style: const TextStyle(
                    color: Color(0xFFEADFFF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4E7F3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.inviterName.isEmpty
                      ? 'Unknown inviter'
                      : invitation.inviterName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2F334A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mobile: ${invitation.inviterMobile.isEmpty ? 'No mobile number' : invitation.inviterMobile}',
                  style: const TextStyle(
                    color: Color(0xFF5F6784),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sent: $dateLabel',
                  style: const TextStyle(
                    color: Color(0xFF666E89),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Invitation Message',
                  style: TextStyle(
                    color: Color(0xFF3E4460),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  invitation.message,
                  style: const TextStyle(
                    color: Color(0xFF575F79),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
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

class ResidentSavedJobsPage extends StatefulWidget {
  const ResidentSavedJobsPage({super.key});

  @override
  State<ResidentSavedJobsPage> createState() => _ResidentSavedJobsPageState();
}

class _ResidentSavedJobsPageState extends State<ResidentSavedJobsPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 520));
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appText('Saved Jobs', 'Naka-save na Trabaho')),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: _loading
          ? const _AppListSkeleton(count: 4)
          : ValueListenableBuilder<int>(
        valueListenable: _ResidentJobsHub.refresh,
        builder: (_, __, ___) {
          final jobs = _ResidentJobsHub.savedJobs;
          if (jobs.isEmpty) {
            return _AppEmptyState(
              icon: Icons.favorite_border_rounded,
              title: _appText('No saved jobs yet', 'Wala pang naka-save na trabaho'),
              subtitle: _appText(
                'Tap Save on the jobs board to keep openings here.',
                'I-tap ang Save sa jobs board para manatili rito ang openings.',
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              itemCount: jobs.length,
              itemBuilder: (_, i) {
                final job = jobs[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E8F4)),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE7ECFF),
                      child: Icon(Icons.work_outline_rounded),
                    ),
                    title: Text(
                      job.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F334A),
                      ),
                    ),
                    subtitle: Text(
                      '${job.company}\n${job.salary} | ${job.schedule}',
                      style: const TextStyle(
                        color: Color(0xFF646C88),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResidentJobApplicationPage(job: job),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ResidentJobApplicationsPage extends StatefulWidget {
  const ResidentJobApplicationsPage({super.key});

  @override
  State<ResidentJobApplicationsPage> createState() =>
      _ResidentJobApplicationsPageState();
}

class _ResidentJobApplicationsPageState extends State<ResidentJobApplicationsPage> {
  bool _loading = true;

  String _formatDate(DateTime value) =>
      '${value.month}/${value.day}/${value.year}';

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 520));
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appText('My Job Applications', 'Aking Job Applications')),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: _loading
          ? const _AppListSkeleton(count: 4)
          : ValueListenableBuilder<int>(
        valueListenable: _ResidentJobsHub.refresh,
        builder: (_, __, ___) {
          final apps = _ResidentJobsHub.applications;
          if (apps.isEmpty) {
            return _AppEmptyState(
              icon: Icons.assignment_turned_in_outlined,
              title: _appText(
                'No applications yet',
                'Wala pang applications',
              ),
              subtitle: _appText(
                'Submitted job applications will appear here.',
                'Dito lalabas ang mga naisumiteng job application.',
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              itemCount: apps.length,
              itemBuilder: (_, i) {
                final app = apps[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE4E7F3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              app.jobTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                color: Color(0xFF2F334A),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7ECFF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              app.status,
                              style: const TextStyle(
                                color: Color(0xFF3A4CB2),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${app.company} | ${_formatDate(app.submittedAt)}',
                        style: const TextStyle(
                          color: Color(0xFF666E89),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Attachment: ${app.attachmentName}',
                        style: const TextStyle(
                          color: Color(0xFF515873),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        app.coverLetter,
                        style: const TextStyle(
                          color: Color(0xFF676F89),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ResidentJobSubmissionsPage extends StatefulWidget {
  final _ResidentJobData job;
  const ResidentJobSubmissionsPage({super.key, required this.job});

  @override
  State<ResidentJobSubmissionsPage> createState() =>
      _ResidentJobSubmissionsPageState();
}

class _ResidentJobSubmissionsPageState extends State<ResidentJobSubmissionsPage> {
  String _formatDateTime(DateTime value) {
    final hour = value.hour == 0
        ? 12
        : value.hour > 12
        ? value.hour - 12
        : value.hour;
    final minute = value.minute.toString().padLeft(2, '0');
    final meridiem = value.hour >= 12 ? 'PM' : 'AM';
    return '${value.month}/${value.day}/${value.year} $hour:$minute $meridiem';
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      appBar: AppBar(
        title: Text(_appText('Job Submissions', 'Job Submissions')),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _ResidentJobsHub.refresh,
        builder: (_, __, ___) {
          final submissions = _ResidentJobsHub.submissionsForJob(job);
          if (submissions.isEmpty) {
            return _AppEmptyState(
              icon: Icons.inbox_outlined,
              title: _appText('No submissions yet', 'Wala pang submissions'),
              subtitle: _appText(
                'Applicants for this job will appear here.',
                'Lalabas dito ang mga applicant para sa job na ito.',
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            itemCount: submissions.length,
            itemBuilder: (_, i) {
              final submission = submissions[i];
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ResidentApplicantReviewPage(job: job, submission: submission),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE4E7F3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              submission.applicantName.isEmpty
                                  ? 'Unnamed applicant'
                                  : submission.applicantName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2F334A),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF7D86A6),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        submission.mobileNumber.isEmpty
                            ? 'No mobile number'
                            : submission.mobileNumber,
                        style: const TextStyle(
                          color: Color(0xFF5F6784),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Submitted: ${_formatDateTime(submission.submittedAt)}',
                        style: const TextStyle(
                          color: Color(0xFF666E89),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Attachment: ${submission.attachmentName.isEmpty ? 'No attachment' : submission.attachmentName}',
                        style: const TextStyle(
                          color: Color(0xFF515873),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ResidentJobApplicationPage extends StatefulWidget {
  final _ResidentJobData job;
  const ResidentJobApplicationPage({super.key, required this.job});

  @override
  State<ResidentJobApplicationPage> createState() =>
      _ResidentJobApplicationPageState();
}

class _ResidentJobApplicationPageState extends State<ResidentJobApplicationPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _coverLetterController;
  late final String _initialName;
  late final String _initialMobile;
  static const String _initialCoverLetter = '';
  XFile? _attachment;
  bool _submitting = false;
  static const int _maxAttachmentBase64Chars = 1800000;

  bool get _hasDraft =>
      _nameController.text.trim() != _initialName ||
      _mobileController.text.trim() != _initialMobile ||
      _coverLetterController.text.trim() != _initialCoverLetter ||
      _attachment != null;

  @override
  void initState() {
    super.initState();
    _initialName = _currentResidentProfile?.displayName ?? '';
    _initialMobile = _currentResidentProfile?.mobile ?? '';
    _nameController = TextEditingController(text: _initialName);
    _mobileController = TextEditingController(text: _initialMobile);
    _coverLetterController = TextEditingController(text: _initialCoverLetter);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1400,
      maxHeight: 1400,
      imageQuality: 72,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() => _attachment = picked);
  }

  String _safeAttachmentName(String input) {
    final cleaned = input.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    if (cleaned.isEmpty) {
      return 'attachment_${DateTime.now().millisecondsSinceEpoch}.bin';
    }
    return cleaned;
  }

  Future<String> _persistAttachment(XFile file) async {
    try {
      final appDocs = await getApplicationDocumentsDirectory();
      final targetDir = Directory('${appDocs.path}/BarangayMo/Applications');
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
      final extension = file.name.contains('.')
          ? file.name.substring(file.name.lastIndexOf('.'))
          : '';
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_safeAttachmentName(file.name)}'
              .replaceAll('..', '.');
      final destination = File('${targetDir.path}/$fileName');
      await File(file.path).copy(destination.path);
      return destination.path;
    } catch (_) {
      return file.path;
    }
  }

  Future<void> _submit() async {
    if (_submitting) {
      return;
    }
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final cover = _coverLetterController.text.trim();
    final attachmentName = _attachment?.name ?? 'No attachment';
    String attachmentBase64 = '';
    if (_attachment != null) {
      attachmentBase64 = base64Encode(await _attachment!.readAsBytes());
      if (attachmentBase64.length > _maxAttachmentBase64Chars) {
        _showFeature(
          context,
          'Attachment is too large. Please upload a smaller image.',
        );
        return;
      }
    }
    final attachmentPath = _attachment == null
        ? ''
        : await _persistAttachment(_attachment!);
    if (name.isEmpty || mobile.length < 11 || cover.isEmpty) {
      _showFeature(
        context,
        'Enter your name, a valid mobile number, and a cover letter.',
      );
      return;
    }
    setState(() => _submitting = true);
    final apiResult = await _JobsApi.instance.sendApplication(
      job: widget.job,
      applicantName: name,
      mobileNumber: mobile,
      coverLetter: cover,
      attachmentName: attachmentName,
      attachmentBase64: attachmentBase64,
    );
    if (!mounted) {
      return;
    }
    if (apiResult.success) {
      await _JobsApi.instance.fetchApplications().then((result) {
        if (result.success) {
          _ResidentJobsHub.replaceApplications(result.applications);
        } else if (apiResult.application != null) {
          _ResidentJobsHub.submitApplication(
            job: widget.job,
            applicantName: name,
            mobileNumber: mobile,
            coverLetter: cover,
            attachmentName: attachmentName,
            attachmentPath: attachmentPath,
            attachmentBase64: attachmentBase64,
          );
        }
      });
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      _showFeature(context, apiResult.message);
      return;
    }

    _ResidentJobsHub.submitApplication(
      job: widget.job,
      applicantName: name,
      mobileNumber: mobile,
      coverLetter: cover,
      attachmentName: attachmentName,
      attachmentPath: attachmentPath,
      attachmentBase64: attachmentBase64,
    );
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
    _showFeature(
      context,
      'Saved locally only: ${apiResult.message}',
      tone: _ToastTone.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return PopScope(
      canPop: !_hasDraft,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !_hasDraft) {
          return;
        }
        final shouldLeave = await _confirmDiscardChanges(context);
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_appText('Job Application', 'Job Application')),
          backgroundColor: const Color(0xFFF7F8FF),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3148C7), Color(0xFF5C78EF)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${job.company} | ${job.salary} | ${job.schedule}',
                  style: const TextStyle(
                    color: Color(0xFFDDE3FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Applicant name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _mobileController,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Mobile number'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _coverLetterController,
            onChanged: (_) => setState(() {}),
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Cover letter / qualifications',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E6F4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_file_rounded, color: Color(0xFF4654BC)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _attachment?.name ?? 'Attach resume or credentials',
                    style: const TextStyle(
                      color: Color(0xFF57607C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _pickAttachment,
                  child: const Text('Upload'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: FilledButton.icon(
            onPressed: _submitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF3946BD),
            ),
            icon: _submitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(_submitting ? 'Submitting...' : 'Submit Application'),
          ),
        ),
      ),
    ),
  );
  }
}

class ResidentApplicantReviewPage extends StatefulWidget {
  final _ResidentJobData job;
  final _ResidentJobApplicationData submission;

  const ResidentApplicantReviewPage({
    super.key,
    required this.job,
    required this.submission,
  });

  @override
  State<ResidentApplicantReviewPage> createState() =>
      _ResidentApplicantReviewPageState();
}

class _ResidentApplicantReviewPageState extends State<ResidentApplicantReviewPage> {
  bool _downloading = false;

  String _formatDateTime(DateTime value) {
    final hour = value.hour == 0
        ? 12
        : value.hour > 12
        ? value.hour - 12
        : value.hour;
    final minute = value.minute.toString().padLeft(2, '0');
    final meridiem = value.hour >= 12 ? 'PM' : 'AM';
    return '${value.month}/${value.day}/${value.year} $hour:$minute $meridiem';
  }

  String _safeFileName(String input) {
    final cleaned = input.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    if (cleaned.isEmpty) {
      return 'submission_attachment_${DateTime.now().millisecondsSinceEpoch}.bin';
    }
    return cleaned;
  }

  Future<File?> _resolveAttachmentSourceFile() async {
    final directPath = widget.submission.attachmentPath.trim();
    if (directPath.isNotEmpty) {
      final directFile = File(directPath);
      if (await directFile.exists()) {
        return directFile;
      }
    }

    final fileName = widget.submission.attachmentName.trim();
    if (fileName.isEmpty || fileName == 'No attachment') {
      return null;
    }
    try {
      final appDocs = await getApplicationDocumentsDirectory();
      final appDir = Directory('${appDocs.path}/BarangayMo/Applications');
      if (!await appDir.exists()) {
        return null;
      }
      final files = appDir.listSync();
      for (final entity in files) {
        if (entity is! File) {
          continue;
        }
        final currentName = entity.uri.pathSegments.last;
        if (currentName == fileName || currentName.endsWith('_$fileName')) {
          return entity;
        }
      }
    } catch (_) {}
    return null;
  }

  Uint8List? _decodeAttachmentPayload() {
    final raw = widget.submission.attachmentBase64.trim();
    if (raw.isEmpty) {
      return null;
    }
    final dataPart = raw.contains(',')
        ? raw.substring(raw.indexOf(',') + 1).trim()
        : raw;
    if (dataPart.isEmpty) {
      return null;
    }
    try {
      return base64Decode(dataPart);
    } catch (_) {
      return null;
    }
  }

  Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      final external = await getExternalStorageDirectory();
      if (external != null) {
        final dir = Directory('${external.path}/Downloads/BarangayMo');
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        return dir;
      }
    }

    final downloads = await getDownloadsDirectory();
    if (downloads != null) {
      final dir = Directory('${downloads.path}/BarangayMo');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    }

    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/BarangayMo/Downloads');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<void> _downloadAttachment() async {
    final sourceFile = await _resolveAttachmentSourceFile();
    final payloadBytes = sourceFile == null ? _decodeAttachmentPayload() : null;
    if (sourceFile == null && payloadBytes == null) {
      _showFeature(
        context,
        'Attachment file is not available on this device for this submission.',
      );
      return;
    }

    setState(() => _downloading = true);
    try {
      final downloadsDir = await _resolveDownloadDirectory();
      final fileName = _safeFileName(
        widget.submission.attachmentName.isEmpty
            ? (sourceFile?.uri.pathSegments.last ?? 'submission_attachment.bin')
            : widget.submission.attachmentName,
      );
      final destinationPath = '${downloadsDir.path}/$fileName';
      if (sourceFile != null) {
        await sourceFile.copy(destinationPath);
      } else {
        await File(destinationPath).writeAsBytes(payloadBytes!, flush: true);
      }
      if (!mounted) {
        return;
      }
      _showFeature(
        context,
        'Attachment downloaded to: $destinationPath',
        tone: _ToastTone.success,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showFeature(
        context,
        'Download failed. Please try again.',
        tone: _ToastTone.error,
      );
    } finally {
      if (mounted) {
        setState(() => _downloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final submission = widget.submission;
    return Scaffold(
      appBar: AppBar(
        title: Text(_appText('Applicant Review', 'Applicant Review')),
        backgroundColor: const Color(0xFFF7F8FF),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2F46C9), Color(0xFF5878F5)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.job.company,
                  style: const TextStyle(
                    color: Color(0xFFDDE3FF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4E7F3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  submission.applicantName.isEmpty
                      ? 'Unnamed applicant'
                      : submission.applicantName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2F334A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mobile: ${submission.mobileNumber.isEmpty ? 'No mobile number' : submission.mobileNumber}',
                  style: const TextStyle(
                    color: Color(0xFF5F6784),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Submitted: ${_formatDateTime(submission.submittedAt)}',
                  style: const TextStyle(
                    color: Color(0xFF666E89),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cover Letter',
                  style: TextStyle(
                    color: Color(0xFF3E4460),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  submission.coverLetter.isEmpty
                      ? 'No cover letter provided.'
                      : submission.coverLetter,
                  style: const TextStyle(
                    color: Color(0xFF575F79),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Attachment: ${submission.attachmentName.isEmpty ? 'No attachment' : submission.attachmentName}',
                  style: const TextStyle(
                    color: Color(0xFF515873),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _downloading ? null : _downloadAttachment,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3555A7),
                    ),
                    icon: _downloading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.download_rounded),
                    label: Text(
                      _downloading ? 'Downloading...' : 'Download Attachment',
                    ),
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
