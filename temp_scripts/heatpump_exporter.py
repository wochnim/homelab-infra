sysdev@tf-test-01:~$ cat heatpump_exporter.py
#!/usr/bin/env python3

import time
from prometheus_client import start_http_server
from prometheus_client.core import (
    GaugeMetricFamily,
    CollectorRegistry,
)

DATA_FILE = "/home/sysdev/heatpump_data_latest.txt"
EXPORTER_PORT = 9105

# ---------- ENUM MAP ----------

ENUM_MAP = {
    "AM002": {"No silent mode": 0, "Silent mode level 1": 1},
    "AM015": {"Active": 1},
    "AM037": {"CH": 1},
    "AM091": {"Frost protection": 1},
    "CM050": {"Yes": 1},
    "CM120": {"Off": 0, "Scheduling": 1},
    "CM140": {"No": 0},
    "CM150": {"No": 0, "Yes": 1},
    "DM007": {"Off": 0},
    "HM004": {"Closed": 0},
    "HM005": {"Closed": 0},
    "HM007": {"No": 0},
    "HM008": {"Off": 0, "On": 1},
    "HM009": {"No": 0, "Yes": 1},
    "HM012": {"Off": 0},
    "HM013": {"Off": 0},
    "HM014": {"Standby": 0},
    "HM030": {"No": 0, "Yes": 1},
}

DEFAULT_ENUM = 2

# ---------- COLLECTOR ----------

class HeatpumpCollector:
    def collect(self):
        metric = GaugeMetricFamily(
            "heatpump_value",
            "Heat pump values",
            labels=["code", "description"]
        )

        try:
            with open(DATA_FILE, encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line or ";" not in line:
                        continue

                    left, raw = line.split(";", 1)
                    raw = raw.strip()

                    # skip missing values
                    if raw == "--":
                        continue

                    code = left.split(" ")[0]
                    desc = left[left.find("(")+1:left.find(")")]

                    value = self.parse_value(code, raw)

                    metric.add_metric(
                        [code, desc],
                        value
                    )

        except Exception as e:
            # exporter must NEVER crash
            return

        yield metric

    def parse_value(self, code, raw):
        if code in ENUM_MAP:
            return ENUM_MAP[code].get(raw, DEFAULT_ENUM)

        try:
            return float(raw)
        except ValueError:
            return DEFAULT_ENUM


# ---------- MAIN ----------

if __name__ == "__main__":
    registry = CollectorRegistry()
    registry.register(HeatpumpCollector())

    start_http_server(EXPORTER_PORT, registry=registry)
    print(f"Heatpump exporter listening on :{EXPORTER_PORT}")

    while True:
        time.sleep(60)
