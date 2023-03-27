import 'package:flutter/material.dart';
import 'package:petopia/util/consts.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkBlueColor,
        appBar: AppBar(
          backgroundColor: darkBlueColor,
          title: Text("Username", style: TextStyle(color: lightBlueColor),),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                  onTap: (){
                    _openBottomModalSheet(context);
                  }, child: Icon(Icons.menu, color: lightBlueColor,)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: lightBlueColor,
                          shape: BoxShape.circle
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text("0", style: TextStyle(color: lightBlueColor, fontWeight: FontWeight.bold),),
                            sizeVertical(8),
                            Text("Posts", style: TextStyle(color: lightBlueColor),)
                          ],
                        ),
                        sizeHorizontal(25),
                        Column(
                          children: [
                            Text("54", style: TextStyle(color: lightBlueColor, fontWeight: FontWeight.bold),),
                            sizeVertical(8),
                            Text("Followers", style: TextStyle(color: lightBlueColor),)
                          ],
                        ),
                        sizeHorizontal(25),
                        Column(
                          children: [
                            Text("123", style: TextStyle(color: lightBlueColor, fontWeight: FontWeight.bold),),
                            sizeVertical(8),
                            Text("Following", style: TextStyle(color: lightBlueColor),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
                sizeVertical(10),
                Text("Name", style: TextStyle(color: lightBlueColor,fontWeight: FontWeight.bold),),
                sizeVertical(10),
                Text("The bio of user", style: TextStyle(color: lightBlueColor),),
                sizeVertical(10),
                GridView.builder(itemCount: 32, physics: ScrollPhysics(), shrinkWrap: true,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5), itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: lightBlueColor,
                  );
                })
              ],
            ),
          ),
        )
    );
  }

  _openBottomModalSheet(BuildContext context) {
    return showModalBottomSheet(context: context, builder: (context) {
      return Container(
        height: 150,
        decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "More Options",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: lightBlueColor),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  thickness: 1,
                  color: lightBlueColor,
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageConsts.editProfilePage);

                      //  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));

                    },
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: lightBlueColor),
                    ),
                  ),
                ),
                sizeVertical(7),
                Divider(
                  thickness: 1,
                  color: lightBlueColor,
                ),
                sizeVertical(7),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: lightBlueColor),
                  ),
                ),
                sizeVertical(7),
              ],
            ),
          ),
        ),
      );
    });
  }
}