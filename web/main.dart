library coUservermonitor;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:google_charts/google_charts.dart' as gcharts;

part 'lib/list.dart';
part 'lib/monitor.dart';

part 'lib/data/cpu.dart';
part 'lib/data/data.dart';
part 'lib/data/datasize.dart';
part 'lib/data/player.dart';
part 'lib/data/status.dart';
part 'lib/data/street.dart';
part 'lib/data/uptime.dart';

part 'lib/export/chart.dart';
part 'lib/export/csv.dart';
part 'lib/export/export.dart';

Future main() async {
	// Persist monitor list
	window.onLoad.listen((_) => MonitorList.loadMonitors());
	window.onBeforeUnload.listen((_) => MonitorList.saveMonitors());

	// Register event handlers
	MonitorList.init();
	CsvExporter.init();

	// Download chart renderer
	await gcharts.AnnotationChart.load();
}