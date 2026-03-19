#!/bin/bash
# 1. Get the code
git submodule update --init --recursive

# 2. Install system dependencies (the user just hits 'Y')
sudo apt update
rosdep update
rosdep install --from-paths src --ignore-src -r -y

# 3. Build everything
colcon build --symlink-install
source install/setup.bash

echo "Build complete. Ready to launch."