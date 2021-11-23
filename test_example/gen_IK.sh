#/bin/bash

. /home/wsh/Documents/myRosProj/test_ws/install/setup.bash

function func1()
{
#   if [ "${1##*.}" = "urdf" ]; then
  if [ -f $1 ]; then
    echo "found $1"
    local name=${1%.*}
    if [ -d $name ]; then
      rm -rf $name
    fi
    mkdir -p $name && cd $name
    ros2 run collada_urdf urdf_to_collada ../$name.urdf $name.dae
    python `openrave-config --python-dir`/openravepy/_openravepy_/ikfast.py --robot=$name.dae --iktype=translation3d --baselink=0 --eelink=4 --savefile=ikfast_$name.cpp
    cp /usr/local/lib/python2.7/dist-packages/openravepy/_openravepy_/ikfast.h .
    g++ ikfast_$name.cpp -o ikfast_$name -llapack -std=c++11
    g++ -fPIC -lstdc++ -DIKFAST_NO_MAIN -DIKFAST_CLIBRARY -shared -Wl,-soname,ikfast_$name.so -o ikfast_$name.so ikfast_$name.cpp
    cd ..
  else
    echo "There is no $1 in current dir"
  fi
}

if [ $# -eq 0 ];then
  for file in $(ls *.urdf)
  do
    func1 ${file}
  done
else
  for i in "$@"
  do
    func1 "${i%.*}.urdf"
  done
fi
