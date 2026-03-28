#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

package_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
local_source_dir="$(cd "$package_dir/../solisite" 2>/dev/null && pwd || true)"

sync_app_source() {
    if [ -z "$local_source_dir" ] || [ ! -d "$local_source_dir" ]; then
        ynh_die --message="Local Solisite source directory not found next to the package. Expected: $package_dir/../solisite"
    fi

    mkdir -p "$install_dir"

    rsync -a --delete \
        --exclude='.env' \
        --exclude='.git' \
        --exclude='.nuxt' \
        --exclude='.output' \
        --exclude='node_modules' \
        --exclude='data/cms.sqlite' \
        --exclude='data/cms.sqlite-shm' \
        --exclude='data/cms.sqlite-wal' \
        "$local_source_dir/" "$install_dir/"
}

prepare_mutable_paths() {
    mkdir -p "$data_dir/uploads"

    if [ -d "$install_dir/public/uploads" ] && [ ! -L "$install_dir/public/uploads" ]; then
        cp -a -n "$install_dir/public/uploads/." "$data_dir/uploads/" 2>/dev/null || true
        rm -rf "$install_dir/public/uploads"
    fi

    ln -sfn "$data_dir/uploads" "$install_dir/public/uploads"
}

fix_app_permissions() {
    chown -R "$app:www-data" "$install_dir" "$data_dir"
}
