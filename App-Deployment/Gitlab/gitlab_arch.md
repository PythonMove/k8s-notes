### Gitlab specs:
* Single node deploy via Kubernetes & Helm charts
* Minimal deploy, serving up to 1000 users
* Estimated HW usage 8vCores/8GB RAM

> **NOTE:** **2GB SWAP** with swappiness set to **10** recommended, but not available due to conflicting dependencies with Kubernetes. Kubernetes does not support SWAP => SWAP is turned off.

### Gitlab arch:
* All core components
  * NGINX Ingress
  * Gitlab/Gitaly
  * Gitlab/Gitlab Exporter
  * Gitlab/Gitlab Grafana
  * Gitlab/Gitlab Shell
  * Gitlab/Migrations
  * Gitlab/Sidekiq
  * Gitlab/Webservice
  * Gitlab/Mailroom
* Optional dependencies
  * PostgreSQL
  * Redis

> **NOTE**: External PostgreSQL database >= v11, required disk space 5-10GB.
