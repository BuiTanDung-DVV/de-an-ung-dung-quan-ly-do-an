import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_do_an_online/screens/login_register_screen/register_screen.dart';
import 'screens/login_register_screen/login_screen.dart';
import 'models/users/user.dart';
import 'widgets/navigation_drawer.dart';
import 'screens/home_screen.dart';
import 'screens/document_list_screen.dart';
import 'screens/user_profile_screen.dart';
import 'models/document/documents_data.dart';
import 'models/users/user_data.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserData(),
        ),
        ChangeNotifierProvider<DocumentsData>(
          create: (context) {
            final userId = Provider.of<UserData>(context, listen: false).userId; // Lấy userId từ UserData
            return DocumentsData(userId);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Quản lý đồ án',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: 'Roboto',
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        home: const LoginScreen(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/main': (context) => MainScreen(),
          '/register': (context) => RegisterScreen(),
          },

        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {


    final userData = Provider.of<UserData>(context);
    final user = userData.user;
    final bool isTeacher = user?.isTeacher ?? false;

    final List<Widget> pages = [
      const HomeScreen(),
      DocumentListScreen(isTeacher: isTeacher),
      UserProfileScreen(user: user!),
    ];

    return Scaffold(
      drawer: CustomNavigationDrawer(user: user!,),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Tài Liệu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá Nhân',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
