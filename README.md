# Socrata.jl

Socrata.jl is a Julia wrapper for accessing the Socrata Open Data API (http://dev.socrata.com) and importing data into a DataFrame.  Socrata is an open data platform used by many local and State governments as well as by the Federal Government.  For example, some popular Socrata repositories include:

* [Socrata's Open Data Site](https://opendata.socrata.com)
* [HealthCare.gov Health Plans](https://www.healthcare.gov/health-plan-information)
* [Centers for Medicare & Medicaid Services](https://data.cms.gov)
* [New York City OpenData](https://nycopendata.socrata.com)

More Open Data Resources can be found [here](http://www.socrata.com/resources/).
## Installation
````julia
Pkg.clone("https://github.com/dreww2/Socrata.jl.git")
````
## Basic Usage

The Socrata API consists of a single function, `socrata`, which at a minimum takes a Socrata `url` and returns a `DataFrame`:

````julia
using Socrata

df = socrata("http://soda.demo.socrata.com/resource/4334-bgaj")
````

The `url` may be a [Socrata API Endpoint](http://dev.socrata.com/docs/endpoints.html) or may be common url found in the address bar (in which case Socrata.jl will automatically attempt to parse the string into a usable format).  For example, the following are all valid urls for the same dataset:

* http://soda.demo.socrata.com/resource/4334-bgaj
* http://soda.demo.socrata.com/resource/4334-bgaj.json
* http://soda.demo.socrata.com/resource/4334-bgaj.csv
* https://soda.demo.socrata.com/dataset/USGS-Earthquakes-for-2012-11-01-API-School-Demo/4334-bgaj
## Optional Arguments

#### Basic Arguments

There are several optional keyword string arguments:

* `app_token` is your [Socrata application token](http://dev.socrata.com/docs/app-tokens.html) which allows for more API requests per unit of time
* `limit` is equal to the number of rows in the dataset you would like to retrieve.  Default is equal to 100, max is equal to 1,000 (Socrata's limit).  If you want to download a large dataset, set `fulldataset=true` (see below).
* `offset` indicates the first row from which to start pulling data.
* `fulldataset` ignores all query parameters including `limit`, `offset`, and any of the Socrata Query Language (SoQL) arguments and downloads the entire dataset.
* `usefieldids` is not yet implemented, but will substitute the default human-readable column headers with API field IDs.

#### Socrata Query Language (SoQL) Arguments

Socrata.jl supports [SoQL queries](http://dev.socrata.com/docs/queries.html) using the following arguments:

* `select`
* `where`
* `order`
* `group`
* `q`
* `limit` and `offset` as described above.

Note that any references to columns inside these arguments must reference the dataset`s API Field ID, which can be found on any Socrata dataset page under Export => SODA API => Column IDs.
## Examples

Setup

````julia
using Socrata

url = "http://soda.demo.socrata.com/resource/4334-bgaj"
token = "your_app_token_goes_here"
`````

A basic query, getting the first 5 rows:

````julia
df = socrata(url, app_token=token, limit="5")
````

Get rows 5-10 of the data:

````julia
df = socrata(url, app_token=token, limit="5", offset="5")
````

Get only the first 10 rows and the Source, Earthquake_ID, Magnitude, and Region columns:
````julia
df = socrata(url, app_token=token, limit="10", select="source, earthquake_id, magnitude, region")
````

You can add multiple conditions within a single argument.  For example, get only rows where magnitude is greater than 5.5 and depth is less than 30:
````julia
df = socrata(url, app_token=token, where="magnitude > 5.5 AND depth < 30")
````

Search for `Hawaii` in the dataset where Magnitude > 2 and only select certain columns:

````julia
df = socrata(url, app_token=token, q="hawaii", where="magnitude > 2", select="datetime, magnitude, region, location")
````
## TODO

* Add support for automatically getting API Field IDs
* Implement better app_token system
* Add support for JSON and XML

