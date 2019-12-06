import 'package:finances_manager/pages/account/account.dart';
import 'package:finances_manager/pages/checkbook/checkbook.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我的账本',
      theme: ThemeData(
        primaryColor: new Color(0xff54a75c),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var mTabInfo={};
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: mTabItems.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Holly要记账'),
          bottom: new TabBar(
            isScrollable: true,
            tabs: mTabItems.map((TabItem choice) {
              return new Tab(
                text: choice.title,
                icon: new Icon(choice.icon),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: mTabItems.map((TabItem item) {
            return new Padding(
              padding: const EdgeInsets.all(16.0),
              child: item.widget,
            );
          }).toList(),
        ),
      ),
    );
    
  }
}

class TabItem {
  TabItem({ this.title, this.icon, this.createSQL,this.widget });
  final String title;
  final IconData icon;
  final String createSQL;
  final Widget widget;
}

List<TabItem> mTabItems = <TabItem>[
  TabItem(
    title: '我的账本', 
    icon: Icons.book, 
    widget:CheckBook()
  ),
  TabItem(
    title: '我的账户', 
    icon: Icons.credit_card, 
    widget:AccountCard()
  ),
  TabItem(
    title: '我的资产', 
    icon: Icons.assessment, 
  ),
];
