import 'package:despensaapp/Client/ui/widgets/chart.dart';
import 'package:despensaapp/Client/ui/screens/pages/pay.dart';
import 'package:despensaapp/Product/ui/screens/favorites_list.dart';
import 'package:despensaapp/Product/ui/screens/shopping_cart.dart';
import 'package:despensaapp/Ticket/pages/PlaneTicketListPage.dart';
import 'package:despensaapp/Ticket/pages/delivery.dart';
import 'package:despensaapp/Wallet/ui/card_type.dart';
import 'package:despensaapp/Wallet/ui/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiffy/jiffy.dart';

import 'package:despensaapp/Product/ui/screens/products_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

class MainPage extends KFDrawerContent {
  MainPage({
    Key key,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool isPlaying = false;
  int _page = 2;
  GlobalKey _bottomNavigationKey = GlobalKey();
  bool _isElegance = false;

  Future<Null> getSharedPrefs() async {
    SharedPreferences theme = await SharedPreferences.getInstance();
    bool isElegance = (theme.getBool("Elegance") ?? false);
    setState(() {
      _isElegance = isElegance;
    });
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _theme;

  String nameClient = "";
  String emailClient = "";
  Future getClient() async {
    final String CLIENTS = "clients";
    final Firestore _db = Firestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final uid = await _auth.currentUser().then((FirebaseUser user) {
      return user.uid;
    });

    QuerySnapshot qn = await _db
        .collection(CLIENTS)
        .where("uid", isEqualTo: uid)
        .getDocuments();

    var clientInfo = [];
    clientInfo.add(qn.documents);

    await Jiffy.locale('es');
    for (var snapshotClient in clientInfo) {
      print("getClient");
      print(snapshotClient[0].data["name"]);
      setState(() {
        nameClient = snapshotClient[0].data["name"];
        emailClient = snapshotClient[0].data["email"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _theme = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool("Elegance") ?? false);
    });
    getSharedPrefs();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    getClient();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color darkColor = Color(0xFF212121);
    final Color lightColor = Color(0xFFF4F8FF);

    final pages = [
      Stack(
        children: <Widget>[
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                  ),
                  _isElegance
                      ? Container()
                      : Container(
                          margin: EdgeInsets.all(20),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Color(0xFFC42036).withOpacity(0.2),
                                BlendMode.dstATop),
                            child: Image.asset(
                              'assets/images/line-shopping-cart.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          MyCart(),
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.menu,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: widget.onMenuPressed,
                            ),
                          ),
                        ),
                        Text(
                          'Tu carrito',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Poppins-Medium",
                              color: _isElegance ? lightColor : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.settings_cell,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: () => {
                                Wiredash.of(context).setOptions(
                                    userEmail: emailClient, appVersion: "1.0"),
                                Wiredash.of(context).show()
                              },
                            ),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        color: _isElegance ? darkColor : Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15.0,
                              offset: Offset(7.0, 7.0))
                        ]),
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Stack(
        children: <Widget>[
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.menu,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: widget.onMenuPressed,
                            ),
                          ),
                        ),
                        Text(
                          'Pedidos',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Poppins-Medium",
                              color: _isElegance ? lightColor : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.settings_cell,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: () => {
                                Wiredash.of(context).setOptions(
                                    userEmail: emailClient, appVersion: "1.0"),
                                Wiredash.of(context).show()
                              },
                            ),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        color: _isElegance ? darkColor : Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: _isElegance ? lightColor : Colors.black12,
                              blurRadius: 15.0,
                              offset: Offset(7.0, 7.0))
                        ]),
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                  ),
                  _isElegance
                      ? Container()
                      : Container() /*Container(
                          margin: EdgeInsets.all(20),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Color(0xFFC42036).withOpacity(0.2),
                                BlendMode.dstATop),
                            child: Image.asset(
                              'assets/images/line-truck.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )*/
                  ,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 70),
                  child: PlaneTicketListPage(),
                ),
                //Order()
              ],
            ),
          )
        ],
      ),
      Stack(
        children: <Widget>[
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.menu,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: widget.onMenuPressed,
                            ),
                          ),
                        ),
                        Text(
                          'Despensa App.',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Poppins-Medium",
                              color: _isElegance ? lightColor : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                              shadowColor: Colors.transparent,
                              color: Colors.transparent,
                              child: IconButton(
                                icon: Icon(Icons.settings_cell,
                                    color: _isElegance
                                        ? lightColor
                                        : Colors.black),
                                onPressed: () => {
                                  Wiredash.of(context).setOptions(
                                      userEmail: emailClient,
                                      appVersion: "1.0"),
                                  Wiredash.of(context).show()
                                },
                              )),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        color: _isElegance ? darkColor : Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: _isElegance ? lightColor : Colors.black12,
                              blurRadius: 15.0,
                              offset: Offset(7.0, 7.0))
                        ]),
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                  ),
                  _isElegance
                      ? Container()
                      : Container(
                          margin: EdgeInsets.all(20),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Color(0xFFC42036).withOpacity(0.2),
                                BlendMode.dstATop),
                            child: Image.asset(
                              'assets/images/online-store.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          HeaderAppBar(),
        ],
      ),
      Stack(
        children: <Widget>[
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                  ),

                ],
              ),
            ),
          ),
          Favorites(),
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.menu,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: widget.onMenuPressed,
                            ),
                          ),
                        ),
                        Text(
                          'Tus listas',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Poppins-Medium",
                              color: _isElegance ? lightColor : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.settings_cell,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: () => {
                                Wiredash.of(context).setOptions(
                                    userEmail: emailClient, appVersion: "1.0"),
                                Wiredash.of(context).show()
                              },
                            ),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        color: _isElegance ? darkColor : Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15.0,
                              offset: Offset(7.0, 7.0))
                        ]),
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Stack(
        children: <Widget>[
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.menu,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: widget.onMenuPressed,
                            ),
                          ),
                        ),
                        Text(
                          'Balance',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Poppins-Medium",
                              color: _isElegance ? lightColor : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          child: Material(
                            shadowColor: Colors.transparent,
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.add,
                                  color:
                                      _isElegance ? lightColor : Colors.black),
                              onPressed: () {
                                /*Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return App();
                                  }),
                                );*/
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CardType()));
                              },
                            ),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        color: _isElegance ? darkColor : Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15.0,
                              offset: Offset(7.0, 7.0))
                        ]),
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                  ),
                  _isElegance
                      ? Container(
                          height: 300,
                        )
                      : Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 20, right: 20, bottom: 0),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Color(0xFFC42036).withOpacity(0.2),
                                BlendMode.dstATop),
                            child: Image.asset(
                              'assets/images/line-credit.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  CardList(),
                  /*ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    child: Material(
                      shadowColor: Colors.transparent,
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(Icons.home, color: Colors.black),
                        onPressed: () {
                          final CurvedNavigationBarState navBarState =
                              _bottomNavigationKey.currentState;
                          navBarState.setPage(2);
                        },
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 120),
            child: LineChartSample1(),
          )
        ],
      ),
    ];
    return Center(
        child: FutureBuilder<bool>(
            future: _theme,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white));
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Scaffold(
                        backgroundColor:
                            _isElegance ? lightColor : Color(0xFFC42036),
                        bottomNavigationBar: CurvedNavigationBar(
                          key: _bottomNavigationKey,
                          backgroundColor:
                              _isElegance ? lightColor : Color(0xFFC42036),
                          color: _isElegance ? darkColor : Colors.white,
                          buttonBackgroundColor:
                              _isElegance ? darkColor : Colors.white,
                          height: 50,
                          items: <Widget>[
                            Icon(Icons.add_shopping_cart,
                                size: 20,
                                color: _isElegance ? lightColor : Colors.black),
                            Icon(Icons.settings_ethernet,
                                size: 20,
                                color: _isElegance ? lightColor : Colors.black),
                            Icon(Icons.home,
                                size: 20,
                                color: _isElegance ? lightColor : Colors.black),
                            Icon(Icons.list,
                                size: 20,
                                color: _isElegance ? lightColor : Colors.black),
                            Icon(Icons.compare_arrows,
                                size: 20,
                                color: _isElegance ? lightColor : Colors.black),
                          ],
                          animationDuration: Duration(milliseconds: 200),
                          index: 2,
                          animationCurve: Curves.bounceInOut,
                          onTap: (index) {
                            setState(() {
                              _page = index;
                            });
                          },
                        ),
                        body: Container(
                          color: _isElegance ? lightColor : Color(0xFFC42036),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                pages[_page],
                              ],
                            ),
                          ),
                        ));
                  }
              }
            }));
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }
}
