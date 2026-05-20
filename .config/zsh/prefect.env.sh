#!/usr/bin/env bash

# Prefect API URLs, one per workspace.
# Referenced by ~/.config/claude/mcp.json via ${PREFECT_<ENV>_<WORKSPACE>_API_URL}.
# To switch the prefect CLI's active profile, use `prefect profile use <name>`
# (profiles defined in ~/.prefect/profiles.toml).

# dev
export PREFECT_DEV_INTEGRATION_TESTS_API_URL="https://api.prefect.dev/api/accounts/9a67b081-4f14-4035-b000-1f715f46231b/workspaces/61ed380f-f0f5-4688-a88c-0bc19b5f59c7"

# stg
export PREFECT_STG_INTEGRATION_TESTS_API_URL="https://api.stg.prefect.dev/api/accounts/9a67b081-4f14-4035-b000-1f715f46231b/workspaces/60305128-9439-47ef-b353-f2a8f6a7a8b4"

# prd
export PREFECT_PRD_INTEGRATION_TESTS_API_URL="https://api.prefect.cloud/api/accounts/12242a57-9f05-4bf5-8853-9bff595d4bab/workspaces/9648a429-137e-4868-8c73-2617543a50a2"
export PREFECT_PRD_INTEGRATION_TESTS_OSS_API_URL="https://api.prefect.cloud/api/accounts/12242a57-9f05-4bf5-8853-9bff595d4bab/workspaces/54b2e424-f158-49ad-b3e0-e546bdcbd85d"

# previous
export PREFECT_PREVIOUS_INTEGRATION_TESTS_API_URL="https://previous-api.private.prefect.dev/api/accounts/63632de1-4dc5-4fb0-a7af-a8d7403462b3/workspaces/6e52f67f-c1d7-454f-9b19-484d57d2be39"

# latest
export PREFECT_LATEST_INTEGRATION_TESTS_API_URL="https://latest-api.private.prefect.dev/api/accounts/266a9b19-5e82-416e-b05b-0a39c13ec6c7/workspaces/0cad180f-5415-4bd7-a067-f6f17f92af15"

#next
export PREFECT_NEXT_INTEGRATION_TESTS_API_URL="https://next-api.prefect.dev/api/accounts/b1e2aee4-085d-48a8-9327-eb07becf288b/workspaces/1fca9652-9709-4170-8b50-12146cf58780"
