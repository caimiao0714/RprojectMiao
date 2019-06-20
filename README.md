# R projects

install packges in Python console instead of in terminals:

```
import subprocess
import sys

def install(package):
    subprocess.call([sys.executable, "-m", "pip", "install", package])

install('h2o')
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
