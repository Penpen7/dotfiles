# shellcheck shell=bash
# Prints the name of the current day.

run_segment() {
  local day_of_week
  day_of_week=$(date +%u)
  local day_name
  case $day_of_week in
    1) day_name="Mon" ;;
    2) day_name="Tue" ;;
    3) day_name="Wed" ;;
    4) day_name="Thu" ;;
    5) day_name="Fri" ;;
    6) day_name="Sat" ;;
    7) day_name="Sun" ;;
    *) return 1 ;;
  esac

  echo "$day_name"

  return 0
}
