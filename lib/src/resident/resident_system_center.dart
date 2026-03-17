part of barangaymo_app;

class ResidentNotificationsPage extends StatelessWidget {
  const ResidentNotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const _AdvancedNotificationCenterPage(role: UserRole.resident);
  }
}

class _ResidentJobNotificationsTab extends StatelessWidget {
  const _ResidentJobNotificationsTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _ResidentJobsHub.refresh,
      builder: (_, __, ___) {
        final items = _ResidentJobsHub.notifications;
        if (items.isEmpty) {
          return const Center(child: Text('Empty Notifications'));
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _ResidentJobsHub.markAllRead,
                icon: const Icon(Icons.done_all_rounded, size: 18),
                label: const Text('Mark all as read'),
              ),
            ),
            ...items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: item.unread ? const Color(0xFFF4F7FF) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: item.unread
                        ? const Color(0xFFD7E3FF)
                        : const Color(0xFFE7E9F2),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.accent.withValues(alpha: 0.16),
                    child: Icon(item.icon, color: item.accent),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F3248),
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF636983),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _ResidentJobsHub.timeAgo(item.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7190),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (item.unread)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4A64FF),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    item.unread = false;
                    _ResidentJobsHub.refresh.value++;
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _ResidentHistory extends StatelessWidget {
  const _ResidentHistory();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: List.generate(
        4,
        (i) => Card(
          child: ListTile(
            title: const Text('Profile Update'),
            subtitle: const Text('You updated your profile details.'),
            trailing: const Text('4 hours ago'),
          ),
        ),
      ),
    );
  }
}

Color _systemPrimaryForRole(UserRole role) {
  return role == UserRole.resident
      ? const Color(0xFF2E35D3)
      : const Color(0xFFB31212);
}

Color _systemSoftForRole(UserRole role) {
  return role == UserRole.resident
      ? const Color(0xFFE7ECFF)
      : const Color(0xFFFCEAEA);
}

String _systemRoleLabel(UserRole role) =>
    role == UserRole.resident ? 'Resident' : 'Official';

String _systemTimeAgo(DateTime value) {
  final delta = DateTime.now().difference(value);
  if (delta.inMinutes < 1) return 'Just now';
  if (delta.inHours < 1) return '${delta.inMinutes}m ago';
  if (delta.inDays < 1) return '${delta.inHours}h ago';
  return '${delta.inDays}d ago';
}

String _systemDateLabel(DateTime value) {
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
  return '${months[value.month - 1]} ${value.day}, ${value.year}';
}

Color _notificationPriorityColor(String priority) {
  switch (priority) {
    case 'emergency':
      return const Color(0xFFD12B2B);
    case 'high':
      return const Color(0xFFB45309);
    default:
      return const Color(0xFF4B5BB7);
  }
}

String _hourLabel(int hour) {
  final normalized = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  final suffix = hour >= 12 ? 'PM' : 'AM';
  return '$normalized:00 $suffix';
}

String _notificationLinkSummary(_AppNotificationItem item) {
  if (item.recordId == null) {
    return item.deliveryChannel;
  }
  return '${item.deliveryChannel} - ${item.recordId}';
}

Future<void> _openNotificationTarget(
  BuildContext context, {
  required UserRole role,
  required _AppNotificationItem item,
}) async {
  _markNotificationRead(role, item);
  final link = item.deepLink;
  if (link == null || link.isEmpty) {
    _showFeature(context, item.title);
    return;
  }
  final uri = Uri.tryParse(link);
  if (uri == null || uri.pathSegments.isEmpty) {
    _showFeature(context, item.title);
    return;
  }
  final target = uri.host.isNotEmpty ? uri.host : uri.pathSegments.first;
  final recordId = item.recordId ??
      (uri.pathSegments.length > 1 ? uri.pathSegments.last : null);
  switch (target) {
    case 'document':
      if (recordId != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _AutomatedDocumentStatusDetailPage(entryId: recordId),
          ),
        );
        return;
      }
      break;
    case 'message':
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _DirectMessagesHomePage(
            role: role,
            initialThreadId: recordId,
          ),
        ),
      );
      return;
    case 'dispatch-log':
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const _NotificationDispatchLogPage(
            role: UserRole.official,
          ),
        ),
      );
      return;
    case 'helpdesk':
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _HelpDeskPage(role: role),
        ),
      );
      return;
    case 'security':
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _SecurityLogPage(role: role),
        ),
      );
      return;
    case 'broadcast':
      _showFeature(context, 'Broadcast record opened.');
      return;
    default:
      break;
  }
  _showFeature(context, item.recordId != null ? 'Opened ${item.recordId}' : item.title);
}

String _currentResidentThreadId() {
  final mobile = _currentResidentProfile?.mobile ?? '09171234567';
  return _directThreadId(mobile);
}

class _SecurePinSettingsPage extends StatefulWidget {
  final UserRole role;
  const _SecurePinSettingsPage({required this.role});

  @override
  State<_SecurePinSettingsPage> createState() => _SecurePinSettingsPageState();
}

class _SecurePinSettingsPageState extends State<_SecurePinSettingsPage> {
  final _currentPin = TextEditingController();
  final _newPin = TextEditingController();
  final _confirmPin = TextEditingController();

  @override
  void dispose() {
    _currentPin.dispose();
    _newPin.dispose();
    _confirmPin.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final mobile = widget.role == UserRole.resident
        ? (_currentResidentProfile?.mobile ?? '')
        : (_currentOfficialMobile ?? _officialEditableProfile.value.phone);
    if (!_isValidAppPin(_currentPin.text.trim()) ||
        !_isValidAppPin(_newPin.text.trim()) ||
        !_isValidAppPin(_confirmPin.text.trim())) {
      _showFeature(context, 'PIN must be 6 digits.');
      return;
    }
    if (_newPin.text.trim() != _confirmPin.text.trim()) {
      _showFeature(context, 'PIN confirmation does not match.');
      return;
    }
    final validCurrent = widget.role == UserRole.resident
        ? await _ResidentMpinStore.verifyPin(mobile, _currentPin.text.trim())
        : await _OfficialMpinStore.verifyPin(mobile, _currentPin.text.trim());
    if (!validCurrent) {
      _showFeature(context, 'Current PIN is incorrect.');
      return;
    }
    if (widget.role == UserRole.resident) {
      await _ResidentMpinStore.savePin(mobile, _newPin.text.trim());
    } else {
      await _OfficialMpinStore.savePin(mobile, _newPin.text.trim());
    }
    _recordSecurityLog(
      widget.role,
      mobile: mobile,
      action: 'Changed security PIN',
    );
    _pushSystemNotification(
      widget.role,
      title: 'Security PIN updated',
      body: 'Your ${_systemRoleLabel(widget.role).toLowerCase()} PIN was changed successfully.',
      category: 'Security',
      icon: Icons.lock_reset,
    );
    if (!mounted) return;
    _showFeature(context, 'Security PIN updated.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(widget.role);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Settings'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _systemSoftForRole(widget.role),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Change your 6-digit security PIN. Current PIN verification is required before saving.',
              style: TextStyle(
                color: Color(0xFF48506B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _currentPin,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'Current 6-digit PIN',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newPin,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'New 6-digit PIN',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _confirmPin,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'Confirm new 6-digit PIN',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Save Security PIN',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileEditorPage extends StatefulWidget {
  final UserRole role;
  const _ProfileEditorPage({required this.role});

  @override
  State<_ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<_ProfileEditorPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  Uint8List? _officialPhotoBytes;

  @override
  void initState() {
    super.initState();
    if (widget.role == UserRole.resident) {
      _nameController = TextEditingController(text: _residentDisplayName());
      _phoneController = TextEditingController(
        text: _currentResidentProfile?.mobile ?? '',
      );
    } else {
      _nameController = TextEditingController(
        text: _officialEditableProfile.value.name,
      );
      _phoneController = TextEditingController(
        text: _officialEditableProfile.value.phone,
      );
      _officialPhotoBytes = _officialEditableProfile.value.photoBytes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickOfficialPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      _officialPhotoBytes = bytes;
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      _showFeature(context, 'Name and phone number are required.');
      return;
    }
    if (widget.role == UserRole.resident) {
      _updateResidentEditableProfile(name: name, phone: phone);
    } else {
      _officialEditableProfile.value = _officialEditableProfile.value.copyWith(
        name: name,
        phone: phone,
        photoBytes: _officialPhotoBytes,
      );
    }
    _pushSystemNotification(
      widget.role,
      title: 'Profile updated',
      body: 'Your name and phone details were updated.',
      category: 'Account',
      icon: Icons.person_outline,
    );
    _showFeature(context, 'Profile updated.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(widget.role);
    final isResident = widget.role == UserRole.resident;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Editor'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: isResident
                ? ValueListenableBuilder<_ResidentProfilePhotoValue>(
                    valueListenable: _ResidentProfilePhotoStore.photo,
                    builder: (context, value, _) {
                      final ImageProvider<Object>? image = value.bytes != null
                          ? MemoryImage(value.bytes!)
                          : (value.url != null && value.url!.isNotEmpty
                              ? NetworkImage(value.url!)
                              : null);
                      return CircleAvatar(
                        radius: 44,
                        backgroundColor: _systemSoftForRole(widget.role),
                        backgroundImage: image,
                        child: image == null
                            ? const Icon(Icons.person, size: 42)
                            : null,
                      );
                    },
                  )
                : CircleAvatar(
                    radius: 44,
                    backgroundColor: _systemSoftForRole(widget.role),
                    backgroundImage: _officialPhotoBytes != null
                        ? MemoryImage(_officialPhotoBytes!)
                        : null,
                    child: _officialPhotoBytes == null
                        ? const Icon(Icons.person, size: 42)
                        : null,
                  ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: isResident
                ? () => _openResidentProfilePhotoEditor(context)
                : _pickOfficialPhoto,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Change Photo'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Save Profile',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountDeletionWorkflowPage extends StatefulWidget {
  final UserRole role;
  const _AccountDeletionWorkflowPage({required this.role});

  @override
  State<_AccountDeletionWorkflowPage> createState() =>
      _AccountDeletionWorkflowPageState();
}

class _AccountDeletionWorkflowPageState
    extends State<_AccountDeletionWorkflowPage> {
  final _pinController = TextEditingController();
  bool _confirmed = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _scheduleDeletion() async {
    final mobile = widget.role == UserRole.resident
        ? (_currentResidentProfile?.mobile ?? '')
        : (_currentOfficialMobile ?? _officialEditableProfile.value.phone);
    if (!_confirmed) {
      _showFeature(context, 'Confirm the deletion notice first.');
      return;
    }
    final valid = widget.role == UserRole.resident
        ? await _ResidentMpinStore.verifyPin(mobile, _pinController.text.trim())
        : await _OfficialMpinStore.verifyPin(mobile, _pinController.text.trim());
    if (!valid) {
      _showFeature(context, 'Current PIN is incorrect.');
      return;
    }
    _scheduleAccountDeletion(widget.role, mobile);
    _recordSecurityLog(
      widget.role,
      mobile: mobile,
      action: 'Scheduled account deletion',
    );
    if (!mounted) return;
    setState(() {});
    _showFeature(context, 'Deletion request scheduled with a 30-day grace period.');
  }

  @override
  Widget build(BuildContext context) {
    final request = _deletionRequestForRole(widget.role).value;
    final primary = _systemPrimaryForRole(widget.role);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1D2D2)),
            ),
            child: Text(
              request == null
                  ? 'Deleting an account now starts a 30-day grace period. You can still cancel the request before ${_systemDateLabel(DateTime.now().add(const Duration(days: 30)))}.'
                  : 'Deletion requested on ${_systemDateLabel(request.requestedAt)}. This account is scheduled for deletion on ${_systemDateLabel(request.deleteOn)}.',
              style: const TextStyle(
                color: Color(0xFF7A4A4A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (request != null) ...[
            FilledButton.icon(
              onPressed: () {
                _cancelScheduledDeletion(widget.role);
                setState(() {});
                _showFeature(context, 'Deletion request cancelled.');
              },
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.restore_from_trash_outlined),
              label: const Text('Cancel Deletion Request'),
            ),
          ] else ...[
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Enter current 6-digit PIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _confirmed,
              onChanged: (v) => setState(() => _confirmed = v ?? false),
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'I understand my account enters a 30-day grace period before permanent deletion.',
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _scheduleDeletion,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD74637),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Schedule Deletion'),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationCenterPage extends StatelessWidget {
  final UserRole role;
  const _NotificationCenterPage({required this.role});

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(role);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => _markAllNotificationsRead(role),
            child: const Text(
              'Mark all',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<_AppNotificationItem>>(
        valueListenable: _notificationCenterForRole(role),
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: item.read ? Colors.white : _systemSoftForRole(role),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: item.read
                        ? const Color(0xFFE3E6F1)
                        : primary.withValues(alpha: 0.25),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primary.withValues(alpha: 0.12),
                    child: Icon(item.icon, color: primary),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text('${item.category} ??? ${item.body}'),
                  trailing: Text(_systemTimeAgo(item.createdAt)),
                  onTap: () {
                    item.read = !item.read;
                    _notificationCenterForRole(role).value = [...items];
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _SecurityLogPage extends StatelessWidget {
  final UserRole role;
  const _SecurityLogPage({required this.role});

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(role);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Log'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<List<_SecurityLogEntry>>(
        valueListenable: _securityLogFeed,
        builder: (context, items, _) {
          final filtered = items.where((entry) => entry.role == role).toList();
          if (filtered.isEmpty) {
            return const Center(child: Text('No security logs yet.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: filtered.map((entry) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _systemSoftForRole(role),
                    child: Icon(Icons.security_rounded, color: primary),
                  ),
                  title: Text(
                    entry.action,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${entry.actor}\nIP ${entry.ipAddress}\n${entry.mobile}',
                  ),
                  trailing: Text(_systemDateLabel(entry.createdAt)),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _TransactionHistoryPage extends StatefulWidget {
  final UserRole role;
  const _TransactionHistoryPage({required this.role});

  @override
  State<_TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<_TransactionHistoryPage> {
  final _searchController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_refreshHistory());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshHistory() async {
    setState(() => _loading = true);
    if (widget.role == UserRole.resident) {
      await _ResidentCartHub.ensureLoaded();
    }
    await Future<void>.delayed(const Duration(milliseconds: 520));
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  DateTime _orderCreatedAt(_OrderHistoryEntry entry) {
    final parts = entry.date.split('/');
    if (parts.length == 3) {
      final month = int.tryParse(parts[0]);
      final day = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (month != null && day != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return DateTime.now();
  }

  String _orderTitle(_OrderHistoryEntry entry) {
    if (entry.items.isEmpty) {
      return 'Marketplace Order';
    }
    final firstTitle = entry.items.first.title;
    final extraCount = entry.items.length - 1;
    return extraCount > 0 ? '$firstTitle +$extraCount more' : firstTitle;
  }

  List<_SystemTransactionEntry> _entries() {
    final seeded = _transactionHistoryFeed.value
        .where((entry) => entry.role == widget.role)
        .toList();
    if (widget.role == UserRole.resident) {
      final docs = _SerbilisDocumentStore.documents.value.map(
        (entry) => _SystemTransactionEntry(
          role: UserRole.resident,
          title: entry.title,
          type: 'Document Request',
          reference: entry.id,
          status: entry.status,
          amount: 75,
          createdAt: entry.submittedAt,
        ),
      );
      final orders = _ResidentCartHub.orders.map(
        (entry) => _SystemTransactionEntry(
          role: UserRole.resident,
          title: _orderTitle(entry),
          type: 'Marketplace Order',
          reference: entry.id,
          status: entry.status,
          amount: entry.total,
          createdAt: _orderCreatedAt(entry),
        ),
      );
      return [...seeded, ...docs, ...orders]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return seeded..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(widget.role);
    final query = _searchController.text.trim().toLowerCase();
    final items = _entries().where((entry) {
      if (query.isEmpty) {
        return true;
      }
      final bag =
          '${entry.title} ${entry.type} ${entry.reference} ${entry.status}'
              .toLowerCase();
      return bag.contains(query);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(_appText('Transaction History', 'Kasaysayan ng Transaksyon')),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const _AppListSkeleton(count: 5)
          : RefreshIndicator(
              onRefresh: _refreshHistory,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      hintText: _appText(
                        'Search document requests or orders',
                        'Maghanap ng requests o orders',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    _AppEmptyState(
                      icon: Icons.history_toggle_off_rounded,
                      title: _appText(
                        'No transactions found',
                        'Walang nahanap na transaksyon',
                      ),
                      subtitle: _appText(
                        query.isEmpty
                            ? 'Your document requests and marketplace orders will appear here.'
                            : 'Try a different keyword or clear your search.',
                        query.isEmpty
                            ? 'Dito lalabas ang iyong document requests at marketplace orders.'
                            : 'Subukan ang ibang keyword o alisin ang search.',
                      ),
                    )
                  else
                    ...items.map((entry) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _systemSoftForRole(widget.role),
                            child: Icon(Icons.receipt_long_rounded, color: primary),
                          ),
                          title: _HighlightedText(
                            text: entry.title,
                            query: _searchController.text,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _HighlightedText(
                                text: entry.type,
                                query: _searchController.text,
                              ),
                              _HighlightedText(
                                text: entry.reference,
                                query: _searchController.text,
                              ),
                              _HighlightedText(
                                text: entry.status,
                                query: _searchController.text,
                              ),
                            ],
                          ),
                          trailing: Text(
                            entry.amount <= 0
                                ? _systemDateLabel(entry.createdAt)
                                : 'PHP ${entry.amount.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}

class _HelpDeskPage extends StatefulWidget {
  final UserRole role;
  const _HelpDeskPage({required this.role});

  @override
  State<_HelpDeskPage> createState() => _HelpDeskPageState();
}

class _HelpDeskPageState extends State<_HelpDeskPage> {
  final _subject = TextEditingController();
  final _message = TextEditingController();
  final _contact = TextEditingController();

  bool get _hasDraft =>
      _subject.text.trim().isNotEmpty ||
      _message.text.trim().isNotEmpty ||
      _contact.text.trim() != _mobileForRole(widget.role);

  @override
  void initState() {
    super.initState();
    _contact.text = _mobileForRole(widget.role);
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    _contact.dispose();
    super.dispose();
  }

  void _submit() {
    if (_subject.text.trim().isEmpty || _message.text.trim().length < 10) {
      _showFeature(context, 'Enter a subject and a more detailed message.');
      return;
    }
    final id = _submitHelpDeskTicket(
      widget.role,
      subject: _subject.text.trim(),
      message: _message.text.trim(),
      contact: _contact.text.trim(),
    );
    _showFeature(context, 'Ticket submitted: $id');
    _subject.clear();
    _message.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(widget.role);
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
          title: Text(_appText('Help Desk', 'Help Desk')),
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
        body: ValueListenableBuilder<List<_HelpDeskTicketEntry>>(
          valueListenable: _helpDeskFeed,
          builder: (context, items, _) {
            final filtered = items.where((entry) => entry.role == widget.role).toList();
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE3E6F1)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _subject,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: _appText('Ticket subject', 'Paksa ng ticket'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _message,
                        onChanged: (_) => setState(() {}),
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: _appText(
                            'Describe your issue',
                            'Ilarawan ang concern mo',
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _contact,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: _appText('Contact number', 'Contact number'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            _appText('Submit Ticket', 'I-submit ang Ticket'),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (filtered.isEmpty)
                  _AppEmptyState(
                    icon: Icons.support_agent_rounded,
                    title: _appText('No tickets yet', 'Wala pang tickets'),
                    subtitle: _appText(
                      'Submitted help desk tickets will appear here.',
                      'Dito lalabas ang mga naisumiteng help desk ticket.',
                    ),
                  )
                else
                  ...filtered.map(
                    (entry) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _systemSoftForRole(widget.role),
                          child: Icon(Icons.support_agent_outlined, color: primary),
                        ),
                        title: Text(
                          entry.subject,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          '${entry.id}\n${entry.message}\n${entry.status}',
                        ),
                        trailing: Text(_systemTimeAgo(entry.createdAt)),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AboutPage extends StatelessWidget {
  final UserRole role;
  const _AboutPage({required this.role});

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(role);
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE3E6F1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BarangayMo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text('Version: $_appVersionLabel'),
                const SizedBox(height: 4),
                Text('Credits: $_appCreditsLabel'),
                const SizedBox(height: 12),
                const Text(
                  'Data Privacy Act Links',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text('https://privacy.gov.ph/data-privacy-act/'),
                const Text(
                  'https://privacy.gov.ph/implementing-rules-and-regulations/',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCenterPage extends StatefulWidget {
  final UserRole role;
  const _FaqCenterPage({required this.role});

  @override
  State<_FaqCenterPage> createState() => _FaqCenterPageState();
}

class _FaqCenterPageState extends State<_FaqCenterPage> {
  String _query = '';

  Map<String, List<(String, String)>> get _categories => {
    'Account': [
      (
        'How do I change my security PIN?',
        'Open Secure Settings, enter your current PIN, then save a new 6-digit PIN.',
      ),
      (
        'How do I update my profile?',
        'Use Profile Editor to update your name, photo, and phone number.',
      ),
    ],
    'Notifications': [
      (
        'How do I clear unread notices?',
        'Open Notification Center and tap Mark all as read.',
      ),
    ],
    'Support': [
      (
        'How do I contact the help desk?',
        'Open Help Desk, enter your concern, and submit a ticket with your contact number.',
      ),
    ],
    'Transactions': [
      (
        'Where do I see requests and orders together?',
        'Open Transaction History to view document requests and marketplace orders in one list.',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(widget.role);
    final filtered = <String, List<(String, String)>>{};
    for (final entry in _categories.entries) {
      final items = entry.value.where((item) {
        final bag = '${entry.key} ${item.$1} ${item.$2}'.toLowerCase();
        return _query.trim().isEmpty || bag.contains(_query.trim().toLowerCase());
      }).toList();
      if (items.isNotEmpty) {
        filtered[entry.key] = items;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: _appText('Search help topics', 'Maghanap ng help topics'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            _AppEmptyState(
              icon: Icons.search_off_rounded,
              title: _appText('No FAQ results', 'Walang FAQ results'),
              subtitle: _appText(
                'Try a broader keyword or browse the categories later.',
                'Subukan ang mas malawak na keyword o balikan ang mga category mamaya.',
              ),
            )
          else
            ...filtered.entries.map(
              (category) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE3E6F1)),
                ),
                child: ExpansionTile(
                  title: _HighlightedText(
                    text: category.key,
                    query: _query,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  children: category.value
                      .map(
                        (item) => ListTile(
                          title: _HighlightedText(
                            text: item.$1,
                            query: _query,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: _HighlightedText(
                            text: item.$2,
                            query: _query,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _systemInfoChip({
  required IconData icon,
  required String label,
  required String value,
  required Color accent,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: accent.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: accent),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF5F6784),
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _AdvancedNotificationCenterPage extends StatelessWidget {
  final UserRole role;
  const _AdvancedNotificationCenterPage({required this.role});

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(role);
    final preferences = _notificationPreferencesForRole(role).value;
    final tokens = _notificationDispatcherTokens.value
        .where((token) => token.role == role)
        .length;
    final deferred = _deferredNotifications.value
        .where((entry) => entry.role == role)
        .length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _NotificationPreferencesPage(role: role),
              ),
            ),
            icon: const Icon(Icons.tune_rounded),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _DirectMessagesHomePage(role: role),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          if (role == UserRole.official)
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const _OfficialBroadcastPage(),
                ),
              ),
              icon: const Icon(Icons.campaign_rounded),
            ),
          TextButton(
            onPressed: () => _markAllNotificationsRead(role),
            child: const Text(
              'Mark all',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<_AppNotificationItem>>(
        valueListenable: _notificationCenterForRole(role),
        builder: (context, items, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ValueListenableBuilder<int>(
                valueListenable: _notificationBadgeForRole(role),
                builder: (context, badgeCount, __) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE3E6F1)),
                    ),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _systemInfoChip(
                          icon: Icons.notifications_active_outlined,
                          label: 'Badge count',
                          value: '$badgeCount',
                          accent: primary,
                        ),
                        _systemInfoChip(
                          icon: Icons.cloud_done_outlined,
                          label: 'FCM tokens',
                          value: '$tokens',
                          accent: primary,
                        ),
                        _systemInfoChip(
                          icon: Icons.bedtime_outlined,
                          label: 'Deferred',
                          value: '$deferred',
                          accent: primary,
                        ),
                        _systemInfoChip(
                          icon: Icons.sms_outlined,
                          label: 'SMS',
                          value: preferences.smsEnabled ? 'On' : 'Off',
                          accent: primary,
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (items.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('No notifications yet.'),
                  ),
                )
              else
                ...items.map((item) {
                  final accent = _notificationPriorityColor(item.priority);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: item.read ? Colors.white : _systemSoftForRole(role),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: item.read
                            ? const Color(0xFFE3E6F1)
                            : accent.withValues(alpha: 0.35),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: accent.withValues(alpha: 0.12),
                        child: Icon(item.icon, color: accent),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              item.priority.toUpperCase(),
                              style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '${item.category} - ${item.body}\n${_notificationLinkSummary(item)}',
                      ),
                      trailing: Text(_systemTimeAgo(item.createdAt)),
                      onTap: () => _openNotificationTarget(
                        context,
                        role: role,
                        item: item,
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _NotificationPreferencesPage extends StatefulWidget {
  final UserRole role;
  const _NotificationPreferencesPage({required this.role});

  @override
  State<_NotificationPreferencesPage> createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<_NotificationPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(widget.role);
    return ValueListenableBuilder<_NotificationPreferenceSettings>(
      valueListenable: _notificationPreferencesForRole(widget.role),
      builder: (context, settings, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notification Preferences'),
            backgroundColor: primary,
            foregroundColor: Colors.white,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile.adaptive(
                value: settings.pushEnabled,
                onChanged: (value) {
                  _notificationPreferencesForRole(widget.role).value =
                      settings.copyWith(pushEnabled: value);
                  setState(() {});
                },
                title: const Text('Push Notifications'),
                subtitle: const Text('Use FCM tokens for app notifications.'),
              ),
              SwitchListTile.adaptive(
                value: settings.smsEnabled,
                onChanged: (value) {
                  _notificationPreferencesForRole(widget.role).value =
                      settings.copyWith(smsEnabled: value);
                  setState(() {});
                },
                title: const Text('SMS Failover'),
                subtitle: const Text('Use SMS routing for high-priority alerts.'),
              ),
              SwitchListTile.adaptive(
                value: settings.marketingEnabled,
                onChanged: (value) {
                  _notificationPreferencesForRole(widget.role).value =
                      settings.copyWith(marketingEnabled: value);
                  setState(() {});
                },
                title: const Text('Marketing Alerts'),
                subtitle: const Text('Allow non-essential promotional announcements.'),
              ),
              SwitchListTile.adaptive(
                value: settings.quietHoursEnabled,
                onChanged: (value) {
                  _notificationPreferencesForRole(widget.role).value =
                      settings.copyWith(quietHoursEnabled: value);
                  setState(() {});
                },
                title: const Text('Quiet Hours'),
                subtitle: const Text('Hold non-emergency alerts during nighttime.'),
              ),
              if (settings.quietHoursEnabled) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: settings.quietStartHour,
                        decoration: const InputDecoration(
                          labelText: 'Quiet from',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(
                          24,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(_hourLabel(index)),
                          ),
                        ),
                        onChanged: (value) {
                          if (value == null) return;
                          _notificationPreferencesForRole(widget.role).value =
                              settings.copyWith(quietStartHour: value);
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: settings.quietEndHour,
                        decoration: const InputDecoration(
                          labelText: 'Quiet until',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(
                          24,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(_hourLabel(index)),
                          ),
                        ),
                        onChanged: (value) {
                          if (value == null) return;
                          _notificationPreferencesForRole(widget.role).value =
                              settings.copyWith(quietEndHour: value);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  _flushDeferredNotifications();
                  _showFeature(context, 'Notification preferences updated.');
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Preferences'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationDispatchLogPage extends StatelessWidget {
  final UserRole role;
  const _NotificationDispatchLogPage({required this.role});

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(role);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatch Log'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<List<_NotificationDispatchLogEntry>>(
        valueListenable: _notificationDispatchLog,
        builder: (context, items, _) {
          final filtered = items.where((entry) => entry.role == role).toList();
          if (filtered.isEmpty) {
            return const Center(child: Text('No dispatch logs yet.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: filtered
                .map(
                  (entry) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _systemSoftForRole(role),
                        child: Icon(Icons.send_outlined, color: primary),
                      ),
                      title: Text(
                        entry.title,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        '${entry.audience}\n${entry.channel} via ${entry.provider}\n${entry.status}',
                      ),
                      trailing: Text(_systemTimeAgo(entry.createdAt)),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _OfficialBroadcastPage extends StatefulWidget {
  const _OfficialBroadcastPage();

  @override
  State<_OfficialBroadcastPage> createState() => _OfficialBroadcastPageState();
}

class _OfficialBroadcastPageState extends State<_OfficialBroadcastPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _zone = 'All';
  String _purok = 'All';
  String _residentType = 'All';
  bool _emergency = false;

  List<_BroadcastResidentProfile> get _recipients => _filterBroadcastRecipients(
    zone: _zone,
    purok: _purok,
    residentType: _residentType,
  );

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _send() {
    if (_titleController.text.trim().isEmpty ||
        _bodyController.text.trim().length < 8) {
      _showFeature(context, 'Enter a title and a fuller broadcast message.');
      return;
    }
    _sendOfficialBroadcast(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      zone: _zone,
      purok: _purok,
      residentType: _residentType,
      emergency: _emergency,
    );
    _showFeature(context, 'Broadcast dispatched to ${_recipients.length} recipients.');
    _titleController.clear();
    _bodyController.clear();
    setState(() => _emergency = false);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFB31212);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Official Broadcast'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const _NotificationDispatchLogPage(
                  role: UserRole.official,
                ),
              ),
            ),
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Broadcast title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _bodyController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Message body',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _zone,
                  decoration: const InputDecoration(
                    labelText: 'Zone',
                    border: OutlineInputBorder(),
                  ),
                  items: const ['All', 'Zone 1', 'Zone 2', 'Zone 3']
                      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) => setState(() => _zone = value ?? 'All'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _purok,
                  decoration: const InputDecoration(
                    labelText: 'Purok',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      const ['All', 'Purok 1', 'Purok 2', 'Purok 3', 'Purok 4']
                          .map(
                            (item) =>
                                DropdownMenuItem(value: item, child: Text(item)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _purok = value ?? 'All'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _residentType,
            decoration: const InputDecoration(
              labelText: 'Resident Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              'All',
              'General',
              'Senior Citizen',
              'PWD',
              'Solo Parent',
            ].map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (value) => setState(() => _residentType = value ?? 'All'),
          ),
          const SizedBox(height: 10),
          SwitchListTile.adaptive(
            value: _emergency,
            onChanged: (value) => setState(() => _emergency = value),
            title: const Text('Emergency / high-priority alert'),
            subtitle: const Text('Bypasses quiet hours and activates SMS failover.'),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE7D7D7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Targeted recipients (${_recipients.length})',
                  style: const TextStyle(
                    color: Color(0xFF5A2B2B),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                if (_recipients.isEmpty)
                  const Text('No residents match the current audience filter.')
                else
                  ..._recipients.take(5).map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '${entry.name} - ${entry.zone}, ${entry.purok} - ${entry.residentType}',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _send,
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.send_rounded),
            label: const Text(
              'Dispatch Broadcast',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectMessagesHomePage extends StatefulWidget {
  final UserRole role;
  final String? initialThreadId;
  const _DirectMessagesHomePage({required this.role, this.initialThreadId});

  @override
  State<_DirectMessagesHomePage> createState() => _DirectMessagesHomePageState();
}

class _DirectMessagesHomePageState extends State<_DirectMessagesHomePage> {
  late final StreamSubscription<_DirectMessageEntry> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _directMessageStreamController.stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
    final initialThreadId = widget.initialThreadId;
    if (initialThreadId != null && initialThreadId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _openThread(initialThreadId);
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  List<String> _threadIds() {
    if (widget.role == UserRole.resident) {
      return [_currentResidentThreadId()];
    }
    final ids = _directMessageStore.value.map((entry) => entry.threadId).toSet().toList()
      ..sort();
    return ids;
  }

  _BroadcastResidentProfile _residentForThread(String threadId) {
    final mobile = threadId.replaceFirst('resident-', '');
    return _broadcastResidentDirectory.firstWhere(
      (entry) => _normalizeMobileForKey(entry.mobile) == mobile,
      orElse: () => const _BroadcastResidentProfile(
        name: 'Resident',
        mobile: '09171234567',
        zone: 'Zone 1',
        purok: 'Purok 1',
        residentType: 'General',
      ),
    );
  }

  void _openThread(String threadId) {
    final resident = _residentForThread(threadId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DirectConversationPage(
          role: widget.role,
          resident: resident,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(widget.role);
    final threads = _threadIds();
    return Scaffold(
      appBar: AppBar(
        title: const Text('In-app Messages'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: threads.map((threadId) {
          final resident = _residentForThread(threadId);
          final messages = _messagesForThread(threadId);
          final latest = messages.isNotEmpty ? messages.last : null;
          final unread = messages
              .where((entry) => entry.senderRole != widget.role && entry.readAt == null)
              .length;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _systemSoftForRole(widget.role),
                child: Icon(Icons.forum_outlined, color: primary),
              ),
              title: Text(
                widget.role == UserRole.official ? resident.name : 'Barangay Secretary',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                latest == null
                    ? 'No messages yet.'
                    : '${latest.text ?? 'Image attachment'}\n${resident.zone} / ${resident.purok}',
              ),
              trailing: unread > 0
                  ? CircleAvatar(
                      radius: 12,
                      backgroundColor: primary,
                      child: Text(
                        '$unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  : Text(latest == null ? '' : _systemTimeAgo(latest.createdAt)),
              onTap: () => _openThread(threadId),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DirectConversationPage extends StatefulWidget {
  final UserRole role;
  final _BroadcastResidentProfile resident;
  const _DirectConversationPage({
    required this.role,
    required this.resident,
  });

  @override
  State<_DirectConversationPage> createState() => _DirectConversationPageState();
}

class _DirectConversationPageState extends State<_DirectConversationPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final StreamSubscription<_DirectMessageEntry> _subscription;

  String get _threadId => _directThreadId(widget.resident.mobile);

  List<_DirectMessageEntry> get _messages => _messagesForThread(_threadId);

  @override
  void initState() {
    super.initState();
    _markDirectMessagesRead(widget.role, _threadId);
    _subscription = _directMessageStreamController.stream.listen((entry) {
      if (entry.threadId != _threadId || !mounted) {
        return;
      }
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _sendText() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    _sendDirectMessage(
      senderRole: widget.role,
      residentName: widget.resident.name,
      residentMobile: widget.resident.mobile,
      text: text,
    );
    _messageController.clear();
    _markDirectMessagesRead(widget.role, _threadId);
    setState(() {});
  }

  Future<void> _sendImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
    );
    if (picked == null) {
      return;
    }
    final bytes = await picked.readAsBytes();
    if (!mounted) {
      return;
    }
    _sendDirectMessage(
      senderRole: widget.role,
      residentName: widget.resident.name,
      residentMobile: widget.resident.mobile,
      imageBytes: bytes,
    );
    _markDirectMessagesRead(widget.role, _threadId);
    setState(() {});
  }

  String _receiptLabel(_DirectMessageEntry message) {
    if (message.senderRole != widget.role) {
      return _systemTimeAgo(message.createdAt);
    }
    if (message.readAt != null) {
      return 'Seen ${_systemTimeAgo(message.readAt!)}';
    }
    return 'Delivered';
  }

  @override
  Widget build(BuildContext context) {
    final primary = _systemPrimaryForRole(widget.role);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.role == UserRole.official ? widget.resident.name : 'Barangay Secretary',
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: _systemSoftForRole(widget.role),
            child: Text(
              'Live socket connected. Messages sync instantly with read receipts.',
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final mine = message.senderRole == widget.role;
                return Align(
                  alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 290),
                    decoration: BoxDecoration(
                      color: mine ? primary : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: mine
                            ? primary.withValues(alpha: 0.3)
                            : const Color(0xFFE3E6F1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.text != null && message.text!.isNotEmpty)
                          Text(
                            message.text!,
                            style: TextStyle(
                              color: mine ? Colors.white : const Color(0xFF2F3248),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (message.hasImage) ...[
                          if (message.text != null && message.text!.isNotEmpty)
                            const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.memory(
                              message.imageBytes!,
                              width: 200,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          _receiptLabel(message),
                          style: TextStyle(
                            color: mine
                                ? const Color(0xFFFADCDC)
                                : const Color(0xFF7B819A),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _sendImage,
                    icon: Icon(Icons.image_outlined, color: primary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _sendText,
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
