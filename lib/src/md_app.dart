import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:md_engine/md_engine.dart';

import 'package:md_engine/src/core/util/md_delegate.dart';
import 'package:md_engine/src/core/util/md_state_engine.dart';

import 'core/i18n/app_localizations.dart';
import 'core/i18n/i18n.dart';
import 'core/util/md_screen_utility.dart';

typedef AppStepCallback = Future<void> Function();

class MdApp {
  MdApp._internal();
  static final MdApp I = MdApp._internal();

  late MdHttpDriverOptions httpDriverOptions;
  late String appName;
  late Flavor flavor;

  final deviceInfo = DeviceInfoPlugin();
  late final PackageInfo packageInfo;

  late final String deviceId;
  late final String buildNumber;
  late final String packageName;
  late final String buildSignature;
  late final String version;

  Future<void> _loadAppInfos() async {
    packageInfo = await PackageInfo.fromPlatform();
    if (UniversalPlatform.isIOS) {
      deviceId = (await deviceInfo.iosInfo).identifierForVendor ?? "";
    } else if (UniversalPlatform.isAndroid) {
      deviceId = (await deviceInfo.androidInfo).id;
    } else if (UniversalPlatform.isWeb) {
      deviceId = (await deviceInfo.webBrowserInfo).vendor ?? "web";
    } else {
      deviceId = "unknow";
    }
    buildNumber = packageInfo.buildNumber;
    appName = packageInfo.appName;
    buildSignature = packageInfo.buildSignature;
    version = packageInfo.version;
    packageName = packageInfo.packageName;
  }

  Future<void> run({
    required MdHttpDriverOptions httpDriverOptions,
    Flavor flavor = Flavor.unknow,
    List<QRoute> routes = const [],
    MdTranslationOptions? translationOptions,
    AppStepCallback? beforeEnsureInitialized,
    AppStepCallback? afterEnsureInitialized,
    VoidCallback? onComplete,
    VoidCallback? initState,
    VoidCallback? dispose,
    String? initRoutePath,
    GlobalKey<NavigatorState>? navigatorKey,
    List<NavigatorObserver>? navigatorObservers,
    Key? key,
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
    RouterConfig<Object>? routerConfig,
    BackButtonDispatcher? backButtonDispatcher,
    Widget Function(BuildContext, Widget?)? builder,
    String appName = '',
    String Function(BuildContext)? onGenerateTitle,
    Color? color,
    ThemeData Function()? theme,
    ThemeData Function()? darkTheme,
    ThemeData Function()? highContrastTheme,
    ThemeData Function()? highContrastDarkTheme,
    ThemeMode? themeMode = ThemeMode.system,
    Duration themeAnimationDuration = kThemeAnimationDuration,
    Curve themeAnimationCurve = Curves.linear,
    Locale? Function(List<Locale>?, Iterable<Locale>)?
        localeListResolutionCallback,
    bool debugShowMaterialGrid = false,
    bool showPerformanceOverlay = false,
    bool checkerboardRasterCacheImages = false,
    bool checkerboardOffscreenLayers = false,
    bool showSemanticsDebugger = false,
    bool debugShowCheckedModeBanner = true,
    Map<ShortcutActivator, Intent>? shortcuts,
    Map<Type, Action<Intent>>? actions,
    String? restorationScopeId,
    ScrollBehavior? scrollBehavior,
    bool enableProativeState = true,
    ErrorStateObsListener? errorListener,
  }) async {
    this.flavor = flavor;
    await beforeEnsureInitialized?.call();
    WidgetsFlutterBinding.ensureInitialized();
    QR.setUrlStrategy();

    if (translationOptions != null) {
      await I18n.I.init(
        filePath: translationOptions.filePath,
        availableLanguages: translationOptions.availableLanguages,
        defaultLocale: translationOptions.defaultLocale,
      );
    }

    await _loadAppInfos();
    this.httpDriverOptions = httpDriverOptions.copyWith(
      deviceId: deviceId,
      appName: appName,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      buildSignature: packageInfo.buildSignature,
      packageName: packageInfo.buildSignature,
    );
    if (appName.isNotEmpty) {
      this.appName = appName;
    }

    GetIt.I.registerFactory<IMdHttpDriver>(() => MdDioHttpDriver());
    await afterEnsureInitialized?.call();
    runApp(
      _MdApp(
        title: appName,
        routes: routes,
        enableI18n: translationOptions != null,
        theme: theme?.call(),
        dispose: dispose,
        initState: (context) {
          initState?.call();
        },
        actions: actions,
        appKey: key,
        backButtonDispatcher: backButtonDispatcher,
        builder: builder,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        color: color,
        darkTheme: darkTheme?.call(),
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        debugShowMaterialGrid: debugShowMaterialGrid,
        highContrastDarkTheme: highContrastDarkTheme?.call(),
        highContrastTheme: highContrastTheme?.call(),
        localeListResolutionCallback: localeListResolutionCallback,
        onGenerateTitle: onGenerateTitle,
        restorationScopeId: restorationScopeId,
        routerConfig: routerConfig,
        scaffoldMessengerKey: scaffoldMessengerKey,
        scrollBehavior: scrollBehavior,
        shortcuts: shortcuts,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        themeAnimationCurve: themeAnimationCurve,
        themeAnimationDuration: themeAnimationDuration,
        themeMode: themeMode,
        navigatorKey: navigatorKey,
        navigatorObservers: navigatorObservers,
        initRoutePath: initRoutePath,
        enableProativeState: enableProativeState,
        errorListener: errorListener,
      ),
    );
    onComplete?.call();
  }
}

class _MdApp extends StatefulWidget {
  final List<QRoute> routes;
  final bool enableI18n;

  final Key? appKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final RouterConfig<Object>? routerConfig;
  final BackButtonDispatcher? backButtonDispatcher;
  final Widget Function(BuildContext, Widget?)? builder;
  final String title;
  final String Function(BuildContext)? onGenerateTitle;
  final Color? color;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final ThemeMode? themeMode;
  final Duration themeAnimationDuration;
  final Curve themeAnimationCurve;
  final Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;
  final void Function(BuildContext context)? initState;
  final VoidCallback? dispose;
  final GlobalKey<NavigatorState>? navigatorKey;
  final List<NavigatorObserver>? navigatorObservers;
  final String? initRoutePath;
  final bool enableProativeState;
  final ErrorStateObsListener? errorListener;

  const _MdApp({
    required this.routes,
    required this.enableI18n,
    this.navigatorKey,
    this.appKey,
    this.scaffoldMessengerKey,
    this.routerConfig,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.localeListResolutionCallback,
    this.dispose,
    this.initState,
    this.navigatorObservers,
    this.initRoutePath,
    this.enableProativeState = true,
    this.errorListener,
  });
  @override
  State<_MdApp> createState() => __MdAppState();
}

class __MdAppState extends State<_MdApp> {
  @override
  void initState() {
    super.initState();
    if (widget.enableProativeState) {
      MdStateEngine.I.start();
    }
    if (widget.errorListener != null) {
      GlobalErrorObserver.listen = widget.errorListener!;
    }
  }

  @override
  void dispose() {
    MdStateEngine.I.stop();
    widget.dispose?.call();
    super.dispose();
  }

  late final routerDelegate = MdDelegate(
    widget.routes,
    navKey: widget.navigatorKey,
    observers: widget.navigatorObservers,
    initPath: widget.initRoutePath,
  );
  late final routeInformationParser = const QRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    MdScreenUtility.I.setContext(context);
    return MaterialApp.router(
      key: widget.appKey,
      actions: widget.actions,
      backButtonDispatcher: widget.backButtonDispatcher,
      builder: widget.builder,
      checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
      checkerboardRasterCacheImages: widget.checkerboardOffscreenLayers,
      color: widget.color,
      darkTheme: widget.darkTheme,
      debugShowMaterialGrid: widget.debugShowMaterialGrid,
      highContrastDarkTheme: widget.highContrastDarkTheme,
      highContrastTheme: widget.highContrastTheme,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      onGenerateTitle: widget.onGenerateTitle,
      restorationScopeId: widget.restorationScopeId,
      routerConfig: widget.routerConfig,
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
      scrollBehavior: widget.scrollBehavior,
      shortcuts: widget.shortcuts,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      themeAnimationCurve: widget.themeAnimationCurve,
      themeAnimationDuration: widget.themeAnimationDuration,
      themeMode: widget.themeMode,
      title: F.title,
      theme: widget.theme ?? ThemeData.light(useMaterial3: true),
      supportedLocales: widget.enableI18n
          ? I18n.I.supportedLocales
          : const <Locale>[Locale('en', 'US')],
      locale: widget.enableI18n ? I18n.I.defaultLocale : null,
      localeResolutionCallback:
          widget.enableI18n ? I18n.I.localeResolutionCallback : null,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        if (widget.enableI18n) AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
    );
  }
}

enum Flavor { prd, dev, hom, lcl, unknow }

class F {
  static Flavor get appFlavor => MdApp.I.flavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.prd:
      case Flavor.unknow:
        return MdApp.I.appName;
      case Flavor.dev:
        return 'Dev ${MdApp.I.appName}';
      case Flavor.hom:
        return 'Hom ${MdApp.I.appName}';
      case Flavor.lcl:
        return 'Lcl ${MdApp.I.appName}';
      default:
        return 'Dev ${MdApp.I.appName}';
    }
  }
}
