# LGSM-based images

## 7 Days To Die
### build
build local container\
`podman build -f Containerfile -t localhost/lgsm-base .`
`podman build -f Containerfile-sdtd -t localhost/sdtdserver .`

### Run
start container\
`podman run --name 7dtd -it -p 26900-26902:26900-26902/tcp -p 26900-26902:26900-26902/udp --userns=keep-id -v "${PWD}":/home/lgsm:z localhost/sdtdserver:latest`

edit server config\
`vim serverfiles/sdtdserver.xml`

start server\
`podman exec -t 7dtd ./sdtdserver start`

### Service creation
Create service file\
`podman generate systemd --new --name --files 7dtd`\
This recreates the container each time the service starts, so updates to localhost/sdtdserver:latest will be captured with a service restart


Modify service to start server by default and to stop server before stopping container
`sed -i -e '/^ExecStart=/s/$/ .\/sdtdserver start/' -e '/^ExecStop=/s/.*/ExecStop=\/usr\/bin\/podman exec -t %t/%n.ctr-id .\/sdtdserver stop\' -e '&/' container-7dtd.service`


install service for use  (insure that lingering/user services are configured)  
 `podman exec -t 7dtd ./sdtdserver stop && \`\
 `podaman rm -f 7dtd && \`\
 `cp -Z container-7dtd.service $HOME/.config/systemd/user/ && \`\
 `systemctl --user enable --now container-7dtd.service`

### Manage
backup: `podman exec -t 7dtd ./sdtdserver backup`\
force update: `podman exec -t 7dtd ./sdtdserver force-update`

### Notes

dont forget to add to firewall\
`firewall-cmd --add-port=26900-26902/tcp --add-port=26900-26902/udp`\
`firewall-cmd --add-port=26900-26902/tcp --add-port=26900-26902/udp --permanent`
