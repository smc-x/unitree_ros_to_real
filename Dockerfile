FROM arm64v8/ros:melodic-perception-bionic

RUN apt-get update \
    && apt-get install -y g++-8 \
    && rm -rf /var/lib/apt/lists/* \
    && rm /usr/bin/gcc \
    && rm /usr/bin/g++ \
    && ln -s /usr/bin/gcc-8 /usr/bin/gcc \
    && ln -s /usr/bin/g++-8 /usr/bin/g++

RUN git clone --depth 1 -b v1.4.0 https://github.com/lcm-proj/lcm \
    && cd lcm \
    && mkdir build && cd build \
    && cmake .. && make \
    && make install \
    && ldconfig \
    && rm -rf lcm

RUN apt-get update \
    && apt-get install -y tmux \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/catkin_ws/src/unitree_ros_to_real
RUN cd /root/catkin_ws/src \
    && git clone --depth 1 -b devel https://github.com/smc-x/unitree_legged_sdk
COPY ./unitree_legged_msgs /root/catkin_ws/src/unitree_ros_to_real/unitree_legged_msgs
COPY ./unitree_legged_real /root/catkin_ws/src/unitree_ros_to_real/unitree_legged_real
RUN /ros_entrypoint.sh bash -c "cd /root/catkin_ws && catkin_make"

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
