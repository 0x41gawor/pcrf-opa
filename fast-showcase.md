# Fast showcase
This doc outlines how to get fast to the state of lab-able stuff presented in readme.

## Start instance of OPA SERVER
There are two opts: Docker or local binary
### Docker
```sh
docker run -p 8181:8181 openpolicyagent/opa \
    run --server --log-level debug
```
### Running locally 
```sh
curl -L -o opa https://openpolicyagent.org/downloads/v0.62.1/opa_linux_amd64_static
chmod 755 ./opa
./opa run --server
```
## Put policies and data 
data:
```curl
curl --location --request PUT 'http://192.168.56.106:8181/v1/data/' \
--header 'Content-Type: application/json' \
--data '{
    "ims": {
        "whitelist": [
            "600500700",
            "100200300",
            "420692137"
        ]
    },
    "internet": {
        "min_credits": 100
    }
}'
```
policy for ims
```curl
curl --location --request PUT 'http://192.168.56.106:8181/v1/policies/ims' \
--header 'Content-Type: text/plain' \
--data '```rego
package ims

import rego.v1

default allow_user := false

allow_user if {
	some i
	input.user.imsi == data.ims.whitelist[i]
}'
```
policy for internet
```curl
curl --location --request PUT 'http://192.168.56.106:8181/v1/policies/internet' \
--header 'Content-Type: text/plain' \
--data 'package internet

import rego.v1

default allow_user := false

allow_user if {
	input.user.credits > data.internet.min_credits
}'
```
## Queries
Is user allowed to enter internet service?
```curl
curl --location 'http://192.168.56.106:8181/v1/data/internet/allow_user' \
--header 'Content-Type: application/json' \
--data '{
    "input": {
        "user": {
            "credits": 1,
            "imsi": "600500700"
        }
    }
}'
```
Is user allowed to enter IMS service?
```curl
curl --location 'http://192.168.56.106:8181/v1/data/ims/allow_user' \
--header 'Content-Type: application/json' \
--data '{
    "input": {
        "user": {
            "credits": 1,
            "imsi": "600500700"
        }
    }
}'
```