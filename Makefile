
ppm: ppm.aml
	acpiexec -da -to 3600 -b "exec \PPM\TEST" ppm.aml | grep "ACPI Debug" \
		| sed -E "s/ACPI Debug:  \"//" \
		| sed -E 's/0000000000000//g' \
		| sed -E 's/"//' > test.ppm

tests: test_softfpu
	echo "Test run"

test_softfpu: softfpu.aml test_softfpu.sh
	/bin/sh test_softfpu.sh
