# Hacker Container

Container with all the list of useful tools/commands while hacking Kubernetes Clusters

![WordCloud Image of Tools](hacker-container.png)

* List of the tools/commands/utilities available in container are [list.todo](list.todo)

## How to use Hacker Container

* Just run the following command to explore in the docker container environments

```bash
docker run --rm -it madhuakula/hacker-container
```

* To deploy as a Pod in Kubernetes cluster run the following command

```bash
kubectl run -it hacker-container --image=madhuakula/hacker-container -- sh
```

> This container can be used in different ways in different environments, it aids your penetration testing or security assessments of container and Kubernetes cluster environments.

## Hacker Container in Action

![Hacker Container in Action](hacker-container-in-action.png)

### Feedback/Suggestions

> Please feel free to [create issue](https://github.com/madhuakula/hacker-container/issues/new) or make a pull request or tweet to me [@madhuakula](https://twitter.com/madhuakula) for improvements and suggestions
