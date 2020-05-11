#!/bin/sh

repo_host="plugins.cloud.ibm.com"
os_name=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "$os_name" != "darwin" ]; then
    echo "Unsupported macOS platform: ${os_name}. Quit installation."
    exit 1
fi

url="https://$repo_host/download/bluemix-cli/latest/osx"
file_name="IBM_Cloud_CLI.pkg"

echo "Current platform is macOS. Downloading corresponding IBM Cloud CLI..."

# Only use sudo if not running as root:
[ "$(id -u)" -ne 0 ] && SUDO=sudo || SUDO=""

if curl -L $url -o /tmp/${file_name}
then
    echo "Download complete. Executing installer..."
else
    echo "Download failed. Please check your network connection. Quit installation."
    exit 1
fi

cd /tmp || exit
if ${SUDO} installer -verbose -pkg ${file_name} -target / ; then
    echo "Install complete."
else
    echo "Install failed."
fi
rm /tmp/${file_name}
