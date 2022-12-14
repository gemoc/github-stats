#!/bin/bash

LIST_REPOSITORIES=($1)
TOKEN=$2
DATE_SINCE=$3

function get_users_from() {
    _QUERY=$1
    _RESULTS=""
    for _REPOSITORY in ${LIST_REPOSITORIES[@]}; do
        _RESULTS=$_RESULTS$(curl -s "https://api.github.com/repos/$_REPOSITORY/$_QUERY?per_page=100&state=all&since=$DATE_SINCE&page=[1-5]" --header "Authorization: token $TOKEN")
    done
    _USERS=$(echo $_RESULTS | jq '.[].user.login' | sort | uniq )
    _USERS_NB=$(echo $_RESULTS | jq '.[].user.login' | sort | uniq | wc -l)
    echo $_USERS
}

echo "Analyzed repositories: "
printf "— %s\n" "${LIST_REPOSITORIES[@]}"

echo ""
echo "Getting all unique users who opened an issue…"
ISSUES_USERS=($(get_users_from "issues"))
echo "" 
echo "Result:"
printf "— %s\n" "${ISSUES_USERS[@]}"
echo ""
echo ${#ISSUES_USERS[@]} "users"
echo ""


echo ""
echo "Getting all unique users who opened an PR…"
PULL_USERS=($(get_users_from "pulls"))
echo "" 
echo "Result:"
printf "— %s\n" "${PULL_USERS[@]}"
echo ""
echo ${#PULL_USERS[@]} "users"
echo ""



echo ""
echo "Merging both lists…"
ALL_USERS_NOT_UNIQUE=( ${ISSUES_USERS[@]} ${PULL_USERS[@]})
ALL_USERS=( $( printf "%s\n" "${ALL_USERS_NOT_UNIQUE[@]}" | sort | uniq ) )
echo "" 
echo "Result:"
printf "— %s\n" "${ALL_USERS[@]}"
echo ""
echo ${#ALL_USERS[@]} "users"
echo ""