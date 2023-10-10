➜  ecs_eks_soci kubectl apply -f eks-torchserve-cpu.yml && kubectl get pod -w
pod/torchserve-cpu-soci created
pod/torchserve-cpu created
NAME                  READY   STATUS              RESTARTS   AGE
torchserve-cpu        0/1     ContainerCreating   0          1s
torchserve-cpu-soci   0/1     ContainerCreating   0          1s
torchserve-cpu-soci   1/1     Running             0          6s
torchserve-cpu        1/1     Running             0          30s

kubectl describe pod torchserve-cpu-soci
kubectl describe pod torchserve-cpu
                                                                                                                                                               
➜  eks_soci kubectl delete -f eks-torchserve-cpu.yml 
pod "torchserve-cpu" deleted
pod "torchserve-cpu-soci" deleted

##### 

➜  eks_soci kubectl apply -f eks-torchserve.yml && kubectl get pod -w
pod/torchserve-soci created
pod/torchserve created
NAME              READY   STATUS              RESTARTS   AGE
torchserve        0/1     ContainerCreating   0          1s
torchserve-soci   0/1     ContainerCreating   0          2s
torchserve-soci   1/1     Running             0          12s
torchserve        1/1     Running             0          2m52s

kubectl describe pod torchserve-soci
kubectl describe pod torchserve

[root@ip-172-31-30-224 ~]# mount | grep fuse
fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
soci on /var/lib/soci-snapshotter-grpc/snapshotter/snapshots/3/fs type fuse.rawBridge (rw,nodev,relatime,user_id=0,group_id=0,allow_other,max_read=131072)
soci on /var/lib/soci-snapshotter-grpc/snapshotter/snapshots/5/fs type fuse.rawBridge (rw,nodev,relatime,user_id=0,group_id=0,allow_other,max_read=131072)
soci on /var/lib/soci-snapshotter-grpc/snapshotter/snapshots/8/fs type fuse.rawBridge (rw,nodev,relatime,user_id=0,group_id=0,allow_other,max_read=131072)
soci on /var/lib/soci-snapshotter-grpc/snapshotter/snapshots/10/fs type fuse.rawBridge (rw,nodev,relatime,user_id=0,group_id=0,allow_other,max_read=131072)

➜  eks_soci kubectl delete -f eks-torchserve.yml                     
pod "torchserve" deleted
pod "torchserve-soci" deleted

