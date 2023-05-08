# The Bitnami Vulnerability Database

This repository contains the data and configuration provided by [Bitnami](https://bitnami.com) to generate its vulnerability database.

## How the database is created

At [config](config) folder you can find the information about the Bitnami components, specially the vendor and product names to work with their [CPE specifications](https://cpe.mitre.org/specification/). Based on this information, the [data](data) folder is updated periodically with the set of CVEs related to our components.

### Available fields in config files

Most of the files under the `config/components` directory only include its component name, but there are components defining other properties like `cpeVendor`, `cpeProduct`, or `cpeSoftwareEdition`. In order to filter the CVEs related to each component, a sample `:cpeVendor:cpeProduct:` string is used, where `cpeVendor` and `cpeProduct` can be overriden by defining the property in its config file, being `name` the default value for both properties.

[All keys in the CPE string](https://cpe.mitre.org/specification/) can be defined in the different config files, which will be consumed by the Bitnami processes generating the SPDX information that are available in the final images. Here is the list of the different keys available: `cpeVendor`, `cpeProduct`, `cpeVersion`, `cpeUpdate`, `cpeEdition`, `cpeLanguage`, `cpeSoftwareEdition`, `cpeTargetSoftware`, `cpeTargetHardware`, and `cpeOther`.

Only `name` is mandatory in the JSON file, and the rest are totally optional. As mentioned previously, `cpeVendor` and `cpeProduct` defaults to `name` key, while the rest of properties are set to `*` by default in case it is not specified.

## Reporting a vulnerability or feedback

[Click here](https://github.com/bitnami/vulndb/issues/new/choose) to report a public vulnerability in the Bitnami ecosystem, or giving feedback about the project.

## License

Copyright &copy; 2023 Bitnami

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
