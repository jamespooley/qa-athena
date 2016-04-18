# qa-athena
Quality assessment of Athena pipeline applied to the Athena pipeline-processed ADHD-200 Sample

### Usage

* Place `generate_qc_report.sh` in a directory with all the structural and functional images and `<YOUR FIRST NAME>.txt`, a file that contains the IDs of the images you've been assigned to rate.
* `$ chmod 755 generate_qc_report.sh`
* `$ ./generate_qc_report.sh <YOUR FIRST NAME>.txt`
* Grab your favorite beverage, sit back and relax, and start rating the quality of structural and functional coregistration of the Athena pipeline-processed images.

### Data

Download the and read about data [here](http://www.nitrc.org/plugins/mwiki/index.php/neurobureau:AthenaPipeline)

### AFNI Stuff

* [Driving AFNI from a plugout or a startup script](https://afni.nimh.nih.gov/pub/dist/doc/program_help/README.driver.html)
* [Unix environment variables used by AFNI](https://afni.nimh.nih.gov/pub/dist/doc/program_help/README.environment.html)
* [plugout_drive](https://afni.nimh.nih.gov/pub/dist/doc/program_help/plugout_drive.html)

### Other Resources

If you want a preprint describing the ADHD 200 Sample preprocessed repository in more detail, click [here](http://biorxiv.org/content/biorxiv/early/2016/01/17/037044.full.pdf)

### TODO

With all due respect to the wise man who said "Don't Let the Perfect Be the Enemy of the Good," this code is currently **very, very bad** and much needs to be done. In particular:
* Take out all the hardcoded stuff so code is shareable/reusable/etc.
* Add functionality so that raters can pause and come back to rating and not have to start at beginning
* Learn *a lot* more about AFNI ... and neuroimaging. Quickly. That would be nice. Example: AFNI is currently giving me problems with reading symbolic links to the relevant images, so a lot of inefficient copying of data is happening. Don't know why AFNI is doing this.
* etc.


