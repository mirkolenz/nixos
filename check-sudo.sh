SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi
