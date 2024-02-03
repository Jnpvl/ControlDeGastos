import 'package:flutter/material.dart';
import 'package:money/components/customAppBar.dart';
import 'package:money/components/movimientoCard.dart';

class BalanceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: CustomAppBar(
        showTitle: true,
        titleText: 'Movimientos',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [MovimientosCard()],
      ),
    );
  }
}
