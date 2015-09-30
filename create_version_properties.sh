#!/bin/bash

# The OpenCms Version number.
#
# If this script is used in the build process, 
# you need to change the version number only here and no where else.
# It can be accessed in OpenCms by OpenCms.getSystemInfo().getVersionNumber().
#
OPENCMS_VERSION_NUMBER="${OpenCmsNumber:-9.0.x}"
OPENCMS_VERSION_NUMBER="${OpenCmsVersionNumber:-$OPENCMS_VERSION_NUMBER}"

#
# The type of build generated.
#
# Values used in the test cases are:
# "Release" for a release build
# "Beta" for a bet build
# "Nightly" for a nightly build
# "Milestone" for a milestone build
# "Manual" for a manual triggered build
# "Auto" for an automated CI build
#
OPENCMS_BUILD_TYPE="${OpenCmsBuildType:-Manual}"

#
# The build system that was used.
#
OPENCMS_BUILD_SYSTEM="${OpenCmsBuildSystem:-Jenkins}"

# The output path/filename where the properties are written.
# 
# The idea of this script is as follows:
# In the RCS there is a 'static' variation of the version properties.
# If this script is used, the 'static' file from the RCS will 
# be replaced by a dynamically generated version that contains
# more detailed information about the build.
# 
if [ -d "$WORKSPACE/opencms" ]; then
    OUTPUT_BASE="$WORKSPACE/opencms"
else 
    OUTPUT_BASE="$WORKSPACE/opencms-core"
fi

if [ ! -d "$OUTPUT_BASE" ]; then
    echo "Error: Workspace '$OUTPUT_BASE' not found!"
    exit 1 
fi

OUTPUT_FILE="$OUTPUT_BASE/src/org/opencms/main/version.properties"

#
# Variables set by the CI/build system.
#
# These will be provided to OpenCms as list of variables that 
# can be accessed by OpenCms.getSystemInfo().getBuildInfo().
#
JENKINS_BUILD_NUMBER="${JENKINS_BUILD_NUMBER:-#$BUILD_NUMBER}"
OPENCMS_BUILD_NUMBER="${JENKINS_BUILD_NUMBER:-Unknown}"
OPENCMS_BUILD_DATE=$(date +"%Y-%m-%d %H:%M")
GIT_COMMIT="${GIT_COMMIT:-Unknown}"
OPENCMS_GIT_ID="${GIT_COMMIT:0:7}"
OPENCMS_GIT_BRANCH="${GIT_BRANCH:-Unknown}"
OPENCMS_GIT_BRANCH_SHOWN="${OpenCmsGitBranchShown:-$OPENCMS_GIT_BRANCH}"

#
# The OpenCms version ID.
#
# This is a condensed String from the variables set above.
# It can be accessed in OpenCms by OpenCms.getSystemInfo().getVersionId().
#
OPENCMS_VERSION_ID="$OPENCMS_BUILD_TYPE $OPENCMS_BUILD_NUMBER ($GIT_BRANCH_SHOWN - $OPENCMS_GIT_ID) $OPENCMS_BUILD_DATE"


#
# Echo some info to the console.
#
echo "# "
echo "# OpenCms Version Information:"
echo "# "
echo "# Build Type      : $OPENCMS_BUILD_TYPE"
echo "# Build System    : $OPENCMS_BUILD_SYSTEM"
echo "# Build Number    : $OPENCMS_BUILD_NUMBER"
echo "# Version Number  : $OPENCMS_VERSION_NUMBER"
echo "# Version ID      : $OPENCMS_VERSION_ID"
echo "# Version File    : $OUTPUT_FILE"
echo "# Git commit      : $OPENCMS_GIT_ID"
echo "# Git branch      : $OPENCMS_GIT_BRANCH"
echo "# Git branch shown: $OPENCMS_GIT_BRANCH_SHOWN"
echo "# "

#
# Generate the output file.
#
echo "# " > "$OUTPUT_FILE"
echo "# OpenCms version information." >> "$OUTPUT_FILE"
echo "# Automatically generated by Jenkins build." >> "$OUTPUT_FILE"
echo "# " >> "$OUTPUT_FILE"
#
echo "version.number=$OPENCMS_VERSION_NUMBER" >> "$OUTPUT_FILE"
echo "version.id=$OPENCMS_VERSION_ID" >> "$OUTPUT_FILE"
if [ $OPENCMS_BUILD_TYPE != "Milestone" ]; then
    echo "build.number=$OPENCMS_BUILD_NUMBER" >> "$OUTPUT_FILE"
fi
echo "build.date=$OPENCMS_BUILD_DATE" >> "$OUTPUT_FILE"
echo "build.type=$OPENCMS_BUILD_TYPE" >> "$OUTPUT_FILE"
echo "build.system=$OPENCMS_BUILD_SYSTEM" >> "$OUTPUT_FILE"
echo "build.gitid=$OPENCMS_GIT_ID" >> "$OUTPUT_FILE"
echo "build.gitbranch=$OPENCMS_GIT_BRANCH_SHOWN" >> "$OUTPUT_FILE"
#
# Nice names for the build information (optional).
#
if [ $OPENCMS_BUILD_TYPE != "Milestone" ]; then
    echo "nicename.build.number=Build Number" >> "$OUTPUT_FILE"
fi    
echo "nicename.build.date=Build Date" >> "$OUTPUT_FILE"
echo "nicename.build.type=Build Type" >> "$OUTPUT_FILE"
echo "nicename.build.system=Build System" >> "$OUTPUT_FILE"
echo "nicename.build.gitid=Git Commit ID" >> "$OUTPUT_FILE"
echo "nicename.build.gitbranch=Git Branch" >> "$OUTPUT_FILE"
