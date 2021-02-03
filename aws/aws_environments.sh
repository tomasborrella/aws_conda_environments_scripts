#!/bin/bash

port=$1
environments_dir=$2
environments_dir_tmp=$3
s3_root=$4 
s3_folder=$5

# Helper functions
spin() {
  while kill -0 $job 2>/dev/null; do
    for s in / - \\ \|; do
      printf "$s"; printf "\b"; sleep .1      
    done
  done
}

# Main program
printf "\n"
if [ ! -d $environments_dir ]; then
  printf "Hi! You are the first user today. Preparing system...\n\n"

  # Create directories for environments 
  mkdir -p $environments_dir
  mkdir -p $environments_dir_tmp

  # Copy packed environments from s3
  printf "> Downloading environments from S3 "
  aws s3 cp \
      s3://$s3_root/$s3_folder \
      $environments_dir_tmp/ \
      --recursive \
      --quiet \
      & job=$!; spin; printf "✔\n"
  
  # Extract environments and unpack
  printf "> Unpacking environments "
  for file in $environments_dir_tmp/*.tar.gz; do
    [ -e $file ] || continue
    name=${file##*/}
    base=${name%.tar.gz}
    
    # Create a folder for the environment
    mkdir -p $environments_dir/$base
  
    # Extract the environment
    tar xzf $file --directory $environments_dir/$base

    # Change permissions
    chmod 777 $environments_dir/$base -R

    # Activate the environment
    source $environments_dir/$base/bin/activate

    # Unpack the environment 
    conda-unpack

    # Deactivate the environment
    source $environments_dir/$base/bin/deactivate
  done & job=$!; spin; printf "✔\n\n"

  # Create envs script to show information
  cat << EOF >> $environments_dir/envs.sh
#!/bin/bash

# Configuration variables
environments_dir=${environments_dir}
EOF

  cat << 'EOF' >> $environments_dir/envs.sh
# Print available environments information
printf "╔════════════════════════╗\n"
printf "║ AVAILABLE ENVIRONMENTS ║\n"
printf "╚════════════════════════╝\n\n"

for dir in $environments_dir/*/; do
  [ -e $dir ] || continue
  dir=${dir%*/}
  base=${dir##*/}
  printf "  » $base\n"
done

printf "\n"
printf "  Commands:\n"
printf "  ────────\n\n"
printf "  ■ envs (show this info)\n"
printf "  ■ activate <envinonmet_name>\n"
printf "  ■ deactivate\n\n"
printf "  ■ jupyter\n"
printf "  ■ aws_s3_ls\n"
printf "\n"
EOF

  chmod +x $environments_dir/envs.sh
  
  # Remove temp folder
  rm -rf $environments_dir_tmp 
fi

# Print available environments information
printf "System ready!\n\n"
source $environments_dir/envs.sh

# Create aliases (first remove if already created)
sed -i '/^alias envs/d' ~/.bashrc 
sed -i '/^alias jupyter/d' ~/.bashrc
sed -i '/^activate/d' ~/.bashrc
sed -i '/^deactivate/d' ~/.bashrc
sed -i '/^aws_s3_ls/d' ~/.bashrc
sed -i '/^aws_s3_sync/d' ~/.bashrc
echo "alias envs=\"$environments_dir/envs.sh\"" >> ~/.bashrc
echo "alias jupyter=\"jupyter notebook --ip 0.0.0.0 --port $port --no-browser --config='/dev/null'\"" >> ~/.bashrc
echo "activate() { source $environments_dir/\$1/bin/activate ; }" >> ~/.bashrc
echo "deactivate() { source \$(ls -d $environments_dir/*/ | head -1)/bin/deactivate ; }" >> ~/.bashrc
echo "aws_s3_ls() { aws s3 ls s3://$s3_root\${1-/} ; }" >> ~/.bashrc
echo "aws_s3_sync() { aws s3 sync s3://$s3_root\$1 \${2-.} ; }" >> ~/.bashrc

source ~/.bashrc
# Add useful commands to .bash_history
echo "aws_s3_ls" >> ~/.bash_history
echo "jupyter" >> ~/.bash_history
echo "envs" >> ~/.bash_history
