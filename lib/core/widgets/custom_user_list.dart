import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:persona_app/core/models/user.dart';
import 'package:persona_app/core/utils/const.dart';

class CustomUserList extends StatelessWidget {
  final List<User> liveUsers;

  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;
  const CustomUserList({
    super.key,
    this.currentUser,
    this.errorMessage,
    required this.liveUsers,
    required this.isLoading,
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
            pinned: true, // A barra "encolhe" e permanece no topo
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
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: MediaQuery.sizeOf(context).height * 0.08,
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
                                    currentUser?.location.city ?? "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  currentUser?.location.country ?? "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
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
                              // Avatar (Placeholder da imagem)
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: secundaryColor,
                                    backgroundImage: NetworkImage(
                                      currentUser?.picture.medium ??
                                          "https://i.pinimg.com/474x/21/9e/ae/219eaea67aafa864db091919ce3f5d82.jpg",
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
                                    onPressed: () {},
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
                              // Nome (Placeholder)
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
                            width: MediaQuery.sizeOf(context).width * 0.1,
                            height: MediaQuery.sizeOf(context).height * 0.06,
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

          if (errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Erro ao buscar usuário:\n$errorMessage',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
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

          // Mostra o estado vazio
          if (!isLoading && liveUsers.isEmpty && errorMessage == null)
            SliverFillRemaining(
              child: const Center(
                child: Text(
                  'Aguardando Ticker...',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final user = liveUsers[index];
              // Este é o card que representa um item da lista
              return Padding(
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
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.picture.thumbnail),
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
                        Text('${user.location.city}, ${user.location.country}'),
                      ],
                    ),

                    onTap: () {
                      // Navigator.of(
                      //   context,
                      // ).pushNamed(AppRoutes.details, arguments: user);
                    },
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
