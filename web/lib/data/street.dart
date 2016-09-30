part of coUservermonitor;

class Street implements Data {
	String label;
	String tsid;

	Street({this.label, this.tsid});

	String get encyclopedia => 'http://childrenofur.com/encyclopedia/#/street/$tsidL';

	String get tsidL {
		if (tsid.startsWith('L')) {
			return tsid;
		} else {
			return tsid.replaceFirst('G', 'L');
		}
	}

	String get tsidG {
		return tsidL.replaceFirst('L', 'G');
	}

	AnchorElement toElement() =>
		new AnchorElement(href: encyclopedia)
			..text = label
			..title = tsid;
}
