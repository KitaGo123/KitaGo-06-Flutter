// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_if_null_operators, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kitago/services/blogservice.dart';
import 'package:kitago/datamodels/paket_dm.dart';
import 'package:kitago/datamodels/booking_dm.dart';
import 'package:kitago/view/refund_screen.dart';
enum Menu { itemOne, itemTwo, itemThree, itemFour }
// ignore: camel_case_types
class myprofileScreen extends StatefulWidget {
  const myprofileScreen({Key? key}) : super(key: key);

  @override
  myprofileScreenState createState() {
    return myprofileScreenState();
  }
}

// ignore: camel_case_types
class myprofileScreenState extends State<myprofileScreen> {
  int _selectedIndex = 0;
  var app = [];
  dynamic user;

  DropdownMenuItem<String> buildMenuItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = json.decode(prefs.getString('user')!);
    });
    defUser();
  }

  defUser() {
    if (user != null) {
      if (user['nama_lengkap'] != null) {
        app = [
          const myprofilePage(),
          const mypackagePage(),
        ];
      } else if (user['nama_penyedia_jasa'] != null) {
        app = [
          const myprofilePage(),
        ];
      }
    }
  }

  defBottomNav() {
    if (user != null) {
      if (user['nama_lengkap'] != null) {
        return Scaffold(
          body: Center(
            child: app.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'My Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_rounded),
              label: 'My Package',
            ),],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFF01121B),
            onTap: _onItemTapped,
          ),
        );
      } else  {
        return Scaffold(
          body: Center(
            child: myprofilePage(),
          ),
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: myprofilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String _selectedMenu = '';
    return defBottomNav();
  }
}
class myprofilePage extends StatefulWidget {
  const myprofilePage({Key? key}) : super(key: key);

  @override
  State<myprofilePage> createState() => _myprofilePageState();
}
class _myprofilePageState extends State<myprofilePage> {
  String _selectedMenu = '';
  dynamic user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = json.decode(prefs.getString('user')!);
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(172, 15, 156, 238),
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "My Profile",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration( 
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/header.jpg"),
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
                onTap: user != null
                ? user['nama_lengkap'] != null
                  ? () => {Navigator.pushNamed(context, '/traveller')}
                  : () => {Navigator.pushNamed(context, '/agent')}
                : () => {Navigator.pop(context)}
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () => {_logout()},
              ),
            ],
          ),
        ),
      body : CustomScrollView(
        primary: false,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top:20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(140),
                        
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      user != null
                        ? user['nama_lengkap'] != null
                          ? user['nama_lengkap']
                          : user['nama_penyedia_jasa']
                        : "",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton.extended(
                      onPressed: (){},
                      icon: Icon(
                        Icons.account_circle,
                        size: 16,
                      ),
                      label: user != null
                      ? user['nama_lengkap'] != null
                        ? Text("Traveller", style: TextStyle(fontSize: 14),)
                        : user['nama_penyedia_jasa'] != null
                          ? Text("Agent Traveller", style: TextStyle(fontSize: 14),)
                          : Text("User Not Found", style: TextStyle(fontSize: 14),)
                      : Text("User Not Found", style: TextStyle(fontSize: 14),)
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: CustomUserData(user)
                    ),
                  ],
                ),
              ),
          ]
              
      )
            
      
    );
  }
}

  List<Widget> CustomUserData(dynamic user) {
    if (user == null) {
      return [];
    } else if (user['nama_lengkap'] != null) {
      List<Widget> list = <Widget>[];
      list.add(CustomCardProf(title: "Nama", contain: user['nama_lengkap']));
      list.add(CustomCardProf(title: "Kontak", contain: user['telpNumbC']));
      list.add(CustomCardProf(title: "Email", contain: user['emailC']));
      list.add(CustomCardProf(title: "Tanggal Lahir", contain: user['birthDate']));
      return list;
    } else if (user['nama_penyedia_jasa'] != null) {
      List<Widget> list = <Widget>[];
      list.add(CustomCardProf(title: "Nama", contain: user['nama_penyedia_jasa']));
      list.add(CustomCardProf(title: "Kontak", contain: user['telpNumbP']));
      list.add(CustomCardProf(title: "Email", contain: user['emailP']));
      list.add(CustomCardProf(title: "Alamat", contain: user['alamat']));
      return list;
    }
    return [];
  }
  
class mypackagePage extends StatefulWidget {
  const mypackagePage({Key? key}) : super(key: key);

  @override
  State<mypackagePage> createState() => _mypackagePageState();
}
class _mypackagePageState extends State<mypackagePage> {
  
  late List<Pakets> pakets;
  late List<dynamic> bookings;
  late List<Widget> listPaket;
  dynamic user;

  @override
  void initState() {
    super.initState();
    pakets = [];
    listPaket = [];
    bookings = [];
    getUser();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = json.decode(prefs.getString('user')!);
    });
  }

  getBook(int id) async {
    await APIService.getBooked(id).then((book) {
      bookings = book;
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamed(context, '/');
  }

  List<Pakets> _myPackets(int id) {
    APIService.getMyPackage(id).then((paket){
      setState(() {
        pakets = paket;
      });
    });
    return pakets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(172, 15, 156, 238),
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "My Package",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration( 
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/header.jpg"),
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
                onTap: user != null
                ? user['nama_lengkap'] != null
                  ? () => {Navigator.pushNamed(context, '/traveller')}
                  : () => {Navigator.pushNamed(context, '/agent')}
                : () => {Navigator.pop(context)}
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () => {_logout()},
              ),
            ],
          ),
        ),
      body : CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: user != null
                      ? pakets.isEmpty
                        ? CustomCardList(_myPackets(int.parse(user['id'])))
                        : listPaket.isEmpty
                          ? CustomCardList(_myPackets(int.parse(user['id'])))
                          : listPaket
                      : []
                    ),
                  )
                ],
              ),
            ),
          ), 
        ],  
      ),
    );
  }
  List<Widget> CustomCardList(List<Pakets> pakets) {
    if (pakets.isEmpty) {
      return [];
    } else  {
      List<Widget> list = <Widget>[];
      for (int i=0;i<pakets.length;i++) {
        getBook(int.parse(user['id']));
        if (bookings.isNotEmpty) {
          list.add(CustomCardPackage(title: pakets[i].namaPaket, contain: "Harga : Rp. ${pakets[i].harga},-", id: int.parse(bookings[i]['id']), paket: pakets[i],));
        }
      }
      bookings = [];
      listPaket.addAll(list);
      return list;
    }
  }
}

class CustomCardProf extends StatelessWidget {
    
      //ini adalah konstruktor, saat class dipanggil parameter konstruktor wajib diisi
      //parameter ini akan mengisi title dan gambar pada setiap card
  CustomCardProf({required this.title, required this.contain});
    
    String title;
    String contain;
    //String image;
    
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
                height: 60,
                width: 440,
                decoration: const BoxDecoration( 
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      contain,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        );
    }
  } 
class CustomCardPackage extends StatelessWidget {
    
      //ini adalah konstruktor, saat class dipanggil parameter konstruktor wajib diisi
      //parameter ini akan mengisi title dan gambar pada setiap card
  CustomCardPackage({required this.title, required this.contain, required this.id, required this.paket});
    
    String title;
    String contain;
    int id;
    Pakets paket;
    //String image;
    
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
                height: 145,
                width: 440,
                decoration: const BoxDecoration( 
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 90,
                          width: 110,
                          decoration: BoxDecoration( 
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image : paket != null
                              ? paket.id % 7 == 0
                                ? AssetImage("assets/images/green-canyon.png")
                                : paket.id % 5 == 0
                                  ? AssetImage("assets/images/kawah-putih.png")
                                  : paket.id % 3 == 0
                                    ? AssetImage("assets/images/curug-luhur-citoe.png")
                                    : paket.id % 2 == 0
                                      ? AssetImage("assets/images/pantai-batu-hiu.jpeg")
                                      : AssetImage("assets/images/perkebunan-teh-rancabali.png")
                              : AssetImage("assets/images/green-canyon.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                contain,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFF1976D2),
                                              Color(0xFF0F9CEE),
                                              Color(0xFF42A5F5),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(16.0),
                                        primary: Colors.white,
                                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                      ),
                                      onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => RefundScreen(id: id)));},
                                      child: const Text('Refund'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        );
    }
  } 

