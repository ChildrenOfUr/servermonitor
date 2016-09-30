part of coUservermonitor;

class CsvExporter {
	static String export(List<Status> history) {
		String csv = '"Timestamp","Player Count","Loaded Street Count","Memory Usage (bytes)","CPU Usage (%)"';

		for (Status status in history) {
			csv += '\n"${status.timestamp}",'
				'"${status.players.length}",'
				'"${status.streets.length}",'
				'"${status.memoryUsage.bytes}",'
				'"${status.cpuUsage}"';
		}

		return csv;
	}
}