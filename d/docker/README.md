# Update order

The suggested update order for the docker stack is something like:

- runc
- containerd
- docker
- moby
- docker-buildx
- docker-compose

## Tips

To get the git commits for docker-related tags, use the following snippets:

- `git ls-remote <the upstream .git> refs/tags/v%(version) |awk '{print $1}'`

The recipes are currently set up to display the git commit and the version.
