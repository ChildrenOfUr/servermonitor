part of coUservermonitor;

class Monitor {
	String url;

	Status currentStatus;

	Timer timer;

	/// 0 = current, 1 = previous, 2 = previous to previous, etc.
	int viewingOffset = 0;
	List<Status> statusHistory = [];

	FieldSetElement _parent = new FieldSetElement()
		..classes = ['monitor'];

	ButtonElement _deleteBtn = new ButtonElement()
		..text = 'x';

	SpanElement _timeDisplay = new SpanElement();

	ButtonElement _prevBtn = new ButtonElement()
		..text = '<'
		..disabled = true;

	ButtonElement _nextBtn = new ButtonElement()
		..text = '>'
		..disabled = true;

	DivElement _content = new DivElement()
		..classes = ['content'];

	Monitor(this.url) {
		_deleteBtn.onClick.listen((_) => _delete());
		_prevBtn.onClick.listen((_) => _prevRecord());
		_nextBtn.onClick.listen((_) => _nextRecord());

		_parent
			..append(new SpanElement()..text = url)
			..append(new DivElement()
				..classes = ['button-set']
				..append(_deleteBtn))
			..append(new HRElement())
			..append(_content)
			..append(new HRElement())
			..append(_timeDisplay)
			..append(new DivElement()
				..classes = ['button-set']
				..append(_prevBtn)
				..append(_nextBtn));

		_update().then((bool success) {
			if (success) {
				resetTimer();
			} else {
				_content.text = 'Error updating, so not doing it again. Refresh to retry.';
			}
		});
	}

	void resetTimer() {
		timer?.cancel();
		timer = new Timer.periodic(new Duration(seconds: MonitorList.refreshInterval), (_) async {
			await _update();
		});
	}

	Future<bool> _update() async {
		try {
			String json = await HttpRequest.getString(url);
			currentStatus = new Status.parse(json);
			statusHistory
				..add(currentStatus)
				..sort((Status a, Status b) => b.compareTo(a)); // newest at index 0

			if (viewingOffset == 0) {
				_displayRecord(currentStatus);

				if (statusHistory.length == 2) {
					_prevBtn.disabled  = false;
				}
			}

			return true;
		} catch (e) {
			print('Error updating $url: $e');
			return false;
		}
	}

	void _displayRecord(Status status) {
		_timeDisplay.text = status.timestamp.toString();
		_content
			..children.clear()
			..append(status.playerDisplay)
			..append(status.streetDisplay)
			..append(status.memoryUsage.toElement())
			..append(status.cpuUsage.toElement())
			..append(status.uptime.toElement());
	}

	void _nextRecord() {
		_displayRecord(statusHistory[--viewingOffset]);
		_prevBtn.disabled = false;

		if (viewingOffset <= 0) {
			_nextBtn.disabled = true;
		}
	}

	void _prevRecord() {
		_displayRecord(statusHistory[++viewingOffset]);
		_nextBtn.disabled = false;

		if (viewingOffset >= statusHistory.length - 1) {
			_prevBtn.disabled = true;
		}
	}

	void _delete() {
		_parent.remove();
		MonitorList.MONITORS.remove(this);
		MonitorList.updateExportList();
	}

	Element get element => _parent;
}