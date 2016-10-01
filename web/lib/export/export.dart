part of coUservermonitor;

class Export {
	static final FormElement EXPORT_FORM = querySelector('#export-data-form')
		..onSubmit.listen((Event event) {
			event.preventDefault();

			Monitor toExport = MonitorList.MONITORS.singleWhere((Monitor m) {
				return m.url == EXPORT_MONITOR.selectedOptions.single.value;
			});

			CsvExporter.display(toExport.statusHistory);
			ChartExporter.renderChart(toExport.statusHistory);
		});

	static final SelectElement EXPORT_MONITOR = EXPORT_FORM.querySelector('select');

	static void updateExportList() {
		EXPORT_MONITOR.children.clear();

		for (Monitor monitor in MonitorList.MONITORS) {
			EXPORT_MONITOR.append(new OptionElement(value: monitor.url)
				..text = monitor.url);
		}
	}
}