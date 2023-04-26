# The Bitnami Vulnerability Database

This repository contains the data and configuration provided by [Bitnami](https://bitnami.com) to generate its vulnerability database.

## How the database is created

At [config](config) folder you can find the information about the Bitnami components, specially the vendor and product names to work with their [CPE specifications](https://cpe.mitre.org/specification/). Based on the information exists in that folder, periodically the [data](data) folder is updated with the set of CVE related to our components.

## Reporting a vulnerability or feedback

[Click here](https://github.com/bitnami/vulndb/issues/new/choose) to report a public vulnerability in the Bitnami ecosystem, or giving feedback about the project.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
