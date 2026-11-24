import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ox_common/business_interface/ox_usercenter/interface.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_usercenter/page/set_up/avatar_preview_page.dart';
import 'package:ox_usercenter/page/set_up/relay_detail_page.dart';
import 'package:ox_usercenter/page/set_up/relays_for_login_page.dart';
import 'package:ox_usercenter/page/set_up/relays_page.dart';
import 'package:ox_usercenter/page/set_up/relays_selector_dialog.dart';
import 'package:ox_usercenter/page/set_up/verify_passcode_page.dart';
import 'package:ox_usercenter/page/usercenter_page.dart';
import 'package:chatcore/chat-core.dart';

class OXUserCenter extends OXFlutterModule {

  static String get loginPageId => "usercenter_page";

  @override
  Future<void> setup() async {
    await super.setup();
  }

  @override
  String get moduleName => OXUserCenterInterface.moduleName;

  @override
  Map<String, Function> get interfaces => {
        'showRelayPage': showRelayPage,
        'showRelaySelectorDialog': showRelaySelectorDialog,
        'userCenterPageWidget': userCenterPageWidget,
      };

  @override
  Future<T?>? navigateToPage<T>(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'UserCenterPage':
        return OXNavigator.pushPage(
          context,
          (context) => const UserCenterPage(),
        );
      case 'AvatarPreviewPage':
        UserDBISAR? userDB = params?['userDB'];
        return OXNavigator.pushPage(context, (context) => AvatarPreviewPage(userDB: userDB),);
      case 'RelayDetailPage':
        final relayName = params?['relayName'];
        return OXNavigator.pushPage(context, (context) => RelayDetailPage(relayURL: relayName,));
      case 'VerifyPasscodePage':
        return OXNavigator.pushReplacement(context, const VerifyPasscodePage());
      case 'RelaysForLoginPage':
        return OXNavigator.pushPage(context, (context) => RelaysForLoginPage(relayUrls: params?['relayUrls'],));
    }
    return null;
  }

  void showRelayPage(BuildContext context) {
    OXNavigator.pushPage(context, (context) => const RelaysPage());
  }

  void showRelaySelectorDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const RelaysSelectorPage();
        });
  }

  Widget userCenterPageWidget(BuildContext context) {
    return const UserCenterPage();
  }
}
