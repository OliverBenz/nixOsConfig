# Gitea runner

`.env` → `/mnt/host/Gitea_Runners/.env` (`chmod 600`):

```sh
GITEA_RUNNER_REGISTRATION_TOKEN=<token from Gitea: Site Administration → Actions → Runners → Create new runner>
```

Only used for the first registration. The result is stored in `/mnt/host/Gitea_Runners/data/.runner`;
delete that file to register again with a new token.
