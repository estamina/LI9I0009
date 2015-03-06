## Testset configuration:
##

# Checking testbed argument
CHECK_VAR IRS_TESTBED_1

# Definition of common arguments
DEF_STD_ARG --testbed="$IRS_TESTBED_1"
DEF_STD_ARG --colors=0
DEF_STD_ARG --concept=3
DEF_STD_ARG --testsegment=LI
DEF_STD_ARG --testgroup=09_ECSCF
DEF_STD_ARG --timeout-multiplier=2


# Additional options
if [ "${IRS_OPTIONS:-0}" != 0 ]; then
	DEF_STD_ARG "$IRS_OPTIONS"
fi


# Flush SAD before each testcase execution
# default off
if [ "${IRS_FLUSH_SAD:-0}" = 1 ]; then
	DEF_ADD_ARG "FLUSH_SAD=1"
fi


##### RUN our testcases ######
DEF_STD_ARG --testcase=LI9I0009
DEF_ADD_ARG RUN_STEP=0
if RUN; then
  DEF_STD_ARG --testsegment=AN
  DEF_STD_ARG --testgroup=05_Emergency_calls_for_FT
  DEF_STD_ARG --testcase=AN5I0201
  DEF_ADD_ARG "OMIT_RESTORE=1"
  DEF_ADD_ARG "OMIT_SET=1"
  if RUN; then
    DEF_ADD_ARG "FLUSH_SAD=1"
    DEF_STD_ARG --testsegment=LI
    DEF_STD_ARG --testgroup=09_ECSCF
    DEF_STD_ARG --testcase=LI9I0009
    DEF_ADD_ARG RUN_STEP=2
    RUN
  fi
fi
