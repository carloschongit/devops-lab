#!/usr/bin/env bash

# Simulación de ejecución de pipeline
# Este script representa lo que un sistema CI ejecutará automáticamente.
# Aún se ejecuta manualmente en esta fase del laboratorio.

set -Eeuo pipefail

PIPELINE_NAME="DEVOPS-LAB PIPELINE"
RUN_ID=$(date +"%Y%m%d-%H%M%S")
PIPELINE_START_TIME=$(date +%s)
CURRENT_STAGE="INIT"

log() {
  echo "[${PIPELINE_NAME}] [RUN:${RUN_ID}] $1"
}
handle_error() {
local exit_code=$?
echo ""
echo "X PIPELINE FAILED"
echo "Stage: ${CURRENT_STAGE}"
echo "Exit Code: ${exit_code}"
echo "Timestamp: $(date)"
exit $exit_code
}
trap 'handle_error' ERR


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
    
    #Simulacion de test controlado
    echo "Running dummy test..."
    true
    end_stage
}

report() {
    stage "REPORT"
    log "Pipeline completed successfully"
    end_stage
}

main() {
    init
    validate
    build
    test_phase
    report
    PIPELINE_END_TIME=$(date +%s)
    TOTAL_DURATION=$((PIPELINE_END_TIME - PIPELINE_START_TIME))
    log "Total pipeline duration: ${TOTAL_DURATION}s"
}

main "$@"