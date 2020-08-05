#!/bin/sh -l

echo "🔥🔥🔥🔥🔥Running security check🔥🔥🔥🔥🔥🔥"
mkdir -p $GITHUB_WORKSPACE/output
touch $GITHUB_WORKSPACE/output/security_report.txt
bandit -r $INPUT_PROJECT_PATH -o $GITHUB_WORKSPACE/output/security_report.txt -f 'txt'
BANDIT_STATUS="$?"

python /main.py -r $INPUT_PROJECT_PATH

if [ $BANDIT_STATUS -eq 0 ]; then
    echo "🔥🔥🔥🔥Security check passed🔥🔥🔥🔥"
    exit 0
fi

echo "🔥🔥🔥🔥Security check failed🔥🔥🔥🔥"
cat $GITHUB_WORKSPACE/output/security_report.txt
if $INPUT_IGNORE_FAILURE; then
    exit 0
fi

exit $BANDIT_STATUS
