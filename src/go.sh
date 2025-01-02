#!/bin/sh

echo ''
echo 'This is an opinionated script for configuring macOS systems. It will install'
echo 'Homebrew (including whatever packages can be installed on your system from the'
echo 'included Brewfile) and update configurations in your home directory, including'
echo 'GPG and SSH keys.'
echo ''
printf 'Continue? [y/N] '
read -r go_now

echo "$go_now" | tr '[:upper:]' '[:lower:]' | grep -q ^y || exit 0

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle

cp ../.editorconfig ~/.editorconfig
cp .gitconfig ~/.gitconfig
cp .gitignore ~/.gitignore
cp .npmrc ~/.npmrc
cp .vimrc ~/.vimrc
cp .zprofile ~/.zprofile
cp .zshenv ~/.zshenv
cp .zshrc ~/.zshrc

printf 'Name: '
read -r name
sed -i '' "s/@name/$name/" ~/.gitconfig

printf 'Email: '
read -r email
sed -i '' "s/@email/$email/" ~/.gitconfig

printf 'GPG Fingerprint (for commit signing): '
read -r gpg_fingerprint
sed -i '' "s/@gpg_fingerpring/$gpg_fingerprint/" ~/.gitconfig

printf 'GitHub Limited Token: '
read -r ghp_limited_token
sed -i '' "s/@ghp_limited_token/$ghp_limited_token/" ~/.zshenv

printf 'GitHub General Token: '
read -r ghp_publish_token
sed -i '' "s/@ghp_publish_token/$ghp_publish_token/g" ~/.npmrc
sed -i '' "s/@ghp_publish_token/$ghp_publish_token/g" ~/.zshenv

printf 'NPM Publish Token: '
read -r npm_publish_token
sed -i '' "s/@npm_publish_token/$npm_publish_token/" ~/.npmrc
sed -i '' "s/@npm_publish_token/$npm_publish_token/" ~/.zshenv

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
printf 'GPG Key File: '
read -r gpg_key_file
gpg --import "$gpg_key_file" && printf 'Delete imported GPG key file? [y/N] ' && read -r gpg_key_delete

echo "$gpg_key_delete" | tr '[:upper:]' '[:lower:]' | grep -q ^y && rm -f "$gpg_key_file" && echo 'Imported GPG key file deleted'

mkdir -p ~/.ssh
chmod 700 ~/.ssh
printf 'SSH Key Path: '
read -r ssh_key_path
cp -r "$ssh_key_path/*" ~/.ssh
find ~/.ssh -mindepth 1 -exec chmod 600 {} \;
find ~/.ssh -iname '*.pub' -exec chmod 644 {} \;
