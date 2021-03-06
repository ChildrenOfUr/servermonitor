part of coUservermonitor;

abstract class MonitorList {
	static final String _LS_KEY = 'coUservermonitor_urls';

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

	static void saveMonitors() {
		List<String> urls = [];
		MONITORS.forEach((Monitor monitor) => urls.add(monitor.url));
		window.localStorage[_LS_KEY] = JSON.encode(urls);
	}

	static void loadMonitors() {
		List<String> urls = [];
		try {
			urls = JSON.decode(window.localStorage[_LS_KEY]);
		} catch (e) {
			window.console.error('Error loading monitors: $e');
		}

		urls.forEach((String url) {
			addMonitor(url);
		});

		Export.updateExportList();
	}
}