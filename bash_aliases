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
alias vi='nvim'
alias vim='nvim'

# Sigma Building
alias cmake_deb_de='cmake -D DEBIAN_BUILD=true -D ENABLE_JSON=on -D CMAKE_BUILD_TYPE=Debug -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'
alias cmake_deb_re='cmake -D DEBIAN_BUILD=true -D ENABLE_JSON=on -D CMAKE_BUILD_TYPE=Release -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'

alias cmake_deb_arm_de='cmake -D CMAKE_TOOLCHAIN_FILE=../toolchains/ubuntuArm.cmake -D ENABLE_JSON=on -D CMAKE_BUILD_TYPE=Debug -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'
alias cmake_deb_arm_re='cmake -D CMAKE_TOOLCHAIN_FILE=../toolchains/ubuntuArm.cmake -D ENABLE_JSON=on -D CMAKE_BUILD_TYPE=Release -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'

alias cmake_jet_de='cmake -D CMAKE_TOOLCHAIN_FILE=../toolchains/jetpack5.cmake -D ENABLE_JSON=on -D CMAKE_BUILD_TYPE=Debug -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'
alias cmake_jet_re='cmake -D CMAKE_TOOLCHAIN_FILE=../toolchains/jetpack5.cmake -D ENABLE_JSON=on -D CMAKE_BUILD_TYPE=Release -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ../'

# ROS
alias ros_load='source /opt/ros/iron/setup.bash && export ROS_DOMAIN_ID=0'
