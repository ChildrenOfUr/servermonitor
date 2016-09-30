part of coUservermonitor;

class Player implements Data {
	String username;

	Player({this.username});

	String get profile => 'http://childrenofur.com/profile?username=$username';

	AnchorElement toElement() =>
		new AnchorElement(href: profile)
			..text = username;
}