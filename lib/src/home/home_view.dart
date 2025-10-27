import 'package:flutter/material.dart';
import 'package:face_app/core/utils/const.dart';
import 'package:face_app/core/widgets/custom_user_list.dart';
import 'package:face_app/src/contacts/contact.dart';
import 'package:face_app/src/home/home_view_model.dart';
import 'package:icons_plus/icons_plus.dart';

class HomeView extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CustomUserList(
            isLoading: isLoading,
            liveUsers: liveUsers,
            currentUser: currentUser,
            errorMessage: errorMessage,
            isconnectState: isConnected,
          ),
          Contact(isconnectState: isConnected),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentPage,
        onTap: onBottomNavTapped,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(BoxIcons.bx_data),
            activeIcon: Icon(BoxIcons.bxs_data),
            label: 'DatabBase',
          ),
        ],
      ),
    );
  }
}
