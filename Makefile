build:
	swift build

test:
	doppler run -- swift test

format:
	swift format -i -p -r --color-diagnostics --follow-symlinks .
