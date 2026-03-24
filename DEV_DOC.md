# Developer Documentation — Inception

This document explains how a developer can set up, build, and maintain the Inception project.

---

## Prerequisites

The following tools are required:

- Docker
- Docker Compose
- Make

The project is designed to run on a Linux environment.

---

## Project configuration

- .env file contains all configuration values such as:
  - DOMAIN_NAME
  - WordPress settings (WP_TITLE, WP_ADMIN_USER, WP_USER, etc.)
  - Database settings (MYSQL_DATABASE, MYSQL_USER)
- Docker secrets are used to store sensitive data (database passwords)
- Each service (NGINX, WordPress, MariaDB) has its own Dockerfile

All containers are connected via a dedicated Docker network, ensuring isolation and secure communication.

---

## Data Persistence

Data persistence is a critical aspect of the project to ensure that data is not lost when containers are stopped, removed, or rebuilt.

In this infrastructure, persistence is handled using **Docker volumes**.

### Why persistence is needed

By default, containers are ephemeral:
- When a container is deleted, all its internal data is lost
- This is problematic for services like databases or CMS

To solve this, persistent storage must be externalized.

### Volumes used in the project

Two main volumes are defined:

- **MariaDB volume**
  - Stores all database data (tables, users, content)
  - Ensures WordPress data is preserved across restarts

- **WordPress volume**
  - Stores website files (themes, plugins, uploads)
  - Prevents data loss when the container is rebuilt

Example:
```bash
docker volume ls
docker images ls
```

---

## Build and launch the project

Clone the repository:
```bash
git clone https://github.com/abllox19/inception.git
cd inception

make       # Build and start the containers
make stop  # Stop the containers
make clean # Remove containers, images, volumes and networks:

docker ps                                       # Check running containers
make logs                                       # View logs
docker container rm -f nginx wordpress mariadb  # Remove specific containers
docker volume rm srcs_wp srcs_db                # Remove volumes
docker system prune -af                         # Prune all unused Docker resources

