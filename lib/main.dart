library barangaymo_app;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'src/core/activation_flow.dart';
part 'src/official/official_shell.dart';
part 'src/shared/barangay_services.dart';
part 'src/shared/barangay_documents.dart';
part 'src/shared/barangay_governance.dart';
part 'src/shared/barangay_health.dart';
part 'src/shared/barangay_community.dart';
part 'src/auth/auth_flow.dart';
part 'src/auth/auth_entry.dart';
part 'src/auth/auth_resident.dart';
part 'src/auth/auth_official.dart';
part 'src/resident/resident_shell_dashboard.dart';
part 'src/resident/resident_commerce.dart';
part 'src/resident/resident_jobs.dart';
part 'src/resident/resident_marketplace.dart';
part 'src/resident/resident_seller_hub.dart';
part 'src/resident/resident_services_account.dart';
part 'src/resident/resident_account_pages.dart';
part 'src/resident/resident_system_center.dart';
part 'src/resident/resident_rbi.dart';
part 'src/official/official_account_pages.dart';
part 'src/official/official_barangay_pages.dart';
part 'src/official/official_services_pages.dart';

void main() => runApp(const BarangayMoApp());

enum _AppLocalePreference { english, tagalog }

enum _ToastTone { info, success, warning, error }

final ValueNotifier<ThemeMode> _appThemeMode = ValueNotifier(ThemeMode.light);
final ValueNotifier<_AppLocalePreference> _appLocalePreference = ValueNotifier(
  _AppLocalePreference.english,
);
final ValueNotifier<bool> _appIsOffline = ValueNotifier(false);

// Single source of truth for backend base URL.
// Change this value when the live domain changes.
const String _defaultApiBaseUrl = 'http://167.172.89.188:8081';
const String _configuredApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: _defaultApiBaseUrl,
);

bool get _isDarkModeEnabled => _appThemeMode.value == ThemeMode.dark;

bool get _isTagalogEnabled =>
    _appLocalePreference.value == _AppLocalePreference.tagalog;

String _appText(String english, String tagalog) {
  return _isTagalogEnabled ? tagalog : english;
}

void _setDarkModeEnabled(bool enabled) {
  _appThemeMode.value = enabled ? ThemeMode.dark : ThemeMode.light;
}

void _setTagalogEnabled(bool enabled) {
  _appLocalePreference.value = enabled
      ? _AppLocalePreference.tagalog
      : _AppLocalePreference.english;
}

ThemeData _buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final seed = isDark ? const Color(0xFFD44747) : const Color(0xFFD70000);
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: isDark
        ? const Color(0xFF11131A)
        : const Color(0xFFF7F8FF),
    cardColor: isDark ? const Color(0xFF191D26) : Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? const Color(0xFF191D26) : Colors.white,
      foregroundColor: isDark ? Colors.white : const Color(0xFF20263C),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? const Color(0xFF20242F) : const Color(0xFF1E2230),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF1A1F2A) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF313746) : const Color(0xFFDCE1EF),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF313746) : const Color(0xFFDCE1EF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary, width: 1.4),
      ),
    ),
  );
}

class _AppNetworkMonitor {
  static Timer? _timer;
  static bool _started = false;

  static void start() {
    if (_started) {
      return;
    }
    _started = true;
    unawaited(_probe());
    _timer = Timer.periodic(
      const Duration(seconds: 16),
      (_) => unawaited(_probe()),
    );
  }

  static Future<void> _probe() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      _appIsOffline.value =
          result.isEmpty || result.first.rawAddress.isEmpty;
    } on SocketException {
      _appIsOffline.value = true;
    } catch (_) {
      _appIsOffline.value = true;
    }
  }

  static void dispose() {
    _timer?.cancel();
    _timer = null;
    _started = false;
  }
}

class BarangayMoApp extends StatefulWidget {
  const BarangayMoApp({super.key});

  @override
  State<BarangayMoApp> createState() => _BarangayMoAppState();
}

class _BarangayMoAppState extends State<BarangayMoApp> {
  @override
  void initState() {
    super.initState();
    _AppNetworkMonitor.start();
  }

  @override
  void dispose() {
    _AppNetworkMonitor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _appThemeMode,
        _appLocalePreference,
        _appIsOffline,
      ]),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: _appText('BarangayMo', 'BarangayMo'),
          theme: _buildAppTheme(Brightness.light),
          darkTheme: _buildAppTheme(Brightness.dark),
          themeMode: _appThemeMode.value,
          home: const BarangayMoSplashScreen(),
          builder: (context, child) {
            return Stack(
              children: [
                child ?? const SizedBox.shrink(),
                if (_appIsOffline.value)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: Material(
                          color: const Color(0xFFB42318),
                          elevation: 8,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.wifi_off_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _appText(
                                      'Offline mode. Some live features are unavailable.',
                                      'Offline mode. May ilang live feature na hindi magagamit.',
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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

class BarangayMoSplashScreen extends StatefulWidget {
  const BarangayMoSplashScreen({super.key});

  @override
  State<BarangayMoSplashScreen> createState() => _BarangayMoSplashScreenState();
}

class _BarangayMoSplashScreenState extends State<BarangayMoSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _handleAppOpened();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RoleGatewayScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8E0D0D),
              Color(0xFFD70000),
              Color(0xFFFFC107),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.28),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 24,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'm',
                              style: TextStyle(
                                color: Color(0xFFD70000),
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'BARANGAYmo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Serbisyong mabilis para sa barangay at mamamayan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFDEDED),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _confirmDiscardChanges(
  BuildContext context, {
  String? title,
  String? message,
}) async {
  final shouldLeave = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        title ??
            _appText('Leave this form?', 'Umalis sa form na ito?'),
      ),
      content: Text(
        message ??
            _appText(
              'Your unsaved changes will be lost.',
              'Mawawala ang mga hindi pa nasasagip na pagbabago.',
            ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(_appText('Stay', 'Manatili')),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(_appText('Leave', 'Umalis')),
        ),
      ],
    ),
  );
  return shouldLeave ?? false;
}

class _AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AppEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 34,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.74,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppListSkeleton extends StatelessWidget {
  final int count;

  const _AppListSkeleton({this.count = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: count,
      itemBuilder: (_, index) => _AppSkeletonCard(index: index),
    );
  }
}

class _AppSkeletonCard extends StatefulWidget {
  final int index;

  const _AppSkeletonCard({required this.index});

  @override
  State<_AppSkeletonCard> createState() => _AppSkeletonCardState();
}

class _AppSkeletonCardState extends State<_AppSkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF252A35)
        : const Color(0xFFE8ECF5);
    final glowColor = isDark
        ? const Color(0xFF303643)
        : const Color(0xFFF4F6FB);
    return FadeTransition(
      opacity: Tween<double>(begin: 0.62, end: 1).animate(_controller),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: baseColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _skeletonBox(baseColor, glowColor, 44, 44, radius: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _skeletonBox(baseColor, glowColor, double.infinity, 14),
                      const SizedBox(height: 8),
                      _skeletonBox(baseColor, glowColor, 160, 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _skeletonBox(baseColor, glowColor, double.infinity, 12),
            const SizedBox(height: 8),
            _skeletonBox(baseColor, glowColor, 220, 12),
          ],
        ),
      ),
    );
  }

  Widget _skeletonBox(
    Color baseColor,
    Color glowColor,
    double width,
    double height, {
    double radius = 10,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [baseColor, glowColor, baseColor],
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const _HighlightedText({
    required this.text,
    required this.query,
    this.style,
    this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedQuery = query.trim();
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    if (trimmedQuery.isEmpty) {
      return Text(
        text,
        style: baseStyle,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;
    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: baseStyle));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + trimmedQuery.length),
          style:
              highlightStyle ??
              baseStyle.copyWith(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.16),
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
        ),
      );
      start = index + trimmedQuery.length;
    }
    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
