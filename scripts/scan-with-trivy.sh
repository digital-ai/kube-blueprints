#!/bin/bash

EXPORT_TYPE="$1"

images=( $(cat -) )

BASE_OUTPUT_DIR="build/scanResults"
OUTPUT_DIR="${BASE_OUTPUT_DIR}/${EXPORT_TYPE}"
TRIVY_PROPS="--scanners vuln"
IGNORE_FIXED="--ignore-unfixed"

TRIVY_EXEC="docker run -u $(id -u):$(id -g) -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/$BASE_OUTPUT_DIR/caches:/root/.cache/ \
  -v $PWD/$BASE_OUTPUT_DIR/caches2:/.cache \
  --name scanner-trivy --rm aquasec/trivy"

rm -fr $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
mkdir -p $BASE_OUTPUT_DIR/caches
mkdir -p $BASE_OUTPUT_DIR/caches2
chmod -R 777 $BASE_OUTPUT_DIR

for image in "${images[@]}"
do
  filename="${image//\//_}"
  filename="${filename//\./_}"
  filename="${filename//:/_}${IGNORE_FIXED}.scan.txt"
  echo "===>>> Scaning: trivy image ${IGNORE_FIXED} \"${image}\" > \"${OUTPUT_DIR}/${filename}\""
  $TRIVY_EXEC image ${IGNORE_FIXED} ${TRIVY_PROPS} "${image}" | sed -r "s:\x1B\[[0-9;]*[mK]::g" > "${OUTPUT_DIR}/${filename}"
  if [ $? -ne 0 ]; then
    echo "***>>> Failed: trivy image ${IGNORE_FIXED} \"${image}\" > \"${OUTPUT_DIR}/${filename}\""
    # Continue work on missing images
  else
    echo "===>>> Finished: trivy image ${IGNORE_FIXED} \"${image}\" > \"${OUTPUT_DIR}/${filename}\""
  fi
done

echo ">>> Finished"

OVERVIEW="${OUTPUT_DIR}-overview${IGNORE_FIXED}.txt"
echo "--" > $OVERVIEW
date >> $OVERVIEW
echo "--" >> $OVERVIEW
$TRIVY_EXEC version >> $OVERVIEW
echo "--" >> $OVERVIEW
echo "Results ${IGNORE_FIXED}" >> $OVERVIEW
echo "--" >> $OVERVIEW
grep -B2 "Total:" ${OUTPUT_DIR}/*.scan.txt >> $OVERVIEW
