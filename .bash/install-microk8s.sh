#!/bin/bash

# INSTALL MICROK8s
sudo snap install microk8s --classic
sudo microk8s config > ~/.kube/config