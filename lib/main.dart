import 'package:excel_sheet_connect/from.dart';
import 'package:excel_sheet_connect/provider/provider.dart';
import 'package:excel_sheet_connect/splash_screen.dart';
import 'package:excel_sheet_connect/user_sheet_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSheetsApi.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(414, 860),
      builder: (BuildContext, Context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => DataProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          ),
        );
      },
    );
  }
}
