import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/views/profil/account/user_profil_view.dart';
import 'package:pharma_signal/views/history/history_view.dart';
import 'package:flutter/material.dart';
import 'package:pharma_signal/views/search/search_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserNavigationBar extends StatelessWidget {
  const UserNavigationBar({Key? key});

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.history),
        title: AppLocalizations.of(context)?.history ?? Constants.notAvailable,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        title:  AppLocalizations.of(context)?.search ?? Constants.notAvailable,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline),
        title:  AppLocalizations.of(context)?.myAccount ?? Constants.notAvailable,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      const HistoryView(),
      const SearchView(),
      const UserProfilView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 1),
      screens: _buildScreens(),
      items: _navBarsItems(context),
      confineInSafeArea: true,
      backgroundColor: Constants.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        colorBehindNavBar: Constants.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, -2),
            blurRadius: 8.0,
          ),
        ],
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12,
    );
  }
}
