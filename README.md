[![Build Status](https://cloud.drone.io/api/badges/bic-harness/docker-hello-world/status.svg?ref=refs/heads/master)](https://cloud.drone.io/bic-harness/docker-hello-world)

Hello World
===========

This is a simple Docker image that just gives http responses on port 8000.


Sample Usage
------------

### Starting a web server on port 80

```bash
$ docker run -d --rm --name web-test -p 80:8000 crccheck/hello-world
```

You can now interact with this as if it were a dumb web server:

```
$ curl localhost
<xmp>
Hello World
...snip...
```

```
$ curl -I localhost
HTTP/1.0 200 OK
```

```
$ curl -X POST localhost/super/secret
<HTML><HEAD><TITLE>501 Not Implemented</TITLE></HEAD>
...snip...
```

```
$ curl --write-out %{http_code} --silent --output /dev/null localhost
200
```
