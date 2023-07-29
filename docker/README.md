Consulted the following link to set up the gerrit instance https://hub.docker.com/r/gerritcodereview/gerrit

* Created docker-compose.yaml file
* Added gerrit/index, gerrit/git, gerrit/etc, gerrit/cache folders
* Created the ssh keys with 'ssh-keygen -t rsa -f ./gerrit/etc/ssh_host_rsa_key'
* Created 'local_repositories' folder, this is where all the 'local' git repos
  will be created, to simulate events on gerrit.
