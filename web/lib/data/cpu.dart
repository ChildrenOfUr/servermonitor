part of coUservermonitor;

class CpuUsage implements Data {
	double percent;

	CpuUsage({this.percent: 0.0});

	CpuUsage.fromMap(Map<String, dynamic> encoded) {
		this.percent = encoded['percent'] ?? 0.0;
	}

	@override
	String toString() => '$percent%';

	Map<String, dynamic> toMap() => {
		'percent': percent
	};

	DivElement toElement() =>
		new DivElement()
			..appendText('CPU usage: ')
			..append(new ProgressElement()
				..max = 100
				..value = percent)
			..appendText(' $this');
}