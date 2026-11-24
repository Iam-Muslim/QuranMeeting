
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_login/page/account_key_login_page.dart';
import 'package:ox_login/page/login_with_qrcode_page.dart';
import 'package:ox_module_service/ox_module_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isBusy = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: canPop
          ? AppBar(
              backgroundColor: ThemeColor.color200,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_rounded, color: ThemeColor.color0, size: 28),
                onPressed: () => OXNavigator.pop(context),
              ),
            )
          : null,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 28.px, vertical: 24.px),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 96.px,
                        height: 96.px,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 48.px,
                          color: const Color(0xFF0D9488),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.px),
                    Text(
                      'Quran Meeting',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ThemeColor.titleColor,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10.px),
                    Text(
                      'Read & learn Quran together with family, friends, and teachers.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ThemeColor.color100,
                        fontSize: 16.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 36.px),
                    Text(
                      'What is your name?',
                      style: TextStyle(
                        color: ThemeColor.titleColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.px),
                    TextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _quickStart(),
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Ahmad or Fatima',
                        hintStyle: TextStyle(
                          color: ThemeColor.color120,
                          fontSize: 17.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: ThemeColor.color100,
                          size: 24.px,
                        ),
                        filled: true,
                        fillColor: ThemeColor.color180,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.px,
                          vertical: 18.px,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.px),
                    SizedBox(
                      height: 58.px,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isBusy ? null : _quickStart,
                        icon: _isBusy
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.arrow_forward_rounded, size: 24),
                        label: Text(
                          _isBusy ? 'Starting...' : 'Start',
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.px),
                    TextButton(
                      onPressed: _isBusy ? null : _login,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.px),
                      ),
                      child: Text(
                        'Already have an account? Restore backup',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColor.color100,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _isBusy ? null : _loginWithQRCode,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8.px),
                      ),
                      child: Text(
                        Localized.text('ox_login.str_login_with_qrcode'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColor.color120,
                          fontSize: 14.sp,
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
    );
  }

  Future<void> _quickStart() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      CommonToast.instance.show(context, 'Please enter your name');
      return;
    }
    setState(() => _isBusy = true);
    await OXLoading.show();
    final String previousPubKey =
        OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    try {
      final Keychain keychain = Account.generateNewKeychain();
      await OXUserInfoManager.sharedInstance.initDB(keychain.public);
      UserDBISAR userDB = await Account.newAccount(user: keychain);
      userDB =
          await Account.sharedInstance.loginWithPriKey(keychain.private) ??
              userDB;
      userDB.name = name;
      Account.sharedInstance.updateProfile(userDB);
      await OXUserInfoManager.sharedInstance.loginSuccess(userDB);
    } catch (error, stack) {
      LogUtil.e('quickStart failed: $error\r\n$stack');
      await OXUserInfoManager.sharedInstance.restoreAccount(previousPubKey);
      await OXLoading.dismiss();
      if (mounted) {
        setState(() => _isBusy = false);
        CommonToast.instance.show(context, 'Could not start. Please try again.');
      }
      return;
    }
    await OXLoading.dismiss();
    if (!mounted) return;
    setState(() => _isBusy = false);
    if (Navigator.of(context).canPop()) {
      OXNavigator.popToRoot(context);
    } else {
      OXModuleService.pushPage(context, 'ox_home', 'HomeTabBarPage', {});
    }
  }

  void _login() {
    OXNavigator.pushPage(context, (context) => AccountKeyLoginPage());
  }

  void _loginWithQRCode() {
    OXNavigator.presentPage(
      context,
      (context) => LoginWithQRCodePage(),
      fullscreenDialog: true,
    );
  }
}
