library coUservermonitor;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

part 'lib/list.dart';
part 'lib/monitor.dart';

part 'lib/data/cpu.dart';
part 'lib/data/data.dart';
part 'lib/data/datasize.dart';
part 'lib/data/player.dart';
part 'lib/data/status.dart';
part 'lib/data/street.dart';
part 'lib/data/uptime.dart';

part 'lib/export/csv.dart';

void main() {
	window.onLoad.listen((_) => MonitorList.loadMonitors());
	window.onBeforeUnload.listen((_) => MonitorList.saveMonitors());

	MonitorList.ADD_FORM.onSubmit.listen((Event event) {
		event.preventDefault();
		MonitorList.addMonitor(MonitorList.ADD_URL.value.trim());
	});

	MonitorList.EXPORT_FORM.onSubmit.listen((Event event) {
		event.preventDefault();
		Monitor toExport = MonitorList.MONITORS.singleWhere((Monitor m) {
			return m.url == MonitorList.EXPORT_MONITOR.selectedOptions.single.value;
		});
		MonitorList.EXPORT_DISPLAY
			..value = CsvExporter.export(toExport.statusHistory)
			..hidden = false;
	});

	MonitorList.EXPORT_DISPLAY.onContextMenu.listen((Event event) {
		event.preventDefault();
		MonitorList.EXPORT_DISPLAY.hidden = true;
	});

	MonitorList.INTERVAL_SLIDER.onChange.listen((_) {
		MonitorList.INTERVAL_DISPLAY.value =
			'${MonitorList.refreshInterval} second${MonitorList.refreshInterval == 1 ? '' : 's'}';

		MonitorList.MONITORS.forEach((Monitor monitor) => monitor.resetTimer());
	});
}