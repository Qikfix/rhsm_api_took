#!/usr/bin/bash

FULL_LOG="/tmp/full_list.log"
PRE_PROC="/tmp/full_pre.log"
POS_PROC="/tmp/full_pos.log"
FINAL="/tmp/rhsm_report.log"
DELETED_LOG="/tmp/uuid_deleted.log"

RHSM_USERNAME="rhn-support-wpinheir"

>$PRE_PROC
>$POS_PROC


sync_data()
{
  echo "Syncing data from RHSM"

  > $FULL_LOG

  TOKEN="took token -e rhsm-auth $RHSM_USERNAME"
  URL="https://api.access.redhat.com/management/v1/systems"

  echo $token

  actual_token=$(echo $TOKEN)
  if [ $? -ne 0 ]; then
    echo "## ATTENTION ##"
    echo "Open a second terminal and type the command below. After that, rerun this script once."
    echo "took decrypt -t 1440m0s"
    exit 1
  fi

  cont=0

  while true
  do
#    sleep 5
    check_system=$(curl -s -H "$($TOKEN)" $URL?limit=1\&offset=$cont | json_reformat | grep count | awk '{print $2}')
    echo "#: $cont, Status: $check_system"
    if [ $check_system -ne 1 ]; then
      echo "Done"
      exit
    else
      curl -s -H "$($TOKEN)" $URL?limit=100\&offset=$cont | json_reformat >> $FULL_LOG
      #curl -s -H "$($TOKEN)" $URL?limit=100\&offset=$cont | json_reformat | tee -a $FULL_LOG
    fi

  (( cont = cont + 100 ))
  done
}

sync_data_temp()
{
  echo "Sync Data Temp"
}

process_file()
{
  echo "Processing Files"

  cat $FULL_LOG | jq '.body[] | .name + " " + .uuid + " " + .type + " " + .lastCheckin' > $PRE_PROC

  while read line
  do
    hostname=$(echo $line | awk '{print $1'} | sed -e 's/^"//g')
    uuid=$(echo $line | awk '{print $2'})
    mtype=$(echo $line | awk '{print $3'})
    ldate=$(echo $line | awk '{print $4'} | sed -e 's/"$//g')
    epoch_date=$(date +%s -d"$ldate" 2>/dev/null)
    echo "$hostname $uuid $mtype $ldate $epoch_date" >> $POS_PROC
    
  done < $PRE_PROC

  echo "fqdn,uuid,type,lastcheckin,epoch_lastcheckin"	> $FINAL
  cat $POS_PROC | sort -nrk5 | sed -e 's/ /,/g' 			>> $FINAL

  count_uuid=$(wc -l $POS_PROC | awk '{print $1}')
  echo "There are $count_uuid UUID on the list"
  echo "Please check the file $FINAL"
}

remove_uuid_list()
{
  filename=$1

  TOKEN="took token -e rhsm-auth $RHSM_USERNAME"
  URL="https://api.access.redhat.com/management/v1/systems"

  if [ "$filename" == "" ]; then
    echo "Please inform the path to the file with uuid to be removed"
    exit 1
  fi
  echo "Removing UUID related to the file $filename"
  count_uuid_to_be_removed=$(cat $filename | cut -d, -f2 | wc -l | awk '{print $1}')
  echo "There are $count_uuid_to_be_removed on the list to be removed"
  echo
  echo -e "Are you sure you would like to remove all of them? (y/n):"
  read opc

  if [ $opc == "n" ]; then
    echo "Exiting ..."
    exit
  elif [ $opc == "y" ]; then
    echo "Removing ..."
    while read line
    do
      uuid=$(echo $line | cut -d, -f2)
      echo "Removing uuid: $uuid"																| tee -a $DELETED_LOG
      echo "curl -s -H \"$($TOKEN)\" -X DELETE $URL/$uuid"			>> $DELETED_LOG
      curl -s -H "$($TOKEN)" -X DELETE $URL/$uuid								| tee -a $DELETED_LOG
      echo 																											| tee -a $DELETED_LOG

    done < $filename
  fi
  
}

# Main

if [ "$1" == "" ]; then
  echo "## Please call this script passing the parameter"
  echo "#"
  echo "# $0 sync_data"
  echo "  or"
  echo "# $0 process_file"
  echo "  or"
  echo "# $0 remove_uuid_list <path to the file with uuid to be removed>"
  echo ""
  echo "## ATTENTION: Before you start, type on the console the command \"took token -e rhsm-auth <rhsm_username>\""
  exit 1
fi

case $1 in
	'sync_data') sync_data
		;;

	'process_file') process_file
		;;

	'remove_uuid_list') remove_uuid_list $2
esac
