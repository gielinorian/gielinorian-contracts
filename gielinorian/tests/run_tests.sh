#/bin/bash
PACT="${PACT_PATH:-pact}"

# Find all .repl files in the current directory
REPL_SCRIPTS=$(find ./gielinorian/tests ! -name "gielinorian.repl" -name "*.repl")

for repl in $REPL_SCRIPTS
  do echo "============================================================"
     echo "Running $(grep -oP "[^/]*$" <<< $repl)"
     echo "============================================================"
     ${PACT} $repl 2>&1
     echo ""
done