apt-component-list() {
    while [ "$1" ]; do
        dpkg-query -W -f='${Section} ${Package}\n' | grep ^$1
        shift
    done
}
