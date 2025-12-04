<!-- markdownlint-disable MD033 MD041 -->
<p align="center">
    <img width="400px" height=auto src="https://dyltqmyl993wv.cloudfront.net/bitnami/bitnami-by-vmware.png" />
</p>

<p align="center">
    <a href="https://twitter.com/bitnami"><img src="https://badgen.net/badge/twitter/@bitnami/1DA1F2?icon&label" /></a>
    <a href="https://github.com/bitnami/vulndb"><img src="https://badgen.net/github/stars/bitnami/vulndb?icon=github" /></a>
    <a href="https://github.com/bitnami/vulndb"><img src="https://badgen.net/github/forks/bitnami/vulndb?icon=github" /></a>
    <a href="https://github.com/bitnami/vulndb/actions/workflows/ci-pipeline.yml"><img src="https://github.com/bitnami/vulndb/actions/workflows/ci-pipeline.yml/badge.svg" /></a>
</p>

# The Bitnami Vulnerability Database

This repository contains the data and configuration provided by [Bitnami](https://bitnami.com) to generate its vulnerability database.

Please note that this database is populated with information from the year 2020 onwards.

## Table of contents

- [The Bitnami Vulnerability Database](#the-bitnami-vulnerability-database)
  - [Table of contents](#table-of-contents)
  - [How the database is created](#how-the-database-is-created)
    - [Available fields in config files](#available-fields-in-config-files)
  - [Deprecation policy](#deprecation-policy)
  - [How to consume this CVE feed](#how-to-consume-this-cve-feed)
  - [Reporting a vulnerability or feedback](#reporting-a-vulnerability-or-feedback)
  - [Deprecation notes](#deprecation-notes)
    - [2025-11](#2025-11)
    - [2025-10](#2025-10)
    - [2025-09](#2025-09)
    - [2025-08](#2025-08)
    - [2025-06](#2025-06)
    - [2025-05](#2025-05)
    - [2025-04](#2025-04)
    - [2025-03](#2025-03)
    - [2024-11](#2024-11)
    - [2024-09](#2024-09)
    - [2024-07](#2024-07)
    - [2024-06](#2024-06)
    - [2024-03](#2024-03)
    - [2024-01](#2024-01)
    - [2023-11](#2023-11)
    - [2023-09](#2023-09)
    - [2023-08](#2023-08)
    - [2023-07](#2023-07)
  - [License](#license)

## How the database is created

In the [config](config) folder you can find the information about the Bitnami components, especially the vendor and product names to work with their [CPE specifications](https://cpe.mitre.org/specification/). Based on this information, the [data](data) folder is updated periodically with the set of CVEs related to our components.

> NOTE: the `summary` information in our CVE registries is retrieved from the [CVEProject/cvelistV5](https://github.com/CVEProject/cvelistV5) CVE cache.

### Available fields in config files

Most of the files under the `config/components` directory only include their component name, but components are defining other properties like `cpeVendor`, `cpeProduct`, or `cpeSoftwareEdition`. To filter the CVEs related to each component, a sample `:cpeVendor:cpeProduct:` string is used, where `cpeVendor` and `cpeProduct` can be overridden by defining the property in its config file, being `name` the default value for both properties.

[All keys in the CPE string](https://cpe.mitre.org/specification/) can be defined in the different config files, which will be consumed by the Bitnami processes generating the SPDX information that is available in the final images. Here is the list of the different keys available: `cpeVendor`, `cpeProduct`, `cpeVersion`, `cpeUpdate`, `cpeEdition`, `cpeLanguage`, `cpeSoftwareEdition`, `cpeTargetSoftware`, `cpeTargetHardware`, and `cpeOther`.

Only `name` is mandatory in the JSON file, and the rest are optional. As mentioned previously, `cpeVendor` and `cpeProduct` defaults to the `name` key, while the rest of the properties are set to `*` by default in case it is not specified.

Additionally, a `to-be-deprecated: <date>` value may be present in those components that will be removed in the short term. For further information on this, please check the [deprecation policy](#deprecation-policy) section.

## Deprecation policy

From time to time, one or more assets may be deprecated. In that situation, we will continue generating the related CVE information for at least one month, or after the expiration date is met. Notice the expiration date is present in the format `yyyymmdd` (i.e. `20231231` stands for Dec. 31st, 2023). The procedure of deprecation and deletion is done by:

- Annotate components with the `to-be-deprecated: <date>` field in their config file setting the date when it will be removed. Add a deprecation notice in this `README.md` file as well.
- Delete the config file and the associated `data/${name}` folder once the retention period has expired.

## How to consume this CVE feed

This database includes CVE information **only** for Bitnami packages installed on top of the operating system for all distributed solutions (containers, Helm charts, OVAs, cloud images, etc.). The procedure to consume this information is shown below:

- Find the SPDX file in your solution. They are located under the `/opt/bitnami/<component>` directory and named with the pattern `.spdx-<component>.spdx`

For instance, in the case of a container:

```console
$ docker run bitnami/postgresql find /opt/bitnami -type f -name ".spdx-*"
/opt/bitnami/postgresql/.spdx-postgresql.spdx

$ docker run bitnami/postgresql cat /opt/bitnami/postgresql/.spdx-postgresql.spdx
{
    "SPDXID": "SPDXRef-postgresql",
    "spdxVersion": "SPDX-2.3",
    ...
```

- Get the packages included in the SPDX file under the `packages` section.

For instance, in the case of a container image:

```console
$ docker run bitnami/postgresql cat /opt/bitnami/postgresql/.spdx-postgresql.spdx
  "...": "...",
  "packages": [
    {
      "SPDXID": "SPDXRef-postgresql",
      "name": "PostgreSQL",
      "versionInfo": "15.3.0",
      "downloadLocation": "https://ftp.postgresql.org/pub/source/v15.3/postgresql-15.3.tar.gz",
      "licenseConcluded": "PostgreSQL",
      "licenseDeclared": "PostgreSQL",
      "filesAnalyzed": false,
      "externalRefs": [
        {
          "referenceCategory": "SECURITY",
          "referenceType": "cpe23Type",
          "referenceLocator": "cpe:2.3:*:postgresql:postgresql:15.3.0:*:*:*:*:*:*:*"
        },
        {
          "referenceCategory": "PACKAGE-MANAGER",
          "referenceType": "purl",
          "referenceLocator": "pkg:bitnami/postgresql@15.3.0"
        }
      ]
    },
    {
      "SPDXID": "SPDXRef-geos",
      "name": "GEOS",
      "versionInfo": "3.8.3",
      "downloadLocation": "https://github.com/libgeos/geos/archive/3.8.3.tar.gz",
      "licenseConcluded": "LGPL-2.1-only",
      "licenseDeclared": "LGPL-2.1-only",
      "filesAnalyzed": false,
      "externalRefs": [
        {
          "referenceCategory": "SECURITY",
          "referenceType": "cpe23Type",
          "referenceLocator": "cpe:2.3:*:libgeos:geos:3.8.3:*:*:*:*:*:*:*"
        },
        {
          "referenceCategory": "PACKAGE-MANAGER",
          "referenceType": "purl",
          "referenceLocator": "pkg:bitnami/geos@3.8.3"
        }
      ]
    },
  "...": "...",
```

- Finally, verify the version of your components against the affected versions of the different CVEs located under the `data/<name>/` directory (lowercase) to get the number of CVEs that affect it. Notice the CVE files honor the [OSV format](https://ossf.github.io/osv-schema).

## Reporting a vulnerability or feedback

[Click here](https://github.com/bitnami/vulndb/issues/new/choose) to report a public vulnerability in the Bitnami ecosystem, or give us feedback about the project.

## Deprecation notes

### 2025-12

- LimeSurvey

### 2025-11

- Keycloak Metrics SPI

### 2025-10

- Apisix Dashboard

### 2025-09

- Gonit

### 2025-08

- Dolibarr
- Matomo
- Subversion
- SuiteCRM

### 2025-06

- KES
- Promtail

### 2025-05

- Kubeapps
- Kubeapps APIs
- Kubeapps AppRepository Controller
- Kubeapps Asset Syncer
- Kubeapps OCI Catalog Service
- Kubeapps Pinniped Proxy
- Spring Cloud Data Flow

### 2025-04

- vmod-querystring

### 2025-03

- Mattermost
- ERPNext
- JFrog Artifactory Open Source

### 2024-11

- Airflow Exporter
- Airflow Scheduler
- Airflow Worker

### 2024-09

- supabase
- supabase-pljava
- supabase-postgres-meta
- supabase-postgres
- supabase-realtime
- supabase-storage
- supabase-vault
- supabase-wrappers

### 2024-07

- Akeneo
- EspoCRM
- Guacamole
- Guacamole Auth JDBC extension
- Live Helper Chat
- Pimcore
- ResourceSpace

### 2024-06

- Alfresco
- alfresco-pdf-renderer
- alfresco-search-services
- alfresco-transform-core
- Openfire
- SilverStripe
- Simple Machines Forum
- Publify
- Redash

### 2024-03

- Abantecart
- Canvas LMS
- Canvas RCE API
- CiviCRM
- Codeigniter
- Concrete5
- Kapacitor
- Mantis
- MODX
- MyBB
- Neos
- OpenProject
- OroCRM
- Osclass
- Percona XtraBackup
- phpList
- ReportServer
- ReviewBoard
- Roundcube
- SEO Panel
- Symfony
- JasperReports
- JRuby
- Tinytinyrss
- ttrss-mailer-smtp
- Typo3
- Weblate

### 2024-01

- ProcessMaker

### 2023-11

- Apache MXNet

### 2023-09

- Harbor Notary signer
- Harbor Notary server

### 2023-08

- Bitnami Shell

### 2023-07

- Wavefront
- Wavefront Proxy
- Wavefront Prometheus Adapter
- Wavefront HPA Adapter

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
