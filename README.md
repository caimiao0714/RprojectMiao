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

Add your conda env to jupyter notebook

```
conda activate your-env-name
conda install ipykernel
ipython kernel install --user --name=your-env-name
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

If your `conda activate` is not working and us showing error messages like 

    CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'.
    To initialize your shell, run

    $ conda init <SHELL_NAME>". 
 
[Do this](https://stackoverflow.com/questions/61915607/commandnotfounderror-your-shell-has-not-been-properly-configured-to-use-conda)
    
```
source ~/anaconda3/etc/profile.d/conda.sh
conda activate my_env

# Export these commands so that it works at every session
export -f conda
export -f __conda_activate
export -f __conda_reactivate
export -f __conda_hashr
```

## 2. Install base-R using conda

```
conda install mamba -n base -c conda-forge -y # faster downloading of packages in conda using mamba
conda config --add channels conda-forge # add conda-forge
conda config --set channel_priority strict # set up conda-forge as the default channel
conda search r-base
conda update -n base -c defaults conda

conda create -n r4.1 python=3.8 r-base=4.1.3
conda activate r4.1
#conda install -c conda-forge r-base=4.1.3

conda install -c r r-glue r-fansi 
```

## 3. Install R package from source

```
install.packages('', repos = NULL, type = "source")
```


### 4. Use R environment set up by conda in RStudio Server

Check out this [tutorial](https://github.com/grst/rstudio-server-conda). Use the [Running Locally tutorial](https://github.com/grst/rstudio-server-conda#running-locally).

```
git clone https://github.com/grst/rstudio-server-conda.git
cd rstudio-server-conda/local
conda activate my_project
./start_rstudio_server.sh 8787  # use any free port number here. 
```

# Linux setting

Show all hard drives

```
lsblk # list all hard drives
fdisk -l # list all hard drives and path
mount /dev/sda /data1/ # mount /dev/sda to path /data1/
# note you need to mkdir /data1/ to run this command
df -lh # Check disk usage and percent
```


Linux Change Default User Home Directory While Adding A New User:

```
vi /etc/default/useradd
# HOME=/home
HOME=/newpath/path_folder
```

Change the user's home directory + Move the contents of the user's current directory

```
usermod -m -d /newhome/username username
```
- `usermod` is the command to edit an existing user.
- `-d` (abbreviation for `--home`) will change the user's home directory.
`-m` (abbreviation for `--move-home`) will move the content from the user's current directory to the new directory.

Check the IP address of the linux server: 

```
hostname -I
```

Give a user sudo privilege

```
usermod -aG wheel your-username
```

### Difference between `/etc/environment` and `/etc/profile`

- `/etc/environment` - This file is specifically meant for system-wide environment variable settings. It is not a script file, but rather consists of assignment expressions, one per line. Specifically, this file stores the system-wide locale and path settings.

- `/etc/profile` - This file gets executed whenever a bash login shell is entered (e.g. when logging in from the console or over ssh), as well as by the DisplayManager when the desktop session loads.

There is a very good tutorial on environmental variables: [A Guide on Environment Variable Configuration in Linux](https://www.alibabacloud.com/blog/a-guide-on-environment-variable-configuration-in-linux_598423)

### Classification of Environment Variables

Environment variables can be divided into user-defined and system-level environment variables.

- Definition Files of **User-Level** Environment Variables: `~/.bashrc` and `~/.profile` (for some systems: `~/.bash_profile`)
- Definition Files of **System-Level** Environment Variables: `/etc/bashrc`, `/etc/profile` (for some systems: `/etc/bash_profile`), and `/etc/environment`

In addition, the system reads the ~/.bash_profile (or ~/.profile) file first for user-level environment variables. If there is no such file, read ~/.bash_login and then read ~/.bashrc based on the content of these files.


## Install Linux compiling environment

### devtoolset-7 (gcc, g++, and gfortran)

Enable devtoolset-7 to update gcc, g++, and gfortran

```
yum install centos-release-scl-rh
yum install devtoolset-7-toolchain
scl enable devtoolset-7 bash
gfortran --version | head -2
```

Need to export devtoolset-7 to system path

```
which gcc
export PATH=/opt/rh/devtoolset-7/root/usr/bin/:$PATH 
export LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib64/:$LD_LIBRARY_PATH
# export PATH=/data1/Software/Installed/Anaconda3/bin:$PATH
source ~/.bashrc

echo $PATH # copy the output of the environment variables
vim /etc/environment # paste the output in this file
source /etc/environment && export PATH
```

### cmake version 3

[See gist here](https://gist.github.com/1duo/38af1abd68a2c7fe5087532ab968574e)

```
# use this:
yum install cmake3

# Don't use the code below (just as reference if the above code does not work)
wget https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz
tar zxvf cmake-3.*
cd cmake-3.*
./bootstrap --prefix=/usr/ # note the '/local' should not be included
make -j$(nproc)
make install
cmake --version
```

### `jpeglib.h`

```
sudo yum install libjpeg-turbo-devel
```

### `gmp.h`

```
sudo yum install mpfr-devel
```

### /lib64/libstdc++.so.6: version `CXXABI_1.3.8' not found 

This problem is caused by low version of `libstdc++.so.6` in your /lib64/. You need to copy newer version of `libstdc++.so.6` (e.g. `libstdc++.so.6.0.28`) and create a soft link for this new `libstdc++.so.6`. See the tutorial [here](https://blog.csdn.net/a13568hki/article/details/108667044).

## Install R on CentOS

[RStudio documentation](https://docs.rstudio.com/resources/install-r/)

```
# Enable the Extra Packages for Enterprise Linux (EPEL) repository
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 

# On RHEL 7, enable the Optional repository
sudo subscription-manager repos --enable "rhel-*-optional-rpms"

# If running RHEL 7 in a public cloud, such as Amazon EC2, enable the
# Optional repository from Red Hat Update Infrastructure (RHUI) instead
sudo yum install yum-utils
sudo yum-config-manager --enable "rhel-*-optional-rpms"

# Specify R version
export R_VERSION=4.1.3

# Download and install the desired version of R.
curl -O https://cdn.rstudio.com/r/centos-7/pkgs/R-${R_VERSION}-1-1.x86_64.rpm
sudo yum install R-${R_VERSION}-1-1.x86_64.rpm

# Verify R version
/opt/R/${R_VERSION}/bin/R --version

# Create a symlink for R
sudo ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R
sudo ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript
```



## RStudio Server setting in Linux

Kill rstudio-server

```
ps -ef | grep rserver
kill -9 <PID>
rstudio-server verify-installation
```

More useful error message for RStudio Server

```
journalctl -u rstudio-server
```

Check if any service is listening on the port 8787

```
netstat -lntp
lsof -i -P -n | grep LISTEN
```

Make port 8787 available 

```
ufw allow 8787/tcp
firewall-cmd --list-all
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
```

Open a web link 

```
gio open command http://localhost:80
xdg-open http://localhost:80
```

## Change R setting in Linux

Change the path of installed R packages

```
cd ~/
echo .Renviron
vim .Renviron
R_LIBS_USER = /your/specific/folder
```


## Install R packages by setting up Linux environment

Install R packages without loading R
```
R -e 'install.packages("sf", repos = "https://mirrors.sustech.edu.cn/CRAN/")'
```

To install `lme4` (dependency `nlopt`)

```
yum install nlopt nlopt-devel
```



### Install proj-9.0.0 with sqlite3

```
cd proj-9.0.0
mkdir build
cd build
cmake ..

# Below are the error messages
-- Requiring C++11
-- Requiring C++11 - done
-- Requiring C99
-- Requiring C99 - done
-- Configuring PROJ:
-- PROJ_VERSION                   = 9.0.0
-- nlohmann/json: internal
CMake Error at CMakeLists.txt:176 (message):
  sqlite3 dependency not found!


CMake Error at CMakeLists.txt:182 (message):
  sqlite3 >= 3.11 required!


CMake Error at /usr/share/cmake3/Modules/FindPackageHandleStandardArgs.cmake:164 (message):
  Could NOT find TIFF (missing: TIFF_LIBRARY TIFF_INCLUDE_DIR)
Call Stack (most recent call first):
  /usr/share/cmake3/Modules/FindPackageHandleStandardArgs.cmake:445 (_FPHSA_FAILURE_MESSAGE)
  /usr/share/cmake3/Modules/FindTIFF.cmake:70 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)
  CMakeLists.txt:193 (find_package)


-- Configuring incomplete, errors occurred!
See also "/data1/Software/PkgDownloads/proj-9.0.0/build/CMakeFiles/CMakeOutput.log".
```

```
find / -name libsqlite3.so
# /data1/Software/Installed/Anaconda3/pkgs/sqlite-3.36.0-hc218d9a_0/lib/libsqlite3.so
# /data1/Software/Installed/Anaconda3/pkgs/sqlite-3.38.3-h4ff8645_0/lib/libsqlite3.so
# /data1/Software/Installed/Anaconda3/lib/libsqlite3.so
# /data1/Software/Installed/Anaconda3/envs/r4.1/lib/libsqlite3.so
# /data1/Software/Installed/Anaconda3/envs/r-gluonts/lib/libsqlite3.so

cmake -DCMAKE_PREFIX_PATH=/data1/Software/Installed/Anaconda3/ .. # the custom prefix for SQLite3 can be specified
```

Network setting: automatically enable ethernet 1 when on boot

```
grep ONBOOT /etc/sysconfig/network-scripts/ifcfg-*
vim /etc/sysconfig/network-scripts/ifcfg-em1
ONBOOT=yes # add this line
```

Set timezone

```
timedatectl list-timezones
timedatectl set-timezone Asia/Hong_Kong
```

Get the number of logical processors

```
grep processor /proc/cpuinfo | wc -l
```

## Enhance system security

Ban an IP address:


Check what user/IP is trying to log into the system

```
vim /var/log/secure
```

