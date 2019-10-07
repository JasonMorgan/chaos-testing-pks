# Chaos Testing a Bosh Managed k8s Cluster

We want to show off what [bosh](https://bosh.io) adds to a Kubernetes cluster. Kubernetes will handle rescheduling containers and ensuring that the desired state of a container environment matches the actual state. Unfortunately it still has some issues managing desired state for the machines that make up the cluster. Bosh was written to provide desired state management for vms in an IaaS agnostic fashion and act as a scheduler for vms.

I won't dive too deeply into bosh here but you can check it our yourself or just ask if you'd like more details. 

## Scenarios

So if we're going to show how bosh can help "Chaos proof" your clusters we need to outline a few favorable scenarios that shows how apps, kubernetes, and bosh can work together to recover from failures. Just want to be crystal clear here: ***you absolutely cannot chaos proof anything*** but you can find an inexpensive and easy way to harden an environment.

### Someone deletes all the nodes in an AZ

This sucks, ideally you've been alerted. Good news, kubernetes has rescheduled your containers. Bad news, you're down an AZ. You get oriented, log into AWS, and try and figure out what happened. Sucks right? Now you start replacing the nodes, unless you're using bosh. With bosh the director, think vm scheduler, notices an agent isn't responding, recreates any missing vms, remounts any external disks. You get to focus on figuring out why the vms were deleted and ensuring that doesn't happen again.

Simulate a downed az with `destroy-nodes.sh`

example: `./destroy-nodes.sh us-east-1c`

### Something is killing pods on your web app

Not fun but k8s can handle that on it's own, unless the vm itself crashes, in which case bosh notices there's a problem. It'll roll up stats about whats happening, forward logs to whatever collection system you have, and, if necessary, recreate the vm from a known good state. It's good to have something fix the vms for you but you also want an easy way to handle system and application logs that aren't necessarily part of k8s itself.

example: `pwsh -c ./disrupt-pods.ps1`
