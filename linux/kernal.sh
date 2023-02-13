#!/usr/bin/env bash

# Export
export KERNEL=/home/$USER/project/linux-6.1.11
export DIR=/home/$USER/project

# Install
sudo dnf -y update
sudo dnf -y groupinstall "C Development Tools and Libraries" "Development Tools" "Development Libraries"
sudo dnf -y install git flex debootstrap golang
sudo dnf -y install openssl-devel elfutils-libelf-devel ncurses-devel 
sudo dnf -y install qemu-system-x86 qemu-kvm 
sudo dnf -y install fakeroot bc dracut qemu-img

# Download
#wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.11.tar.xz
cp ~/Downloads/linux-6.1.11.tar.xz .
git clone --depth=1 https://github.com/google/syzkaller.git

# Compile
tar -xf linux-6.1.11.tar.xz
pushd linux-6.1.11/
curl https://raw.githubusercontent.com/google/syzkaller/master/dashboard/config/linux/upstream-apparmor-kasan.config -o .config
make olddefconfig
make -j32
popd

pushd syzkaller/
make
popd

# Create image
wget https://raw.githubusercontent.com/google/syzkaller/master/tools/create-image.sh -O create-image.sh
chmod +x create-image.sh
./create-image.sh

# Verify
qemu-system-x86_64 \
	-m 2G \
	-smp 2 \
	-kernel $KERNEL/arch/x86/boot/bzImage \
	-append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
	-drive file=$DIR/stretch.img,format=raw \
	-net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
	-net nic,model=e1000 \
	-enable-kvm \
	-nographic

# ssh
##ssh -i $IMAGE/stretch.id_rsa -p 10021 -o "StrictHostKeyChecking no" root@localhost

# Download
#sudo apt update
#sudo apt install -y make gcc flex bison libncurses-dev libelf-dev libssl-dev
#sudo apt install -y git
#git clone --depth=1 https://github.com/google/syzkaller.git


curl -OL https://dl.google.com/go/go1.19.linux-amd64.tar.gz

tar -xvf go1.19.linux-amd64.tar.gz

mv go/ /usr/local/

export PATH=$PATH:/usr/local/go/bin

cd syzkaller
make


go version go1.7.4 linux/amd64





sudo tar -C /usr/local -xvf go1.7.4.linux-amd64.tar.gz
sudo nano ~/.profile

export PATH=$PATH:/usr/local/go/bin

source ~/.profile


curl -O https://storage.googleapis.com/golang/go1.13.5.linux-amd64.tar.gz
tar -xvf go1.13.5.linux-amd64.tar.gz


echo "export GOPATH=$HOME/work" >> ~/.profile 
echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> ~/.profile
source ~/.profile






