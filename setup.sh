#!/bin/bash
# 1. Get the code
git submodule update --init --recursive

# --- 2. The Livox Driver "Surgery" ---
DRIVER_PATH="src/drivers/livox_ros_driver2"
if [ -d "$DRIVER_PATH" ]; then
    echo "🔧 Preparing Livox Driver for ROS 2..."
    cp $DRIVER_PATH/package_ROS2.xml $DRIVER_PATH/package.xml
fi

# --- 3. Environment Setup ---
# This helps the compiler find the SDK headers
export LIVOX_SDK2_PATH=$(pwd)/src/drivers/Livox-SDK2

# 4. Install system dependencies
rosdep update
rosdep install --from-paths src --ignore-src -r -y --skip-keys "ament_python"

# 5. Build Everything (The Sequential Way)
# --- 1. Build the SDK (The Foundation) ---
echo "--- Building SDK ---"
colcon build --symlink-install --packages-select livox_sdk2

# --- 2. Build ONLY the Message Headers (The Fix) ---
echo "--- Generating Livox Interfaces ---"
# This forces CMake to run the message generation target first
colcon build --symlink-install --packages-select livox_ros_driver2 \
    --cmake-args -DROS_EDITION=ROS2 -DLIVOX_SDK2_PATH=$LIVOX_SDK2_PATH \
    --cmake-target livox_ros_driver2__rosidl_typesupport_cpp

# --- 3. Build Everything Else (The Completion) ---
echo "--- Finalizing Build ---"
source install/setup.bash
# Now we build normally; the 'NOTFOUND' will disappear because the folder exists now
colcon build --symlink-install --allow-overriding livox_ros_driver2 \
    --cmake-args -DROS_EDITION=ROS2 -DLIVOX_SDK2_PATH=$LIVOX_SDK2_PATHDROS_EDITION=ROS2 -DLIVOX_SDK2_PATH=$LIVOX_SDK2_PATH

source install/setup.bash