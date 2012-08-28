#!/bin/bash
bundle check | sed "s/ \* /\'/; s/ [(]/\': version => \'/; s/[)]/\' ;/ " | sort

