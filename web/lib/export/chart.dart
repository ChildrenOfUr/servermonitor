part of coUservermonitor;

class ChartExporter {
	static final DivElement CHART_DISPLAY = querySelector('#chart');

	static Future renderChart(List<Status> data) async {
		// Convert to almost-CSV format
		List<List> array = [['Timestamp', 'Player Count', 'Loaded Street Count', 'Memory Usage (GB)', 'CPU Usage (%)']];
		for (Status status in data) {
			array.add([status.timestamp, status.players.length, status.streets.length, status.memoryUsage.gigabytes, status.cpuUsage.percent]);
		}

		Map<String, dynamic> options = {
			'thickness': 2
		};

		gcharts.AnnotationChart chart = new gcharts.AnnotationChart(CHART_DISPLAY);
		gcharts.DataTable table = gcharts.arrayToDataTable(array);
		chart.draw(table, options);

		CHART_DISPLAY.hidden = false;
	}
}