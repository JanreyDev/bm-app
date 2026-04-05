part of barangaymo_app;

class SerbilisServicesPage extends StatelessWidget {
  const SerbilisServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Serbilis Services'),
          backgroundColor: _officialHeaderStart,
          foregroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_officialHeaderStart, _officialHeaderEnd],
              ),
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: _officialHeroSubtext,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            tabs: [
              Tab(text: 'Brgy Services'),
              Tab(text: 'SK Services'),
            ],
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF7F8FC), _officialSurfaceBlend],
              ),
            ),
          child: TabBarView(
            children: [
              _serviceGrid(context, _brgyServices),
              _serviceGrid(context, _skServices),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceGrid(BuildContext context, List<_ServiceAction> data) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_officialHeaderStart, _officialHeaderEnd],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(
                  Icons.miscellaneous_services_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Official Service Console',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Run barangay workflows and track resident-facing service modules.',
                      style: TextStyle(
                        color: _officialHeroSubtext,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth < 360 ? 2 : 3;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.92,
              ),
              itemCount: data.length,
              itemBuilder: (_, index) {
                final item = data[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.page),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _officialCardBorder),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEFEA),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: _officialHeaderStart,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: _officialText,
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
      ],
    );
  }
}

class OfficialRequestsInboxPage extends StatefulWidget {
  final String? serviceCategory;
  final String? pageTitle;

  const OfficialRequestsInboxPage({
    super.key,
    this.serviceCategory,
    this.pageTitle,
  });

  @override
  State<OfficialRequestsInboxPage> createState() => _OfficialRequestsInboxPageState();
}

class _OfficialRequestsInboxPageState extends State<OfficialRequestsInboxPage> {
  final _statusFilters = const <String>['All', 'Pending', 'Approved', 'Rejected', 'Completed'];
  final _entries = <_ResidentRequestEntry>[];
  bool _loading = true;
  bool _updating = false;
  String _selectedStatus = 'All';
  String _search = '';

  bool get _isResponderFilter =>
      (widget.serviceCategory ?? '').trim().toLowerCase() == 'responder';

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final result = await _ServiceRequestApi.instance.fetchRequests();
    if (!mounted) return;
    if (result.success) {
      setState(() {
        _entries
          ..clear()
          ..addAll(result.entries);
        _loading = false;
      });
      return;
    }
    setState(() => _loading = false);
    _showFeature(context, result.message);
  }

  List<_ResidentRequestEntry> get _filtered {
    final requestedCategory = widget.serviceCategory?.trim().toLowerCase();
    return _entries.where((item) {
      if (requestedCategory != null && requestedCategory.isNotEmpty) {
        final itemCategory = item.category.trim().toLowerCase();
        if (itemCategory != requestedCategory) {
          return false;
        }
      }
      final statusOk = _selectedStatus == 'All' || item.status == _selectedStatus;
      if (!statusOk) return false;
      if (_search.trim().isEmpty) return true;
      final q = _search.trim().toLowerCase();
      final bucket =
          '${item.category} ${item.title} ${item.requestId} ${item.purpose} ${item.requesterName} ${item.requesterMobile}'
              .toLowerCase();
      return bucket.contains(q);
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF1F8A55);
      case 'Rejected':
        return const Color(0xFFC0483C);
      case 'Completed':
        return const Color(0xFF3557C8);
      case 'Pending':
      default:
        return const Color(0xFFB1762B);
    }
  }

  Future<void> _changeStatus(_ResidentRequestEntry item) async {
    final next = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['Pending', 'Approved', 'Rejected', 'Completed'].map((status) {
                final selected = item.status == status;
                return ListTile(
                  leading: Icon(
                    selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  ),
                  title: Text(status),
                  onTap: () => Navigator.pop(context, status),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    if (!mounted || next == null || next == item.status || item.id <= 0) {
      return;
    }
    setState(() => _updating = true);
    final result = await _ServiceRequestApi.instance.updateRequestStatus(
      serviceRequestId: item.id,
      status: next,
    );
    if (!mounted) return;
    setState(() => _updating = false);
    _showFeature(context, result.message, tone: result.success ? _ToastTone.success : _ToastTone.warning);
    if (result.success) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle ?? 'Requests Inbox'),
        backgroundColor: _officialHeaderStart,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FC), _officialSurfaceBlend],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              if (_isResponderFilter) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyResponderDashboardPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.map_rounded),
                    label: const Text('Open Responder Dashboard'),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              TextField(
                onChanged: (value) => setState(() => _search = value),
                decoration: const InputDecoration(
                  hintText: 'Search by request ID, title, requester...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _statusFilters.map((label) {
                  final selected = _selectedStatus == label;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedStatus = label),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              if ((widget.serviceCategory ?? '').trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_rounded, size: 16, color: _officialSubtext),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Service filter: ${widget.serviceCategory}',
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    (widget.serviceCategory ?? '').trim().isEmpty
                        ? 'No requests found for this filter.'
                        : 'No ${widget.serviceCategory} requests found for this filter.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _officialSubtext,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                ..._filtered.map((item) {
                  final accent = _statusColor(item.status);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _officialCardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  color: _officialText,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  color: accent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${item.requestId} | ${item.date}',
                          style: const TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        if (item.requesterName.trim().isNotEmpty || item.requesterMobile.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'Requester: ${item.requesterName.isEmpty ? '-' : item.requesterName}'
                              '${item.requesterMobile.isEmpty ? '' : ' • ${item.requesterMobile}'}',
                              style: const TextStyle(
                                color: _officialSubtext,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          item.purpose,
                          style: const TextStyle(
                            color: _officialText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: _updating ? null : () => _changeStatus(item),
                            style: FilledButton.styleFrom(
                              backgroundColor: _officialHeaderStart,
                            ),
                            icon: const Icon(Icons.edit_note_rounded),
                            label: Text(_updating ? 'Updating...' : 'Update Status'),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfficialFeedbackQuickSheet extends StatelessWidget {
  const _OfficialFeedbackQuickSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback and Reports',
              style: TextStyle(
                color: _officialText,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Send in-app feedback, report bugs, or contact support without leaving the official dashboard.',
              style: TextStyle(
                color: _officialSubtext,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            _quickSheetTile(
              context,
              icon: Icons.bug_report_outlined,
              title: 'Bug Report',
              subtitle: 'Report app issues and broken flows',
              page: const OfficialBugReportPage(),
            ),
            _quickSheetTile(
              context,
              icon: Icons.feedback_outlined,
              title: 'Quick Feedback',
              subtitle: 'Send suggestions to the product team',
              page: const OfficialSupportPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickSheetTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _officialCardBorder),
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _officialSoftAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _officialHeaderStart),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: _officialText,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: _officialSubtext,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}

class OfficialGovAgenciesPage extends StatefulWidget {
  const OfficialGovAgenciesPage({super.key});

  @override
  State<OfficialGovAgenciesPage> createState() => _OfficialGovAgenciesPageState();
}

class _OfficialGovAgenciesPageState extends State<OfficialGovAgenciesPage> {
  bool _loading = true;
  bool _saving = false;
  String _message = '';
  List<_OfficialAgencyInfo> _agencies = const <_OfficialAgencyInfo>[];

  @override
  void initState() {
    super.initState();
    unawaited(_loadAgencies());
  }

  Future<void> _loadAgencies() async {
    setState(() => _loading = true);
    final result = await _OfficialGovAgenciesApi.instance.fetchAgencies();
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      _message = result.message;
      _agencies = result.agencies;
    });
  }

  Future<void> _addOrEditAgency({_OfficialAgencyInfo? existing}) async {
    final labelCtrl = TextEditingController(text: existing?.label ?? '');
    final nameCtrl = TextEditingController(text: existing?.displayName ?? '');
    final websiteCtrl = TextEditingController(text: existing?.website ?? '');
    final sortCtrl = TextEditingController(
      text: existing?.sortOrder.toString() ?? '0',
    );
    final isEdit = existing != null;
    final submit = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (dialogContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16 + MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Agency' : 'Add Agency',
                style: const TextStyle(
                  color: _officialText,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: labelCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code (e.g. PNP)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: websiteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Website URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: sortCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Sort order',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: _officialHeaderStart,
                  ),
                  child: Text(isEdit ? 'Save Changes' : 'Add Agency'),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (submit != true || !mounted) {
      return;
    }

    final label = labelCtrl.text.trim();
    final name = nameCtrl.text.trim();
    final website = websiteCtrl.text.trim();
    final sortOrder = int.tryParse(sortCtrl.text.trim()) ?? 0;
    if (label.isEmpty || name.isEmpty || website.isEmpty) {
      _showFeature(
        context,
        'Please complete code, display name, and website.',
        tone: _ToastTone.warning,
      );
      return;
    }

    setState(() => _saving = true);
    final result = isEdit
        ? await _OfficialGovAgenciesApi.instance.updateAgency(
            agencyId: existing.id,
            label: label,
            displayName: name,
            website: website,
            sortOrder: sortOrder,
          )
        : await _OfficialGovAgenciesApi.instance.createAgency(
            label: label,
            displayName: name,
            website: website,
            sortOrder: sortOrder,
          );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    _showFeature(
      context,
      result.message,
      tone: result.success ? _ToastTone.success : _ToastTone.warning,
    );
    if (result.success) {
      await _loadAgencies();
    }
  }

  Future<void> _deleteAgency(_OfficialAgencyInfo agency) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Agency'),
          content: Text('Delete ${agency.displayName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD70000)),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _saving = true);
    final result = await _OfficialGovAgenciesApi.instance.deleteAgency(
      agencyId: agency.id,
    );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    _showFeature(
      context,
      result.message,
      tone: result.success ? _ToastTone.success : _ToastTone.warning,
    );
    if (result.success) {
      await _loadAgencies();
    }
  }

  Future<void> _showLeaveDialog(
    BuildContext context,
    _OfficialAgencyInfo agency,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 68,
                    color: Color(0xFFBEBEBE),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'You are leaving BarangayMo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2B2D3A),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to visit ${agency.displayName}\'s website?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF666B82),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE7E7E7),
                          foregroundColor: const Color(0xFF353535),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Stay here'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _showFeature(
                            context,
                            'Open this website in your browser: ${agency.website}',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD70000),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _agencyTile(BuildContext context, _OfficialAgencyInfo agency) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showLeaveDialog(context, agency),
      onLongPress: () async {
        final action = await showModalBottomSheet<String>(
          context: context,
          showDragHandle: true,
          builder: (dialogContext) {
            return SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_rounded),
                    title: const Text('Edit'),
                    onTap: () => Navigator.pop(dialogContext, 'edit'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD70000)),
                    title: const Text('Delete'),
                    onTap: () => Navigator.pop(dialogContext, 'delete'),
                  ),
                ],
              ),
            );
          },
        );
        if (!mounted) return;
        if (action == 'edit') {
          await _addOrEditAgency(existing: agency);
        } else if (action == 'delete') {
          await _deleteAgency(agency);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: agency.accent.withValues(alpha: 0.12),
                  border: Border.all(
                    color: agency.accent.withValues(alpha: 0.28),
                    width: 2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(agency.icon, color: agency.accent, size: 24),
                    Positioned(
                      bottom: 9,
                      child: Text(
                        agency.label,
                        style: TextStyle(
                          color: agency.accent,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            agency.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2F3248),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Government\nAgencies'),
        backgroundColor: const Color(0xFFD70000),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 82,
        actions: [
          IconButton(
            onPressed: _saving ? null : () => _addOrEditAgency(),
            icon: const Icon(Icons.add_rounded),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OfficialNotificationsPage(),
              ),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAgencies,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            if (_saving)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            if (_message.trim().isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD7BA)),
                ),
                child: Text(
                  _message,
                  style: const TextStyle(
                    color: Color(0xFF8B4A0D),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _officialCardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECEC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.assignment_rounded,
                      color: _officialHeaderStart,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gov Agencies Requests',
                          style: TextStyle(
                            color: _officialText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Review and update resident requests related to government agencies.',
                          style: TextStyle(
                            color: _officialSubtext,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OfficialRequestsInboxPage(
                            serviceCategory: 'Gov Agencies',
                            pageTitle: 'Gov Agencies Requests',
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _officialHeaderStart,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    child: const Text('View'),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: const Color(0xFFE8E8E8)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (_agencies.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'No agencies available for this barangay yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF666B82),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _agencies.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (_, index) =>
                          _agencyTile(context, _agencies[index]),
                    ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFB80F0F), Color(0xFFD73232)],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22B11212),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REGISTRY OF BARANGAY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'INHABITANTS (RBI)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Avail services by registering your barangay.',
                                style: TextStyle(
                                  color: Color(0xFFFFE5E5),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 76,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.14),
                            ),
                          ),
                          child: const Icon(
                            Icons.badge_rounded,
                            color: Colors.white,
                            size: 34,
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

class _OfficialAgencyInfo {
  final int id;
  final String label;
  final String displayName;
  final String website;
  final int sortOrder;
  final Color accent;
  final IconData icon;

  const _OfficialAgencyInfo({
    this.id = 0,
    required this.label,
    required this.displayName,
    required this.website,
    this.sortOrder = 0,
    required this.accent,
    required this.icon,
  });
}

class _OfficialGovAgenciesApiResult {
  final bool success;
  final String message;
  final List<_OfficialAgencyInfo> agencies;

  const _OfficialGovAgenciesApiResult({
    required this.success,
    required this.message,
    this.agencies = const <_OfficialAgencyInfo>[],
  });
}

class _OfficialGovAgencyActionResult {
  final bool success;
  final String message;
  final _OfficialAgencyInfo? agency;

  const _OfficialGovAgencyActionResult({
    required this.success,
    required this.message,
    this.agency,
  });
}

class _OfficialGovAgenciesApi {
  _OfficialGovAgenciesApi._();
  static final instance = _OfficialGovAgenciesApi._();

  Map<String, String> _scopePayload() {
    final profile = _officialEditableProfile.value;
    final province = _officialBarangaySetup.province.trim();
    final city = _officialBarangaySetup.city.trim();
    final barangay = profile.barangay.trim().isNotEmpty
        ? profile.barangay.trim()
        : _officialBarangaySetup.barangay.trim();
    final payload = <String, String>{};
    if (province.isNotEmpty) payload['province'] = province;
    if (city.isNotEmpty) payload['city_municipality'] = city;
    if (barangay.isNotEmpty) payload['barangay'] = barangay;
    return payload;
  }

  Future<_OfficialGovAgenciesApiResult> fetchAgencies() async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _OfficialGovAgenciesApiResult(
        success: false,
        message: 'Please log in again to load agencies.',
      );
    }

    final paths = <String>['official/gov-agencies', 'official/agencies'];
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
          final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
          final body = decoded is Map<String, dynamic>
              ? decoded
              : const <String, dynamic>{};
          if (response.statusCode < 200 || response.statusCode >= 300) {
            return _OfficialGovAgenciesApiResult(
              success: false,
              message: _extractApiMessage(
                body,
                fallback: 'Unable to load agencies.',
              ),
            );
          }
          final rows = <_OfficialAgencyInfo>[];
          final raw = body['agencies'] ?? body['data'];
          if (raw is List) {
            for (final item in raw) {
              if (item is! Map<String, dynamic>) continue;
              final mapped = _mapAgency(item);
              if (mapped != null) rows.add(mapped);
            }
          }
          return _OfficialGovAgenciesApiResult(
            success: true,
            message: _extractApiMessage(body, fallback: 'Agencies loaded.'),
            agencies: rows..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
          );
        } on TimeoutException {
          return const _OfficialGovAgenciesApiResult(
            success: false,
            message: 'Loading agencies timed out.',
          );
        } catch (_) {
          return const _OfficialGovAgenciesApiResult(
            success: false,
            message: 'Cannot connect to server to load agencies.',
          );
        }
      }
    }
    return const _OfficialGovAgenciesApiResult(
      success: false,
      message: 'Agencies endpoint is not available yet.',
    );
  }

  Future<_OfficialGovAgencyActionResult> createAgency({
    required String label,
    required String displayName,
    required String website,
    required int sortOrder,
  }) async {
    final payload = jsonEncode({
      'label': label.trim(),
      'display_name': displayName.trim(),
      'website': website.trim(),
      'sort_order': sortOrder,
      ..._scopePayload(),
    });
    return _mutateAgency(
      method: 'POST',
      path: 'official/gov-agencies',
      payload: payload,
      fallback: 'Unable to add agency.',
    );
  }

  Future<_OfficialGovAgencyActionResult> updateAgency({
    required int agencyId,
    required String label,
    required String displayName,
    required String website,
    required int sortOrder,
  }) async {
    final payload = jsonEncode({
      'label': label.trim(),
      'display_name': displayName.trim(),
      'website': website.trim(),
      'sort_order': sortOrder,
      ..._scopePayload(),
    });
    return _mutateAgency(
      method: 'PATCH',
      path: 'official/gov-agencies/$agencyId',
      payload: payload,
      fallback: 'Unable to update agency.',
    );
  }

  Future<_OfficialGovAgencyActionResult> deleteAgency({
    required int agencyId,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _OfficialGovAgencyActionResult(
        success: false,
        message: 'Please log in again to manage agencies.',
      );
    }
    final path = 'official/gov-agencies/$agencyId';
    for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
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
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode < 200 || response.statusCode >= 300) {
          return _OfficialGovAgencyActionResult(
            success: false,
            message: _extractApiMessage(body, fallback: 'Unable to delete agency.'),
          );
        }
        return _OfficialGovAgencyActionResult(
          success: true,
          message: _extractApiMessage(body, fallback: 'Agency deleted.'),
        );
      } on TimeoutException {
        return const _OfficialGovAgencyActionResult(
          success: false,
          message: 'Delete agency request timed out.',
        );
      } catch (_) {
        return const _OfficialGovAgencyActionResult(
          success: false,
          message: 'Cannot connect to server to delete agency.',
        );
      }
    }
    return const _OfficialGovAgencyActionResult(
      success: false,
      message: 'Agencies endpoint is not available yet.',
    );
  }

  Future<_OfficialGovAgencyActionResult> _mutateAgency({
    required String method,
    required String path,
    required String payload,
    required String fallback,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      return const _OfficialGovAgencyActionResult(
        success: false,
        message: 'Please log in again to manage agencies.',
      );
    }
    for (final endpoint in _AuthApi.instance._endpointCandidates(path)) {
      try {
        final uri = endpoint;
        final headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        };
        final Future<http.Response> requestFuture = method == 'POST'
            ? http.post(uri, headers: headers, body: payload)
            : http.patch(uri, headers: headers, body: payload);
        final response = await requestFuture.timeout(const Duration(seconds: 8));
        if (response.statusCode == 404) {
          continue;
        }
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        final body = decoded is Map<String, dynamic>
            ? decoded
            : const <String, dynamic>{};
        if (response.statusCode < 200 || response.statusCode >= 300) {
          return _OfficialGovAgencyActionResult(
            success: false,
            message: _extractApiMessage(body, fallback: fallback),
          );
        }
        final raw = body['agency'] ?? body['data'];
        final mapped = raw is Map<String, dynamic> ? _mapAgency(raw) : null;
        return _OfficialGovAgencyActionResult(
          success: true,
          message: _extractApiMessage(
            body,
            fallback: method == 'POST' ? 'Agency added.' : 'Agency updated.',
          ),
          agency: mapped,
        );
      } on TimeoutException {
        return const _OfficialGovAgencyActionResult(
          success: false,
          message: 'Agency request timed out.',
        );
      } catch (_) {
        return const _OfficialGovAgencyActionResult(
          success: false,
          message: 'Cannot connect to server to manage agencies.',
        );
      }
    }
    return const _OfficialGovAgencyActionResult(
      success: false,
      message: 'Agencies endpoint is not available yet.',
    );
  }

  _OfficialAgencyInfo? _mapAgency(Map<String, dynamic> raw) {
    String read(String key, {String fallback = ''}) {
      final value = raw[key];
      if (value == null) return fallback;
      final text = value.toString().trim();
      return text.isEmpty ? fallback : text;
    }

    final label = read('label', fallback: read('code'));
    final name = read('display_name', fallback: label);
    final website = read('website');
    if (label.isEmpty || website.isEmpty) {
      return null;
    }
    return _OfficialAgencyInfo(
      id: int.tryParse(read('id')) ?? 0,
      label: label,
      displayName: name,
      website: website,
      sortOrder: int.tryParse(read('sort_order')) ?? 0,
      accent: _officialAgencyAccent(label),
      icon: _officialAgencyIcon(label, name),
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

Color _officialAgencyAccent(String label) {
  final key = label.trim().toLowerCase();
  if (key.contains('pnp') || key.contains('police')) return const Color(0xFFB43434);
  if (key.contains('dilg')) return const Color(0xFFC68B0D);
  if (key.contains('dfa')) return const Color(0xFF154A99);
  if (key.contains('dole')) return const Color(0xFF2659B8);
  if (key.contains('dpwh')) return const Color(0xFF324D93);
  if (key.contains('dswd')) return const Color(0xFF6B6E77);
  if (key.contains('lto')) return const Color(0xFF1F4FA2);
  if (key.contains('tesda')) return const Color(0xFF3E7C86);
  if (key.contains('sen')) return const Color(0xFFC39B2C);
  return const Color(0xFF4A59A8);
}

IconData _officialAgencyIcon(String label, String displayName) {
  final bucket = '$label $displayName'.toLowerCase();
  if (bucket.contains('police') || bucket.contains('pnp')) {
    return Icons.local_police_rounded;
  }
  if (bucket.contains('transport') || bucket.contains('lto')) {
    return Icons.directions_car_filled_rounded;
  }
  if (bucket.contains('school') || bucket.contains('education') || bucket.contains('tesda')) {
    return Icons.school_rounded;
  }
  if (bucket.contains('labor') || bucket.contains('work') || bucket.contains('dole')) {
    return Icons.work_outline_rounded;
  }
  if (bucket.contains('foreign') || bucket.contains('dfa')) {
    return Icons.public_rounded;
  }
  if (bucket.contains('city') || bucket.contains('municipal')) {
    return Icons.location_city_rounded;
  }
  if (bucket.contains('president') || bucket.contains('office of the president')) {
    return Icons.flag_circle_rounded;
  }
  return Icons.account_balance_rounded;
}

class _ServiceAction {
  final String name;
  final IconData icon;
  final Widget page;
  const _ServiceAction(this.name, this.icon, this.page);
}

const _brgyServices = [
  _ServiceAction(
    'Assistance',
    Icons.volunteer_activism,
    OfficialRequestsInboxPage(
      serviceCategory: 'Assistance',
      pageTitle: 'Assistance Requests',
    ),
  ),
  _ServiceAction(
    'BPAT',
    Icons.shield,
    OfficialRequestsInboxPage(
      serviceCategory: 'BPAT',
      pageTitle: 'BPAT Requests',
    ),
  ),
  _ServiceAction(
    'Clearance',
    Icons.description,
    OfficialRequestsInboxPage(
      serviceCategory: 'Clearance',
      pageTitle: 'Clearance Requests',
    ),
  ),
  _ServiceAction(
    'Community',
    Icons.forum,
    OfficialRequestsInboxPage(
      serviceCategory: 'Community',
      pageTitle: 'Community Requests',
    ),
  ),
  _ServiceAction(
    'Council',
    Icons.groups,
    OfficialRequestsInboxPage(
      serviceCategory: 'Council',
      pageTitle: 'Council Requests',
    ),
  ),
  _ServiceAction(
    'Disclosure',
    Icons.table_chart,
    OfficialRequestsInboxPage(
      serviceCategory: 'Disclosure',
      pageTitle: 'Disclosure Requests',
    ),
  ),
  _ServiceAction(
    'Education',
    Icons.menu_book,
    OfficialRequestsInboxPage(
      serviceCategory: 'Education',
      pageTitle: 'Education Requests',
    ),
  ),
  _ServiceAction(
    'Gov Agencies',
    Icons.account_balance,
    OfficialGovAgenciesPage(),
  ),
  _ServiceAction(
    'Health',
    Icons.health_and_safety,
    OfficialRequestsInboxPage(
      serviceCategory: 'Health',
      pageTitle: 'Health Requests',
    ),
  ),

  _ServiceAction(
    'Merchant',
    Icons.store_rounded,
    OfficialMerchantVerificationPage(),
  ),
  _ServiceAction(
    'Other Barangay',
    Icons.travel_explore,
    OfficialRequestsInboxPage(
      serviceCategory: 'Other Barangay',
      pageTitle: 'Other Barangay Requests',
    ),
  ),
  _ServiceAction(
    'Police',
    Icons.local_police,
    OfficialRequestsInboxPage(
      serviceCategory: 'Police',
      pageTitle: 'Police Requests',
    ),
  ),
  _ServiceAction(
    'Provincial Govt',
    Icons.apartment_rounded,
    OfficialRequestsInboxPage(
      serviceCategory: 'Provincial Gov',
      pageTitle: 'Provincial Gov Requests',
    ),
  ),
  _ServiceAction(
    'QR ID',
    Icons.qr_code_scanner,
    OfficialRequestsInboxPage(
      serviceCategory: 'QR ID',
      pageTitle: 'QR ID Requests',
    ),
  ),
  _ServiceAction(
    'RBI',
    Icons.badge,
    OfficialRequestsInboxPage(
      serviceCategory: 'RBI',
      pageTitle: 'RBI Requests',
    ),
  ),
  _ServiceAction(
    'Responder',
    Icons.local_shipping,
    OfficialRequestsInboxPage(
      serviceCategory: 'Responder',
      pageTitle: 'Responder Requests',
    ),
  ),
  _ServiceAction(
    'Special Docs',
    Icons.stars,
    OfficialRequestsInboxPage(
      serviceCategory: 'Special Docs',
      pageTitle: 'Special Docs Requests',
    ),
  ),
];

const _skServices = [
  _ServiceAction(
    'Community',
    Icons.hub,
    OfficialRequestsInboxPage(
      serviceCategory: 'Community',
      pageTitle: 'Community Requests',
    ),
  ),
  _ServiceAction(
    'Education',
    Icons.school,
    OfficialRequestsInboxPage(
      serviceCategory: 'SK Education',
      pageTitle: 'SK Education Requests',
    ),
  ),
  _ServiceAction(
    'Officials',
    Icons.groups_2,
    OfficialRequestsInboxPage(
      serviceCategory: 'Officials',
      pageTitle: 'Officials Requests',
    ),
  ),
  _ServiceAction(
    'Programs',
    Icons.assignment,
    OfficialRequestsInboxPage(
      serviceCategory: 'Programs',
      pageTitle: 'Programs Requests',
    ),
  ),
  _ServiceAction(
    'Scholarship',
    Icons.card_giftcard,
    OfficialRequestsInboxPage(
      serviceCategory: 'Scholarship',
      pageTitle: 'Scholarship Requests',
    ),
  ),
  _ServiceAction(
    'Sports',
    Icons.sports_basketball,
    OfficialRequestsInboxPage(
      serviceCategory: 'Sports',
      pageTitle: 'Sports Requests',
    ),
  ),
];

class SimpleSerbilisPage extends StatelessWidget {
  final String title;
  final bool isOfficial;
  const SimpleSerbilisPage({
    super.key,
    required this.title,
    this.isOfficial = false,
  });

  void _openModule(
    BuildContext context,
    _SerbilisPortalItem item,
    Color heroStart,
    Color heroEnd,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _SerbilisModuleScreen(
          portalTitle: title,
          item: item,
          heroStart: heroStart,
          heroEnd: heroEnd,
          isOfficial: isOfficial,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _SerbilisPortalData.fromTitle(title);
    const residentAppBarBg = Color(0xFFF5F7FF);
    const residentFg = Color(0xFF2B3353);
    const residentBgStart = Color(0xFFF5F7FF);
    const residentBgEnd = Color(0xFFF0F3FF);
    const residentHeroStart = Color(0xFF3E4CC7);
    const residentHeroEnd = Color(0xFF6775E6);
    final appBarBg = isOfficial ? const Color(0xFFF7F8FC) : residentAppBarBg;
    final fg = isOfficial ? const Color(0xFF2F3248) : residentFg;
    final bgStart = isOfficial ? const Color(0xFFF7F8FC) : residentBgStart;
    final bgEnd = isOfficial ? _officialSurfaceBlend : residentBgEnd;
    final heroStart = isOfficial ? _officialHeaderStart : residentHeroStart;
    final heroEnd = isOfficial ? _officialHeaderEnd : residentHeroEnd;
    final heroSubtext = isOfficial
        ? _officialHeroSubtext
        : const Color(0xFFDDE3FF);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: appBarBg,
        foregroundColor: fg,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgStart, bgEnd],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [heroStart, heroEnd],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x30FFFFFF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isOfficial
                                ? 'Official Workflow'
                                : 'Resident Self-Service',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cfg.headline,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          cfg.description,
                          style: TextStyle(
                            color: heroSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: const Color(0x34FFFFFF),
                    child: Icon(cfg.icon, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...cfg.modules.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E8F2)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: heroStart),
                  ),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F3248),
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF676D86),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF636A85),
                  ),
                  onTap: () =>
                      _openModule(context, item, heroStart, heroEnd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SerbilisPortalData {
  final String headline;
  final String description;
  final Color heroStart;
  final Color heroEnd;
  final IconData icon;
  final List<_SerbilisPortalItem> modules;

  const _SerbilisPortalData({
    required this.headline,
    required this.description,
    required this.heroStart,
    required this.heroEnd,
    required this.icon,
    required this.modules,
  });

  static _SerbilisPortalData fromTitle(String title) {
    switch (title) {
      case 'Education':
      case 'SK Education':
        return const _SerbilisPortalData(
          headline: 'Barangay Education Hub',
          description:
              'Scholarships, training, and learning support for residents and youth.',
          heroStart: Color(0xFF4759C8),
          heroEnd: Color(0xFF6D7CE7),
          icon: Icons.menu_book,
          modules: [
            _SerbilisPortalItem(
              title: 'Scholarship Registry',
              subtitle: 'Apply and track scholarship assistance',
              icon: Icons.school,
              bg: Color(0xFFE3E9FF),
            ),
            _SerbilisPortalItem(
              title: 'TESDA Referral',
              subtitle: 'Skills training and employment readiness',
              icon: Icons.engineering,
              bg: Color(0xFFE8F2FF),
            ),
            _SerbilisPortalItem(
              title: 'ALS Enrollment',
              subtitle: 'Alternative learning support schedules',
              icon: Icons.groups,
              bg: Color(0xFFEAF5E8),
            ),
            _SerbilisPortalItem(
              title: 'Youth Programs',
              subtitle: 'Workshops, mentoring, and campus outreach',
              icon: Icons.workspace_premium,
              bg: Color(0xFFFFEFE1),
            ),
          ],
        );
      case 'Police':
        return const _SerbilisPortalData(
          headline: 'Police Coordination',
          description:
              'Incident reporting, blotter tracking, and safety coordination with PNP.',
          heroStart: Color(0xFF274F93),
          heroEnd: Color(0xFF4D72B3),
          icon: Icons.local_police,
          modules: [
            _SerbilisPortalItem(
              title: 'Report Incident',
              subtitle: 'Submit details for police and barangay response',
              icon: Icons.report_problem,
              bg: Color(0xFFE4ECFF),
            ),
            _SerbilisPortalItem(
              title: 'Blotter Verification',
              subtitle: 'Check report status and case reference',
              icon: Icons.receipt_long,
              bg: Color(0xFFE9F0FF),
            ),
            _SerbilisPortalItem(
              title: 'Patrol Request',
              subtitle: 'Request presence in high-risk areas',
              icon: Icons.directions_walk,
              bg: Color(0xFFEAF6EF),
            ),
            _SerbilisPortalItem(
              title: 'Emergency Contacts',
              subtitle: 'Quick access to hotline and precinct channels',
              icon: Icons.call,
              bg: Color(0xFFFFEFE4),
            ),
          ],
        );
      case 'Other Barangay':
        return const _SerbilisPortalData(
          headline: 'Inter-Barangay Services',
          description:
              'Coordinate requests and verification across neighboring barangays.',
          heroStart: Color(0xFF8E4E44),
          heroEnd: Color(0xFFB46B5A),
          icon: Icons.travel_explore,
          modules: [
            _SerbilisPortalItem(
              title: 'Transfer Request',
              subtitle: 'Start resident transfer and endorsement documents',
              icon: Icons.swap_horiz,
              bg: Color(0xFFFFE9E4),
            ),
            _SerbilisPortalItem(
              title: 'Cross-Barangay Clearance',
              subtitle: 'Coordinate clearance with destination barangay',
              icon: Icons.assignment_turned_in,
              bg: Color(0xFFFFEFE6),
            ),
            _SerbilisPortalItem(
              title: 'Referral Letter',
              subtitle: 'Generate referral for health and social support',
              icon: Icons.mail_outline,
              bg: Color(0xFFEAF0FF),
            ),
            _SerbilisPortalItem(
              title: 'Barangay Directory',
              subtitle: 'Contacts and office hours of nearby barangays',
              icon: Icons.location_city,
              bg: Color(0xFFEAF6EF),
            ),
          ],
        );
      default:
        return _SerbilisPortalData(
          headline: '$title Services',
          description: 'Access community services and support requests.',
          heroStart: const Color(0xFF3E4CC7),
          heroEnd: const Color(0xFF6978E1),
          icon: Icons.miscellaneous_services,
          modules: [
            const _SerbilisPortalItem(
              title: 'Open Services',
              subtitle: 'Access service request forms',
              icon: Icons.open_in_new,
              bg: Color(0xFFE4E9FF),
            ),
            const _SerbilisPortalItem(
              title: 'Status Tracking',
              subtitle: 'Monitor progress and updates',
              icon: Icons.timeline,
              bg: Color(0xFFE9F5EE),
            ),
          ],
        );
    }
  }
}

class _SerbilisPortalItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;

  const _SerbilisPortalItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bg,
  });
}

class _SerbilisModuleScreen extends StatefulWidget {
  final String portalTitle;
  final _SerbilisPortalItem item;
  final Color heroStart;
  final Color heroEnd;
  final bool isOfficial;

  const _SerbilisModuleScreen({
    required this.portalTitle,
    required this.item,
    required this.heroStart,
    required this.heroEnd,
    required this.isOfficial,
  });

  @override
  State<_SerbilisModuleScreen> createState() => _SerbilisModuleScreenState();
}

class _SerbilisModuleScreenState extends State<_SerbilisModuleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _requesterController = TextEditingController();
  final _mobileController = TextEditingController();
  final _detailsController = TextEditingController();
  String _priority = 'Normal';
  bool _submitting = false;
  String? _reference;
  DateTime? _submittedAt;

  @override
  void dispose() {
    _requesterController.dispose();
    _mobileController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  String _formatStamp(DateTime value) {
    final hh = value.hour.toString().padLeft(2, '0');
    final mm = value.minute.toString().padLeft(2, '0');
    return '${value.month}/${value.day}/${value.year} $hh:$mm';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();
    setState(() {
      _submitting = false;
      _submittedAt = now;
      _reference = 'SRV-${now.millisecondsSinceEpoch % 1000000}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSubmission = _reference != null && _submittedAt != null;
    final appBarBg = widget.isOfficial
        ? const Color(0xFFF7F8FC)
        : const Color(0xFFF5F7FF);
    final fg = widget.isOfficial
        ? const Color(0xFF2F3248)
        : const Color(0xFF2B3353);
    final bgStart = widget.isOfficial
        ? const Color(0xFFF7F8FC)
        : const Color(0xFFF5F7FF);
    final bgEnd = widget.isOfficial
        ? _officialSurfaceBlend
        : const Color(0xFFF0F3FF);
    final heroSubtext = widget.isOfficial
        ? _officialHeroSubtext
        : const Color(0xFFDDE3FF);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        backgroundColor: appBarBg,
        foregroundColor: fg,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgStart, bgEnd],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.heroStart, widget.heroEnd],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0x2EFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.item.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x2EFFFFFF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.isOfficial
                                ? 'Official Processing'
                                : 'Resident Request',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.item.subtitle,
                          style: TextStyle(
                            color: heroSubtext,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4E8F2)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Intake',
                      style: TextStyle(
                        color: Color(0xFF2F3248),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _requesterController,
                      decoration: const InputDecoration(
                        labelText: 'Requester Name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                      ),
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
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: const [
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                        DropdownMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(
                          value: 'Urgent',
                          child: Text('Urgent'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _priority = value ?? 'Normal');
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _detailsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Request Details',
                        hintText:
                            'Describe your ${widget.item.title.toLowerCase()} request.',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 10) {
                          return 'Please enter at least 10 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _submitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: widget.heroStart,
                        ),
                        icon: const Icon(Icons.send_rounded),
                        label: Text(
                          _submitting ? 'Submitting...' : 'Submit Request',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasSubmission) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2FAF6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCAE9D8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Submitted',
                      style: TextStyle(
                        color: Color(0xFF2E4D3F),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reference: $_reference',
                      style: const TextStyle(
                        color: Color(0xFF2F5E47),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Time: ${_formatStamp(_submittedAt!)}',
                      style: const TextStyle(
                        color: Color(0xFF4D6E5E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _SerbilisProgressRow(
                      icon: Icons.check_circle,
                      title: 'Received by Barangay Desk',
                      subtitle: 'Digital ticket has been queued.',
                    ),
                    const SizedBox(height: 6),
                    _SerbilisProgressRow(
                      icon: Icons.tune,
                      title: 'Screening and Routing',
                      subtitle: 'Assigned based on priority: $_priority',
                    ),
                    const SizedBox(height: 6),
                    _SerbilisProgressRow(
                      icon: Icons.schedule,
                      title: 'Expected update window',
                      subtitle: _priority == 'Urgent'
                          ? 'Within 2-4 hours'
                          : 'Within 24 hours',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SerbilisProgressRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SerbilisProgressRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F3EC),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: const Color(0xFF2E5A46), size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2F3248),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF5E657D),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OfficialMerchantVerificationPage extends StatefulWidget {
  const OfficialMerchantVerificationPage({super.key});

  @override
  State<OfficialMerchantVerificationPage> createState() =>
      _OfficialMerchantVerificationPageState();
}

class _OfficialMerchantVerificationPageState
    extends State<OfficialMerchantVerificationPage> {
  final _registrations = <_ResidentCommercialRegistrationData>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final result = await _OfficialMerchantApi.instance.fetchRegistrations();
    if (!mounted) return;
    if (result.success) {
      setState(() {
        _registrations
          ..clear()
          ..addAll(result.registrations);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      _showFeature(context, result.message, tone: _ToastTone.warning);
    }
  }

  Future<void> _verify(_ResidentCommercialRegistrationData item, bool verified) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(verified ? 'Approve Merchant' : 'Reject Merchant'),
        content: Text(
          '${verified ? "Approve" : "Reject"} registration for "${item.businessName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: verified ? _officialHeaderStart : Colors.red,
            ),
            child: Text(verified ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final id = int.tryParse(item.id) ?? 0;
    if (id <= 0) return;

    _showFeature(context, 'Updating status...', tone: _ToastTone.info);
    final result =
        await _OfficialMerchantApi.instance.updateVerification(id, verified);
    if (!mounted) return;

    _showFeature(
      context,
      result.message,
      tone: result.success ? _ToastTone.success : _ToastTone.warning,
    );
    if (result.success) {
      unawaited(_load());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Verifications'),
        backgroundColor: _officialHeaderStart,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FC), _officialSurfaceBlend],
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: _registrations.isEmpty
                    ? ListView(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              'No merchant registrations found.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _officialSubtext,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _registrations.length,
                        itemBuilder: (ctx, index) {
                          final item = _registrations[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: _officialCardBorder),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.businessName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: _officialText,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item.merchantVerified
                                              ? Colors.green.withOpacity(0.12)
                                              : Colors.orange.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          item.verificationStatus,
                                          style: TextStyle(
                                            color: item.merchantVerified
                                                ? Colors.green[800]
                                                : Colors.orange[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _infoRow(Icons.person_outline, 'Owner', item.ownerName),
                                  _infoRow(Icons.business_center_outlined, 'Type', item.businessType),
                                  _infoRow(Icons.phone_android_outlined, 'Contact', item.contactNumber),
                                  _infoRow(Icons.badge_outlined, 'Permit', item.businessPermitNumber),
                                  _infoRow(Icons.location_on_outlined, 'Address', item.address),
                                  _infoRow(Icons.handshake_outlined, 'Meetup', item.meetupSpot),
                                  if (!item.merchantVerified) ...[
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => _verify(item, false),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.red,
                                              side: const BorderSide(color: Colors.red),
                                            ),
                                            child: const Text('REJECT'),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: FilledButton(
                                            onPressed: () => _verify(item, true),
                                            style: FilledButton.styleFrom(
                                              backgroundColor: _officialHeaderStart,
                                            ),
                                            child: const Text('APPROVE'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: _officialSubtext),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: const TextStyle(
              color: _officialSubtext,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _officialText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialMerchantApi {
  _OfficialMerchantApi._();
  static final instance = _OfficialMerchantApi._();

  Future<_OfficialMerchantListResult> fetchRegistrations({bool onlyPending = false}) async {
    final query = onlyPending ? '?status=pending' : '';
    for (final endpoint in _AuthApi.instance._endpointCandidates('official/merchant-registrations$query')) {
      try {
        final response = await http.get(
          endpoint,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
        ).timeout(const Duration(seconds: 8));
        
        if (response.statusCode == 404) continue;
        
        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        if (response.statusCode < 200 || response.statusCode >= 300) {
          return _OfficialMerchantListResult(
            success: false,
            message: _extractApiMessage(decoded, 'Unable to load registrations.'),
          );
        }

        final raw = decoded['registrations'];
        final list = <_ResidentCommercialRegistrationData>[];
        if (raw is List) {
          for (final r in raw) {
            if (r is Map<String, dynamic>) {
              list.add(_SellerApi.instance.mapRegistration(r));
            }
          }
        }
        return _OfficialMerchantListResult(
          success: true,
          message: 'Registrations loaded.',
          registrations: list,
        );
      } catch (e) {
        debugPrint('[OfficialMerchantApi] Error: $e');
      }
    }
    return const _OfficialMerchantListResult(success: false, message: 'Server unavailable.');
  }

  Future<_OfficialMerchantActionResult> updateVerification(int id, bool verified) async {
    for (final endpoint in _AuthApi.instance._endpointCandidates('official/merchant-registrations/$id/verify')) {
      try {
        final response = await http.patch(
          endpoint,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
          body: jsonEncode({'verified': verified}),
        ).timeout(const Duration(seconds: 8));

        if (response.statusCode == 404) continue;

        final decoded = _AuthApi.instance._decodeDynamicJson(response.body);
        if (response.statusCode < 200 || response.statusCode >= 300) {
          return _OfficialMerchantActionResult(
            success: false,
            message: _extractApiMessage(decoded, 'Unable to update status.'),
          );
        }

        return _OfficialMerchantActionResult(
          success: true,
          message: verified ? 'Merchant approved.' : 'Merchant rejected.',
        );
      } catch (e) {
        debugPrint('[OfficialMerchantApi] Error: $e');
      }
    }
    return const _OfficialMerchantActionResult(success: false, message: 'Server unavailable.');
  }

  String _extractApiMessage(dynamic decoded, String fallback) {
    if (decoded is Map<String, dynamic>) {
      final m = decoded['message'];
      if (m is String && m.isNotEmpty) return m;
    }
    return fallback;
  }
}

class _OfficialMerchantListResult {
  final bool success;
  final String message;
  final List<_ResidentCommercialRegistrationData> registrations;
  const _OfficialMerchantListResult({
    required this.success,
    required this.message,
    this.registrations = const [],
  });
}

class _OfficialMerchantActionResult {
  final bool success;
  final String message;
  const _OfficialMerchantActionResult({required this.success, required this.message});
}
