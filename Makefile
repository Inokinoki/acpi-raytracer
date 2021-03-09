
ppm: ppm.aml
	acpiexec -da -to 3600 -b "exec \DEV2\MTH1" ppm.aml | grep "ACPI Debug" \
		| sed -E "s/ACPI Debug:  \"//" \
		| sed -E 's/0000000000000//g' \
		| sed -E 's/"//' > test.ppm

ppm.aml: ppm.asl
	iasl ppm.asl

tests: test_softfpu
	echo "Test run"

test_softfpu: acpi-softfpu/softfpu.aml test_softfpu.sh
	/bin/sh test_softfpu.sh

acpi-softfpu/softfpu.aml: acpi-softfpu/softfpu.asl
	iasl acpi-softfpu/softfpu.asl
