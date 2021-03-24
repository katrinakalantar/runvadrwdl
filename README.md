# runvadrwdl
wdl to run vadr module

First, clone the repo:

```
git clone https://github.com/katrinakalantar/runvadrwdl.git
```

Then, build the docker image:

```
docker build -t vadr-img runvadrwdl
```

We then use the docker image to run the pipeline as follows:

Here we run it for a single test sample (one file within a .fasta)

```
miniwdl run --verbose runvadrwdl/run.wdl docker_image_id=vadr-img assembly=runvadrwdl/test_files/EPI_ISL_869155.consensus.fasta
```


We can also run it with a .fasta files containing multiple inputs:

```
miniwdl run --verbose runvadrwdl/run.wdl docker_image_id=vadr-img assembly=runvadrwdl/test_files/test_multiple_assemblies.fasta
```


The resulting outputs are as follows:
Note, when running this workflow with an input file containing a single sequence, you will see one line in the outputs. When running with an input file containing multiple sequences, there should be one line per sequence in the .sqc file.

out/Vadr.vadr_quality/vadr-output.vadr.sqc - the .sqc file format is outlined here: https://github.com/ncbi/vadr/blob/master/documentation/formats.md#sqc

```
#seq  seq                            seq                                      sub                           seq    mdl         num                     sub   score  diff/  seq   
#idx  name                           len  p/f   ant  model1     grp1          grp1          score  sc/nt    cov    cov  bias  hits  str  model2  grp2  grp2   diff     nt  alerts
#---  ---------------------------  -----  ----  ---  ---------  ------------  ----------  -------  -----  -----  -----  ----  ----  ---  ------  ----  ----  -----  -----  ------
1     EPI_ISL_869155/ARTIC/medaka  29903  PASS  yes  NC_045512  Sarbecovirus  SARS-CoV-2  55171.0  1.845  1.000  1.000     0     1    +  -       -     -         -      -  N_AT_START(ambgnt5s),N_AT_END(ambgnt3s)
```

out/Vadr.vadr_alerts/vadr-output.vadr.alt.list - the .alt.list file format is outlined here: https://github.com/ncbi/vadr/blob/master/documentation/formats.md#altlist

```
#sequence       error   feature error-description
```


More info on VADR warnings can be found in their manuscript here: https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-020-3537-3/tables/3 

