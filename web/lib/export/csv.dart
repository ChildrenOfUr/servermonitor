part of coUservermonitor;

class CsvExporter {
	static final TextAreaElement EXPORT_DISPLAY = Export.EXPORT_FORM.querySelector('textarea');

	static String export(List<Status> history) {
		String csv = '"Timestamp","Player Count","Loaded Street Count","Memory Usage (MB)","CPU Usage (%)"';

		history.sort();

		for (Status status in history) {
			csv += '\n"${status.timestamp}",'
				'"${status.players.length}",'
				'"${status.streets.length}",'
				'"${status.memoryUsage.megabytes}",'
				'"${status.cpuUsage}"';
		}

		return csv;
	}

	static void display(List<Status> data) {
		EXPORT_DISPLAY
			..value = export(data)
			..hidden = false;
	}
}