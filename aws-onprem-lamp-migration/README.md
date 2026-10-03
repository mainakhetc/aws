# AWS On-Premises LAMP Application Migration

## Overview

Hands-on project demonstrating the migration of a small **Linux LAMP application and MySQL database** from a simulated on-premises environment to AWS.

### Migration

![On-Premises LAMP Application to AWS Migration](./architecture/architecture-diagram.png)


```text
On-Premises
Amazon Linux
Apache + PHP + MySQL
        │
        │ Application + DB Migration
        ▼
AWS VPC
 ├── EC2 — Apache + PHP + PHP-FPM
 └── RDS — MySQL
```

## AWS Architecture

* **VPC:** `10.0.0.0/16`
* **Public Subnet:** EC2 application server
* **Private Subnets:** RDS MySQL
* **Internet Gateway:** Public subnet connectivity
* **Security Groups:** Restricted EC2 → RDS access
* **EC2:** Amazon Linux 2023
* **RDS:** MySQL
* **Migration:** `mysqldump` / MySQL restore

---

## 1. Source Application

The original PHP/MySQL application was running on the simulated on-premises Linux server.

![Source Application](screenshots/01-source-application.png)

![Source Application](screenshots/02-source-application.png)

### Source MySQL Data

![Source MySQL Data](screenshots/03-source-mysql-data.png)

---

## 2. AWS Network

Created a dedicated VPC with public and private subnets.

![VPC](screenshots/04-vpc.png)

![Subnets](screenshots/05-subnets.png)

### Public Route Table

Internet Gateway route for the EC2 public subnet.

![Public Route Table](screenshots/06-public-route-table.png)

### Private Database Route Table

Private routing for the RDS subnets.

![Private Route Table](screenshots/07-private-db-route-table.png)

---

## 3. EC2 Application Server

Deployed **Amazon Linux 2023** in the public subnet.

![EC2 Instance](screenshots/08-ec2-instance.png)

![Amazon Linux](screenshots/09-target-amazon-linux.png)

Installed and configured:

* Apache
* PHP
* PHP-FPM

![LAMP Stack](screenshots/10-target-lamp.png)

![PHP-FPM Service](screenshots/17-enable-php-fpm-service.png)

![PHP-FPM Configuration](screenshots/18-php-fpm-configure.png)

---

## 4. Amazon RDS MySQL

Created an RDS MySQL database in private subnets.

![RDS Subnet Group](screenshots/11-rds-subnet-group.png)

![RDS MySQL](screenshots/12-rds-mysql-database.png)

### Database Security

RDS MySQL port `3306` is restricted to the EC2 application security group.

![RDS Security Group](screenshots/13-rds-security-group.png)

---

## 5. Database Migration

Created a MySQL backup from the source environment and restored it into RDS.

```bash
mysqldump -u <user> -p <database> > database.sql

mysql -h <RDS-ENDPOINT> -u <user> -p <database> < database.sql
```

### Backup

![Database Backup](screenshots/14-database-backup.png)

### Migrated Data

![RDS Migrated Data](screenshots/15-rds-migrated-data.png)

---

## 6. Application Migration

Copied the PHP application to EC2 and updated the database configuration from:

```text
localhost
```

to:

```text
RDS MySQL Endpoint
```

![Application Code](screenshots/16-application-code-migrated.png)

---

## 7. Migration Validation

The migrated application was successfully accessed from the EC2 web server and verified against the RDS database.

![Migrated Application](screenshots/19-migrated-application.png)

![Migrated Application](screenshots/20-migrated-application2.png)

---

## Key Skills Demonstrated

**AWS:** VPC, EC2, RDS, Security Groups, Route Tables, Internet Gateway, Availability Zones

**Linux:** Amazon Linux, Apache, PHP, PHP-FPM, MySQL

**Migration:** Application migration, MySQL backup/restore, database migration, application reconfiguration, validation

**Architecture:** Public/private subnet design, application/database tier separation, least-privilege network access

---

## Project Outcome

Successfully migrated a traditional **single-server LAMP application** to AWS with:

```text
EC2 → Application Tier
RDS → Database Tier
VPC → Network Isolation
Security Groups → Controlled DB Access
```

This project demonstrates an end-to-end **Linux application + database migration to AWS**.

