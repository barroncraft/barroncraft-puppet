MCDIR=/home/minecraft
RESETFILE=$MCDIR/server/reset-required
STARTFILE=$MCDIR/server/auto-start
MCSCRIPT=$MCDIR/bin/minecraft.sh

# If the server writes out a 'reset-required' file, reset the server
if [ -e $RESETFILE ]; then
    touch $STARTFILE
    rm -f $RESETFILE
    $MCSCRIPT reset

# There have been issues with the server sometimes not coming back online
# after a reset.  This is a safty measure to make sure that an error during
# the reset won't prevent it from coming back online.
elif [ -e $STARTFILE ]; then
    $MCSCRIPT start
fi
