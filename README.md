# docker-potreeconverter

Yet another Docker container w/ PotreeConverter but using [more] explicit versioning.  Built using standalone LASzip and PotreeConverter repositories:

- https://github.com/LASzip/LASzip
- https://github.com/potree/PotreeConverter

Building
--------
To build (in directory w/ `Dockerfile`):

    docker build -t potree_test .

Testing
-------
To run the `test.sh` script I bundled with this build

    docker run potree_test bash -c "cd /root/PotreeConverter/Release && ./test.sh"

Converting
----------

