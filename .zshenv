export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export PATH=$HOME/.local/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

export RESTIC_PASSWORD_FILE=$HOME/.local/restic_pass
export AWS_SECRET_ACCESS_KEY=$(cat $HOME/.local/aws_secret_key)
export AWS_ACCESS_KEY_ID=$(cat $HOME/.local/aws_key)
export RESTIC_REPOSITORY=s3:https://s3.us-west-1.wasabisys.com/bckp
