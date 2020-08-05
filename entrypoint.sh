#!/bin/sh -l

if [ -z "$INPUT_PYTHON_VERSION" ]; then
    echo "🔥🔥🔥🔥🔥No python version provided🔥🔥🔥🔥🔥🔥"
    exit 1
else
    pyenv install $INPUT_PYTHON_VERSION
    pyenv global $INPUT_PYTHON_VERSION
    pyenv rehash
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv virtualenv $INPUT_PYTHON_VERSION venv
pyenv activate venv

echo "🔥🔥🔥🔥🔥Running security check🔥🔥🔥🔥🔥🔥"
pip  install -r requirements.txt
mkdir -p $GITHUB_WORKSPACE/output
touch $GITHUB_WORKSPACE/output/security_report.txt
bandit -r $INPUT_PROJECT_PATH -o $GITHUB_WORKSPACE/output/security_report.txt -f 'txt'
BANDIT_STATUS="$?"

python annotations.py -r $INPUT_PROJECT_PATH

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
