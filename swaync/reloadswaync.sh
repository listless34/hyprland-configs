#!/bin/bash

for i in {1..5}; do
	kill -9 swaync
done

swaync &

