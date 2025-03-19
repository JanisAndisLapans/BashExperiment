 #!/bin/bash

 warning_cnt=0
 for file in $(find . -maxdepth 1 -type f -name "*.sh"); do
    warning_cnt=$(( $warning_cnt + $(shellcheck --format=json "$file" | grep -o '"level":"warning"' | wc -l) ))
 done

 echo "Count warning: $warning_cnt"