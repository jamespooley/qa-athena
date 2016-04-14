#!/bin/bash

# set -e
# set -o
# set -u pipefail

OUTPUT_DIR=~/Desktop

if [ $# -ne 1 ]; then
  echo ""
  echo "ERROR: MISSING INPUT"
  echo "  Usage: $0 <YOUR NAME>"
  echo ""
  exit 1
fi

RATER=$1
SESSIONS=$2 # DON'T USE THIS YET

MNI152=avg152T1_brain.nii.gz

#ln -s /usr/share/fsl/5.0/data/standard/avg152T1.nii.gz .  # Brain + skull
#ln -s /usr/share/fsl/5.0/data/standard/avg152T1_brain.nii.gz . # Skull-stripped

# TODO: Better way to do this ...
anat_files=($(find . -name "wssd*anat.nii.gz" | sort))
func_files=($(find . -name "wmean*" | sort))

n_imgs=${#anat_files[@]}

afni -yesplugouts &> /dev/null &

# TODO: Replace hardcoded path
printf "%s\n" id status anat func | paste -sd "," > \
  ${OUTPUT_DIR}/qc_report_${RATER}.csv 

for (( i=0; i<$n_imgs; i++ )); do  # TODO: Make this better

  plugout_drive -com "OPEN_WINDOW A.axialimage geom=800x800+416+344" \
                -com "SWITCH_UNDERLAY A.$(basename ${anat_files[$i]})" \
                -com "CLOSE_WINDOW A.sagittalimage" \
                -com "SWITCH_OVERLAY A.$(basename ${func_files[$i]})" \
                -com "SEE_OVERLAY A.+" \
                -com "OPEN_WINDOW B.sagittalimage geom=800x800+416+344" \
                -com "SWITCH_UNDERLAY B.$(basename ${anat_files[$i]})" \
                -com "SWITCH_OVERLAY B.$MNI152" \
                -com "SEE_OVERLAY B.+" \
                -quit

  echo "TODO: Make user progress updates more informative/prominent"
  echo "--------------------------------------------------------------------"
  echo ""
  echo "Enter general assessment of coregistration quality [OK/Maybe/Failed]"
  echo -n "for image $((i+1)) of $n_imgs: "
  read quality
  echo ""

  anat=""
  func=""

  # Prompt user to enter additional information if coregistration quality not
  # rated "OK"
  if [ "${quality^^}" != "OK" ]; then
    
    # TODO: heredoc this and put it in a function??
    echo "You indicated there was a problem with coregistration. Please provide"
    echo "additional information. Here is a list of suggested annotations:"
    echo ""
    echo "     SL+: large signal loss. This is typically observed in the" 
    echo "          orbito-frontal cortex and the temporal pole." 
    echo "     BET: problem with brain extraction (BET+ brain too large," 
    echo "          BET- brain too small, BET)" 
    echo "     ABN: brain abnormality (ranges from calcifications to tumors,"
    echo "          lesions, etc)"
    echo "     VENT: ventricles not properly aligned (either too small VENT- or"
    echo "           too big VENT+)."
    echo "     ATR: general brain atrophy"
    echo "     GHO: ghosting"
    echo "     MOT: motion artefacts" 
    echo "     ART: miscallenous types of artefacts (e.g. big ripples in the"
    echo "          middle of the brain)"
    echo "     FOV: field of view problem (mention the brain part affected and"
    echo "          the severity by minor, medium, big)"
    echo "     TILT: BOLD image is too tilted forward than the T1 scan." 
    echo "     MR: Generic misregistration between the BOLD and T1 scans."
    echo ""

    echo -n "Enter any comments on quality of ANATOMICAL coregistration: "
    read anat
    echo ""

    echo -n "Enter any comments on quality of FUNCTIONAL coregistration: "
    read func
    echo ""

  fi

  printf "%s\n" "sub_00$i" "${quality^^}" "${anat^^}" "${func^^}" | paste -sd "," \
    >> ${OUTPUT_DIR}/qc_report_${RATER}.csv
  prompt_user -pause "Click OK to move to next image"

done

plugout_drive -com "QUIT" \
              -quit
