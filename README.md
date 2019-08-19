
Prometheus / Grafana monitoring stack using Docker
==================================================

Contents
--------

- [Overview](#overview)
- [Repository layout](#repository-layout)
- [Docker configuration](#docker-configuration)
- [Setup scripts](#scripts)
  * [MySQL Exporter](#mysql-exporter)
  * [Linux Node Exporter](#linux-node-exporter)
  * [ActiveMQ Exporter](#activemq-exporter)
  * [Windows / IIS / .NET Exporter](#windows-/-iis-/-.net-exporter)
  * [Windows / SQL Server Exporter](#windows-/-sql-server-exporter)

Overview
--------

The goal of this project is to build a monitoring stack with [Prometheus](https://prometheus.io) and [Grafana](https://grafana.com) inside [Docker](https://www.docker.com) containers.

Both Prometheus and Grafana have multiple options and can be configured in many ways. In this repository we are using them to collect basic metrics from **Microsoft Windows**, **IIS Web Services** and **SQL Server**. As well as **Linux** operating system, **ActiveMQ** and **MySQL** services.

Prometheus is going to find which servers (*targets*) to monitor by using a **service discovery** integration. Discovery is available for **AWS**, **Azure** or **Kubernetes**, among others. Although in this repository we are using simple **file discovery**.

Metrics are exposed on target systems by [exporters](https://prometheus.io/docs/instrumenting/exporters/), providing an HTTP service which Prometheus can query at regular intervals. If a Docker daemon is available on the target system, exporters can run as containers as well. Otherwise, they can be installed manually as normal applications of course.

Along with Prometheus and Grafana we are also setting up [Alertmanager](https://github.com/prometheus/alertmanager) for automated notifications.

Repository layout
-----------------

This repository has four directories which contain all the required files.

- **config**: configuration files for supporting services
- **dashboards**: sample Grafana dashboards which work with our Prometheus configuration
- **docker**: required files to run Prometheus / Grafana in Docker containers
- **scripts**: scripts for setting up exporters on Windows / Linux


Docker configuration
--------------------

We are using [docker-compose](https://docs.docker.com/compose/) to run Prometheus / Grafana containers. This means all Docker configuration can be found in the **docker-compose.yml** file. Persistent data is stored on Docker **volumes** while configuration files are used through Docker **bind mounts**. To spin up a new monitoring stack you can run (from inside **docker** directory):

	$ docker-compose up

Prometheus configuration and service discovery files can be found under the **prometheus** directory. Each file with the **json** extension is used by the *file discovery* service. The **rules.yml** file is used to setup **alert conditions**. And the **prometheus.yml** file is the main Prometheus configuration file.

Grafana configuration can also be found under the **grafana** directory. You will want to update the **grafana.ini** file. This is the main configuration file. Other files in this directory are used for automatic *datasource provisioning*.

The third service docker-compose will launch is Alertmanager. You can find its configuration under the **alertmanager** directory.

Setup scripts
-------------

### MySQL Exporter

There's two required steps to use the [mysqld_exporter](https://github.com/prometheus/mysqld_exporter). First, create a new database user which the exporter will use to connect to the MySQL server. And next, install the mysqld_exporter on the target system.

To create the database user, run the following commands using the **mysql** client.

	CREATE USER 'mysqld_exporter'@'localhost' IDENTIFIED BY 'MySecret' WITH MAX_USER_CONNECTIONS 3;
	GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'mysqld_exporter'@'localhost';

To install the mysqld_exporter, run the ```install-mysqld-exporter.sh``` **Bash** script.

### Linux Node Exporter

To install the [node_exporter](https://github.com/prometheus/node_exporter), run the ```install-node-exporter.sh``` **Bash** script.

### ActiveMQ Exporter

Apache ActiveMQ metrics are collected by [Telegraf](https://github.com/influxdata/telegraf), a metrics collection agent with input/output plugins for many systems.

To install the Telegraf agent for ActiveMQ, run the ```install-telegraf-activemq.sh``` **Bash** script.

### Windows / IIS / .NET Exporter

Microsoft Windows, IIS and .NET Framework metrics are collected by [Telegraf](https://github.com/influxdata/telegraf), a metrics collection agent with input/output plugins for many systems.

To install the Telegraf agent for Windows / IIS / .NET, run the ```install-telegraf-dotnet.ps1``` **PowerShell** script.

### Windows / SQL Server Exporter

Microsoft Windows and SQL Server metrics are collected by [Telegraf](https://github.com/influxdata/telegraf), a metrics collection agent with input/output plugins for many systems.

There's two required steps to use Telegraf with SQL Server. First, create a new database user which the exporter will use to connect to the SQL Server system. And next, install the Telegraf agent on the target system.

To create the database user, run the following **T-SQL** commands.

	USE master;
	GO
	CREATE LOGIN [telegraf] WITH PASSWORD = N'MySecret';
	GO
	GRANT VIEW SERVER STATE TO [telegraf];
	GO
	GRANT VIEW ANY DEFINITION TO [telegraf];
	GO

To install the Telegraf agent for Windows / SQL Server, run the ```install-telegraf-mssql.ps1``` **PowerShell** script.
