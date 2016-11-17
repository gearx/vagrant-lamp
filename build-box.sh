#!/bin/bash

vagrant up
vagrant package --output gearx-lamp.box
vagrant destroy
