import 'package:flutter/material.dart';
import '../../helpers/card_colors.dart';
import '../widgets/card/chip.dart';
import '../../blocs/card_bloc.dart';
import '../../blocs/bloc_provider.dart';

class CardFront extends StatelessWidget{
  final int rotatedTurnsValue;
  CardFront({this.rotatedTurnsValue});

  @override
  Widget build(BuildContext context) {
    final CardBloc bloc = BlocProvider.of<CardBloc>(context);

    final _cardNumber = Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<String>(
            stream: bloc.number,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? _formatCardNumber(snapshot.data)
                  : _formatCardNumber('0000000000000000');
            },
          ),
        ],
      ),
    );

    final _cardLastNumber = Padding(
        padding: const EdgeInsets.only(top: 0.0, left: 28.0),
        child: StreamBuilder<String>(
          stream: bloc.number,
          builder: (context, snapshot) {
            return Text(
              snapshot.hasData && snapshot.data.length >= 15
                  ? snapshot.data
                      .replaceAll(RegExp(r'\s+\b|\b\s'), '')
                      .substring(12)
                  : '0000',
              style: TextStyle(color: Colors.white, fontSize: 8.0,
                fontFamily: "Poppins-Regular"),
            );
          },
        ));

    final _cardValidThru = Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'VENCE',
                style: TextStyle(color: Colors.white,
                  fontSize: 6.0,
                  fontFamily: "Poppins-Medium"),
              ),
              Text(
                'FIN DE',
                style: TextStyle(color: Colors.white,
                  fontSize: 6.0,
                  fontFamily: "Poppins-Medium"),
              )
            ],
          ),
          SizedBox(
            width: 5.0,
          ),
          StreamBuilder(
            stream: bloc.month,
            builder: (context, snapshot) {
              return Text(
                snapshot.hasData ? snapshot.data : '00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              );
            },
          ),
          StreamBuilder<String>(
              stream: bloc.year,
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData && snapshot.data.length > 2
                      ? '/${snapshot.data.substring(2)}'
                      : '/00',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                );
              })
        ],
      ),
    );

    final _cardOwner = Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 28.0),
      child: StreamBuilder(
        stream: bloc.name,
        builder: (context, snapshot) => Text(
              snapshot?.data ?? 'NOMBRE DEL TITULAR',
              style: TextStyle(color: Colors.white, fontSize: 18.0,
                fontFamily: "Poppins-Regular"),
            ),
      ),
    );

    final _cardLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 30.0),
          child: Image(
            image: AssetImage('assets/images/visa_logo.png'),
            width: 65.0,
            height: 32.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: StreamBuilder(
              stream: bloc.type,
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData ? snapshot.data : '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    fontFamily: "Poppins-Medium",),
                );
              }),
        ),
      ],
    );

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<int>(
        stream: bloc.colorIndexSelected,
        initialData: 0,
        builder: (context, snapshopt) {
          return Stack(
            children: <Widget>[
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                        colors: [
                          CardColor.baseColors[snapshopt.data],
                          CardColor.baseColors[snapshopt.data]
                        ],
                        begin: FractionalOffset(0.2, 0.0),
                        end: FractionalOffset(1.0, 0.6),
                        stops: [0.0, 0.6],
                        tileMode: TileMode.clamp)),
                child: FittedBox(
                  fit: BoxFit.none,
                  alignment: Alignment(-1.5, -0.8),
                  child: Container(
                    width: screenHeight,
                    height: screenHeight,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        borderRadius: BorderRadius.circular(screenHeight / 2)),
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: rotatedTurnsValue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _cardLogo,
                    CardChip(),
                    _cardNumber,
                    _cardLastNumber,
                    _cardValidThru,
                    _cardOwner,
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget _formatCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    List<Widget> numberList = new List<Widget>();
    var counter = 0;
    for (var i = 0; i < cardNumber.length; i++) {
      counter += 1;
      numberList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Text(
            cardNumber[i],
            style: TextStyle(color: Colors.white, fontSize: 18,
              fontFamily: "Poppins-Regular",),
          ),
        ),
      );
      if (counter == 4) {
        counter = 0;
        numberList.add(SizedBox(width: 18.0));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numberList,
    );
  }

}