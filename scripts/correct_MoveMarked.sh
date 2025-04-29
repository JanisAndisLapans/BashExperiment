#!/bin/bash

find "/etc/docs" -name '*.docx.found' | xargs -i bash -cx 'docx=`dirname {}`/`basename {} .found`;[ -e "$docx" ] && movedpath=`realpath --relative-to="/etc/docs" $(dirname {})` && { mkdir --parents "$0/$movedpath";  mv {} "$docx" "$0/$movedpath";}' "/etc/movedDocs"
