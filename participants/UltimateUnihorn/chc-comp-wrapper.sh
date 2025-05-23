#!/bin/sh
if [ ! "$1" ]; then
    echo "First argument has to be the file that we analyze"
    exit
fi

if [ ! "$2" ]; then
    echo "No Second argument! On StarExec, the second argument is an absolute path to a directory in which we can write output for debugging. If you run this script on you machine the second argument has to be an absolute path to some directory with write access."
    exit
fi

# note this is not used at the moment, except for the check below
# mem=$((STAREXEC_MAX_MEM - 4096))
# 
# if [[ $mem -le 0 ]]; then
#     echo "star exex max memory (expected: in Mbyte) is $STAREXEC_MAX_MEM and is smaller than 4096"
#     exit 1
# fi



# pushd ../Ultimate > /dev/null
java  -Dosgi.configuration.area=config/  -Xmx32000M -Xss4m -jar "./Ultimate/plugins/org.eclipse.equinox.launcher_1.6.800.v20240513-1750.jar"  -data "$TMPDIR" -tc "./AutomizerCHC.xml" -s "./chccomp-Unihorn_Default.epf" -i "$1" | tee "$2"/output.txt
# popd > /dev/null

RESULT_UNSAFE=`cat "$2"/output.txt | grep "CounterExampleResult"`
RESULT_SAFE=`cat "$2"/output.txt | grep "PositiveResult"`
RESULT_UNKNOWN_EXCEPTION=`cat "$2"/output.txt | grep "The toolchain threw an exception"`

if [ "$RESULT_SAFE" ]; then
	echo "sat"
	exit
fi
    
if [ "$RESULT_UNSAFE" ]; then
	echo "unsat"
	exit
fi
    
echo "unknown"
echo ""
# cat "$2"/output.txt
