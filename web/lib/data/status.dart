part of coUservermonitor;

class Status implements Comparable<Status> {
	DateTime timestamp;

	List<Player> players = [];
	List<Street> streets = [];

	DataSize memoryUsage = new DataSize();
	CpuUsage cpuUsage = new CpuUsage();

	Uptime uptime = new Uptime();

	Status({this.timestamp, this.players, this.streets, this.memoryUsage, this.cpuUsage, this.uptime}) {
		if (timestamp == null) {
			timestamp = new DateTime.now();
		}
	}

	Status.parse(dynamic data) {
		timestamp = new DateTime.now();

		if (data is String) {
			data = JSON.decode(data);
		}

		if (data is Map) {
			for (String username in data['playerList']) {
				players.add(new Player(username: username));
			}

			for (Map<String, String> street in data['streetsLoaded']) {
				streets.add(new Street(label: street['label'], tsid: street['tsid']));
			}

			memoryUsage = new DataSize(label: 'RAM usage', bytes: data['bytesUsed']);
			cpuUsage = new CpuUsage(percent: data['cpuUsed']);
			uptime = new Uptime.parse(data['uptime']);
		} else {
			throw new ArgumentError('Can only parse Status from String or Map, not ${data.runtimeType}');
		}
	}

	UListElement get playerDisplay => _bulletList(players, 'online player')
		..classes.add('player-list');

	UListElement get streetDisplay => _bulletList(streets, 'loaded street')
		..classes.add('street-list');

	UListElement _bulletList(List<Data> items, [String itemType]) {
		UListElement list = new UListElement()
			..classes = ['status-list'];

		if (itemType != null) {
			list.append(new LIElement()
				..text = '${items.length} $itemType${items.length == 1 ? '' : 's'}');
		}

		for (Data point in items) {
			list.append(new LIElement()
				..append(point.toElement()));
		}

		return list;
	}

	int compareTo(Status other) {
		return timestamp.compareTo(other.timestamp);
	}
}