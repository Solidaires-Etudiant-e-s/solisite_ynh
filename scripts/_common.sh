#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

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
