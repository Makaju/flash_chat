import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/modules/services/database.dart';
import 'package:flash_chat/modules/theme/theme_provider.dart';
import 'package:flash_chat/screens/landing_screen/logout_dialog/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../modules/theme/theme_change_switch.dart';
import '../landing_page.dart';
import 'change_password_popup.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _image;
  var imagePicker;

  String? username = nameofuser;
  bool spinner = false;
  bool isDarkModeDemo = false;
  // final provider = Provider.of<ThemeProvider>(_, listen: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    getUser();
    nameGetterCaller();
  }

  nameGetterCaller() async {
    await getUsersName();
    setState(() {
      spinner = false;
    });
  }



  themeGetter(var context) {
    if (Theme.of(context).primaryColor == Colors.black) {
      isDarkModeDemo = true;
      return true;
    } else if (Theme.of(context).primaryColor != Colors.black) {
      isDarkModeDemo = false;
      return false;
    }
  }
  void clearCache(BuildContext context) async{
    Future.delayed(const Duration(seconds: 5));
    profileOfUserLink = await getImageUrl(loggedInUser.email.toString());
    imageCache.clear();
    imageCache.clearLiveImages();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(screen: 3,),
        ));


    setState((){});

  }

  @override
  Widget build(BuildContext context) {

    ThemeProvider provider =Provider.of<ThemeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: (nameofuser != null) ? bodyWidget(context, provider) : Container(),
      ),
    );
  }

  Widget bodyWidget(context, ThemeProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Container(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                        bottom: Radius.circular(16),
                      )),
                  // height: 325,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 140, 10, 10),
                    child: Column(
                      children: [
                        Text(
                          nameofuser.toString(),
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Theme.of(context).primaryColor)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          loggedInUser.email.toString(),
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => const TestPage()
                        //             // LandingPage(
                        //             //   screen: 1,
                        //             // )
                        //             ));
                        //   },
                        //   child: const Text(
                        //     'Okay',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: (){
                            Provider.of<ThemeProvider>(context, listen: false).swapTheme();
                            },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            color: Colors.transparent,
                            height: 64,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.nightlight_round),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      Theme.of(context).primaryColor==Colors.black?'Turn on Dark Mode':'Turn on Light Mode',
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).primaryColor)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    width: 52,
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        const Positioned(
                                            top: 1,
                                            right: 1,
                                            child: SizedBox(
                                                width: 52,
                                                height: 50,
                                                child: ChangeThemeSwitchWidget())),
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<ThemeProvider>(context,
                                                listen: false)
                                                .swapTheme();
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            height: 6.h,
                                            width: 6.h,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return const ChangePasswordPopUp();
                                  //const ChangePasswordPopUp();
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            color: Colors.transparent,
                            height: 64,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.lock),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      'Change Password',
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).primaryColor)),
                                    ),
                                  ],
                                ),
                                const RotatedBox(
                                    quarterTurns: 2,
                                    child: Icon(Icons.arrow_back_ios_outlined))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return const LogoutDialog();
                                  //const ChangePasswordPopUp();
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            color: Colors.transparent,
                            height: 64,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.logout,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      'Log Out',
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).primaryColor)),
                                    ),
                                  ],
                                ),
                                const RotatedBox(
                                    quarterTurns: 2,
                                    child: Icon(Icons.arrow_back_ios_outlined))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -96,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          color: const Color(0xCA4a148c),
                          shape: BoxShape.circle),
                      child: newProfilePictureWidget(96.0),
                    ),
                    Positioned(
                        bottom: 5,
                        right: 5,
                        child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet(context)));
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  color: const Color(0xCA4a148c),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text('Chose A profile Photo'),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                XFile image =
                    await imagePicker.pickImage(source: ImageSource.camera);

                final uploadlink = image.path;
                setState(() {
                  _image = File(image.path);
                  // print('$_image');
                });

                storage
                    .uploadFile(uploadlink.toString(),
                        loggedInUser.email.toString().replaceAll('.', ''))
                    .then((value){
                  log('Uploaded');
                  clearCache(context);

                });

                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No File Selected')));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt),
                  Text('Add from Camera'),
                ],
              )),
          ElevatedButton(
            onPressed: () async {
              XFile image =
                  await imagePicker.pickImage(source: ImageSource.gallery);

              final uploadlink = image.path;
              // print('$_image');
              storage
                  .uploadFile(uploadlink.toString(),
                      loggedInUser.email.toString().replaceAll('.', ''))
                  .then((value){
                log('Uploaded');
                clearCache(context);

              });
              setState(() {
                _image = File(image.path);
              });
              if (_image == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No File Selected')));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.image),
                Text('Add From Gallery'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future<File> saveImagePermanently(String imagePath) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = basename(imagePath);
  //   final image = File('${directory.path}/$name');
  //   return File(imagePath).copy(image.path);
  // }
}

imageWidget(String cacheURL) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: CachedNetworkImage(
      height: 150,
      width: 150,
      imageUrl: cacheURL,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    ),
  );
}

getImageUrlCache() async {
  // MyApp.cacheURL= null;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? url = pref.getString('url');
  // MyApp.cacheURL= url.toString();
  // log('what what '+MyApp.cacheURL.toString());
  return url.toString();
}

saveNameForCacheImage(String value) async {
  await DefaultCacheManager().emptyCache();
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('url', value.toString());
}



getImageUrl(String name) async{
  String formtedName = name.replaceAll('.', '') + '.jpg';
  String urlIs= await storage.downloadURL(formtedName);
  return urlIs;
}

Widget profilePictureWidget(String name, double radiuss) {
  String formtedName = name.replaceAll('.', '') + '.jpg';
  // print(formtedName);
  return FutureBuilder(
    future: storage.downloadURL(formtedName),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.hasData) {
        return CircleAvatar(
          radius: radiuss,
          backgroundImage: NetworkImage(
            snapshot.data!,
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: const Color(0xCA4a148c),
                  shape: BoxShape.circle),
              child: CircleAvatar(
                  radius: radiuss,
                  backgroundImage:
                      const AssetImage('images/contactdefault.png')),
            ),
            const Positioned(
                top: 80, right: 60, child: CircularProgressIndicator()),
          ],
        );
      }
      if (snapshot.connectionState == ConnectionState.done &&
          !snapshot.hasData) {
        return CircleAvatar(
          radius: radiuss,
          backgroundImage: const AssetImage('images/contactdefault.png'),
        );
      }
      return const Image(image: AssetImage('images/default_profile.jpg'));
    },
  );
}

Widget newProfilePictureWidget(double radius) {
  String link = profileOfUserLink.toString();
  return ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: CachedNetworkImage(
      height: radius * 2,
      width: radius * 2,
      imageUrl: link,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    ),
  );
}
