set -ex

# Required for cross-compiling
export PKG_CONFIG_SYSROOT_DIR=$PREFIX
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

cargo install --path . --root ${PREFIX}

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
