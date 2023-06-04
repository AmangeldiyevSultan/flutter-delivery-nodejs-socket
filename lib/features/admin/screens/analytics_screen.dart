import 'package:gooddelivary/common/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/sales.dart';
import '../services/admin_services.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    _getEarnings();
  }

  _getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Total earning: \$$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 500, child: _sfCartesianCharts())
            ],
          );
  }

  SfCartesianChart _sfCartesianCharts() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Categories')),
        primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'The price of total sales in dollars')),

        // Chart title
        title: ChartTitle(text: 'Each category sales analysis'),

        // Enable tooltip
        tooltipBehavior: _tooltipBehavior,
        series: <ColumnSeries<Sales, String>>[
          ColumnSeries<Sales, String>(
              dataSource: earnings!,
              xValueMapper: (Sales sales, _) => sales.label,
              yValueMapper: (Sales sales, _) => sales.earning,
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ]);
  }
}
