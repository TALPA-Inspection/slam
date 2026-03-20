import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource

def generate_launch_description():
    # 1. Path to your custom config
    config_file = os.path.join(
        get_package_share_directory('my_configs'),
        'config',
        'zed_f9p.yaml'
    )

    # 2. Include the ORIGINAL ublox launch, but pass the config
    ublox_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(get_package_share_directory('ublox_gps'), 'launch', 'ublox_gps_node-launch.py')
        ),
        launch_arguments={
            'params_file': config_file
        }.items()
    )

    return LaunchDescription([
        ublox_launch
    ])
