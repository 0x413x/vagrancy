Test the Installation of the Vagrancy Package in a Docker Container
===================================================================

The script `test_install.sh` builds a docker image based on a recent
Ubuntu version and installs the x86_64 version of the previously
generated package (see `packaging/build_in_docker/README.md` on how
to build the packages). A docker container is then started with the
packaged vagrancy and the access to the vagrancy is tested.


Usage
-----

    packaging/test_install_in_docker/test_install.sh
