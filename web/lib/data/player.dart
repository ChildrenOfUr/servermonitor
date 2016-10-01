part of coUservermonitor;

class Player implements Data {
	String username;

	Player({this.username});

	Player.fromMap(Map<String, dynamic> encoded) {
		this.username = encoded['username'];
	}

	String get profile => 'http://childrenofur.com/profile?username=$username';

	Map<String, dynamic> toMap() => {
		'username': username
	};

	AnchorElement toElement() =>
		new AnchorElement(href: profile)
			..text = username;
}