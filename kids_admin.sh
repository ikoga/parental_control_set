#!/bin/bash
LANG=C
TIME_H=""

# Kids device
TARGET1="(子どもの端末の IP アドレス)"
TIME_TO_RESTRICTED="20"
TIME_TO_NEXT_OPEN="180"
POLLING_DURATION="5"
PING_COUNT="1"
SCRIPT_OPEN="${HOME}/bin/parental_control_allow.sh"
SCRIPT_CLOSE="${HOME}/bin/parental_control_block.sh"

# do not open 21:00 - 06:00
MID_NIGHT=21
EARLY_MORNING=6

while true
do
   # check if deice was woke
   echo -n "`date "+%x %H:%M"` INFO: pinging ${TARGET1} ... "
   ping -c "${PING_COUNT}" "${TARGET1}" >/dev/null 2>&1
   RETVAL=`echo $?`
   # device was woke up
   if [ "${RETVAL}" = "0" ]; then
      echo "Device was waking up at `date "+%H:%M"`, will be shut at `date --date "${TIME_TO_RESTRICTED} minutes" "+%H:%M"`"
      sleep "${TIME_TO_RESTRICTED}m"
      echo "`date "+%x %H:%M"` INFO: Time is up at `date "+%H:%M"`, shutting the target device ($TARGET1)"
      bash ${SCRIPT_CLOSE} > /dev/null
      echo "`date "+%x %H:%M"` INFO: The next allowed time is `date --date "${TIME_TO_NEXT_OPEN} minutes " "+%H:%M"`"
      sleep "${TIME_TO_NEXT_OPEN}m"

      # do not open if it is too late night or too early morning
      TIME_H=`date "+%H"`
        if [ ${TIME_H} -ge ${MID_NIGHT} ]; then
           echo "`date "+%x %H:%M"` INFO: Too late night, good night, keep closing"
        elif [ ${TIME_H} -le ${EARLY_MORNING} ]; then
           echo "`date "+%x %H:%M"` INFO: Too early morning, stay in bed, keep closing"
        else
           echo "`date "+%x %H:%M"` INFO: Ok, it is allowed"
           bash ${SCRIPT_OPEN} > /dev/null
        fi
   # device is still sleeping
   else
      echo "Device is down, waiting for next polling ..."
      sleep "${POLLING_DURATION}m"
   fi
done
