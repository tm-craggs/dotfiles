#!/bin/bash

# Function to check version compatibility
ver_check() {
  local name=$1
  local cmd=$2
  local required=$3

  if ! command -v $cmd &>/dev/null; then
    echo "ERROR: $name ($cmd) not found"
    return 1
  fi

  current_ver=$($cmd --version | head -n1 | grep -Eo '[0-9]+(\.[0-9]+)+')
  if printf '%s\n' "$required" "$current_ver" | sort -V -C; then
    printf "OK: %-12s %s >= %s\n" "$name" "$current_ver" "$required"
    return 0
  else
    printf "ERROR: %-12s %s is too old (>= %s required)\n" "$name" "$current_ver" "$required"
    return 1
  fi
}

# Kernel version check
ver_kernel() {
  required=$1
  kver=$(uname -r | grep -Eo '^[0-9.]+')
  if printf '%s\n' "$required" "$kver" | sort -V -C; then
    printf "OK: Linux Kernel %s >= %s\n" "$kver" "$required"
    return 0
  else
    printf "ERROR: Linux Kernel %s is TOO OLD (>= %s required)\n" "$kver" "$required"
    return 1
  fi
}

# Alias check
alias_check() {
  if $1 --version 2>&1 | grep -qi "$2"; then
    printf "OK: %-4s is %s\n" "$1" "$2"
  else
    printf "ERROR: %-4s is NOT %s\n" "$1" "$2"
  fi
}

# Tool version checks
ver_check Coreutils sort 8.1 || exit 1
ver_check Bash bash 3.2
ver_check Binutils ld 2.13.1
ver_check Bison bison 2.7
ver_check Diffutils diff 2.8.1
ver_check Findutils find 4.2.31
ver_check Gawk gawk 4.0.1
ver_check GCC gcc 5.2
ver_check "GCC (C++)" g++ 5.2
ver_check Grep grep 2.5.1a
ver_check Gzip gzip 1.3.12
ver_check M4 m4 1.4.10
ver_check Make make 4.0
ver_check Patch patch 2.5.4
ver_check Perl perl 5.8.8
ver_check Python python3 3.4
ver_check Sed sed 4.1.5
ver_check Tar tar 1.22
ver_check Texinfo texi2any 5.0
ver_check Xz xz 5.0.0

# Kernel specific features
ver_kernel 5.4
if mount | grep -q 'devpts on /dev/pts' && [ -e /dev/ptmx ]; then
  echo "OK: Linux Kernel supports UNIX 98 PTY"
else
  echo "ERROR: Linux Kernel does NOT support UNIX 98 PTY"
fi

# Alias checks
echo "Aliases:"
alias_check awk GNU
alias_check yacc Bison
alias_check sh Bash

# Compiler test
echo "Compiler check:"
if printf "int main(){}" | g++ -x c++ -o /dev/null -; then
  echo "OK: g++ works"
else
  echo "ERROR: g++ does NOT work"
fi

# CPU core count
if [ -n "$(command -v nproc)" ] && [ -n "$(nproc)" ]; then
  echo "OK: nproc reports $(nproc) logical cores are available"
else
  echo "ERROR: nproc is not available or it produces empty output"
fi
