import 'package:face_app/core/models/user.dart';
import 'package:face_app/core/utils/const.dart';
import 'package:face_app/core/widgets/animated_item_list.dart';
import 'package:face_app/src/routes/arguments/details_arguments.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CustomUserList extends StatelessWidget {
  final List<User> liveUsers;

  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;
  final Function() ontap;
  final bool isconnectState;

  const CustomUserList({
    super.key,
    this.currentUser,
    this.errorMessage,
    required this.liveUsers,
    required this.isLoading,
    required this.ontap,
    required this.isconnectState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            expandedHeight: 250.0,
            pinned: true,
            elevation: 0,

            actions: [
              if (isLoading && liveUsers.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              if (!isconnectState)
                IconButton(
                  onPressed: () => ontap(),
                  icon: Icon(
                    Icons.signal_wifi_statusbar_connected_no_internet_4_sharp,
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'Social Users',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: primaryColor),
                  Center(
                    child: Text(
                      currentUser?.nat ?? "",
                      style: TextStyle(
                        color: backgroudColor.withOpacity(0.1),
                        fontWeight: FontWeight.w700,
                        fontSize: MediaQuery.sizeOf(context).width * 0.7,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: Colors.grey[200],
                                ),
                                Flexible(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.justify,
                                    currentUser?.location.city ?? "",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.sizeOf(context).width *
                                          0.03,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  currentUser?.location.country ?? "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        MediaQuery.sizeOf(context).width * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: secundaryColor,
                                    backgroundImage: NetworkImage(
                                      currentUser?.picture.medium ??
                                          defaultUserImage,
                                    ),
                                    child: currentUser?.picture.medium == null
                                        ? Icon(
                                            Icons.person,
                                            size: 60,
                                            color: primaryColor,
                                          )
                                        : null,
                                  ),

                                  FloatingActionButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        "/details",
                                        arguments: DetailsArguments(
                                          user: currentUser!,
                                          isConnected: isconnectState,
                                        ),
                                      );
                                    },
                                    mini: true,
                                    elevation: 1,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      BoxIcons.bx_info_circle,
                                      size: 20,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                currentUser == null
                                    ? ""
                                    : currentUser!
                                          .fullName, // Placeholder (como na imagem)
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_ind_rounded,
                                  size: 20,
                                  color: Colors.grey[200],
                                ),
                                Text(
                                  (currentUser?.dob.age.toString()) ?? "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isLoading && liveUsers.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primaryColor),
                    const SizedBox(height: 16),
                    const Text('Buscando primeiro usuário...'),
                  ],
                ),
              ),
            ),

          if (!isconnectState && liveUsers.isEmpty && errorMessage != null ||
              liveUsers.isEmpty)
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.group_off),
                  Text(
                    'Sem usuarios salvos',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final user = liveUsers[index];
              return AnimatedItemList(
                key: Key(user.login.uuid),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: isconnectState
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.picture.thumbnail,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: secundaryColor,

                              child: Icon(
                                Icons.person,
                                size: 20,
                                color: primaryColor,
                              ),
                            ),
                      title: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          Text(
                            "${user.name.first} ${user.name.last}, ${user.dob.age}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          Text(
                            '${user.location.city}, ${user.location.country}',
                          ),
                        ],
                      ),

                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed("/details", arguments: user),
                    ),
                  ),
                ),
              );
            }, childCount: liveUsers.length),
          ),
        ],
      ),
    );
  }
}
