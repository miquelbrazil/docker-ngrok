#!/usr/bin/env bash

set -e
set -u
set -o pipefail

CONFIG_FILE="/home/ngrok/.ngrok2/ngrok.yml"


# -------------------------------------------------------------------------------------------------
# SPECIFY REGION
# -------------------------------------------------------------------------------------------------

if ! env | grep -q '^REGION='; then
	REGION=
else
	REGION="$( env env | grep '^REGION=' | awk -F'=' '{print $2}' | xargs )"
	REGION="${REGION##*( )}" # Trim leading whitespaces
	REGION="${REGION%%*( )}" # Trim trailing whitespaces

	if [ -z "${REGION}" ]; then
		>&2 echo "[WARN]  REGION specified, but empty"
	else
		echo "[INFO]  Using region as specified in REGION: ${REGION}"
		echo "region: ${REGION}" >> "${CONFIG_FILE}"
	fi
fi


# -------------------------------------------------------------------------------------------------
# SPECIFY AUTH TOKEN
# -------------------------------------------------------------------------------------------------

if ! env | grep -q '^AUTHTOKEN='; then
	>&2 echo "[WARN]  No AUTHTOKEN specified, limited functionality only"
else
	AUTHTOKEN="$( env env | grep '^AUTHTOKEN=' | awk -F'=' '{print $2}' | xargs )"
	AUTHTOKEN="${AUTHTOKEN##*( )}" # Trim leading whitespaces
	AUTHTOKEN="${AUTHTOKEN%%*( )}" # Trim trailing whitespaces

	if [ -z "${AUTHTOKEN}" ]; then
		>&2 echo "[WARN]  AUTHTOKEN specified, but empty, limited functionality only"
	else
		echo "[INFO]  Using authtoken as specified in AUTHTOKEN"
		echo "authtoken: ${AUTHTOKEN}" >> "${CONFIG_FILE}"
	fi
fi

cat ${CONFIG_FILE}

# -------------------------------------------------------------------------------------------------
# START NGROK
# -------------------------------------------------------------------------------------------------

exec ngrok start --all
