import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_navigator_observer_mixin.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_usercenter/page/set_up/profile_set_up_page.dart';
import 'package:ox_usercenter/page/set_up/relays_page.dart';
import 'package:ox_usercenter/page/set_up/settings_page.dart';
import 'package:ox_usercenter/page/set_up/switch_account_page.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
part 'usercenter_page_ui.dart';

class UserCenterPage extends StatefulWidget {
  const UserCenterPage({Key? key}) : super(key: key);

  @override
  State<UserCenterPage> createState() => UserCenterPageState();
}

class UserCenterPageState extends State<UserCenterPage>
    with TickerProviderStateMixin, OXUserInfoObserver, WidgetsBindingObserver,
        CommonStateViewMixin, OXChatObserver, NavigatorObserverMixin {
  late ScrollController _nestedScrollController;
  int selectedIndex = 0;

  final GlobalKey globalKey = GlobalKey();

  double get _topHeight {
    return kToolbarHeight + Adapt.px(52);
  }

  double _scrollY = 0.0;

  bool _isVerifiedDNS = false;
  final ScrollController _appBarScrollController = ScrollController();
  double _appBarHeight = 66.px;
  bool _sliverPinned = false;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    imageCache.maximumSize = 10;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    Localized.addLocaleChangedCallback(onLocaleChange);
    WidgetsBinding.instance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
    _nestedScrollController = ScrollController()
      ..addListener(() {
        if (_sliverPinned) {
          setState(() {
            _sliverPinned = false;
          });
        }
        if (_nestedScrollController.offset > _topHeight) {
          _scrollY = _nestedScrollController.offset - _topHeight;
        } else {
          if (_scrollY > 0) {
            _scrollY = 0.0;
          }
        }
      });
    _loadData();
  }

  void _loadData() {
    _verifiedDNS();
  }

  void _showSliverAppBar() {
    setState(() {
      _sliverPinned = true;
    });
  }

  @override
  void dispose() {
    ThemeManager.removeOnThemeChangedCallback(onThemeStyleChange);
    Localized.removeLocaleChangedCallback(onLocaleChange);
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didPopNext() async {
    _showSliverAppBar();
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: _appBarPreferredSizeWidget(),
      body: commonStateViewWidget(
        context,
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _nestedScrollController,
          slivers: _body(),
        ),
      ),
    );
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    _loadData();
    if (mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
      });
    }
  }

  @override
  void didLogout() {
    _loadData();
    if (mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
        LogUtil.e("usercenter.didLogout");
      });
    }
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    _loadData();
    if (mounted) {
      if (OXUserInfoManager.sharedInstance.isLogin){
        setState(() {
          updateStateView(CommonStateView.CommonStateView_None);
        });
      }
    }
  }

  String getHostUrl(String url) {
    RegExp regExp = RegExp(r"^.*?://(.*?)/.*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }

  void _verifiedDNS() async {
    UserDBISAR? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    if(userDB == null) return;
    var isVerifiedDNS = await OXUserInfoManager.sharedInstance.checkDNS(userDB: userDB);
    if (mounted) {
      setState(() {
      _isVerifiedDNS = isVerifiedDNS;
    });
    }
  }

  void _deleteAccountHandler() {
    OXCommonHintDialog.show(context,
      title: Localized.text('ox_usercenter.warn_title'),
      content: Localized.text('ox_usercenter.delete_account_dialog_content'),
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () async {
            OXNavigator.pop(context);
            showDeleteAccountDialog();
          },
        ),
      ],
      isRowAction: true,
    );
  }

  void showDeleteAccountDialog() {
    String userInput = '';
    final matchWord = Localized.text('ox_usercenter.str_delete');
    OXCommonHintDialog.show(
      context,
      title: Localized.text('ox_usercenter.str_permanently_delete_account'),
      contentView: TextField(
        onChanged: (value) {
          userInput = value;
        },
        decoration: InputDecoration(hintText: Localized.text('ox_usercenter.str_type_delete_to_confirm')),
      ),
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction(
          text: () => Localized.text('ox_usercenter.str_delete'),
          style: OXHintActionStyle.red,
          onTap: () async {
            OXNavigator.pop(context);
            if (userInput == matchWord) {
              await OXLoading.show();
              await OXUserInfoManager.sharedInstance.logout();
              await OXLoading.dismiss();
            }
          },
        ),
      ],
      isRowAction: true,
    );
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _switchAccount() {
    OXNavigator.pushPage(context, (context) => const SwitchAccountPage());
  }

}
