import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._();
  factory AdService() => _instance;
  AdService._();

  // Use Google's official test ad IDs in debug, real IDs in release
  static String get _bannerAdUnitId => kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-9101104960476427/6879817892';
  static String get _interstitialAdUnitId => kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-9101104960476427/9113227437';
  static String get _rewardedAdUnitId => kDebugMode
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-9101104960476427/5323922599';

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInitialized = false;

  int _downloadCount = 0;
  DateTime? _lastInterstitialTime;

  Future<void> initialize() async {
    // Set test device BEFORE initializing SDK
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: ['BD727F61A8CDEDDB30FD4C2C50A9F076'],
      ),
    );
    final status = await MobileAds.instance.initialize();
    _isInitialized = true;
    if (kDebugMode) {
      debugPrint('AdMob init status:');
      status.adapterStatuses.forEach((adapter, adapterStatus) {
        debugPrint('  $adapter: ${adapterStatus.state} - ${adapterStatus.description}');
      });
    }
    // Small delay to let SDK fully settle before loading ads
    await Future.delayed(const Duration(seconds: 1));
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  // ── Banner ──

  BannerAd loadBannerAd({required void Function() onLoaded}) {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (kDebugMode) debugPrint('Banner ad loaded successfully');
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) debugPrint('Banner ad failed: ${error.code} - ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  // ── Interstitial ──

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) debugPrint('Interstitial ad loaded successfully');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) debugPrint('Interstitial ad failed: ${error.code} - ${error.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  void onDownloadComplete() {
    _downloadCount++;
    if (_downloadCount >= 3 && _canShowInterstitial()) {
      _showInterstitialAd();
      _downloadCount = 0;
    }
  }

  bool _canShowInterstitial() {
    if (_lastInterstitialTime == null) return true;
    return DateTime.now().difference(_lastInterstitialTime!) >=
        const Duration(minutes: 2);
  }

  void _showInterstitialAd() {
    final ad = _interstitialAd;
    if (ad == null) {
      _loadInterstitialAd();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadInterstitialAd();
      },
    );
    ad.show();
    _interstitialAd = null;
    _lastInterstitialTime = DateTime.now();
  }

  // ── Rewarded ──

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) debugPrint('Rewarded ad loaded successfully');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) debugPrint('Rewarded ad failed: ${error.code} - ${error.message}');
          _rewardedAd = null;
        },
      ),
    );
  }

  bool get isRewardedAdReady => _rewardedAd != null;

  void showRewardedAd({required void Function() onRewardEarned}) {
    final ad = _rewardedAd;
    if (ad == null) {
      _loadRewardedAd();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadRewardedAd();
      },
    );
    ad.show(onUserEarnedReward: (_, __) => onRewardEarned());
    _rewardedAd = null;
  }
}
