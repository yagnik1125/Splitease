// import 'package:auhackathon/tabpages/activity.dart';
import 'package:auhackathon/tabpages/friends.dart';
import 'package:auhackathon/tabpages/groups.dart';
import 'package:auhackathon/tabpages/settings.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        // backgroundColor: Colors.blue,
        gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        title: "SplitEase",
      ),
      // body: const Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       // Text(
      //       //   '$_counter',
      //       //   style: Theme.of(context).textTheme.headlineMedium,
      //       // ),
      //     ],
      //   ),
      // ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _pageController = PageController(initialPage: _currentIndex);
          });
        },
        children: const [
          FriendsPage(),
          GroupsPage(), //koi pan const ne lidhe aaya error aavi sake
          // ActivityPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        // backgroundColor: Color.fromARGB(255, 244, 151, 108),
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        // onItemSelected: (index) => setState(() => _currentIndex = index),
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: <BottomNavyBarItem>[
          // BottomNavyBarItem(
          //   icon: const Icon(Icons.group),
          //   title: const Text('Groups'),
          //   activeColor: hexStringToColor("CB2B93"),
          //   textAlign: TextAlign.center,
          // ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Friends'),
            activeColor: hexStringToColor("CB2B93"),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.group),
            title: const Text('Groups'),
            activeColor: hexStringToColor("9546C4"),
            textAlign: TextAlign.center,
          ),
          // BottomNavyBarItem(
          //   icon: const Icon(Icons.notifications_active_outlined),
          //   title: const Text('Activity'),
          //   activeColor: hexStringToColor("9546C4"),
          //   textAlign: TextAlign.center,
          // ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
            activeColor: hexStringToColor("5E61F4"),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient gradient;
  // final VoidCallback onReload;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
    // required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        // actions: [
        //   IconButton(
        //     onPressed: (){},
        //     icon: const Icon(Icons.replay_outlined),
        //   ),
        // ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16.0);
}
