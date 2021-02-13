#!/bin/bash

AML_FILE=softfpu.aml

assert_acpiexec_result () {
    echo "Running" $3
    result=`acpiexec -dt -b "$3" $1 2>/dev/null | tail -2 | head -1`
    if [ "$result" == "$2" ]
    then
        return 0
    else
        echo "Test failed for" $3
        echo "    Expected:" $2
        echo "    Got:" $result
        return 1
    fi
}

# Construct float
assert_acpiexec_result \
    $AML_FILE \
    "  [Integer] = 000000003EEF1AA0" \
    "exec \DEV1\MTH1 0 125 7281312"

# ABS positive
assert_acpiexec_result \
    $AML_FILE \
    "  [Integer] = 000000003EEF1AA0" \
    "exec \DEV1\MTH2 0x3EEF1AA0"
# ABS negative
assert_acpiexec_result \
    $AML_FILE \
    "  [Integer] = 000000003EEF1AA0" \
    "exec \DEV1\MTH2 0xBEEF1AA0"

# Infinity positive
assert_acpiexec_result \
    $AML_FILE \
    "  [Integer] = FFFFFFFFFFFFFFFF" \
    "exec \DEV1\MTH4 0x7f800000"
# Infinity negative
assert_acpiexec_result \
    $AML_FILE \
    "  [Integer] = FFFFFFFFFFFFFFFF" \
    "exec \DEV1\MTH4 0xff800000"
# Infinity other
assert_acpiexec_result \
    $AML_FILE \
    "  [Integer] = 0000000000000000" \
    "exec \DEV1\MTH4 0x7f800001"

# Is negative
assert_acpiexec_result \
    $AML_FILE \
    "  [Integer] = 0000000000000000" \
    "exec \DEV1\MTH5 0x7f800001"
# Is positive
assert_acpiexec_result \
    $AML_FILE \
    "  [Integer] = FFFFFFFFFFFFFFFF" \
    "exec \DEV1\MTH5 0xff800001"
