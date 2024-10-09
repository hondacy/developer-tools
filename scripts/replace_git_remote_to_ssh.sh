#!/bin/bash

# A simple script to change github remote url from HTTP to more secure SSH
# To use:
#     - Clone this repo: git clone 
#     - Install all tools by running install.sh
#     - cd to base development dir: cd ~/development
#     - Run the script: replace_git_remote_to_ssh

# Check cuurent config with:
# git config --get remote.origin.url

# Note: Don't forget to first authorize your private ssh with the repo/ https://github.com/settings/keys
# Github Docs about how to add a new SSH key to your account: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

## CONSTANT VARS - Change to suit your organization:
ORGANIZATION='ClickIDF'
DEBUG=flase

count=0
for DIR in $(find . -type d -depth 1); do

    ((count++))
    if [ -d "$DIR/.git" ] || [ -f "$DIR/.git" ]; then

        # Idea adopted from: https://stackoverflow.com/a/67401533/7485216 with some changes
        
        # Using ( and ) to create a subshell, so the working dir doesn't change in the main script
        # subshell start
        (
            cd "$DIR"
            REMOTE=$(git config --get remote.origin.url)
            # uses quotes to allow spaces in path
            REPO=$(basename "`git rev-parse --show-toplevel`")

            if [[ "$REMOTE" == "https://github.com/${ORGANIZATION}/"* ]]; then

                if [ "$DEBUG" = true ]; then echo "HTTPS repo found ($REPO) $DIR"; fi
                git remote set-url origin git@github.com:${ORGANIZATION}/${REPO}.git

                # Check if the conversion worked
                REMOTE=$(git config --get remote.origin.url)
                if [[ "$REMOTE" == "git@github.com:"* ]]; then
                    echo "Repo \"$REPO\" converted successfully!"
                else
                    echo "Failed to convert repo $REPO from HTTPS to SSH"
                fi

            elif [[ "$REMOTE" == "git@github.com:"* ]]; then
                if [ "$DEBUG" = true ]; then echo "SSH repo - skip ($REPO) $DIR"; fi
            else
                if [ "$DEBUG" = true ]; then echo "Not Github - skip ($REPO) $DIR"; fi
            fi
        )
        # subshell end

    fi

done

echo -e "Finished! \nProcessed ${count} directories"
