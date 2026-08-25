# Docker

# Docker push issues

When docker push present issues and docker login and tag are working fine consider there are different protocol versions supported between your **Docker CLI** and your **private repository** (in my case artifactory), so you can either upgrade or downgrade your docker installation.

Solution example:

```bash
sudo -i
dnf remove docker-ce docker-ce-cli
dnf install docker-ce-3:25.0.5-1.el8.x86_64 docker-ce-cli-1:25.0.5-1.el8.x86_64
```

Error message example:

```bash
docker push ....
....
Waiting unknown: failed commit on ref "config-sha256:6e0e13295...":
unexpected status from PUT request to https://docker.artifactory..../blobs/uploads/...?digest=sha256%...: 404 Not Found
```
