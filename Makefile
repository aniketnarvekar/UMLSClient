# Convert comma-separated UMLSCLIENT_UPCOMING_FEATURES into space-separated flags
SWIFT_FLAGS = $(foreach flag, $(subst ,, $(UMLSCLIENT_UPCOMING_FEATURES)), -Xswiftc -D$(flag))

build:
	swift build $(SWIFT_FLAGS)

test:
	doppler run -- swift test $(SWIFT_FLAGS)

format:
	swift format -i -p -r --color-diagnostics --follow-symlinks .

lint:
	swift format lint -r -p -s --color-diagnostics --follow-symlinks .
