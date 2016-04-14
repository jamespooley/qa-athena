# qa-athena
Quality assessment of Athena pipeline applied to ADHD 200 Sample

### Data

Download the data [here](http://www.nitrc.org/plugins/mwiki/index.php/neurobureau:AthenaPipeline)

### AFNI Stuff

* [Driving AFNI from a plugout or a startup script](https://afni.nimh.nih.gov/pub/dist/doc/program_help/README.driver.html)
* [Unix environment variables used by AFNI](https://afni.nimh.nih.gov/pub/dist/doc/program_help/README.environment.html)
* [plugout_drive](https://afni.nimh.nih.gov/pub/dist/doc/program_help/plugout_drive.html)

### Other Resources

If you want a preprint describing the ADHD 200 Sample preprocessed repository in more detail, click [here](http://biorxiv.org/content/biorxiv/early/2016/01/17/037044.full.pdf)

### TODO

This code is currently **very, very bad** and much needs to be done. In particular:
* Take out all the hardcoded stuff so code so code is sharable/reusable/etc.
* Make backup copy of qa report CSV file before overwriting
* Add functionality so that raters can pause and come back to rating and not have to start at beginning
* Read in file of images to be rated as opposed to reading everything in current directory
* Learn *a lot* more about AFNI ... and neuroimaging. That would be helpful.
* etc.


