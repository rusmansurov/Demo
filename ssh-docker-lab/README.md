# 🐳 SSH Docker Lab

An educational project to learn **SSH** using **Docker**. This container runs an OpenSSH server with public key authentication so you can:

* Connect via SSH
* Transfer files (`scp`)
* Forward ports
* Work with SSH keys and agent

### Setup

1. Clone the project:

   ```bash
   git clone https://github.com/rusmansurov/Demo.git
   cd ssh-docker-lab
   ```

2. Generate SSH key:

   ```bash
   ssh-keygen -t ed25519 -f ./id_ed25519 -N "" -C "docker lab"
   ```

3. Start the container:

   ```bash
   docker compose up --build -d
   ```

### Connect

```bash
ssh -i ./id_ed25519 sshuser@localhost -p 2222
```

### Examples

* Copy file into container:

  ```bash
  scp -i ./id_ed25519 -P 2222 ./file.txt sshuser@localhost:/home/sshuser/
  ```

* Port forwarding:

  ```bash
  ssh -i ./id_ed25519 -p 2222 -L 9000:localhost:8000 sshuser@localhost
  ```

### Cleanup

```bash
docker compose down
```

---

## Extras

You can add this to your `~/.ssh/config`:

```ssh
Host dockerlab
  HostName localhost
  Port 2222
  User sshuser
  IdentityFile /path/to/project/id_ed25519
```

Then just run:

```bash
ssh dockerlab
```
--

## Author

Created for educational purposes to explore SSH hands-on with Docker.

