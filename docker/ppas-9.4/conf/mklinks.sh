#!/bin/sh
for conf in $(ls ../../../postgresql_static_conf/*.conf); do ln -h "$conf"; done
