// ignore_for_file: unnecessary_const, prefer_const_constructors, unnecessary_new, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:kitago/view/addPakett.dart';
import 'package:kitago/view/myprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kitago/datamodels/agent_dm.dart';
import 'package:kitago/datamodels/paket_dm.dart';
import 'package:kitago/services/blogservice.dart';
import 'dart:convert';
import 'dart:async';

import 'package:kitago/view/viewPaket.dart';
enum Menu { itemOne, itemTwo, itemThree, itemFour }
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KitaGO',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key, this.user}) : super(key: key);

  final String title = 'Home Page';
  static const routeName = "/";
  String? user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedMenu = '';
  List<Pakets> pakets = <Pakets>[];
  String? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    if (user != null) {
      _initPaket();
    } else {
      pakets = [];
    }
  }

  _initPaket() {
    APIService.pakets().then((paket){
      setState(() {
        pakets = paket;
      });
    });
  }

  _deletePaket(Pakets paket) async {
    await APIService.deletePaket(paket.id).then((result){
      if ("success" == result) {
        _initPaket();
      }
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamed(context, '/');
  }

  List<Widget> PaketListFav(List<Pakets> pakets) {
    if (pakets.isEmpty) {
      return [];
    } else {
      List<Widget> list = <Widget>[];
      for (var i=0;i<pakets.length;i++) {
        list.add(new CustomCardCFav(paket: pakets[i]));
        list.add(const SizedBox(width: 20));
      }
      return list;
    }
  }

  List<Widget> PaketList(List<Pakets> pakets) {
    if (pakets.isEmpty) {
      return [];
    } else {
      List<Widget> list = <Widget>[];
      if (user == "traveller") {
        for (var i=0;i<pakets.length;i++) {
          list.add(new CustomCardC(paket: pakets[i]));
        }
      } else if (user == "agent") {
        for (var i=0;i<pakets.length;i++) {
          list.add(new CustomCardP(paket: pakets[i], index: i,));
        }
      }
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "KitaGO",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          actions: <Widget>[
            PopupMenuButton<Menu>(
                onSelected: (Menu item) {
                  setState(() {
                    _selectedMenu = item.name;
                  });
                },
                itemBuilder: (BuildContext context) => popUp(),),
            
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: user != null 
              ? <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration( 
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/header.jpg'),
                        fit: BoxFit.fill,
                      ),
                      
                    ),
                    child: Text(
                      'KitaGO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: user == "traveller"
                    ? () => {Navigator.pushNamed(context, '/traveller')}
                    : () => {Navigator.pushNamed(context, '/agent')},
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => myprofileScreen())),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () => {_logout()},
                  ),
                ]
              : <Widget>[
              DrawerHeader(
                decoration: BoxDecoration( 
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/header.jpg'),
                    fit: BoxFit.fill,
                  ),
                  
                ),
                child: Text(
                  'KitaGO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () => {Navigator.pushNamed(context, '/')},
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Login'),
                onTap: () => {Navigator.pushNamed(context, '/loginPage')},
              ),
            ],
          ),
        ),
        body:  CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                    height: 220,
                    decoration: const BoxDecoration( 
                      //borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30), bottomRight:Radius.circular(30)),
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/header.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                ),
              ),
              user == null
              ? SliverToBoxAdapter(
                child: Container(
                    height: 150,
                    margin: EdgeInsets.only(top: 70.0),
                    decoration: const BoxDecoration( 
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/embarrassed.png"),
                      ),
                    ),
                ),
              )
              : SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  height: 215,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                      children: PaketListFav(pakets)
                    ),
                ),
              ),
              user == null
              ? SliverToBoxAdapter(
                child: Column(
                  children: const [
                    const SizedBox(height: 20),
                    Text(
                      "Login dulu yuk",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 180),
                  ],
                ),
              )
              : SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: PaketList(pakets),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  color: const Color(0xFFBABDBA),
                  child: const Center(
                    child: 
                      Text(
                        "Copyright ©2022, All Rights Reserved.",
                        style: TextStyle(fontWeight:FontWeight.w300, fontSize: 12.0, color: Colors.black),
                        
                      ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  color: const Color(0xFFBABDBA),
                  child: const Center(
                    child: 
                      Text(
                        "Powered by KitaGO",
                        style: TextStyle(fontWeight:FontWeight.w300, fontSize: 12.0, color: Colors.black),
                        
                      ),
                  ),
                ),
              ),
              
            ],
          ),
        floatingActionButton: user == "agent"
        ? FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => addPaketScreen(type: "add", id: -1,)));
            },
            backgroundColor: Color(0xFF0F9CEE),
            child: const Icon(Icons.add),
        )
        : null
    );
  }
  popUp() {
    if (user != null) {
      return <PopupMenuEntry<Menu>>[PopupMenuItem<Menu>(
        value: Menu.itemOne,
        child: TextButton(
          onPressed: () => {_initPaket()},
          child: const Text('Refresh')
        ),
      )];
    } else {
      return <PopupMenuEntry<Menu>>[PopupMenuItem<Menu>(
        value: Menu.itemOne,
        child: TextButton(
          onPressed: () => {Navigator.pushNamed(context, '/registerPage/traveller')},
          child: const Text('Sign In as Traveller')
        ),
      ),
      PopupMenuItem<Menu>(
        value: Menu.itemTwo,
        child: TextButton(
          onPressed: () => {Navigator.pushNamed(context, '/registerPage/agent')},
          child: const Text('Sign In as Agent Traveller')
        ),
      )];
    }
  }
}

// ignore: must_be_immutable
class CustomCardC extends StatelessWidget {
    
      //ini adalah konstruktor, saat class dipanggil parameter konstruktor wajib diisi
      //parameter ini akan mengisi title dan gambar pada setiap card
  CustomCardC({required this.paket, });
    
    Pakets paket;
    //String image;
    
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Card(
          //menambahkan bayangan
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: double.maxFinite,
                decoration: BoxDecoration( 
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: paket.id % 7 == 0
                    ? AssetImage("assets/images/green-canyon.png")
                    : paket.id % 5 == 0
                      ? AssetImage("assets/images/kawah-putih.png")
                      : paket.id % 3 == 0
                        ? AssetImage("assets/images/curug-luhur-citoe.png")
                        : paket.id % 2 == 0
                          ? AssetImage("assets/images/pantai-batu-hiu.jpeg")
                          : AssetImage("assets/images/perkebunan-teh-rancabali.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Center(child: Text(paket.namaPaket, style: const TextStyle(fontSize: 12.0)))
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.black,
                  minimumSize: const Size.fromHeight(10),
                  textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPaket(paket: paket)));},
                child: const Text('See Details'),
              ),
            ],
          ),
        ),
      );
    }
  }
  class CustomCardP extends StatefulWidget {
    
      //ini adalah konstruktor, saat class dipanggil parameter konstruktor wajib diisi
      //parameter ini akan mengisi title dan gambar pada setiap card
    CustomCardP({required this.paket, required this.index});
    
    Pakets paket;
    int index;
    //String image;
     @override
    _CustomCardPState createState() => _CustomCardPState();
  }

class _CustomCardPState extends State<CustomCardP> {
    
    @override
    Widget build(BuildContext context) {
      return Card(
            //menambahkan bayangan
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                width: double.maxFinite,
                decoration: BoxDecoration( 
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: widget.paket.id % 7 == 0
                      ? AssetImage("assets/images/green-canyon.png")
                      : widget.paket.id % 5 == 0
                        ? AssetImage("assets/images/kawah-putih.png")
                        : widget.paket.id % 3 == 0
                          ? AssetImage("assets/images/curug-luhur-citoe.png")
                          : widget.paket.id % 2 == 0
                            ? AssetImage("assets/images/pantai-batu-hiu.jpeg")
                            : AssetImage("assets/images/perkebunan-teh-rancabali.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10, left: 10, right: 10, bottom: 5),
                child: Center(child: Text(widget.paket.namaPaket, style: const TextStyle(fontSize: 12.0),),)
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: Color(0xFF0F9CEE),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => addPaketScreen(type: "update", id: widget.paket.id)));},
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: Color(0xFF0F9CEE),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () {_HomeState()._deletePaket(widget.paket);},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
    }
    
  }
  class CustomCardCFav extends StatelessWidget {
    
      //ini adalah konstruktor, saat class dipanggil parameter konstruktor wajib diisi
      //parameter ini akan mengisi title dan gambar pada setiap card
  CustomCardCFav({required this.paket});
    
    Pakets paket;
    
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 100,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                      image: paket.id % 7 == 0
                      ? AssetImage("assets/images/green-canyon.png")
                      : paket.id % 5 == 0
                        ? AssetImage("assets/images/kawah-putih.png")
                        : paket.id % 3 == 0
                          ? AssetImage("assets/images/curug-luhur-citoe.png")
                          : paket.id % 2 == 0
                            ? AssetImage("assets/images/pantai-batu-hiu.jpeg")
                            : AssetImage("assets/images/perkebunan-teh-rancabali.png"),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  textBaseline: TextBaseline.alphabetic,
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      paket.namaPaket, 
                      style: const TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold, ),
                      textAlign: TextAlign.left,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(3),
                    ),
                    Text(
                      paket.deskripsi, 
                      style: const TextStyle(color: Color(0xFF141414), fontSize: 10.0),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )
                  
              ),
            ],
          ),
      );
    }
  } 