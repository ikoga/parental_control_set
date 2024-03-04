#!/bin/sh
LANG=C

BASEDIR="/etc/mrtg"
ALERT_TO="ここに通知したい宛先メールアドレス"
TIME=`date "+%H:%M"`

# Challenge Touch
TARGET1="子どもの端末(チャレンジタッチ) の IP アドレス"
# GIGA PC
TARGET2="子どもの端末(学校の PC) の IP アドレス"
COUNT="1"

send_notify () {
  TARGET_DEVICE="$1"
  if [ "$2" = "1" ]; then
     OLDSTAT="off"
  elif [ "$2" = "0" ]; then
     OLDSTAT="on"
  else
     OLDSTAT="unknown"
  fi

  if [ "$3" = "1" ]; then
     NEWSTAT="off"
     TIME=`date --date "0 minutes ago" "+%H:%M"`
  elif [ "$3" = "0" ]; then
     NEWSTAT="on"
  else
     NEWSTAT="unknown"
  fi

(
  echo "Subject: [KidsMon] ${TARGET_DEVICE} ${OLDSTAT} -> ${NEWSTAT} (${TIME})"
  echo
  echo "Power status has changed: ${OLDSTAT} -> ${NEWSTAT} (${TIME})"
) | /usr/sbin/sendmail "${ALERT_TO}"
}

ping -c "${COUNT}" "${TARGET1}" >/dev/null 2>&1
RETVAL=`echo $?`
PING_STATUS1=`echo $(( ( 1 - ${RETVAL} ) * 100))`
echo "${RETVAL} ${TIME}" > ${BASEDIR}/${TARGET1}.new
OLDSTAT=`awk '{ print $1 }' ${BASEDIR}/${TARGET1}.stat`

if [ "${RETVAL}" != "${OLDSTAT}" ]; then
   send_notify "Touch" "${OLDSTAT}" "${RETVAL}"
fi
mv -f "${BASEDIR}/${TARGET1}.new" "${BASEDIR}/${TARGET1}.stat"

ping -c "${COUNT}" "${TARGET2}" >/dev/null 2>&1
RETVAL=`echo $?`
PING_STATUS2=`echo $(( ( 1 - ${RETVAL} ) * 100))`
echo "${RETVAL} ${TIME}" > ${BASEDIR}/${TARGET2}.new
OLDSTAT=`awk '{ print $1 }' ${BASEDIR}/${TARGET2}.stat`

if [ "${RETVAL}" != "${OLDSTAT}" ]; then
   send_notify "PC" "${OLDSTAT}" "${RETVAL}"
fi
mv -f "${BASEDIR}/${TARGET2}.new" "${BASEDIR}/${TARGET2}.stat"


UPTIME=`uptime 2>/dev/null | awk '{print $3, $4, $5}' | sed -e "s/,/\ /g"`
echo "$PING_STATUS1"
echo "$PING_STATUS2"
echo "$UPTIME"
echo `hostname -f`
