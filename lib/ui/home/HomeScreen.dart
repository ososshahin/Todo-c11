import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/providers/appauthprovider.dart';
import 'package:todo_c11/ui/common/addTaskBottomSheet.dart';
import 'package:todo_c11/ui/home/list/TasksListTab.dart';
import 'package:todo_c11/ui/home/settings/SettingsTab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTabIndex = 0;

  var tabs = [
    TasksListTab(),
    SettingsTab(),
  ];


  @override

  Widget build(BuildContext context) {
    var authProvider = Provider.of<AppAuthProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(authProvider.appUser==null?'Welcome':
            'Welcome ${authProvider.appUser?.fullname}'
            ),
        actions: [
          IconButton(onPressed:() {
            authProvider.logout(context);

          },  icon: Icon(Icons.logout) )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white,
          width: 4)
        ),
        onPressed: (){
          showAddTaskBottomSheet();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: BottomNavigationBar(
          currentIndex: selectedTabIndex,
          onTap: (newSelectedIndex) {
            selectedTabIndex = newSelectedIndex;
            setState(() {

            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list),label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: ''),
          ],
        ),
      ),
      body: tabs[selectedTabIndex],
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(context: context, builder:
    (context) =>addTaskBottomSheet());
  }
}


