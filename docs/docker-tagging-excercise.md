Here's a complete CLI exercise from pull to cleanup
---

Docker Pull → Tag → Run → Cleanup Exercise
Step 1: Pull Ubuntu (latest)
docker pull ubuntu:latest
Step 2: Find Out Which Version You Actually Pulled

# Inspect the image to find the actual version

docker image inspect ubuntu:latest --format='{{.Config.Labels}}'

# Or check the repo digests / run a quick version check

docker run --rm ubuntu:latest cat /etc/os-release
Note the VERSION_ID (e.g., 22.04, 24.04) — this is what latest currently points to.
Step 3: Tag It with the Real Version

# Replace 22.04 with whatever version you discovered above

docker tag ubuntu:latest ubuntu:22.04

# Verify both tags exist

docker images ubuntu
Step 4: Run Interactively with -it
docker run -it --name my-ubuntu-test ubuntu:22.04 /bin/bash
You're now inside the container! Try a few commands:
ls /
cat /etc/os-release
exit
The exit command stops the container (because the main process /bin/bash ends).
Step 5: Verify Container Exists (Stopped State)
docker ps -a
You should see my-ubuntu-test with status Exited.
Step 6: Remove the Container
docker rm my-ubuntu-test
Step 7: Remove Both Image Tags (Cleanup)
docker rmi ubuntu:22.04
docker rmi ubuntu:latest
Step 8: Verify Everything Is Cleaned Up
docker ps -a          # Should show no containers
docker images ubuntu  # Should show no Ubuntu images
---

Quick Reference Summary
Step Command Purpose
Pull docker pull ubuntu:latest Get the image
Inspect docker run --rm ubuntu:latest cat /etc/os-release Find actual version
Tag docker tag ubuntu:latest ubuntu:22.04 Pin the version
Run docker run -it --name my-ubuntu-test ubuntu:22.04 /bin/bash Interactive session
Exit exit Leave + stop container
Remove container docker rm my-ubuntu-test Delete stopped container
Remove images docker rmi ubuntu:22.04 ubuntu:latest Cleanup images
Pro tip: docker rm + docker rmi will fail if something depends on them. Use docker ps -a and docker images to debug.
