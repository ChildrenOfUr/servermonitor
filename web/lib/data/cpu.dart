part of coUservermonitor;

class CpuUsage implements Data {
	double percent;

	CpuUsage({this.percent: 0.0});

	@override
	String toString() => '$percent%';

	DivElement toElement() =>
		new DivElement()
			..appendText('CPU usage: ')
			..append(new ProgressElement()
				..max = 100
				..value = percent)
			..appendText(' $this');
}