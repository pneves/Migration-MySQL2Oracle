#!/bin/bash
set -euo pipefail

export NLS_LANG=.AL32UTF8
ORACLE_USER="GruposDedicadasPRD"
ORACLE_PASS="oppass"
ORACLE_CONN="host:1521/service_name"
CONN="${ORACLE_USER}/${ORACLE_PASS}@${ORACLE_CONN}"

DDL_DIR="./ddl"
CTL_DIR="./ctl"
LOG_DIR="./logs"
CSV_DIR="./csv"

mkdir -p "$LOG_DIR"
mkdir -p "$CSV_DIR"

echo "== Extraindo CSVs =="

for archive in *.tar.gz; do
    if [[ -f "$archive" ]]; then
        echo "Extraindo $archive ..."
        tar -xzf "$archive" -C "$CSV_DIR" --strip-components=1
    else
        echo "Arquivo não encontrado: $archive"
    fi
done

TABLE="${1:-}"

run_sql() {
    local file="$1"
    echo "== Executando $file =="
    sqlplus -s "$CONN" <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE
@"$file"
EXIT
EOF
}

load_one() {
    local table="$1"

    if [[ ! -f "$CTL_DIR/${table}.ctl" ]]; then
        echo "CTL não encontrado: $CTL_DIR/${table}.ctl"
        exit 1
    fi

    echo "== Carregando $table =="

    sqlldr "$CONN" \
        control="$CTL_DIR/${table}.ctl" \
        log="$LOG_DIR/${table}.log" \
        bad="$LOG_DIR/${table}.bad" \
        discard="$LOG_DIR/${table}.dsc" \
        direct=false \
        errors=100000 \
        readsize=20971520 \
        bindsize=20971520 \
        rows=1000
}

if [[ -n "$TABLE" ]]; then
    load_one "$TABLE"
    exit 0
fi

run_sql "$DDL_DIR/01_tables.sql"
run_sql "$DDL_DIR/02_primary_unique_constraints.sql"

for ctl in "$CTL_DIR"/*.ctl; do
    table=$(basename "$ctl" .ctl)

    case "${table^^}" in
        ACTIVITYLOG|TASKEXECUTION|RAWINGESTEVENT)
            echo "Pulando carga de dados da tabela $table"
            continue
            ;;
    esac

    load_one "$table"
done

run_sql "$DDL_DIR/03_foreign_keys.sql"
run_sql "$DDL_DIR/04_indexes.sql"
run_sql "$DDL_DIR/05_views.sql"
run_sql "$DDL_DIR/06_stats.sql"

echo "Migração concluída."
