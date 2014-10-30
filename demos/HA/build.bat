@echo off
echo Hello, World!

set VAGRANT_CONFIG_FILE=configs/2-controllers-0-compute.yaml
set PROPOSAL_YAML=/root/HA-cloud.yaml
echo var %VAGRANT_CONFIG_FILE%

:usage
echo Setup a SUSE Cloud demo setup with HA on Windows with vagrant and virtualbox
goto:eof

call:usage
