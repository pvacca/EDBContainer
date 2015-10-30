#!/bin/sh
for conf in ../../../postgresql_static_conf/*.conf; do ln -h "$conf"; done
