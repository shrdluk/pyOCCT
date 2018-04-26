# Check if a new build should be scheduled and send request using
# Travis API

# echo "BRANCH=$TRAVIS_BRANCH"

#echo "API_TOKEN=$1"

echo "Checking if a new build should be scheduled"

if [ -f reschedule_required ] ; then
    echo "Reschedule required. Issuing request"

    body="{
        \"request\": {
            \"branch\": \"$TRAVIS_BRANCH\",
            \"message\": \"Continue build (API request)\"
        }}"

    curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Travis-API-Version: 3" \
    -H "Authorization: token $API_TOKEN" \
    -d "$body" \
    https://api.travis-ci.org/repo/shrdluk%2FpyOCCT/requests

    echo "Request sent"
else
    echo "No reschedule required"
fi
