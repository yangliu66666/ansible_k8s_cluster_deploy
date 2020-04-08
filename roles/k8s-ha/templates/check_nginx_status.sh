#!/bin/bash

if [ -f {{ nginx_dir }}/logs/nginx.pid ];then
   exit 0
else
   exit 1
fi
