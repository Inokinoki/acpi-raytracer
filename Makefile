
tests: test_softfpu
	echo "Test run"

test_softfpu: softfpu.aml test_softfpu.sh
	/bin/sh test_softfpu.sh
