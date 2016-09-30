part of coUservermonitor;

abstract class MonitorList {
	static final List<Monitor> MONITORS = [];

	static final Element CONTAINER = querySelector('main');

	static final FormElement ADD_FORM = querySelector('#add-server-form');
	static final UrlInputElement ADD_URL = ADD_FORM.querySelector('input');

	static final FormElement EXPORT_FORM = querySelector('#export-data-form');
	static final TextAreaElement EXPORT_DISPLAY = EXPORT_FORM.querySelector('textarea');
	static final SelectElement EXPORT_MONITOR = EXPORT_FORM.querySelector('select');

	static final RangeInputElement INTERVAL_SLIDER = querySelector('#interval-form input');
	static final OutputElement INTERVAL_DISPLAY = querySelector('#interval-form output');

	static final String _LS_KEY = 'coUservermonitor_urls';

	static int get refreshInterval => INTERVAL_SLIDER.valueAsNumber.toInt();

	static void addMonitor(String url) {
		Monitor monitor = new Monitor(url);
		MONITORS.add(monitor);
		CONTAINER.append(monitor.element);
		updateExportList();
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

		updateExportList();
	}

	static void updateExportList() {
		EXPORT_MONITOR.children.clear();

		for (Monitor monitor in MONITORS) {
			EXPORT_MONITOR.append(new OptionElement(value: monitor.url)
				..text = monitor.url);
		}
	}
}