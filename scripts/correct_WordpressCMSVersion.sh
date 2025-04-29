#!/bin/bash

find /home/*/public_html/ -type f -iwholename "*/wp-includes/version.php" -exec grep -H "\$wp_version =" {} \; | awk -F"'" '{print "Found: " $2}'
