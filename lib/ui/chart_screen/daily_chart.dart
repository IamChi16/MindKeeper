import 'package:flutter/material.dart';
import 'package:reminder_app/app/app_export.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DailyChart extends StatefulWidget {
  const DailyChart({super.key});

  @override
  State<DailyChart> createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  final DatabaseService _databaseService = DatabaseService();

  Future<int> _calculateCompletedPercentage() async {
    // Replace with your actual logic to get the total and completed tasks
    int totalTasks = await _databaseService.countTotalTasks();
    int completedTasks = await _databaseService.countCompletedTasks();
    if (totalTasks == 0) return 0;
    return (completedTasks / totalTasks * 100).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appTheme.blackA700,
      surfaceTintColor: appTheme.blackA700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(10 * 1.5),
        child: Column(
          children: [
            Container(
              height: 250,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme.blackA700,
              ),
              child: StreamBuilder(
                stream: Stream.fromFuture(_calculateCompletedPercentage()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SfRadialGauge(
                      axes: [
                        RadialAxis(
                          pointers: [
                            RangePointer(
                              value: snapshot.hasData
                                  ? snapshot.data!.toDouble()
                                  : 0,
                              width: 35,
                              cornerStyle: CornerStyle.bothCurve,
                              gradient: SweepGradient(colors: [
                                appTheme.indigo30001,
                                appTheme.indigo20001
                              ], stops: const [
                                0.1,
                                0.75
                              ]),
                            ),
                          ],
                          axisLineStyle: AxisLineStyle(
                            thickness: 35,
                            color: appTheme.gray40001,
                          ),
                          startAngle: 5,
                          endAngle: 5,
                          showLabels: false,
                          showTicks: false,
                          annotations: [
                            GaugeAnnotation(
                              widget: Text(
                                '${snapshot.data}%',
                                style: appStyle(
                                    30, appTheme.blue900, FontWeight.bold),
                              ),
                              angle: 270,
                            )
                          ],
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Task Completed",
              style: appStyle(20, appTheme.whiteA700, FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: appTheme.indigo20001,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Completed",
                          style:
                              appStyle(14, appTheme.whiteA700, FontWeight.w600),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: appTheme.gray400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Total tasks",
                          style:
                              appStyle(14, appTheme.whiteA700, FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
