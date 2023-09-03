set -ex

# Required for cross-compiling with pkg-config
export PKG_CONFIG_SYSROOT_DIR=$PREFIX
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

# Help the linker can find zlib
export LIBRARY_PATH=$PREFIX${LIBRARY_PATH:+:$LIBRARY_PATH}

cargo install --path . --root ${PREFIX}

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
