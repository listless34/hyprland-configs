#!/usr/bin/env bash

sudo pacman -Rns $(pacman -Qdtq)
yay -Scc
yay -Yc
