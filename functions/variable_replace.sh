#!/usr/bin/env bash
function variable_replace() {
  _key_value_pair="${1}"
  _file="${2}"
  IFS=',' read -r -a key_value_array <<< "${_key_value_pair}"
  
  for element in "${key_value_array[@]}"
  do
    # check that we have at least one colon separator and error if not
    if [[ "${element}" == *:* ]]
    then
      variable_replace_key=$(echo "${element}" | cut -d':' -f1)
      variable_replace_val=$(echo "${element}" | cut -d':' -f2-)
    else
      echo "The ':' value is a separator for key:value pairs used for variable replacement"
      echo "and must be present in variables_to_replace in the config or the '-o' option"
      return 1
    fi
    # call replace function
    perform_variable_replace "${variable_replace_key}" "${variable_replace_val}" "${_file}"
    if [ ${?} -ne 0 ]
    then
      return 1
    fi
  done
  if [ ${?} -eq 0 ]
  then
    unset _key_value_pair
    unset _file
    return 0
  else
    return 1
  fi 
}
