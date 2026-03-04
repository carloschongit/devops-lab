#!/usr/bin/env bash

# Simulación de ejecución de pipeline
# Este script representa lo que un sistema CI ejecutará automáticamente.
# Aún se ejecuta manualmente en esta fase del laboratorio.

set -Euo pipefail

PIPELINE_NAME="DEVOPS-LAB PIPELINE"
RUN_ID=$(date +"%Y%m%d-%H%M%S")

LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/pipeline-${RUN_ID}.log"

mkdir -p "${LOG_DIR}"

exec > >(tee -a "${LOG_FILE}") 2>&1

PIPELINE_STATUS="SUCCESS"
PIPELINE_START_TIME=$(date +%s)
CURRENT_STAGE="INIT"

log() {
  echo "[${PIPELINE_NAME}] [RUN:${RUN_ID}] $1"
}
handle_error() {
local exit_code=$1

PIPELINE_STATUS="FAILED"
PIPELINE_EXIT_CODE="${exit_code}"

echo ""
echo "X PIPELINE FAILED"
echo "Stage: ${CURRENT_STAGE}"
echo "Exit Code: ${exit_code}"
echo "Timestamp: $(date)"
}
trap 'handle_error $?' ERR


stage() {
    STAGE_NAME="$1"
    CURRENT_STAGE="$STAGE_NAME"
    STAGE_START_TIME=$(date +%s)
    log "========== STAGE: ${STAGE_NAME} =========="
}

end_stage() {
    local STAGE_END_TIME
    local DURATION

    if [[ -z "${STAGE_START_TIME:-}" ]]; then 
        log "Stage start time not set"
        exit 1
    fi 
    STAGE_END_TIME=$(date +%s)
    DURATION=$((STAGE_END_TIME - STAGE_START_TIME))

    log "Stage ${CURRENT_STAGE} duration: ${DURATION}s"
}

init() {
    stage "INIT"
    log "Preparing execution environment"
    pwd
    end_stage
} 

validate()  {
    stage "VALIDATE"
    log "Running repository validation checks"
    test -f docker/Dockerfile
    test -f README.md
    end_stage
}

build() {
    stage "BUILD"
    log "Simulating container build"
    echo "docker build would run here"
    end_stage
}

test_phase() {
    stage "TEST"
    log "Simulating validation test"
    echo "Running dummy test..."
    false
    end_stage
}

report() {
    stage "REPORT"

    if [[ "${PIPELINE_STATUS}" == "SUCCESS" ]]; then
        log "Pipeline completed successfully"
    else 
        log "Pipeline finished with errors"
    fi

    log "Final Status: ${PIPELINE_STATUS}"
    log "Log File: ${LOG_FILE}"

    end_stage
}

main() {
    init
    validate
    build
    test_phase
    
    PIPELINE_END_TIME=$(date +%s)
    TOTAL_DURATION=$((PIPELINE_END_TIME - PIPELINE_START_TIME))

    report
    log "Total pipeline duration: ${TOTAL_DURATION}s"

    if [[ "${PIPELINE_STATUS}" == "FAILED" ]]; then
        exit "${PIPELINE_EXIT_CODE}"
    fi
}

main "$@"