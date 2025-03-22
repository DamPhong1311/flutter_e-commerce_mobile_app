import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/firebase_options.dart';

import 'package:ecommerece_flutter_app/nav_page.dart';
import 'package:ecommerece_flutter_app/pages/home/home_page.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'common/theme/theme.dart';
import 'pages/intro/splash.dart';
import 'services/theme_provider_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  //FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // .then(
  //  (FirebaseApp value) => Get.put(AuthenticationRepository()),
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Đưa ThemeProvider vào đây
      ],
    child: EasyLocalization(
      supportedLocales: const [
        Locale("vi"), // tieng viet
        Locale("en") // tieng anh
      ],
      path: "assets/translations",
       fallbackLocale: Locale('en'), //mặc định nếu k thấy ngôn ngữ
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    ),),
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(

      // locale: DevicePreview.locale(context),
      locale: context.locale,

      builder: DevicePreview.appBuilder,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.dartTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      home: Splash(),
      // home: NavPage(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch, // Hỗ trợ vuốt trên điện thoại
        PointerDeviceKind.mouse, // Hỗ trợ vuốt bằng chuột trên Web
        PointerDeviceKind.trackpad, // Hỗ trợ vuốt bằng trackpad
      };
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
   late ScrollController _scrollController;

  

  @override
  void initState() {
    _scrollController = ScrollController();
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Helper.navigateAndReplace(context, HomePage());
      } else {
        Helper.navigateAndReplace(context, LoginPage());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
