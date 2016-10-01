part of coUservermonitor;

class Export {
	static final FormElement EXPORT_FORM = querySelector('#export-data-form');

	static final SelectElement EXPORT_MONITOR = EXPORT_FORM.querySelector('select');

	static void init() {
		window.onKeyDown.listen((KeyboardEvent event) {
			if (event.keyCode == 27) {
				// Escape
				ChartExporter.CHART_DISPLAY.hidden = true;
				CsvExporter.EXPORT_DISPLAY.hidden = true;
			}
		});

		EXPORT_FORM.onSubmit.listen((Event event) {
			event.preventDefault();

			Monitor toExport = MonitorList.getMonitor(EXPORT_MONITOR.selectedOptions.single.value);

			ChartExporter.renderChart(toExport.statusHistory);
			CsvExporter.display(toExport.statusHistory);

			// TODO: remove this test stuff
			Map<String, List<Map<String, dynamic>>> histories = {};
			MonitorList.MONITORS.forEach((Monitor monitor) => histories.addAll({monitor.url: monitor.encodeHistory()}));
			print(histories);
			print(JSON.encode(histories));
		});
	}

	static void updateExportList() {
		EXPORT_MONITOR.children.clear();

		for (Monitor monitor in MonitorList.MONITORS) {
			EXPORT_MONITOR.append(new OptionElement(value: monitor.url)
				..text = monitor.url);
		}
	}
}