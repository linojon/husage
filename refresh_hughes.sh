#!/bin/bash
cd /Users/jonathan/rails/hughes
#/opt/local/bin/ruby script/runner -eproduction 'Usage.refresh'
curl "http://localhost:3006/refresh"
