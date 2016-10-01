part of coUservermonitor;

class Uptime implements Data {
	Duration uptime;

	Uptime({this.uptime});

	Uptime.parse(String duration) {
		List<int> places = _getPlaces(duration);
		uptime = new Duration(hours: places[0], minutes: places[1], seconds: places[2]);
	}

	Uptime.fromMap(Map<String, dynamic> encoded) {
		uptime = new Duration(hours: encoded['hours'], minutes: encoded['minutes'], seconds: encoded['seconds']);
	}

	List<int> _getPlaces(String formatted) {
		List<String> places = formatted.split(':');

		int hours = int.parse(places[0]);
		int minutes = int.parse(places[1]);
		int seconds = double.parse(places[2]).toInt();

		return [hours, minutes, seconds];
	}

	@override
	String toString() {
		String string = '';
		List<int> places = _getPlaces(uptime.toString());

		if (places[0] > 0) {
			string += '${places[0]} hour${places[0] == 1 ? '' : 's'} ';
		}

		if (places[1] > 0) {
			string += '${places[1]} minute${places[1] == 1 ? '' : 's'} ';
		}

		if (places[2] > 0) {
			string += '${places[2]} second${places[2] == 1 ? '' : 's'} ';
		}

		return string.trimRight();
	}

	Map<String, dynamic> toMap() {
		List<int> places = _getPlaces(uptime.toString());
		return {
			'hours': places[0],
			'minutes': places[1],
			'seconds': places[2]
		};
	}

	DivElement toElement() =>
		new DivElement()
			..text = 'Uptime: $this';
}