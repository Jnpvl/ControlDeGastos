import 'package:flutter/material.dart';
import 'package:money/components/customAlert.dart';
import 'package:money/views/categoriasView.dart';

class OtherServices extends StatelessWidget {
  OtherServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 160,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Otros servicios',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ServiceButton(
                  icon: Icons.add_chart,
                  label: 'Agregar categoría',
                  color: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoriasView()),
                    );
                  },
                ),
                ServiceButton(
                  icon: Icons.pie_chart_outline,
                  label: 'presupuesto',
                  color: Colors.blue,
                  onTap: () {
                    CustomAlert.showInfoDialog(
                      context: context,
                      title: 'No disponible',
                      message:
                          'Funcionalidad no disponible, gracias por su comprension',
                    );
                  },
                ),
                ServiceButton(
                    icon: Icons.bar_chart,
                    label: 'análisis',
                    color: Colors.purple,
                    onTap: () {
                      CustomAlert.showInfoDialog(
                        context: context,
                        title: 'No disponible',
                        message:
                            'Funcionalidad no disponible, gracias por su comprension',
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const ServiceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            Text(label,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
