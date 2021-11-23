# ikfast_setup (for ubuntu 20.04 and ros2)
>1.&ensp;Install 3 ros2 packages.&emsp;[collada_parser,&ensp;collada_urdf](https://github.com/WSH95/collada_urdf/tree/port_to_ros2),&ensp;[urdf_parser_plugin](https://github.com/ros2/urdf).  
&emsp;&emsp;Convert urdf file to dae file.  

```bash
ros2 run collada_urdf urdf_to_collada ${URDF_FILE_NAME}.urdf ${URDF_FILE_NAME}.dae
```

>2.&ensp;Install OpenRAVE following [this](https://github.com/crigroup/openrave-installation).  
&emsp;&emsp;Generate IK cpp file from .dae file.

```bash
python `openrave-config --python-dir`/openravepy/_openravepy_/ikfast.py --robot=${URDF_FILE_NAME}.dae --iktype=translation3d --baselink=0 --eelink=4 --savefile=ikfast_${URDF_FILE_NAME}.cpp
```

>3.&ensp;Copy the &nbsp;"ikfast.h"&nbsp; file to current directory. Then build and generate corresponding executable file and shared library.

```bash
cp /usr/local/lib/python2.7/dist-packages/openravepy/_openravepy_/ikfast.h .

g++ ikfast_${URDF_FILE_NAME}.cpp -o ikfast_${URDF_FILE_NAME} -llapack -std=c++11

g++ -fPIC -lstdc++ -DIKFAST_NO_MAIN -DIKFAST_CLIBRARY -shared -Wl,-soname,ikfast_${URDF_FILE_NAME}.so -o ikfast_${URDF_FILE_NAME}.so ikfast_${URDF_FILE_NAME}}.cpp
```

>4.&ensp;Test...  
&emsp;&nbsp;for end position (X, Y, Z):
```bash
./ikfast_${URDF_FILE_NAME} 0 0 0 X 0 0 0 Y 0 0 0 Z
```