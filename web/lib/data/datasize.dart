part of coUservermonitor;

class DataSize implements Data {
	String label;
	int bytes;

	DataSize({this.label, this.bytes: 0});

	int get kilobytes => bytes ~/ 1000;

	int get megabytes => kilobytes ~/ 1000;

	double get gigabytes => megabytes / 1000;

	String get autoUnit {
		if (gigabytes >= 1) {
			return '$gigabytes GB';
		} else if (megabytes >= 1) {
			return '$megabytes MB';
		} else {
			return '$kilobytes KB';
		}
	}

	@override
	String toString() => autoUnit;

	DivElement toElement() => new DivElement()
		..text = '${label != null ? '$label: ' : ''} $this';
}