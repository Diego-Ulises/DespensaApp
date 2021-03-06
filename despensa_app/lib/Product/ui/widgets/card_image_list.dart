import 'package:despensaapp/Client/model/client.dart';
import 'package:despensaapp/Client/repository/firebase_auth_api.dart';
import 'package:despensaapp/widgets/button_outline.dart';
import 'package:despensaapp/widgets/button_purple.dart';
import 'package:flutter/material.dart';
import 'package:despensaapp/Product/model/product.dart';
import 'package:despensaapp/Product/ui/widgets/card_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardImageList extends StatefulWidget {
  Client user;

  CardImageList(@required this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CardImageList();
  }
}

class _CardImageList extends State<CardImageList> {
  final FirebaseAuthAPI _userRepository = FirebaseAuthAPI();
  Product selectedProduct = Product(
      id: "",
      name: "",
      description: "",
      urlImage: "",
      likes: 0,
      liked: false,
      price: 0,
      isBulk: false,
      category: "",
      store: "");

  final Color darkColor = Color(0xFF212121);
  final Color lightColor = Color(0xFFF4F8FF);

  bool _isElegance = false;

  Future<Null> getSharedPrefs() async {
    SharedPreferences theme = await SharedPreferences.getInstance();
    bool isElegance = (theme.getBool("Elegance") ?? false);
    setState(() {
      _isElegance = isElegance;
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: _userRepository.productsStream,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              print("PLACESLIST: WAITING");
              return Container(
                height: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white)),
                  ],
                ),
              );
            case ConnectionState.none:
              print("PLACESLIST: NONE");
              return Container(
                height: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white)),
                  ],
                ),
              );
            case ConnectionState.active:
              print("PLACESLIST: ACTIVE");
              return listViewProducts(_userRepository.buildProducts(
                  snapshot.data.documents, widget.user));
            case ConnectionState.done:
              print("PLACESLIST: DONE");
              return listViewProducts(_userRepository.buildProducts(
                  snapshot.data.documents, widget.user));
            default:
              print("PLACESLIST: DEFAULT");
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white)),
                ],
              );
          }
        });
  }

  Widget listViewProducts(List<Product> products) {
    void setLiked(Product product) {
      setState(() {
        product.liked = !product.liked;
        _userRepository.likePlace(product, widget.user.uid);
        product.likes = product.liked ? product.likes + 1 : product.likes - 1;
        selectedProduct = product;

        _userRepository.addFavorites(product, widget.user.uid);
      });
    }

    void setAdded(Product product) {
      setState(() {
        product.added = !product.added;
        _userRepository.addProduct(
            selectedProduct, widget.user.uid, true, true);
        selectedProduct = product;

        _userRepository.addCart(selectedProduct, widget.user.uid);
      });
    }

    IconData iconDataLiked = Icons.favorite;
    IconData iconDataLike = Icons.favorite_border;
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: (selectedProduct.id == ""
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: 118.0, left: 20.0, right: 20.0, bottom: 10),
                      child: Text(
                        "Selecciona un producto.",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Poppins-Medium",
                          color: _isElegance ? darkColor : Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 20.0,
                              color: _isElegance ? lightColor : Colors.black,
                              offset: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 200,
                      child: _isElegance
                          ? Container(
                        margin: EdgeInsets.all(10),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Color(0xFFF4F8FF).withOpacity(0.2),
                              BlendMode.dstATop),
                          child: Image.asset(
                            'assets/images/guarantee.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.all(10),
                      ),
                    )

                  ],
                )
              : Column(
                  children: <Widget>[
                    titleStars(selectedProduct),
                  ],
                )),
        ),
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height - 400),
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 10, right: 20),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Ver catálogo.',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Poppins-ExtraBold",
                            color: _isElegance ? darkColor : Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 20.0,
                                color: _isElegance ? lightColor : Colors.black,
                                offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      (selectedProduct.id == ""
                          ? Container()
                          : _isElegance
                              ? ButtonOutline(
                                  buttonText: selectedProduct.added
                                      ? "Añadido"
                                      : "Añadir al carrito.",
                                  iconText: selectedProduct.added
                                      ? Icon(Icons.shopping_cart,
                                          color: Color(0xFFffffff))
                                      : Icon(Icons.add_shopping_cart,
                                          color: Color(0xFFffffff)),
                                  widthButton: 200.0,
                                  onPressed: () {
                                    print("PREPARE ADD TO CART");
                                    print(selectedProduct.name);
                                    setAdded(selectedProduct);
                                  })
                              : ButtonPurple(
                                  buttonText: selectedProduct.added
                                      ? "Añadido"
                                      : "Añadir al carrito.",
                                  iconText: selectedProduct.added
                                      ? Icon(Icons.shopping_cart,
                                          color: Colors.white)
                                      : Icon(Icons.add_shopping_cart,
                                          color: Colors.white),
                                  widthButton: 200.0,
                                  onPressed: () {
                                    print("PREPARE ADD TO CART");
                                    print(selectedProduct.name);
                                    setAdded(selectedProduct);
                                  }))
                    ],
                  )),
              Container(
                  height: 250.0,
                  child: ListView(
                    padding: EdgeInsets.all(25.0),
                    scrollDirection: Axis.horizontal,
                    children: products.map((product) {
                      return GestureDetector(
                        onTap: () {
                          print("CLICK PRODUCT: ${product.name}");
                          setState(() {
                            selectedProduct = product;
                          });
                        },
                        child: CardImageWithFabIcon(
                            pathImage: product.urlImage,
                            width: 300.0,
                            height: 250.0,
                            left: 20.0,
                            iconData:
                                product.liked ? iconDataLiked : iconDataLike,
                            onPressedFabIcon: () {
                              setLiked(product);
                            },
                            internet: true,
                            isElegance: _isElegance),
                      );
                    }).toList(),
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget titleStars(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(top: 118.0, left: 20.0, right: 20.0, bottom: 20),
          child: Text(
            product.name + ".",
            style: TextStyle(
              fontFamily: "Poppins-ExtraBold",
              color: _isElegance ? darkColor : Colors.white,
              fontSize: 18.0,
              shadows: [
                Shadow(
                  blurRadius: 20.0,
                  color: _isElegance ? lightColor : Colors.black,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            "\$ ${product.price}" + (product.isBulk ? " / Kg" : ""),
            style: TextStyle(
                fontFamily: "Poppins-SemiBold",
                fontSize: 16.0,
                color: _isElegance ? darkColor : Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: new EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Text(
            product.description + ".",
            style: TextStyle(
              fontFamily: "Poppins-Medium",
              color: _isElegance ? Colors.black54 : Colors.white70,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
          child: Text(
            "${product.likes} Me gusta",
            style: TextStyle(
              fontFamily: "Poppins-SemiBold",
              fontSize: 16.0,
              color: _isElegance ? darkColor : Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 20.0,
                  color: _isElegance ? lightColor : Colors.black,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            "En ${product.store}",
            style: TextStyle(
              fontFamily: "Poppins-Medium",
              fontSize: 16.0,
              color: _isElegance ? darkColor : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 60),
          child: Text(
            "${product.category}",
            style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: 16.0,
                color: _isElegance ? Colors.black54 : Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  final star_half = Container(
    margin: EdgeInsets.only(top: 353.0, right: 3.0),
    child: Icon(
      Icons.star_half,
      color: Color(0xFFf2C611),
    ),
  );

  final star_border = Container(
    margin: EdgeInsets.only(top: 353.0, right: 3.0),
    child: Icon(
      Icons.star_border,
      color: Color(0xFFf2C611),
    ),
  );

  final star = Container(
    margin: EdgeInsets.only(top: 353.0, right: 3.0),
    child: Icon(
      Icons.star,
      color: Color(0xFFf2C611),
    ),
  );
}
