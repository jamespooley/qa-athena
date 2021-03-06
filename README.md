# qa-athena
Quality assessment of Athena pipeline applied to the Athena pipeline-processed ADHD-200 Sample

### Instructions

* Place `generate_qc_report.sh` in a directory with all the structural and functional images and `<YOUR FIRST NAME>.txt`, a file that contains the IDs of the images you've been assigned (randomly by `assign_images.py`) to rate. [**NB: This code only accounts for images from session/scan 1/1, not, e.g., session/scan 1/2 or 2/1.**] You'll need to `cp` the files into whatever directory you run the script from. The files needed for everything to run properly include the following:
  1. Structural files: `wssd*_session_session_1_anat.nii.gz`
  2. Functional files: `wmean_mrda*_session_1_rest_scan_1.nii.gz`
  3. Anatomical template file: Symbolic link to FSL's file for the MNI152 template or a copy of the MNI152 template. [NB: Improving how this is done is on my TODO list.]
* `$ chmod 755 generate_qc_report.sh`
* `$ ./generate_qc_report.sh <YOUR FIRST NAME>.txt`
* Rate the quality of structural and functional coregistration of the Athena pipeline-processed images using  [this](https://github.com/SIMEXP/niak_manual/blob/master/qc_manual_v1.0/qc_manual_niak.pdf) document as your guide. Windows were cluttered and difficult to track on my screen when I was giving this a test run. So instead of opening windows with sagittal/axial/coronal views for both the structural and functional coregistrations, I recommend using the buttons on your A and B controllers (controlling the functional and structural coregistration images, respecitively; see screenshot below) to switch between views. By default, the script displays the sagittal view.
![Image of AFNI controller](afni-controller.png)
* **NB: Do not exit the program after starting it! Currently, you can't restart the program and continue where you left off. When you want to take a break, just leave the program running. See item 1 on my TODO list below. If you do exit and but don't feel like doing everything all over again, an inelegant but effective solution would be to see the last subject ID number on your `qc_report_<YOUR FIRST NAME>.csv` output file, manually edit the `<YOUR FIRST NAME>.txt` input file, and go from there. A better solution is to just set up an x2go session and close the window (but don't log out) when you want a break. Instructions for setting everything up are [here](https://cmi.hackpad.com/Installing-and-Configuring-x2go-Rdf2mMYbjMu).**

### Data

You can download and read about the data [here](http://www.nitrc.org/plugins/mwiki/index.php/neurobureau:AthenaPipeline). If you want even more detail/context, there's a [preprint](http://biorxiv.org/content/biorxiv/early/2016/01/17/037044.full.pdf) describing the ADHD-200 Sample preprocessed repository.

### AFNI Stuff

* [Driving AFNI from a plugout or a startup script](https://afni.nimh.nih.gov/pub/dist/doc/program_help/README.driver.html)
* [Unix environment variables used by AFNI](https://afni.nimh.nih.gov/pub/dist/doc/program_help/README.environment.html)
* [plugout_drive](https://afni.nimh.nih.gov/pub/dist/doc/program_help/plugout_drive.html)

### TODO

With all due respect to the wise man who said "Don't Let the Perfect Be the Enemy of the Good," this code is not user-friendly and much needs to be done. In particular:
* Add functionality so that raters can pause and come back to rating and not have to start at beginning
* Split up the structural and functional coregistration QA?
* Take out all the hardcoded stuff so code is shareable/reusable/etc.


