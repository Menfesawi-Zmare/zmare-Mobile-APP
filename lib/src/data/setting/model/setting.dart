class AppSetting {
  String? title;
  String? logo;
  String? tagline;
  int? mPerPage;
  int? ePerPage;
  int? sPerPage;
  dynamic androidExplorerAd;
  dynamic androidInterstitialAd;
  dynamic androidMaxInterstitialAdClick;
  dynamic androidAppOpenAd;
  dynamic iosExplorerAd;
  dynamic iosInterstitialAd;
  dynamic iosMaxInterstitialAdClick;
  dynamic iosAppOpenAd;
  int? androidExplorerStatus;
  int? androidInterstitialStatus;
  int? androidAppOpenStatus;
  int? iosExplorerStatus;
  int? iosInterstitialStatus;
  int? iosAppOpenStatus;
  dynamic facebook;
  dynamic twitter;
  dynamic instagram;
  dynamic youtube;
  dynamic telegram;
  dynamic tosUrl;
  dynamic privacyUrl;
  dynamic cookieUrl;
  dynamic psUrl;
  dynamic asUrl;

  AppSetting(
      {this.title,
      this.logo,
      this.tagline,
      this.mPerPage,
      this.ePerPage,
      this.sPerPage,
      this.androidExplorerAd,
      this.androidInterstitialAd,
      this.androidMaxInterstitialAdClick,
      this.androidAppOpenAd,
      this.iosExplorerAd,
      this.iosInterstitialAd,
      this.iosMaxInterstitialAdClick,
      this.iosAppOpenAd,
      this.androidExplorerStatus,
      this.androidInterstitialStatus,
      this.androidAppOpenStatus,
      this.iosExplorerStatus,
      this.iosInterstitialStatus,
      this.iosAppOpenStatus,
      this.facebook,
      this.twitter,
      this.instagram,
      this.youtube,
      this.telegram,
      this.tosUrl,
      this.privacyUrl,
      this.psUrl,
      this.asUrl});

  AppSetting.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    logo = json['logo'];
    tagline = json['tagline'];
    mPerPage = json['m_per_page'];
    ePerPage = json['e_per_page'];
    sPerPage = json['s_per_page'];
    androidExplorerAd = json['android_explorer_ad'];
    androidInterstitialAd = json['android_interstitial_ad'];
    androidMaxInterstitialAdClick = json['android_max_interstitial_ad_click'];
    androidAppOpenAd = json['android_app_open_ad'];
    iosExplorerAd = json['ios_explorer_ad'];
    iosInterstitialAd = json['ios_interstitial_ad'];
    iosMaxInterstitialAdClick = json['ios_max_interstitial_ad_click'];
    iosAppOpenAd = json['ios_app_open_ad'];
    androidExplorerStatus = json['android_explorer_status'];
    androidInterstitialStatus = json['android_interstitial_status'];
    androidAppOpenStatus = json['android_app_open_status'];
    iosExplorerStatus = json['ios_explorer_status'];
    iosInterstitialStatus = json['ios_interstitial_status'];
    iosAppOpenStatus = json['ios_app_open_status'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    telegram = json['telegram'];
    tosUrl = json['tos_url'] ?? "";
    privacyUrl = json['privacy_url'];
    cookieUrl = json['cookie_url'];
    psUrl = json['ps_url'];
    asUrl = json['as_url'];
  }
}