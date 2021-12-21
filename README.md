# LGSM-based images

## 7 Days To Die
### build
build local container\
`podman build -f Containerfile-sdtd -t sdtdserver .`

### Run
start container\
`podman run --name 7dtd -it -p 26900-26902:26900-26902/tcp -p 26900-26902:26900-26902/udp --userns=keep-id -v "${PWD}":/home/lgsm:z localhost/sdtdserver:latest`

edit server config\
`vim serverfiles/sdtdserver.xml`

start server\
`podman exec -t 7dtd ./sdtdserver start`

### Service creation
create systemd service file -- each new continer creation (if using new version of image)\
`podman generate systemd 7dtd > 7dtd.service`

modify service to start server stop server seperate from container\
`sed -i -e '/^ExecStart=/s/^.*$/\/usr\/bin\/bash -c "podman start 7dtd; sleep 5; exec podman exec -t 7dtd ./sdtdserver start"' 7dtd.service`\
`sed -i -e '/^ExecStop=/s/^.*$/\/user\/bin\/podman exec -t 7dtd ./sdtdserver stop"' 7dtd.service`

(ExecStopPost stops the container)

install service for use  (insure that lingering/user services are configured)  
 `podman exec -t 7dtd ./sdtdserver stop && \`\
 `podaman stop 7dtd && \`\
 `cp 7dtd.service .config/systemd/user/ && \`\
 `systemctl --user enable --now 7dtd.service`

### Manage
backup: `podman exec -t 7dtd ./sdtdserver backup`\
force update: `podman exec -t 7dtd ./sdtdserver force-update`

### Notes

dont forget to add to firewall\
`firewall-cmd --add-port=26900-26902/tcp --add-port=26900-26902/udp`\
`firewall-cmd --add-port=26900-26902/tcp --add-port=26900-26902/udp --permanent`
