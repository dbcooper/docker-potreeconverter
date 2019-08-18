#!/bin/bash

# Modified for docker-potreeconverter build configuration.
#
# Execute in /root/PotreeConverter/Release

testPath="../test"
exe="PotreeConverter/PotreeConverter"

# test all inputs

# XXX  As of 2019-08-18, this build of PotreeConverter segfaults on
#      ripple.ptx.  Might be related to
#      https://github.com/potree/PotreeConverter/issues/265 ?  Possibly
#      fixed by https://github.com/NextDroid/PotreeConverter/pull/12 ?

for i in $( ls "${testPath}/resources" )
do
   echo -e "\n    ⇒ $exe  -i "${testPath}/resources/$i" -o "${testPath}/converted" --generate-page -l 3 -s 0.5 --overwrite\n"
   $exe -i "${testPath}/resources/$i" -o "${testPath}/converted" --generate-page -l 3 -s 0.5  --overwrite
done

# test single input
echo -e "\n    ⇒ $exe -i "${testPath}/resources/ripple.pts" -o "${testPath}/converted" --generate-page -l 3 -s 0.5 --overwrite\n"
$exe -i "${testPath}/resources/ripple.pts" -o "${testPath}/converted" --generate-page -l 3 -s 0.5 --overwrite
