import 'package:mobile_application/utils/constants.dart';
import 'package:mobile_application/views/alert_medication/alert_medication_view.dart';
import 'package:mobile_application/views/graphique/graphique_view.dart';
import 'package:mobile_application/views/profil/account/account-information.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class UserNavigationBar extends StatelessWidget {
  const UserNavigationBar({super.key});

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.date_range_outlined),
          title: 'Signalements',
          activeColorPrimary: Constants.navBarGreen,
          inactiveColorPrimary: Constants.navBarBlue),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.trending_up_rounded),
          title: 'Statistiques',
          activeColorPrimary: Constants.navBarGreen,
          inactiveColorPrimary: Constants.navBarBlue),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_4_outlined),
          title: 'Compte',
          activeColorPrimary: Constants.navBarGreen,
          inactiveColorPrimary: Constants.navBarBlue),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      const AlertMedicationView(),
      const HistoryView(), //Statistiques
      const AccountInformationView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 1),
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Constants.adminDarkBlue,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        colorBehindNavBar: Constants.adminDarkBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(0, -2),
            blurRadius: 1.0,
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
