#! /bin/sh
# Run all of the unit tests, and make sure the assert/stub environment is ready to go


bin_dir="$( cd "$( dirname "$0" )" && pwd )"
test_dir="$( cd "$( dirname "$bin_dir" )" && pwd )"
dot_dir="$( cd "$( dirname "$test_dir" )" && pwd )"
if [ ! -f "$bin_dir"/assert.sh ]; then
    echo "Error assert.sh must be in $bin_dir see test dependancies"
    exit
fi

if [ ! -f "$bin_dir"/stub.sh ]; then
    echo "Error stub.sh must be in $bin_dir see test dependancies"
    exit
fi

source "$bin_dir"/assert.sh
source "$bin_dir"/stub.sh

echo
for FILE in $(find "$test_dir" -not -path '../bin' -name '*.t'); do
    file_path="$(echo "$FILE" | sed -e "s~$test_dir/~~")"
    echo "*** Running Test $file_path ***"
    (source "$FILE"; assert_end "$file_path")
    echo
done
