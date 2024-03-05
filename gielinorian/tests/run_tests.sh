#/bin/bash
PACT="${PACT_PATH:-pact}"

# Check if pact is installed
if ! command -v $PACT &> /dev/null; then
    echo "Error: Pact is not installed."
    exit 1
fi

# Find all .repl files in the current directory
REPL_SCRIPTS=$(find ./gielinorian/tests ! -name "gielinorian.repl" -name "*.repl")

for repl in $REPL_SCRIPTS
  do echo "============================================================"
     echo "Running $(grep -oP "[^/]*$" <<< $repl)"
     echo "============================================================"
     ${PACT} $repl 2>&1
     echo ""
done