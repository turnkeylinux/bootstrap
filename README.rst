About
=====

This project builds a Debian ``bootstrap`` for use as a base for
building TurnKey GNU/Linux appliances. It also supports building an
Ubuntu base. Please note that TurnKey is built on Debian, Ubuntu
support should be considered "second class".

A ``bootstrap`` is the minimal root filesystem in which packages can
be installed. TurnKey uses a default "minbase" variant Debian bootstrap,
with the addition of a couple of packages.

For further info please run::

    make help


Build & copy to bootstraps directory
====================================

If you are building a bootstrap for local use only, then it is not necessary
to do a complete ``make`` (which will generate a tarball as noted below).
Instead you can just build to the ``install`` target.

That will build the bootstrap, remove the pre-set list of files noted
within the removelist file and copy the bootstrap to
``$FAB_PATH/bootstraps/$(basename $RELEASE)``::

    make clean
    make install

Generate release tarball, sign and publish
==========================================

These notes have been superceeded by `buildtasks/bt-bootstrap`_ but noted
here for historical purposes::

    ARCH=$(dpkg --print-architecture)
    TARBALL=$FAB_PATH/build/bootstrap-$(basename $RELEASE)-$ARCH.tar.gz
    ln build/bootstrap.tar.gz $TARBALL

    cd turnkey-builds
    source vars
    export PUBLISH_DEST=${PUBLISH_IMAGES}/bootstrap/
    $BT_BIN/generate-signature $TARBALL
    $BT_BIN/signature-sign $TARBALL.hash
    contrib/publish-files $TARBALL $TARBALL.hash

.. _buildtasks/bt-bootstrap: https://github.com/turnkeylinux/buildtasks/blob/master/bt-bootstrap
