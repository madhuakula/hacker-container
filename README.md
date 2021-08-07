# Hacker Container

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/madhuakula/hacker-container/blob/master/LICENSE)
[![Github Stars](https://img.shields.io/github/stars/madhuakula/hacker-container)](https://github.com/madhuakula/hacker-container/stargazers)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/madhuakula/hacker-container/pulls)
[![Docker Pulls Hacker Container](https://img.shields.io/docker/pulls/madhuakula/hacker-container?logo=docker)](https://hub.docker.com/r/madhuakula/hacker-container)
[![Twitter](https://img.shields.io/twitter/url?url=https://github.com/madhuakula/hacker-container)](https://twitter.com/intent/tweet/?text=Container%20with%20all%20the%20list%20of%20useful%20tools%20and%20commands%20while%20hacking%20Kubernetes%20Clusters%20created%20by%20%40madhuakula&url=https://github.com/madhuakula/hacker-container)

Container with all the list of useful tools/commands while hacking Kubernetes Clusters. Read more about it in the blogpost [https://blog.madhuakula.com/hacker-container-for-kubernetes-security-assessments-7d1522e96073](https://blog.madhuakula.com/hacker-container-for-kubernetes-security-assessments-7d1522e96073)

[![WordCloud Image of Tools](hacker-container.png)](https://blog.madhuakula.com/hacker-container-for-kubernetes-security-assessments-7d1522e96073)

* List of the tools/commands/utilities available in container are **[list.todo](list.todo)**

## How to use Hacker Container

[![Try in PWD](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/madhuakula/hacker-container/master/docker-stack.yml)

* Just run the following command to explore in the docker container environments

```bash
docker run --rm -it madhuakula/hacker-container
```

* To deploy as a Pod in Kubernetes cluster run the following command

```bash
kubectl run -it hacker-container --image=madhuakula/hacker-container
```

> This container can be used in different ways in different environments, it aids your penetration testing or security assessments of container and Kubernetes cluster environments.

## Hacker Container in Action

![Hacker Container in Action](hacker-container-in-action.png)

### Feedback/Suggestions

> Please feel free to [create issue](https://github.com/madhuakula/hacker-container/issues/new) or make a pull request or tweet to me [@madhuakula](https://twitter.com/madhuakula) for improvements and suggestions
