DIR = test-dir
MALICIOUS_DIR = quarantine
INTERVAL = 5

.PHONY: all pre-build restore

all: pre-build
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

pre-build:
	mkdir -p $(MALICIOUS_DIR)

restore: pre-build
	./restore.sh $(DIR) $(MALICIOUS_DIR)
