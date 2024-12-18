import 'package:flutter/material.dart';
import 'package:reminder_app/ui/chart_screen/daily_chart.dart';
import '../../app/app_export.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.blackA700,
          leading: IconButton(
            iconSize: 20,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey[500],
            ),
          ),
          title: const Text(
            "Report",
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.insert_chart_outlined_outlined,
                color: Colors.grey[500],
              ),
              onPressed: () {},
            )
          ],
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                DailyChart(),
              ],
            ),
          ),
        ));
  }
}
