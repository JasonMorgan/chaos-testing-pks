# Chaos Testing a Bosh Managed k8s Cluster

We want to show off what [bosh](https://bosh.io) adds to a Kubernetes cluster. Kubernetes will handle rescheduling containers and ensuring that the desired state of a container environment matches the actual state. Unfortunately it still has some issues managing desired state for the machines that make up the cluster. Bosh was written to provide desired state management for vms in an IaaS agnostic fashion and act as a scheduler for vms.

I won't dive too deeply into bosh here but you can check it our yourself or just ask if you'd like more details. 

## Scenarios

So if we're going to show how bosh can help "Chaos proof" your clusters we need to outline a few favorable scenarios that shows how apps, kubernetes, and bosh can work together to recover from failures. Just want to be crystal clear here: ***you absolutely cannot chaos proof anything*** but you can find an inexpensive and easy way to harden an environment.

### Someone deletes some nodes in your cluster

This sucks, ideally you've been alerted. Good news, kubernetes has rescheduled your containers. Bad news, you're down one or more nodes. You get oriented, log into AWS, and try and figure out what happened. Sucks right? Now you start replacing the nodes, unless you're using bosh. With bosh the Director, think vm scheduler, notices an agent isn't responding, recreates any missing vms, remounts any external disks. You get to focus on figuring out why the vms were deleted and ensuring that doesn't happen again.

### Someone uses up all the CPU on a few nodes

Not fun but k8s can handle that on it's own, unless the vm itself crashes, in which case bosh notices there's a problem. It'll roll up stats about whats happening, forward logs to whatever collection system you have, and, if necessary, recreate the vm from a known good state. It's good to have something fix the vms for you but you also want an easy way to handle system and application logs that aren't necessarily part of k8s itself.

### Someone turns off some nodes

Pretty unfortunate but it'll follow the same path as a deleted node. Bosh doesn't care why a vm isn't responding, it only cares that it isn't doing what it's supposed to do. One nice thing here is that bosh treats persistent disk in much the same way k8s does. It will unmount the disk, create a new vm, and mount it back.

### Someone leaks your credentials on github

Bosh can't do a ton but depending on the creds you've had exposed bosh simplifies the process of replacing creds. You update your manifest, hit apply, and bosh handles recreating all the vms and apps with the new credentials you've generated.

## Demos

### Delete some nodes

### Delete an API server

### Run up the CPU

### Disrupt some pods

### Eliminate long lived nodes
