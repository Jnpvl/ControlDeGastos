import 'package:flutter/material.dart';
import 'package:money/components/balanceCard.dart';
import 'package:money/components/customAppBar.dart';
import 'package:money/components/movimientoCard.dart';
import 'package:money/components/otherServices.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  int maxCardsToShow = 3;

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: CustomAppBar(
        showTitle: true,
        titleText: 'Inicio',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // ignore: prefer_const_constructors
          BalanceCard(),
          OtherServices(),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  'Actividad reciente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          MovimientosCard(
            maxItems: 4,
            enableDelete: false,
          )
        ],
      ),
    );
  }
}
