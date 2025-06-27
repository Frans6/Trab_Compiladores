#!/bin/bash

if [ -x "scripts/run_tests.sh" ]; then
    exec scripts/run_tests.sh "$@"
else
    echo "Erro: scripts/run_tests.sh não encontrado ou não executável"
    exit 1
fi 