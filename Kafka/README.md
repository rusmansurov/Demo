# Kafka KRaft Cluster (No Zookeeper) in Docker Compose

This project sets up a local Apache Kafka cluster using **KRaft mode** (no Zookeeper) with **three brokers/controllers** using Docker Compose.

## Components

* Kafka 3-node cluster (KRaft mode)
* Bitnami Kafka Docker images

## Getting Started

### 1. Start the Cluster

```bash
docker compose up -d
```

### 2. Create a Topic

```bash
./scripts/create-topic.sh my-topic
```

### 3. Produce Messages

```bash
./scripts/produce.sh my-topic
```
> Entyer your message (any text)
> Exit with `Ctrl + D`

### 4. Consume Messages

```bash
./scripts/consume.sh my-topic
```

> Exit with `Ctrl + C`

## Scripts

All CLI tools are run inside the `kafka-1` container:

* `create-topic.sh` — creates a topic with 1 partition and 1 replication.
* `produce.sh` — opens an interactive Kafka producer.
* `consume.sh` — starts a console consumer to read from the beginning.

--

## Environment Variable Descriptions

| Variable | Description |
|---------|-------------|
| `KAFKA_CFG_NODE_ID` | Unique ID of the Kafka node (used in quorum voting). |
| `KAFKA_KRAFT_CLUSTER_ID` | Identifier for the KRaft cluster. Must be the same across all nodes. |
| `KAFKA_CFG_PROCESS_ROLES` | Defines the role(s) of the node: `broker`, `controller`, or both. |
| `KAFKA_CFG_CONTROLLER_QUORUM_VOTERS` | List of all controllers in the form `ID@host:port`. Required for quorum. |
| `KAFKA_CFG_LISTENERS` | Declares the listener endpoints inside the container. Example: PLAINTEXT://:9090, EXTERNAL://:9092. |
| `KAFKA_CFG_ADVERTISED_LISTENERS` | How the broker advertises itself to clients (must be resolvable externally). |
| `KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP` | Maps listeners to their security protocols. Usually PLAINTEXT for development. |
| `KAFKA_CFG_CONTROLLER_LISTENER_NAMES` | Specifies which listener to use for controller communication. |
| `KAFKA_CFG_INTER_BROKER_LISTENER_NAME` | Defines which listener is used for internal broker-to-broker communication. |

--

## 📘 References

* [Apache Kafka KRaft mode](https://kafka.apache.org/documentation/#kraft)
* [Bitnami Kafka Docker](https://hub.docker.com/r/bitnami/kafka)
