# fix-github-https-repo

Script to automate https://help.github.com/articles/why-is-git-always-asking-for-my-password

Transforms:

- `https://github.com/myusername/myproject` -> `git@github.com:myusername/myproject.git`
- `https://gitlab.mycompany.com/myusername/myproject` -> `git@gitlab.mycompany.com:myusername/myproject.git`
- `https://gitlab.mycompany.com/myusername/myproject` + --port 999 -> `ssh://git@gitlab.mycompany.com:999/myusername/myproject.git`
- `git@gitlab.mycompany.com/myusername/myproject.git` + --port 999 -> `ssh://git@gitlab.mycompany.com:999/myusername/myproject.git`
- `git@gitlab.mycompany.com:999/myusername/myproject.git` + --port 999 -> `ssh://git@gitlab.mycompany.com:999/myusername/myproject.git`
- `ssh://git@gitlab.mycompany.com:999/myusername/myproject.git` + --port 999 -> `ssh://git@gitlab.mycompany.com:999/myusername/myproject.git`

