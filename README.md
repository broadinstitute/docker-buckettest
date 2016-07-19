# buckettest
Broad web bucket test tool

# Requirements
* Docker

# Running buckettest
This is a very simple container that just runs a script to try to test the various web buckets on a test host before changes are pushed globally.  To run, you just do:

```bash
docker run -it --rm broadinstitute/buckettest -b bucket -t testhost -u /url/to/check/
```
