# GIT

## Install graphical interface

```
sudo yum install git-gui
```

## Open graphical interface

```
gitk
```

## Branching strategy

Define a naming convention that suits to the team.

Source: [Introducing the Space Git Flow](https://blog.jetbrains.com/space/2023/04/18/space-git-flow/)


### Git flow

[jgit-flow](https://bitbucket.org/atlassian/jgit-flow/wiki/Home), it has performance differences between use "git:" and "https:" protocols.

Connection credentials on the maven plugin.
````
<build>
    <plugins>
        <plugin>
            <groupId>external.atlassian.jgitflow</groupId>
            <artifactId>jgitflow-maven-plugin</artifactId>
            <version>1.0-m5.1</version>
            <configuration>
                <username>${git.username}</username>
                <password>${git.password}</password>
                <!-- see goals wiki page for configuration options -->
            </configuration>
        </plugin>
    </plugins>
</build>
````


[How to make a release with Git and Maven via JGitFlow](https://gist.github.com/lemiorhan/97b4f827c08aed58a9d8)

![Git flow](./git/git-flow.png)

### GitHub flow

![GitHub flow](./git/github-flow.png)

### Trunk-Based

![Trunk-Based](./git/trunk-based.png)

### Jetbrains Space Git flow

![Space Git flow](./git/jetbrains-space-git-flow-1.png)
