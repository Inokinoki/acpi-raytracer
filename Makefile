
all: ppm.aml ray.aml acpi-softfpu/softfpu.aml vector.aml

ppm: ppm.aml ray.aml acpi-softfpu/softfpu.aml vector.aml
	acpiexec -da -to 3600 -b "exec \PPM\TEST" ppm.aml ray.aml acpi-softfpu/softfpu.aml vector.aml | grep "ACPI Debug" \
		| sed -E "s/ACPI Debug:  \"//" \
		| sed -E 's/0000000000000//g' \
		| sed -E 's/"//' > test.ppm

ray.aml: ray.asl
	iasl ray.asl

vector.aml: vector.asl
	iasl vector.asl

ppm.aml: ppm.asl
	iasl ppm.asl

tests: test_softfpu
	echo "Test run"

test_softfpu: acpi-softfpu/softfpu.aml test_softfpu.sh
	/bin/sh test_softfpu.sh

acpi-softfpu/softfpu.aml: acpi-softfpu/softfpu.asl
	iasl acpi-softfpu/softfpu.asl
