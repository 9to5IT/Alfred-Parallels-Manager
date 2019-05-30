#!/bin/bash
#
# .SYNOPSIS
#   Alfred workflow - parallels manager
#
# .DESCRIPTION
#   Parallels Manager is an Alfred Workflow that is used to managed your Parallels Desktop
#   virtual machines. You can Start, Stop, Pause, Suspend, Restart and Resume a machine.
#
# .PARAMETER $1 = uuid
#   Optional. This is the UUID of the virtual machine to execute an action against.
#
# .PARAMETER $2 = action
#   Optional. This is the action (start, stop, pause, resume, suspend, restart) to execute.
#
# .INPUTS None
#
# .OUTPUTS Alfred Debugger
#   Alfred Script Filter JSON
#
# .NOTES
#   Version:        1.0
#   Author:         Luca Sturlese
#   Creation Date:  20.05.2019
#   Purpose/Change: Initial script development
#
# .NOTES
#   Version:        1.1
#   Author:         Luca Sturlese
#   Creation Date:  30.05.2019
#   Purpose/Change: Resolved issue where VM name cannot have spaces

#-----------------------------------------------------------[Functions]------------------------------------------------------------

#=========================================
# Check-PreReqs
#
# Synopsis: Checks to ensure all required
# software is installed before executing
#
# Parameters:
#   $1 = Command to check for
#=========================================
function Check-PreReqs {
  command -v $1 >/dev/null 2>&1 || {
    echo "This script requires $1 but it isn't installed. Aborting."  1>&2
    exit 1
  }
}

#=========================================
# ListMode
#
# Synopsis: Gets a list of vms from Parallels Desktop (prlctl command) and
#           returns details via Alfred script filter.
#
# Parameters:
#   $1 = None
#=========================================
function ListMode {
  echo "ListMode function.." 1>&2

  # Get list of Parallels virtual machines & their status
  resultsString=""
  results=$( /usr/local/bin/prlctl list --all --output uuid,status,name --json | /usr/local/bin/jq .[] )

  # Split resultsString into an array with delimiter as { (this results in first element of array being empty)
  delimiter='{'
  s=$results$delimiter
  resultsArray=();
  
  while [[ $s ]]; do
    resultsArray+=( "${s%%"$delimiter"*}" );
    s=${s#*"$delimiter"};
  done;

  # Declare resultsArray & projects array
  declare -p resultsArray > /dev/null 2>&1
  vmlist=()

  # Add pre JSON data
  jsonOutput+="{\"items\": ["

  # Enumerate resultsArray array and clean-up string and build project array
  for ((i = 0; i < ${#resultsArray[*]}; i++)) do

    # Only process items with content (i.e. skip array index 0)
    if [ "${resultsArray[$i]}" != '' ]; then
      # Add '{ ' to the beginning of each item to create valid json
      item="{ ${resultsArray[$i]}"

      # Get content from item and remove "" characters
      uuid=$( echo $item | /usr/local/bin/jq -r .uuid )
      name=$( echo $item | /usr/local/bin/jq -r .name )
      status=$( echo $item | /usr/local/bin/jq -r .status )

      jsonProject="{ \"uid\": \"$uuid\", \"title\": \"$name\", \"subtitle\": \"$status\", \"arg\": \"$uuid\", \"icon\": { \"path\": \"icons/vm-icon.png\" } },"
      jsonOutput+=$jsonProject
    fi
  done

  # Remove comma from last json item
  jsonOutput=${jsonOutput%?}

  # Add post JSON data
  jsonOutput+="]}"

  # Return JSON to Alfred
cat << EOB
$jsonOutput
EOB
}


#=========================================
# ExecuteMode
#
# Synopsis: Executes the action parameter against the vm uuid parameter
#
# Parameters:
#   $1 = uuid
#   $2 = action
#=========================================
function ExecuteMode {
  echo "ExecuteMode function.." 1>&2
  uuid=$1
  action=$2

  # Build command to execute
  cmd="/usr/local/bin/prlctl "
  cmd+="$action $uuid"

  # --- START COMMAND EXECUTION ---
  
  # Launch Parallels Desktop on start only
  if [ "$action" == 'start' ]; then
    eval "/Applications/Parallels\ Desktop.app/Contents/MacOS/prl_client_app &>/dev/null &"
  fi
  
  # Exeute Parallels Desktop command
  eval $cmd

  # --- END COMMAND EXECUTION ---
}


#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Check pre-reqs are installed on machine
Check-PreReqs /usr/local/bin/jq

# Check arguments: No more than 1 argument
if [ "$#" -gt 2 ]; then
  echo "Too many arguments supplied. Aborting" 1>&2
  exit 1
fi

# Check arguments: Argument passed or not
if [ "$1" == '' ]; then
  ListMode
else
  ExecuteMode $1 $2
fi