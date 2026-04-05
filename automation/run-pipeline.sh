#!/usr/bin/env bash

# Simulación de ejecución de pipeline
# Este script representa lo que un sistema CI ejecutará automáticamente.
# Aún se ejecuta manualmente en esta fase del laboratorio.

set -Euo pipefail

PIPELINE_NAME="DEVOPS-LAB PIPELINE"
RUN_ID=$(date +"%Y%m%d-%H%M%S")

LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/pipeline-${RUN_ID}.log"

ARTIFACT_DIR="artifacts"
ARTIFACT_FILE="${ARTIFACT_DIR}/pipeline-${RUN_ID}.json"

mkdir -p "${LOG_DIR}"
mkdir -p "${ARTIFACT_DIR}"

exec > >(tee -a "${LOG_FILE}") 2>&1

PIPELINE_STATUS="SUCCESS"
PIPELINE_START_TIME=$(date +%s)
CURRENT_STAGE="INIT"

#DevOps Logs color
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

#Colores estilo CI
COLOR_INFO="\033[1;34m"
COLOR_WARN="\033[1;33m"
COLOR_ERROR="\033[1;31m"
COLOR_RESET="\033[0m"

#Registro de duracion de stages
declare -A STAGE_DURATIONS
declare -A STAGE_STATUS

log() {
    local LEVEL="$1"
    local MESSAGE="$2"

    local TIMESTAMP
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    case "$LEVEL" in
        INFO)
        COLOR=$COLOR_INFO
        ;;
        WARN)
        COLOR=$COLOR_WARN
        ;;
        ERROR)
        COLOR=$COLOR_ERROR
        ;;
        *)
        COLOR=$COLOR_RESET
        ;;
    esac

    echo -e "${COLOR}[${TIMESTAMP}] [${LEVEL}] [${PIPELINE_NAME}] [RUN:${RUN_ID}] ${MESSAGE}${COLOR_RESET}"
}

handle_error() {
local exit_code=$1

PIPELINE_STATUS="FAILED"
PIPELINE_EXIT_CODE="${exit_code}"

STAGE_STATUS["${CURRENT_STAGE}"]="FAILED"

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
   echo -e "${CYAN}========== STAGE: ${STAGE_NAME} ==========${RESET}"
}

end_stage() {
    local STAGE_END_TIME
    local DURATION

    if [[ -z "${STAGE_START_TIME:-}" ]]; then 
        log ERROR "Stage start time not set"
        exit 1
    fi 

    STAGE_END_TIME=$(date +%s)
    DURATION=$((STAGE_END_TIME - STAGE_START_TIME))

    STAGE_DURATIONS["${CURRENT_STAGE}"]=$DURATION

    if [[ "$CURRENT_STAGE" == "REPORT" ]]; then
        STAGE_STATUS["${CURRENT_STAGE}"]="SUCCESS"
    elif [[ "${PIPELINE_STATUS}" == "FAILED" ]]; then 
        STAGE_STATUS["${CURRENT_STAGE}"]="FAILED"
    else
        STAGE_STATUS["${CURRENT_STAGE}"]="SUCCESS"
    fi

    log INFO "Stage ${CURRENT_STAGE} duration: ${DURATION}s"
}

init() {
    stage "INIT"
    log INFO "Preparing execution environment"
    sleep 1
    pwd
    end_stage
} 

validate()  {
    stage "VALIDATE"
    log INFO "Running repository validation checks"
    sleep 1
    test -f docker/Dockerfile
    test -f README.md
    end_stage
}

build() {
    stage "BUILD"
    log INFO "Building Docker image"
    docker build -t devops-lab-web ./docker
    sleep 2
    end_stage
}

test_stage() {
    stage "TEST"
    log INFO "Running container validation test"

    CONTAINER_NAME="pipeline-test-container"
    
    # Limpiar si existe previo
    docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

    # Ejecutar contenedor
    docker run -d -p 8081:80 --name "$CONTAINER_NAME" devops-lab-web

    sleep 3
    
    # Validar que esta ocurriendo
    if docker ps | grep -q "$CONTAINER_NAME"; then
        log INFO "Container is running correctly"
    else
        log ERROR "Container faile to start"
        exit 1
    fi
    # Limpieza
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"

    end_stage
}

report() {
    stage "REPORT"

    STAGE_STATUS["REPORT"]="SUCCESS"

    if [[ "${PIPELINE_STATUS}" == "SUCCESS" ]]; then
        log INFO "Pipeline completed successfully"
    else 
        log INFO "Pipeline finished with errors"
    fi

    log INFO "Final Status: ${PIPELINE_STATUS}"
    log INFO "Log File: ${LOG_FILE}"

    generate_artifact > "${ARTIFACT_FILE}"
    log INFO "Artifact File: ${ARTIFACT_FILE}"

    generate_summary
    log INFO "Summary File: ${ARTIFACT_DIR}/pipeline-summary.txt"

    echo ""
    echo "PIPELINE SUMMARY"
    echo "================"

    for stage in INIT VALIDATE BUILD TEST REPORT; do
    status="${STAGE_STATUS[$stage]:-FAILED}"
    duration="${STAGE_DURATIONS[$stage]:-0}"

    if [[ "$status" == "SUCCESS" ]]; then
        printf "%-10s ✔ (%ss)\n" "$stage" "$duration"
    else
        printf "%-10s ✖ (%ss)\n" "$stage" "$duration"
    fi
    done

    echo ""

    STAGE_STATUS["REPORT"]="SUCCESS"

    end_stage
}

generate_artifact() {

    echo "{"
    echo "  \"pipeline_name\": \"${PIPELINE_NAME}\","
    echo "  \"run_id\": \"${RUN_ID}\","
    echo "  \"status\": \"${PIPELINE_STATUS}\","
    echo "  \"total_duration\": ${TOTAL_DURATION},"
    echo "  \"stages\": {"

    stages=(INIT VALIDATE BUILD TEST REPORT)
    for ((i=0; i<${#stages[@]}; i++)); do

        stage="${stages[$i]}"

        status="${STAGE_STATUS[$stage]-}"
        duration="${STAGE_DURATIONS[$stage]-}"

        status=${status:-FAILED}
        duration=${duration:-0}

        if [[ $i -lt $((${#stages[@]} - 1)) ]]; then
            echo "    \"${stage}\": { \"status\": \"${status}\", \"duration\": ${duration} },"
        else
            echo "    \"${stage}\": { \"status\": \"${status}\", \"duration\": ${duration} }"
        fi
        
    done

    echo "  }"
    echo "}"

}

generate_summary() {
    
    SUMMARY_FILE="${ARTIFACT_DIR}/pipeline-summary.txt"

    echo "PIPELINE SUMMARY" > "$SUMMARY_FILE"
    echo "================" >> "$SUMMARY_FILE"
    echo "PIPELINE: ${PIPELINE_NAME}" >> "$SUMMARY_FILE"
    echo "Run ID: ${RUN_ID}" >> "$SUMMARY_FILE"
    echo "Status: ${PIPELINE_STATUS}" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"

    for stage in INIT VALIDATE BUILD TEST REPORT; do

        status="${STAGE_STATUS[$stage]-}"
        duration="${STAGE_DURATIONS[$stage]-}"

        status=${status:-FAILED}
        duration=${duration:-0}

        printf "%-10s %s (%ss)\n" "$stage" "$status" "$duration" >> "$SUMMARY_FILE"

    done

}
main() {
    init
    validate
    build
    test_stage
    
    PIPELINE_END_TIME=$(date +%s)
    TOTAL_DURATION=$((PIPELINE_END_TIME - PIPELINE_START_TIME))

    report
    log INFO "Total pipeline duration: ${TOTAL_DURATION}s"

    if [[ "${PIPELINE_STATUS}" == "FAILED" ]]; then
        exit "${PIPELINE_EXIT_CODE}"
    fi
}

main "$@"