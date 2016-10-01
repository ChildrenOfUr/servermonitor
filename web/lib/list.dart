part of coUservermonitor;

abstract class MonitorList {
	static final String _LS_KEY = 'coUservermonitor_urls';
	static final String _LS_COLLECTED = 'coUservermonitor_data';

	static final List<Monitor> MONITORS = [];

	static final Element CONTAINER = querySelector('main');

	static final FormElement ADD_FORM = querySelector('#add-server-form');
	static final UrlInputElement ADD_URL = ADD_FORM.querySelector('input');

	static final RangeInputElement INTERVAL_SLIDER = querySelector('#interval-form input');
	static final OutputElement INTERVAL_DISPLAY = querySelector('#interval-form output');

	static int get refreshInterval => INTERVAL_SLIDER.valueAsNumber.toInt();

	static void init() {
		ADD_FORM.onSubmit.listen((Event event) {
			event.preventDefault();
			MonitorList.addMonitor(MonitorList.ADD_URL.value.trim());
		});

		INTERVAL_SLIDER.onChange.listen((_) {
			MonitorList.INTERVAL_DISPLAY.value =
			'${MonitorList.refreshInterval} second${MonitorList.refreshInterval == 1 ? '' : 's'}';

			MonitorList.MONITORS.forEach((Monitor monitor) => monitor.resetTimer());
		});
	}

	static void addMonitor(String url) {
		Monitor monitor = new Monitor(url);
		MONITORS.add(monitor);
		CONTAINER.append(monitor.element);
		Export.updateExportList();
	}

	static Monitor getMonitor(String url) {
		try {
			return MONITORS.singleWhere((Monitor m) => m.url == url);
		} catch (_) {
			return null;
		}
	}

	static void saveMonitors() {
		// Save URLs
		List<String> urls = [];
		MONITORS.forEach((Monitor monitor) => urls.add(monitor.url));
		window.localStorage[_LS_KEY] = JSON.encode(urls);

		// Save monitor data
		Map<String, List<Map<String, dynamic>>> histories = {};
		MONITORS.forEach((Monitor monitor) => histories.addAll({monitor.url: monitor.encodeHistory()}));
		window.localStorage[_LS_COLLECTED] = JSON.encode(histories);
	}

	static void loadMonitors() {
		// Load URLs
		try {
			if (window.localStorage[_LS_KEY] == null) {
				return;
			}

			List<String> urls = JSON.decode(window.localStorage[_LS_KEY]);
			urls.forEach((String url) {
				addMonitor(url);
			});
			Export.updateExportList();
		} catch (e) {
			window.console.error('Error loading monitors: $e');
		}

		// Load monitor data
		try {
			if (window.localStorage[_LS_COLLECTED] == null) {
				return;
			}

			Map<String, List<Map<String, dynamic>>> histories = JSON.decode(window.localStorage[_LS_COLLECTED]);
			histories.forEach((String url, List<Map<String, dynamic>> history) {
				Monitor monitor = getMonitor(url);
				if (monitor != null) {
					monitor.decodeHistory(history);
				}
			});
		} catch (e) {
			window.console.error('Error loading monitor data: $e');
		}
	}
}