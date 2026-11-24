import 'package:flutter/material.dart';

///Title: home_tabbar_type
///Description: Bottom navigation tabs for Quran Meeting
enum HomeTabBarType {
  discover, // Meet (primary landing screen)
  home,     // Chats
  contact,  // Friends & Groups
  me,       // Profile & Settings
}

extension HomeTabBarTypeEx on HomeTabBarType {

  String get riveFileNames {
    switch (this) {
      case HomeTabBarType.contact:
        return 'Contact';
      case HomeTabBarType.home:
        return 'Home';
      case HomeTabBarType.discover:
        return 'Discover';
      case HomeTabBarType.me:
        return 'Me';
    }
  }

  IconData get icon {
    switch (this) {
      case HomeTabBarType.discover:
        return Icons.videocam_outlined;
      case HomeTabBarType.home:
        return Icons.chat_bubble_outline_rounded;
      case HomeTabBarType.contact:
        return Icons.people_outline_rounded;
      case HomeTabBarType.me:
        return Icons.person_outline_rounded;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case HomeTabBarType.discover:
        return Icons.videocam_rounded;
      case HomeTabBarType.home:
        return Icons.chat_bubble_rounded;
      case HomeTabBarType.contact:
        return Icons.people_rounded;
      case HomeTabBarType.me:
        return Icons.person_rounded;
    }
  }

  String get stateMachineNames {
    switch (this) {
      case HomeTabBarType.contact:
        return 'state_machine_contact';
      case HomeTabBarType.home:
        return 'state_machine_home';
      case HomeTabBarType.discover:
        return 'state_machine_discover';
      case HomeTabBarType.me:
        return 'state_machine_me';
    }
  }
}
