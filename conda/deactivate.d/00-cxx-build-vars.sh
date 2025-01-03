#!/bin/sh

# Remove this Conda's include and library directories from the search paths
# of C/C++ compilers.

path_remove() {
    local var_name="$1"
    local dir_to_remove="$2"
    local path_var="${!var_name}"

    # Remove the first occurence of the directory from the path variable
    IFS=: read -r -a path_segments <<< "$path_var"

    # Remove the first matching segment
    for i in "${!path_segments[@]}"; do
        if [ "${path_segments[i]}" = "$dir_to_remove" ]; then
            unset 'path_segments[i]'
            break
        fi
    done

    # Rebuild the path variable
    path_var="$(IFS=:; echo "${path_segments[*]}")"
    
    # Export the modified path variable
    export "$var_name"="$path_var"
}

path_remove  CPATH              "$CONDA_PREFIX/include"
path_remove  C_INCLUDE_PATH     "$CONDA_PREFIX/include"
path_remove  CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
path_remove  LIBRARY_PATH       "$CONDA_PREFIX/lib"
path_remove  LD_LIBRARY_PATH    "$CONDA_PREFIX/lib"

