#!/bin/sh

set -e;

if [ "${ENABLE_PIP_INSTALL}" = "true" ]; then
  PIP_REQUIREMENTS_FILE=${PIP_REQUIREMENTS_FILE:-/requirements.txt}
  if [ -f "${PIP_REQUIREMENTS_FILE}" ]; then
    pip install --no-cache-dir -r ${PIP_REQUIREMENTS_FILE}
  fi
fi

if [ "${ENABLE_HF_MODELS}" = "true" ]; then
  HF_MODEL_HOOK=${HOOKS_DIR}/hfmodels.py
  if [ -f "${HF_MODEL_HOOK}" ]; then 
    python3 ${HF_MODEL_HOOK}
  fi
fi