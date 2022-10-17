#!/bin/bash

echo " ************** MODIFIED FILES"
printf ${MODIFIED_FILES}
printf "\n*****************************\n"

PATHS=$(printf ${MODIFIED_FILES} | tr \\n '\n')

URI="https://api.github.com"
addLabel="holycode"
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")


is_holycode_label_eligible () {
  IS_CORE_FILE=$(echo $PATHS | grep -P "^app/code/core/.+$" | wc -l)

  for MODIFIED_FILE in $PATHS
  do
      IS_MODIFIED_FILE_EXISTS_IN_OPENMAGE=$(cat /openmage_files_v1.6.txt | grep -P "^.*${MODIFIED_FILE}" | wc -l)

      if [[ $IS_MODIFIED_FILE_EXISTS_IN_OPENMAGE == 1 || $IS_CORE_FILE == 1 ]]
      then
        return 1
      fi
  done

  return 0
}

is_holycode_label_eligible

if [[ $? == 1 ]]
then
  echo "The holycode label is eligible"
  curl -sSL \
          -H "${AUTH_HEADER}" \
          -H "${API_HEADER}" \
          -X POST \
          -H "Content-Type: application/json" \
          -d "{\"labels\":[\"${addLabel}\"]}" \
          "${URI}/repos/${GITHUB_REPOSITORY}/issues/${number}/labels"
else
  echo "The holycode label is not eligible"
  curl -sSL \
              -H "${AUTH_HEADER}" \
              -H "${API_HEADER}" \
              -X DELETE \
              "${URI}/repos/${GITHUB_REPOSITORY}/issues/${number}/labels/${addLabel}"
fi
