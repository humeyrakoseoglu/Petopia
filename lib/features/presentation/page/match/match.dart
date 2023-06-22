import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petopia/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:petopia/util/consts.dart';
import 'package:petopia/injection_container.dart' as di;

import '../../../domain/entities/animal/animal_entity.dart';
import '../../cubit/user/user_cubit.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  String _currentUid = "";
  int currentIndex = 0;

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
        print("current : $_currentUid");
      });
    });

    BlocProvider.of<UserCubit>(context).getUsers(user: const AnimalEntity());

    super.initState();
  }

  void changeUser(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightPurpleColor,
        appBar: AppBar(
          backgroundColor: darkPurpleColor,
          title: const Text("Match"),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                size: 32,
              )),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState is UserLoaded) {
              final List<AnimalEntity> users = userState.users;
              users.removeWhere((element) => element.uid == _currentUid);

              if (users.isEmpty) {
                return const Center(
                  child: Text('No users available.'),
                );
              }
              final AnimalEntity animal = users[currentIndex];
              // if (animal.uid != _currentUid) {
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Card(
                          color: white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 16.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, PageConsts.singleUserProfilePage, arguments: animal.uid);
                                },
                                child: Container(
                                  width: 200,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: NetworkImage(animal.profileUrl ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      animal.username ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.pets, size: 16),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          animal.type ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        const Text("Breed: "),
                                        Text(
                                          animal.breed ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                changeUser((currentIndex + 1) % users.length);
                              },
                              icon: const Icon(Iconsax.close_circle, color: darkBlueGreenColor, size: 32),
                            ),
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<UserCubit>(context)
                                    .getFavUsers(user: AnimalEntity(uid: _currentUid, otherUid: animal.uid));
                                if (animal.favorites!.contains(_currentUid)) {
                                  Navigator.pushNamed(context, PageConsts.matchedPage, arguments: animal.uid);
                                }
                                changeUser((currentIndex + 1) % users.length);
                              },
                              icon: const Icon(Iconsax.like, color: Colors.red, size: 32),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
              // }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
