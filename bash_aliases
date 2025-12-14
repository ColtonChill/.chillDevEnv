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
alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'
