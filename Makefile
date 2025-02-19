build:
	swift build

test:
	doppler run -- swift test

format:
	swift format -i -p -r --color-diagnostics --follow-symlinks .

lint:
	swift format lint -r -p -s --color-diagnostics --follow-symlinks .
