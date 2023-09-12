ip=127.0.0.10
image=debian:12-slim
pubkey=~/.ssh/id_rsa.pub

docker run --detach --rm -it --ip="$ip" \
           -p 22:22 -p 80:80 -p 443:443 \
           --name=freshdebian "$image"
docker exec freshdebian apt update
docker exec freshdebian apt install -y openssh-server
docker exec freshdebian service ssh start
docker cp "$pubkey" freshdebian:/root/.ssh/authorized_keys
ssh-keygen -f ~/.ssh/known_hosts -R "$ip"
ssh-keyscan -H "$ip" >> ~/.ssh/known_hosts
ssh "$ip"
docker kill freshdebian
