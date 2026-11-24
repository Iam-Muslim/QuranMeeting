part of 'usercenter_page.dart';

extension UserCenterPageUI on UserCenterPageState{

  PreferredSizeWidget _appBarPreferredSizeWidget () {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    return CommonAppBar(
      backgroundColor: ThemeColor.color200,
      title: '',
      useLargeTitle: false,
      centerTitle: false,
      canBack: false,
      leading: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: CommonImage(
          iconName: 'icon_qrcode.png',
          size: 24.px,
          package: 'ox_usercenter',
          color: ThemeColor.color0,
        ),
        onTap: () {
          OXModuleService.invoke('ox_chat', 'showMyIdCardDialog', [context]);
        },
      ),
      actions: <Widget>[
        if (isLogin)
          Container(
            color: Colors.transparent,
            child: OXButton(
              highlightColor: Colors.transparent,
              color: Colors.transparent,
              minWidth: Adapt.px(44),
              height: Adapt.px(44),
              child: Text(
                Localized.text('ox_common.edit'),
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.color0,
                ),
              ),
              onPressed: () {
                OXNavigator.presentPage(
                  context,
                  fullscreenDialog: true,
                      (_) => const ProfileSetUpPage(),
                ).then((value) {
                  setState(() {});
                });
              },
            ),
          ),
      ],
    );
  }

  SliverAppBar _getAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: ThemeColor.color200,
      expandedHeight: _appBarHeight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            _titleView()
          ],
        ),
      ),
    );
  }

  Widget _titleView() {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    return CommonAppBarNoPreferredSize(
      backgroundColor: ThemeColor.color200,
      title: '',
      useLargeTitle: false,
      centerTitle: false,
      canBack: false,
      leading: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: Adapt.px(44),
          height: Adapt.px(44),
          margin: EdgeInsets.only(left: 16.px),
          color: Colors.transparent,
          child: Center(
            child: CommonImage(
              iconName: 'icon_qrcode.png',
              size: 24.px,
              package: 'ox_usercenter',
              color: ThemeColor.color0,
            ),
          ),
        ),
        onTap: () {
          OXModuleService.invoke(
              'ox_chat', 'showMyIdCardDialog', [context]);
        },
      ),
      actions: <Widget>[
        if (isLogin)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: Adapt.px(44),
              height: Adapt.px(44),
              margin: EdgeInsets.only(right: 16.px),
              color: Colors.transparent,
              child: Center(
                child: Text(
                  Localized.text('ox_common.edit'),
                  style: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight: FontWeight.w600,
                    color: ThemeColor.color0,
                  ),
                ),
              ),
            ),
            onTap: () {
              OXNavigator.presentPage(
                context,
                fullscreenDialog: true,
                    (_) => const ProfileSetUpPage(),
              ).then((value) {
                _updateState();
              });
            },
          ),
      ],
    );
  }

  List<Widget> _body() {
    return [
      // _getAppBar(),
      SliverToBoxAdapter(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: PlatformUtils.listWidth,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: ThemeColor.color200,
                    child: Column(
                      children: <Widget>[
                        buildHeadImage(),
                        SizedBox(
                          height: Adapt.px(16),
                        ),
                        buildHeadName(),
                        buildHeadDesc(),
                        buildHeadPubKey(),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.px),
                  const SwitchAccountPage(),
                  SizedBox(height: 24.px),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Adapt.px(16)),
                      color: ThemeColor.color180,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => OXNavigator.pushPage(
                              context, (context) => const RelaysPage()),
                          child: itemView(
                            'icon_settings_relays.png',
                            'ox_usercenter.relays',
                            '',
                            false,
                            devLogWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OXChatInterface.showRelayInfoWidget(
                                    showRelayIcon: false),
                                CommonImage(
                                  iconName: 'icon_arrow_more.png',
                                  width: Adapt.px(24),
                                  height: Adapt.px(24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Adapt.px(24)),
                  const SettingsPage(),
                  if (Platform.isIOS || Platform.isMacOS) _buildDeleteButton(),
                  // SizedBox(height: Adapt.px(24)),
                  // Container(
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(Adapt.px(16)),
                  //     color: ThemeColor.color180,
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 130.px),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget buildHeadImage() {
    String headImgUrl =
        OXUserInfoManager.sharedInstance.currentUserInfo?.picture ?? "";
    LogUtil.e("headImgUrl: $headImgUrl");
    String localAvatarPath = 'assets/images/user_image.png';

    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(120),
      height: Adapt.px(120),
      package: 'ox_common',
    );
    return SizedBox(
      width: Adapt.px(120),
      height: Adapt.px(120),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(120)),
              child: headImgUrl.isNotEmpty ? OXCachedNetworkImage(
                imageUrl: headImgUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => placeholderImage,
                errorWidget: (context, url, error) => placeholderImage,
                width: Adapt.px(120),
                height: Adapt.px(120),
              ): placeholderImage,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Container(
                width: Adapt.px(111),
                height: Adapt.px(111),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Adapt.px(111)),
                  border: Border.all(
                    color: ThemeColor.color200,
                    width: Adapt.px(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeadName() {
    String name = OXUserInfoManager.sharedInstance.currentUserInfo?.name ?? "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(color: ThemeColor.titleColor, fontSize: 20),
        ),
      ],
    );
  }

  Widget buildHeadDesc() {
    String dns = OXUserInfoManager.sharedInstance.currentUserInfo?.dns ?? '';
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dns,
            maxLines: 1,
            style:
            TextStyle(color: ThemeColor.color120, fontSize: Adapt.px(14)),
            // overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: Adapt.px(4),
          ),
          dns.isNotEmpty && _isVerifiedDNS
              ? CommonImage(
            iconName: "icon_npi05_verified.png",
            width: Adapt.px(16),
            height: Adapt.px(16),
            package: 'ox_common',
          )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildUnreadWidget(){
    return Container(
      color: Colors.transparent,
      width: Adapt.px(6),
      height: Adapt.px(6),
      child: const Image(
        image: AssetImage("assets/images/unread_dot.png"),
      ),
    );
  }

  Widget buildHeadPubKey() {
    String encodedPubKey =
        OXUserInfoManager.sharedInstance.currentUserInfo?.encodedPubkey ?? '';

    String newPubKey = '';
    if (encodedPubKey.isNotEmpty) {
      final String start = encodedPubKey.substring(0, 16);
      final String end = encodedPubKey.substring(encodedPubKey.length - 16);

      newPubKey = '$start:$end';
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await TookKit.copyKey(context, encodedPubKey);
      },
      child: Container(
        margin: EdgeInsets.only(top: Adapt.px(8)),
        padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(12), vertical: Adapt.px(8)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(12)),
          color: ThemeColor.color180,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 96.px),
              child: Text(
                newPubKey,
                style: TextStyle(
                    fontSize: Adapt.px(12),
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.color0,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            SizedBox(width: Adapt.px(8)),
            encodedPubKey.isNotEmpty
                ? CommonImage(
              iconName: "icon_copy.png",
              width: Adapt.px(16),
              height: Adapt.px(16),
              useTheme: true,
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _topItemBuild(
      {String? iconName, String? title, String? badgeImgUrl, bool isShowDivider = false, Function()? onTap}) {
    Widget placeholderImage = CommonImage(
      iconName: 'icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(48),
      height: Adapt.px(48),
      useTheme: true,
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: Adapt.px(52),
            padding: EdgeInsets.symmetric(horizontal: 16.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonImage(
                      iconName: iconName ?? '',
                      width: Adapt.px(32),
                      height: Adapt.px(32),
                      package: 'ox_usercenter',
                    ),
                    SizedBox(width: 12.px),
                    Text(
                      title ?? '',
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: Adapt.px(16),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: Adapt.px(56),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      badgeImgUrl == null
                          ? const SizedBox()
                          : OXCachedNetworkImage(
                        imageUrl: badgeImgUrl,
                        placeholder: (context, url) => placeholderImage,
                        errorWidget: (context, url, error) =>
                        placeholderImage,
                        width: Adapt.px(32),
                        height: Adapt.px(32),
                        fit: BoxFit.cover,
                      ),
                      CommonImage(
                        iconName: 'icon_arrow_more.png',
                        width: Adapt.px(24),
                        height: Adapt.px(24),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isShowDivider,
            child: Divider(
              height: Adapt.px(0.5),
              color: ThemeColor.color160,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return ThemeButton(
      onTap: _deleteAccountHandler,
      text: Localized.text('ox_usercenter.delete_account'),
      height: 48.px,
      textStyle: TextStyle(color: ThemeColor.red1),
      gradientBg: LinearGradient(colors: [
        ThemeColor.color180,
        ThemeColor.color180,
      ]),
    ).setPaddingOnly(top: 24.px);
  }
}