#!/usr/bin/env bash

#############################################################
#                                                           #
#  Name:    check_satellite_service                         #
#                                                           #
#  Version: 0.1                                             #
#  Created: 2016-11-03                                      #
#  License: GPLv3 - http://www.gnu.org/licenses             #
#  Copyright: (c)2016 René Koch                             #
#  Author:  René Koch <rkoch@rk-it.at>                      #
#  URL: https://github.com/scrat14/check_satellite_service  #
#                                                           #
#############################################################

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Changelog:
# * 0.1.0 - Thu Nov 3 2013 - René Koch <rkoch@rk-it.at>
# - This is the first release of new plugin check_satellite_service

# Configuration
KATELLO_SERVICE="/usr/bin/katello-service"

# Variables
PROG="check_satellite_service"
VERSION="0.1"
VERBOSE=0
STATUS=3

# Icinga/Nagios status codes
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_UNKNOWN=3


# function print_usage()
print_usage(){
  echo "Usage: ${0} [-v] [-V]"
}


# function print_help()
print_help(){
  echo ""
  echo "Red Hat Satellite 6 plugin for Icinga/Nagios version ${VERSION}"
  echo "(c)2016 - Rene Koch <rkoch@rk-it.at>"
  echo ""
  echo ""
  print_usage
  cat <<EOT
Options:
 -h, --help
    Print detailed help screen
 -V, --version
    Print version information
 -v, --verbose
    Show details for command-line debugging (Nagios may truncate output)
Send email to rkoch@rk-it.at if you have questions regarding use
of this software. To sumbit patches of suggest improvements, send
email to rkoch@rk-it.at
EOT

exit ${STATUS_UNKNOWN}

}


# function print_version()
print_version(){
  echo "${PROG} ${VERSION}"
  exit ${STATUS_UNKNOWN}
}


# The main function starts here

# Parse command line options
while test -n "$1"; do
  
  case "$1" in
    -h | --help)
      print_help
      ;;
    -V | --version)
      print_version
      ;;
    -v | --verbose)
      VERBOSE=1
      shift
      ;;
    *)
      echo "Unknown argument: ${1}"
      print_usage
      exit ${STATUS_UNKNOWN}
      ;;
  esac
  shift
      
done


# Get status of Satellite services
if [ ${VERBOSE} -eq 1 ]; then
  echo "[V]: Output of katello-service status:"
  echo "`${KATELLO_SERVICE} status 2>/dev/null`"
fi

KATELLO=`${KATELLO_SERVICE} status 2>/dev/null | tail -1`
if [ $? -ne 0 ]; then
  echo "Satellite UNKNOWN: exit code of ${KATELLO_SERVICE} not 0!"
  exit ${STATUS_UNKNOWN}
fi

if [ "${KATELLO}" != "Success!" ]; then
  echo "Satellite CRITICAL: ${KATELLO}"
  exit ${STATUS_CRITICAL}
else
  echo "Satellite OK: All services are running!"
  STATUS=${STATUS_OK}
fi

exit ${STATUS}