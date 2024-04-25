SRC_PATHS = Sources Tests Package.swift
SWIFT_BUILD = .build

.PHONY: lint
lint:
	swiftlint lint $(SRC_PATHS)
	swift-format lint -s -p -r  $(SRC_PATHS)

.PHONY: format
format:
	swift-format format -i -p -r  $(SRC_PATHS)

clean:
	$(RM) -r $(SWIFT_BUILD)

build:
	swift build -c debug
	
test:
	swift test

all: format lint test build