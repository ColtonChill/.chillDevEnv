# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ip='ip -c'
alias ipa='ip -br a'
alias ipl='ip -br l'
alias ipr='ip -br r'
# alias markdown ='grip -b'
alias tarball='tar -czvf'
alias untar='tar -xzvf'
alias tarpeak='tar -ztvf'
alias vim='nvim'

# Sigma Building
alias cmake_deb_de='cmake -D DEBIAN_BUILD=true -D CMAKE_BUILD_TYPE=Debug -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'
alias cmake_deb_re='cmake -D DEBIAN_BUILD=true -D CMAKE_BUILD_TYPE=Release -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'
alias cmake_deb_cuda='cmake -D DEBIAN_BUILD=true -D CMAKE_BUILD_TYPE=Release -D CMAKE_EXPORT_COMPILE_COMMANDS=ON -D SIGMA_BUILD_WITH_CUDA=ON ../'

alias cmake_rocky_re='cmake -D ROCKY_BUILD=true -D CMAKE_BUILD_TYPE=Release ../'
alias cmake_rocky_cuda='cmake -D ROCKY_BUILD=true -D CMAKE_BUILD_TYPE=Release -D SIGMA_BUILD_WITH_CUDA=ON ../'
alias cmake_rocky_cuda_TMX='cmake -D ROCKY_BUILD=true -D CMAKE_BUILD_TYPE=Release -D SIGMA_BUILD_WITH_CUDA=ON -D TensorRT_DIR=/usr/src/tensorrt -D CUDA_TOOLKIT_INCLUDE=/usr/local/cuda-11/targets/x86_64-linux/include -D CUDA_CUDART_LIBRARY=/usr/local/cuda-11/targets/x86_64-linux/lib/libcudart.so -D -DSIGMA_SANITIZER=none -DSIGMA_BUILD_DOC=OFF ../'
alias cmake_rocky_re_asan='cmake -D ROCKY_BUILD=true -D CMAKE_BUILD_TYPE=Release -D BUILD_EXTERNAL_IFCS=OFF -D SIGMA_BUILD_DOC=OFF -D SIGMA_SANITIZER:STRING=asan'

alias cmake_deb_arm_de='cmake -D CMAKE_TOOLCHAIN_FILE=../toolchains/ubuntuArm.cmake -D CMAKE_BUILD_TYPE=Debug -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'
alias cmake_deb_arm_re='cmake -D CMAKE_TOOLCHAIN_FILE=../toolchains/ubuntuArm.cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'

alias cmake_jet_de='cmake -D CMAKE_TOOLCHAIN_FILE=../toolchains/jetpack5.cmake -D CMAKE_BUILD_TYPE=Debug -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'
alias cmake_jet_re='cmake -D CMAKE_TOOLCHAIN_FILE=../toolchains/jetpack5.cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'

# ROS
alias ros_load='source /opt/ros/iron/setup.bash && export ROS_DOMAIN_ID=0'

# Proton Tricks
# export PROTON_HOME="$HOME/.local/share/Steam/steamapps/common/Proton - Experimental"
# export WINE="$PROTON_HOME/files/bin/wine"
# export WINESERVER="$PROTON_HOME/files/bin/wineserver"
# export WINEPREFIX="$HOME/.local/share/Steam/steamapps/compatdata/230410/pfx"
alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'

# Save building
function safeMake () (
  # ----- defaults -----
  local jobs=8  #(nproc)
  local softLimit=0.75
  local hardLimit=0.85
  dryRun=false
  local -a targets=()

  # ----- help message -----
  function usage() {
    echo "============================================================================="
    echo "Safe Make: Kill your build before your build kills you …"
    echo "============================================================================="
    echo "Usage:  safeMake [OPTIONS] [target ...]"
    echo
    echo "Options:"
    echo "  -h, --help            Show this help"
    echo "  -j, --jobs N          Number of parallel jobs (default: ${jobs})"
    echo "  -l, --soft-limit F    RAM % at which throttling starts (default: ${softLimit})"
    echo "  -L, --hard-limit F    RAM % at which the build is aborted (default: ${hardLimit})"
    echo "  -d, --dry-run         Don't run, just generate the final command (default: ${dryRun})"
    echo
    echo "target ...              Optional make target(s) (install, package, …)"
    echo
    echo "Example: safeMake -j8 --soft-limit ${softLimit} --hard-limit ${hardLimit} install package"
  }

  # ----- argument parsing-----
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)  usage; return 0 ;;
      -d|--dry-run) dryRun=true; shift ;;
      -j | --jobs)
        [[ $2 && $2 != -* ]] || { echo "Error: --jobs needs a positive integer" >&2; return 1; }
        [[ $2 =~ ^[0-9]+$ ]]   || { echo "Error: --jobs must be an integer" >&2; return 1; }
        jobs=$2; shift 2
        ;;
      -j[0-9]*)  # Compact form ( -j8 vs -j 8 )
        local val=${1#-j}
        [[ $val =~ ^[0-9]+$ ]] || { echo "Error: -j expects an integer (got ‘$val’)" >&2; return 1; }
        jobs=$val; shift
        ;;
      -l | --softLimit)
        [[ $2 && $2 != -* ]] || { echo "Error: --soft-limit needs a float" >&2; return 1; }
        [[ $2 =~ ^0(\.[0-9]+)?$|^1(\.0*)?$ ]] || { echo "Error: --soft-limit must be between 0 and 1" >&2; return 1; }
        softLimit=$2; shift 2
        ;;
      -l[0-9]*| -l[0-9]*\.*[0-9]*) # Compact form ( -l0.7 vs -l 0.7 )
        local val=${1#-l}
        [[ $val =~ ^0(\.[0-9]+)?$|^1(\.0*)?$ ]] || { echo "Error: -l expects a float in [0,1] (got ‘$val’)" >&2; return 1; }
        softLimit=$val; shift
        ;;
      -L | --hardLimit)
        [[ $2 && $2 != -* ]] || { echo "Error: --hard-limit needs a float" >&2; return 1; }
        [[ $2 =~ ^0(\.[0-9]+)?$|^1(\.0*)?$ ]] || { echo "Error: --hard-limit must be between 0 and 1" >&2; return 1; }
        hardLimit=$2; shift 2
        ;;
      -L[0-9]*| -L[0-9]*\.*[0-9]*) # Compact form ( -L0.9 vs -L 0.9 )
        local val=${1#-L}
        [[ $val =~ ^0(\.[0-9]+)?$|^1(\.0*)?$ ]] || { echo "Error: -L expects a float in [0,1] (got ‘$val’)" >&2; return 1; }
        hardLimit=$val; shift
        ;;
      # Catch any other extra flags
      -*) echo "Error: unknown option \"$1\"" >&2; usage; return 1 ;;
      # Anything else is a make target, store it in an array.
      *) targets+=( "$1" ); shift ;;
    esac
  done

  # the soft limit must be strictly smaller than the hard limit
  if (( $(awk 'BEGIN{print ('"$softLimit"'>='"$hardLimit"')}') )); then
    echo "Error: --soft-limit ($softLimit) must be < --hard-limit ($hardLimit)" >&2
    return 1
  fi

  # calculate RAM limits
  local maxRAM=$(free -g | awk '/Mem:/ {print $2}')
  local softRamLimit=$(echo "scale=0; $maxRAM * $softLimit / 1" | bc)
  local hardRamLimit=$(echo "scale=0; $maxRAM * $hardLimit / 1" | bc)

  # compose the actual make command 
  local -a makeCmd=(make -j"$jobs")
  if ((${#targets[@]})); then
    makeCmd+=( "${targets[@]}" )
  fi

  # exit early of dryRun==true 
  if $dryRun; then
    echo "[DRY-RUN] Would execute:"
    echo "sudo systemd-run --scope -p MemoryHigh=${softRamLimit}G -p MemoryMax=${hardRamLimit}G" "${makeCmd[@]}"
    return 0
  fi

  # else, do the thing
  sudo systemd-run --scope -p MemoryHigh=${softRamLimit}G -p MemoryMax=${hardRamLimit}G "${makeCmd[@]}"
)
