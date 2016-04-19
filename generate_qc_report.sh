#!/bin/bash

# set -e
# set -u
# set -o pipefail

assignments_file=$1
rater=$(basename $assignments_file .txt)

QA_REPORT_DIR=$PWD/report
MNI152=avg152T1.nii.gz

assignments=($(cut -f 1 $assignments_file))
n_images=${#assignments[@]}

afni -yesplugouts &> /dev/null &

if [ ! -d $QA_REPORT_DIR ]; then
  mkdir -p $QA_REPORT_DIR
fi

if [ ! -f $MNI152 ]; then
  ln -s /usr/share/fsl/5.0/data/standard/avg152T1.nii.gz .
fi

if [ ! -f ${OUTPUT_DIR}/qc_report_${rater}.csv ]; then
  echo ""
  echo "Creating spreadsheet for QA ratings and comments"
  echo ""
  printf "%s\n" id status anat func | paste -sd "," > \
    ${QA_REPORT_DIR}/qc_report_${rater}.csv
else
  echo ""
  echo "QA report spreadsheet already exists! Creating backup copy"
  echo "before overwriting..."
  echo ""
  cp ${QA_REPORT_DIR}/qc_report_${rater}.csv \
     ${QA_REPORT_DIR}/qc_report_${rater}_incomplete.csv
fi


for subject_id in ${assignments[@]}; do

  anat_file="wssd${subject_id}_session_1_anat.nii.gz"
  func_file="wmean_mrda${subject_id}_session_1_rest_1.nii.gz"

  # NB: QA script only deals with session/scan 1/1. Not dealing with repeat
  # functional scans at all.
  if [ -f $anat_file ] && [ -f $func_file ]; then

	  plugout_drive -com "OPEN_WINDOW A.axialimage geom=800x800+416+344" \
	                -com "SWITCH_UNDERLAY A.$(basename $anat_file)" \
	                -com "CLOSE_WINDOW A.sagittalimage" \
	                -com "SWITCH_OVERLAY A.$(basename $func_file)" \
	                -com "SEE_OVERLAY A.+" \
	                -com "SET_PBAR_ALL A.-99 1.0 Spectrum:yellow_to_cyan+gap" \
	                -com "OPEN_WINDOW B.sagittalimage geom=800x800+416+344" \
	                -com "SWITCH_UNDERLAY B.$MNI152" \
	                -com "SWITCH_OVERLAY B.$(basename $anat_file)" \
	                -com "SEE_OVERLAY B.+" \
	                -com "SET_PBAR_ALL B.-99 1.0 Spectrum:yellow_to_cyan+gap" \
	                -quit

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
	    
	    # TODO: here doc this
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

      # Write quality assessment to rater's output file.
	  printf "%s\n" "$subject_id" "${quality^^}" "${anat^^}" "${func^^}" | paste -sd "," \
	    >> ${QA_REPORT_DIR}/qc_report_${rater}.csv
	  prompt_user -pause "Click OK to move to next image"

	fi

done
