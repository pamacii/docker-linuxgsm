# LGSM-based images

## 7 Days To Die
### local build
build local container\
`podman build -f Containerfile.local -t localhost/lgsm-base .`\
`podman build -f Containerfile-sdtd.local -t localhost/sdtdserver .`

### Run (first run/manual runs)
change to storage folder (e.g. /opt/7dtd)\
`mkdir -p /opt/7dtd; cd /opt/7dtd`

start container\
`podman run --name 7dtd -dt -p 26900-26902:26900-26902/tcp -p 26900-26902:26900-26902/udp --userns=keep-id -v "${PWD}":/home/lgsm:z quay.io/pamacii/sdtdserver:latest`

wait for server install to complete
`podman logs -f 7dtd`

edit server config\
`vim serverfiles/sdtdserver.xml`

start server\
`podman exec -t 7dtd ./sdtdserver start`

stop server\
`podman exec -t 7dtd ./sdtdserver stop && podman stop 7dtd`

### Service creation (existing container/ server files exist)
Create service file\
`podman generate systemd --new --name --files 7dtd`\
This recreates the container each time the service starts, so updates to sdtdserver will be captured with a service restart

Modify service to start server by default and to stop server before stopping container\
```
sed -i -e '/^ExecStart=/s/.*/\/usr\/bin\/bash -c "& \&\& exec \/usr\/bin\/podman exec -t 7dtd .\/sdtdserver start"/
/^ExecStop=/s/.*/ExecStop=\/usr\/bin\/podman exec -t 7dtd .\/sdtdserver stop\
&/' container-7dtd.service
```

install service for use  (insure that lingering/user services are configured)  
 `podman exec -t 7dtd ./sdtdserver stop && \`\
 `podaman rm -f 7dtd && \`\
 `cp -Z container-7dtd.service $HOME/.config/systemd/user/ && \`\
 `systemctl --user install container-7dtd.service`
 `systemctl --user enable --now container-7dtd.service`

### Manage
backup: `podman exec -t 7dtd ./sdtdserver backup`\
force update: `podman exec -t 7dtd ./sdtdserver force-update`

### Notes

dont forget to add to firewall\
#ROOT `firewall-cmd --add-port=26900-26902/tcp --add-port=26900-26902/udp`\
#ROOT `firewall-cmd --add-port=26900-26902/tcp --add-port=26900-26902/udp --permanent`

enable server to start/stay alive without user login (servicefile install target should include default.target)\
`loginctl enable-linger $USER`
