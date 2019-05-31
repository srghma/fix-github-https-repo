# fix-github-https-repo

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Script to automate https://help.github.com/articles/why-is-git-always-asking-for-my-password

Transforms:

```
https://github.com/myusername/myproject                                    -> ssh://git@github.com/myusername/myproject.git
https://gitlab.mycompany.com/myusername/myproject                          -> ssh://git@gitlab.mycompany.com/myusername/myproject.git
https://gitlab.mycompany.com/myusername/myproject           + --port 999   -> ssh://git@gitlab.mycompany.com:999/myusername/myproject.git
git@gitlab.mycompany.com/myusername/myproject.git           + --port 999   -> ssh://git@gitlab.mycompany.com:999/myusername/myproject.git
git@gitlab.mycompany.com:111/myusername/myproject.git       + --port 999   -> ssh://git@gitlab.mycompany.com:999/myusername/myproject.git
git@gitlab.mycompany.com:111/myusername/myproject.git                      -> ssh://git@gitlab.mycompany.com:111/myusername/myproject.git
git@gitlab.mycompany.com:111/myusername/myproject.git       + --unset-port -> ssh://git@gitlab.mycompany.com/myusername/myproject.git
ssh://git@gitlab.mycompany.com:111/myusername/myproject.git + --port 999   -> ssh://git@gitlab.mycompany.com:999/myusername/myproject.git
```

