# bash's setup files
.bash_login
.bash_profile
.bashrc
.profile

## Order of reading configuration files
1. /etc/profile
2. .bash_profile in the home directory of the user who stared it.
3. If ~/.bash_profile is not present, ~/.bash_login is read.
4. If ~/.bash_login is also missing, then ~/.profile is read.

The .bashrc is supposed to be read when bash is launched outside of the login shell.
For example, when you launch a  terminal locally or log in to a server via ssh.
