#!/bin/bash

PACT="${PACT_PATH:-pact}"

# Check if pact is installed
if ! $PACT -v; then
    echo "Error: Pact is not installed."
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p ./out
MAIN_LOG="./out/test_output.log"
echo -n "" $MAIN_LOG > /dev/null

# Find all .repl files in the current directory
REPL_SCRIPTS=$(find . ! -name "gielinorian.repl" -name "*.repl" -not -path "./namespaces/*")

passed_tests=0
failed_tests=0

# Run each .repl file test
for repl in $REPL_SCRIPTS; do
    echo "============================================================"
    echo "Running $(basename "$repl")"
    echo "============================================================"
    echo ""

    ${PACT} --trace "$repl" > "$MAIN_LOG" 2>&1

    if grep -q "FAILURE:" "$MAIN_LOG"; then
        echo "There were failures in $(basename "$repl")"

        grep "FAILURE:" "$MAIN_LOG" | while read -r line; do
          echo "------------------------------------------------------------"
          grep "FAILURE" <<< "$line" | awk -F 'FAILURE: ' '{print $2}' | awk -F ':' '{print $1}' | awk -F ' expected' '{print $1 ":"}'
          # Pact v4.x.x
          grep "expected " <<< "$line" | awk -F 'expected ' '{print "Expected: " $2}' | awk -F ', received ' '{print $1 "\nReceived: " $2}'

          # Pact v5.x.x
          line=$(echo "$line" | tr -d '"')
          grep "expected: " <<< "$line" | awk -F 'expected: ' '{print "Expected: " $2}' | awk -F ', received: ' '{print $1 "\nReceived: " $2}'

          echo "------------------------------------------------------------"
          echo ""
        done
    else
        echo "All tests passed in $(basename "$repl")"
        echo ""
    fi
    passed_tests=$((passed_tests + $(grep -c 'Expect: success' $MAIN_LOG)))
    failed_tests=$((failed_tests + $(grep -c 'FAILURE' $MAIN_LOG)))
done

echo "============================================================"
echo "Summary"
echo "============================================================"
echo "Total tests run: $((passed_tests + failed_tests))"
echo "Passed tests: $((passed_tests))"
echo "Failed tests: $((failed_tests))"
echo "============================================================"

# Check if the test failed
if grep -q "Load fail" "$MAIN_LOG"; then
  exit 1
fi