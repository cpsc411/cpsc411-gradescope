cd /autograder/source

apt-get update -y
apt-get install git nasm software-properties-common -y
add-apt-repository ppa:plt/racket -y
apt-get install -y racket
apt-get clean
raco setup --doc-index --force-user-docs

mkdir -p /root/.ssh
cp ssh_config /root/.ssh/config
cp id_cpsc411-deploy-key /root/.ssh/deploy_key
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

raco pkg install --auto https://github.com/cpsc411/cpsc411-pub.git?path=cpsc411-lib#2021w2

git clone --depth 1 --single-branch git@github.com:cpsc411/compilers2.0
raco pkg install --batch --auto ./compilers2.0/cpsc411-priv/cpsc411-reference-tests ./compilers2.0/cpsc411-priv/cpsc411-reference-lib
