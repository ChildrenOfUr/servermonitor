part of coUservermonitor;

abstract class Data {
	Data.fromMap(Map<String, dynamic> encoded);

	Map<String, dynamic> toMap();

	Element toElement();
}