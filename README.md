## Introduction

This is a simple repository which i intend to keep a running journal of all the openData API's and Scrapers which relate to legal research. The intention is that it be a machine readable system which the community may add to as necessary. Each data set will be available in both YAML and JSON formats which together should be parseable and integrateable by most any modern programming or scripting language.

This is not meant as a comprehensive API documentation system, but rather as a starting point to let machines find the API end point.

The files should probably be smarter than they currently are and incorporate ISO codes, airport codes, and other non-ambigous machine readable codes. If you agree, feel free to send a pull request!

### Organization

For now, I'm proposing to create the following folder structure:

    root
      |--legislation
      |   |
      |   |--international_organizations.yaml
      |   |--international_organizations.json
      |   |--states.yaml
      |   |--states.json
      |   |--defacto_states.yaml
      |   |--defacto_states.json
      |   |--sub_states.yaml
      |   |--sub_states.json
      |   |--municipalities.yaml
      |   |--municipalities.json
      |--regulation
      |   |
      |   |--...(same as above)
      |--cases
      |   |
      |___|--...(same as above)

### Classification

* `international_organizations`: UN treates, WTO agreements, etc. (I know this is not technically legislation, but it is close enough. If you think treaties deserve their own folder log an issue and I'm happy to talk it through.) ...
* `states`: not states as in the State of Tennessee, states as in members of the UN General Assembly. Rigidly defined to members.
* `defacto_states`: operate like a state but not member of the UNGA. I work in a defacto state, or non-recognized state, or whatever one may want to call it. It does not fit the other criteria.
* `sub_states`: State of Tennessee, Province of Alberta, Scotland, ...
* `municipalities`: municipal codes, to the extent they exist, ...

### Using

Simply require the document you need straight from the repo; in ruby you would do:

```ruby
require 'open-uri'
require 'yaml'
url = 'https://raw.github.com/compleatang/open-law-end-points/master/legislation/states.yaml'
source = YAML.load(open( URI.escape( url ) ))
```

or, if you wanted the JSON

```ruby
require 'open-uri'
require 'json'
url = 'https://raw.github.com/compleatang/open-law-end-points/master/legislation/states.json'
source = JSON.load(open( URI.escape( url ) ))
```

and you're ready to go with an updated list of the APIs end points.

## Contributing

Please do!

1. Fork it.
2. Add what you know; add to yaml or json as you prefer.
3. Run the ruby script so that the repo will build the yaml or json collateral file which you did not fill in.
4. Send a pull request.

### License

Public domain.