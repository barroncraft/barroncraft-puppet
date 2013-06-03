MCDIR=/home/minecraft
RESETFILE=$MCDIR/server/reset-required

if [ -e $RESETFILE ]; then
    $MCDIR/bin/minecraft.sh reset
    rm -f $RESETFILE
fi
