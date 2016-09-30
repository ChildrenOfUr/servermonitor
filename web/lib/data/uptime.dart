part of coUservermonitor;

class Uptime implements Data {
	Duration uptime;

	Uptime({this.uptime});

	Uptime.parse(String duration) {
		List<String> places = duration.split(':');

		int hours = int.parse(places[0]);
		int minutes = int.parse(places[1]);
		int seconds = int.parse(places[2]);

		uptime = new Duration(hours: hours, minutes: minutes, seconds: seconds);
	}

	@override
	String toString() {
		String string = '';
		List<String> places = uptime.toString().split(':');

		int hours = double.parse(places[0]).toInt();
		int minutes = double.parse(places[1]).toInt();
		int seconds = double.parse(places[2]).toInt();

		if (hours > 0) {
			string += '${hours} hour${hours == 1 ? '' : 's'} ';
		}

		if (minutes > 0) {
			string += '${minutes} minute${minutes == 1 ? '' : 's'} ';
		}

		if (seconds > 0) {
			string += '${seconds} second${seconds == 1 ? '' : 's'} ';
		}

		return string.trimRight();
	}

	DivElement toElement() =>
		new DivElement()
			..text = 'Uptime: $this';
}