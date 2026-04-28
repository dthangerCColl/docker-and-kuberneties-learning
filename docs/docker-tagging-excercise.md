# Docker Pull → Tag → Run → Cleanup Exercise

## Step 1: Pull Ubuntu (latest)

```bash
docker pull ubuntu:latest
```

## Step 2: Find Out Which Version You Actually Pulled

```bash
# Inspect the image to find the actual version
docker image inspect ubuntu:latest --format='{{.Config.Labels}}'

# Or check the repo digests / run a quick version check
docker run --rm ubuntu:latest cat /etc/os-release
```

> Note the VERSION_ID (e.g., 22.04, 24.04) — this is what `latest` currently points to.

## Step 3: Tag It with the Real Version

```bash
# Replace 22.04 with whatever version you discovered above
docker tag ubuntu:latest ubuntu:22.04

# Verify both tags exist
docker images ubuntu
```

## Step 4: Run Interactively with -it

```bash
docker run -it --name my-ubuntu-test ubuntu:22.04 /bin/bash
```

You're now inside the container! Try a few commands:

```bash
ls /
cat /etc/os-release
exit
```

> The `exit` command stops the container (because the main process `/bin/bash` ends).

## Step 5: Verify Container Exists (Stopped State)

```bash
docker ps -a
```

You should see `my-ubuntu-test` with status `Exited`.

## Step 6: Remove the Container

```bash
docker rm my-ubuntu-test
```

## Step 7: Remove Both Image Tags (Cleanup)

```bash
docker rmi ubuntu:22.04
docker rmi ubuntu:latest
```

## Step 8: Verify Everything Is Cleaned Up

```bash
docker ps -a # Should show no containers
docker images ubuntu # Should show no Ubuntu images
```

---

## Quick Reference Summary

| Step | Command |
|------|---------|
| Pull | `docker pull ubuntu:latest` |
| Inspect | `docker run --rm ubuntu:latest cat /etc/os-release` |
| Tag | `docker tag ubuntu:latest ubuntu:22.04` |
| Run | `docker run -it --name my-ubuntu-test ubuntu:22.04 /bin/bash` |
| Exit | `exit` |
| Remove container | `docker rm my-ubuntu-test` |
| Remove images | `docker rmi ubuntu:22.04 ubuntu:latest` |

> **Pro tip:** `docker rm` + `docker rmi` will fail if something depends on them. Use `docker ps -a` and `docker images` to debug.