part of barangaymo_app;

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final locationController = TextEditingController();
    final salaryController = TextEditingController();
    final requirementsController = TextEditingController();
    final postedByController = TextEditingController(text: 'Barangay Employer');
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
                          onPressed: () {
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
                                context,
                                'Complete all fields before posting.',
                              );
                              return;
                            }

                            _ResidentJobsHub.addHiringPost(
                              title: title,
                              company: company,
                              location: location,
                              salary: salary,
                              schedule: schedule,
                              requirements: requirements,
                              postedBy: postedBy,
                              urgent: urgent,
                            );
                            Navigator.pop(context);
                            _showFeature(
                              this.context,
                              'Hiring post published. Residents are notified.',
                            );
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
      titleController.dispose();
      companyController.dispose();
      locationController.dispose();
      salaryController.dispose();
      requirementsController.dispose();
      postedByController.dispose();
    });
  }

  void _openJobHunterSheet(BuildContext context) {
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
                          onPressed: () {
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
                                context,
                                'Complete all fields before posting.',
                              );
                              return;
                            }
                            _ResidentJobsHub.addTalentPost(
                              fullName: fullName,
                              desiredJob: desiredJob,
                              skills: skills,
                              preferredSetup: setup,
                              expectedSalary: expectedSalary,
                              zone: zone,
                              availableNow: availableNow,
                            );
                            Navigator.pop(context);
                            _showFeature(
                              this.context,
                              'Job hunter profile published.',
                            );
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
      nameController.dispose();
      desiredController.dispose();
      skillsController.dispose();
      salaryController.dispose();
      zoneController.dispose();
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
                    onPressed: () {
                      _ResidentJobsHub.toggleSaved(job);
                      final nowSaved = _ResidentJobsHub.isSaved(job);
                      _showFeature(
                        context,
                        nowSaved
                            ? 'Saved "${job.title}" to Saved Jobs.'
                            : 'Removed "${job.title}" from Saved Jobs.',
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResidentJobApplicationPage(job: job),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3946BD),
                    ),
                    child: const Text('Apply'),
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
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showFeature(
                      context,
                      'Message sent to ${talent.fullName}.',
                    ),
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 16,
                    ),
                    label: const Text('Message'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showFeature(
                      context,
                      'Invitation sent to ${talent.fullName}.',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7E46D7),
                    ),
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                    label: const Text('Invite'),
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

class ResidentJobApplicationPage extends StatefulWidget {
  final _ResidentJobData job;
  const ResidentJobApplicationPage({super.key, required this.job});

  @override
  State<ResidentJobApplicationPage> createState() =>
      _ResidentJobApplicationPageState();
}

class _ResidentJobApplicationPageState extends State<ResidentJobApplicationPage> {
  final _nameController = TextEditingController(text: 'Juan Dela Cruz');
  final _mobileController = TextEditingController(text: '09123456789');
  final _coverLetterController = TextEditingController(
    text:
        'I am interested in this position and can start immediately. I have community-facing work experience and basic document handling skills.',
  );
  XFile? _attachment;

  bool get _hasDraft =>
      _nameController.text.trim() != 'Juan Dela Cruz' ||
      _mobileController.text.trim() != '09123456789' ||
      _coverLetterController.text.trim() !=
          'I am interested in this position and can start immediately. I have community-facing work experience and basic document handling skills.' ||
      _attachment != null;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) {
      return;
    }
    setState(() => _attachment = picked);
  }

  void _submit() {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final cover = _coverLetterController.text.trim();
    final attachmentName = _attachment?.name ?? '';
    if (name.isEmpty ||
        mobile.length < 11 ||
        cover.length < 20 ||
        attachmentName.isEmpty) {
      _showFeature(
        context,
        'Complete your name, mobile number, cover letter, and resume attachment.',
      );
      return;
    }
    _ResidentJobsHub.submitApplication(
      job: widget.job,
      applicantName: name,
      mobileNumber: mobile,
      coverLetter: cover,
      attachmentName: attachmentName,
    );
    Navigator.pop(context);
    _showFeature(context, 'Application sent for "${widget.job.title}".');
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
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF3946BD),
            ),
            icon: const Icon(Icons.send_rounded),
            label: const Text('Submit Application'),
          ),
        ),
      ),
    ),
  );
  }
}
