# R projects

install packges in Python console instead of in terminals:

```
import subprocess
import sys

def install(package):
    subprocess.call([sys.executable, "-m", "pip", "install", package])

install('h2o')
```    

keep the first observation in each group in `data.table`:

```
head = largeDT[, head(.SD, 3), cyl]
SD   = largeDT[, .SD[1:3], cyl]
I    = largeDT[largeDT[, .I[1:3], cyl]$V1]

Unit: relative
 expr      min       lq     mean   median       uq      max neval cld
 head 1.808732 1.917790 2.087754 1.902117 2.340030 2.441812    10   b
   SD 1.923151 1.937828 2.150168 2.040428 2.413649 2.436297    10   b
    I 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000    10  a
```


```
library(tidyverse)
df %>%
  mutate(b = ifelse(b == 2, 1, b),
             c = case_when(
                     c == 0 ~ 3,
                     c == 1 ~ 5,
                     TRUE ~ c
                      )
               )
```

The OSC code upon startup:

```
module load cxx17/7.3.0 intel/18.0.3
module load R/3.5.2
R
```

When using `tlmgr` to install LaTeX dependencies, the package name does not necessary be the same as the `.sty` file called in `\usepackage{}`. In that case, we can use the following code to find out the name of corresponding package names:

```
$ tlmgr search --global --file amssymb.sty
tlmgr: package repository http://ftp.math.purdue.edu/mirrors/ctan.org/systems/texlive/tlnet (not verified: gpg unavailable)
amsfonts:
    texmf-dist/tex/latex/amsfonts/amssymb.sty
kotex-oblivoir:
    texmf-dist/tex/latex/kotex-oblivoir/memhangul-x/xob-amssymb.sty
```

Then we can find out that `amsfonts` is the package you want to install using the `tlmgr` command. The above code is from [a GitHub issue](https://github.com/MareoRaft/MATH-Calc/issues/2)


Let Git delete all unpushed commits:

```
git reset origin/master
```

Dirichlet process in R/3

```
shiny::runGitHub('jasonroy0/BNP-short-course/', username = 'jasonroy0', subdir = 'DP ShinyApp/DPMixApp/')
```


Switching between strings and objects in R
```
# string -> object
x <- 42
eval(parse(text = "x"))
get("x")
[1] 42

# object -> string
x <- 42
deparse(substitute(x))
[1] "x"
```
```
devtools::install_github('pzhaonet/pinyin')
require('pinyin')
mypy = pydic(method = 'toneless', dic = 'pinyin2')
> py(c("我", "一定", "是个", "天才"),  dic = mypy, sep = '')
```

Add a specific python version to jupyter notebook kernel

```
conda create -n p36workshop python=3.6 ipykernel jupyter anaconda
source activate p36workshop
ipython kernel install --name p36workshop --user
```

Be sure to `conda activate p36workshop` before you use `conda install` or `pip install`

source from [https://sites.northwestern.edu/summerworkshops/resources/software-installation/adding-python-3-to-jupyter-notebooks/](https://sites.northwestern.edu/summerworkshops/resources/software-installation/adding-python-3-to-jupyter-notebooks/)

- `conda env list`: a list of environments
- `conda list`: a list of all packages installed in the current environment
- `conda list 'tensorflow|pytorch'`: a list of all different versions of packges

```
conda install --name py36 pytorch
conda install -c conda-forge keras tensorflow # install from conda-forge
```

Remove a specific Python distribution
```
# Delete a specific conda python distribution
conda env remove --name myenv
# OR
conda remove --name myenv --all

# PLUS: delete the kernel for jupyter notebook
jupyter kernelspec uninstall unwanted_kernel
```

# Create R environment using conda

## 1. Install conda on linux
```
du -h --max-depth=1 | sort -hr
wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh
ssh cn5
bash Anaconda3-2021.11-Linux-x86_64.sh

vi ~/.bashrc
export PATH=$PATH:/home/lighthouse/anaconda3/bin
source ~/.bashrc
conda --version
```

## 2. Install base-R using conda

```
conda install mamba -n base -c conda-forge -y # faster downloading of packages in conda using mamba
conda config --add channels conda-forge # add conda-forge
conda config --set channel_priority strict # set up conda-forge as the default channel
conda search r-base
conda update -n base -c defaults conda

conda create -n r4.1 python=3.8 
conda activate r4.1
conda install -c conda-forge r-base=4.1.3

conda install -c r r-glue r-fansi 
```
