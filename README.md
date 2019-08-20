docker-potreeconverter
======================

Yet another Docker container w/ PotreeConverter but using [more] explicit versioning.  Built using standalone LASzip and PotreeConverter repositories:

- https://github.com/LASzip/LASzip
- https://github.com/potree/PotreeConverter

Building
--------
To build (in directory w/ `Dockerfile`):

    docker build -t potree_test .

Testing
-------
To run the `test.sh` script in this repo

    docker run potree_test bash -c "cd /root/PotreeConverter/Release && ./test.sh"

Using
-----

Using PotreeConverter container to convert Lidar files.

### Windows
For this example, assume we have a Lidar file `c:\tmp\input\My Lidar.las` and we want to generate the PotreeConverter content in the `c:\tmp\converted` directory.  E.g., when finished the [main] PotreeConverter-generated HTML file will be in `c:\tmp\converted\My Lidar.html`.

*NOTE*: Your local drive `C:\` with Docker Desktop for this to work

    docker run -vc:/tmp/input:/data/input  -vc:/tmp/converted:/data/converted potree_test  bash -c "PotreeConverter 'input/My Lidar.las' -o 'converted' -p 'My Lidar'"

