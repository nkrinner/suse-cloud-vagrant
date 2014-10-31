@echo off

REM set variables
REM TODO think about: does this make sense on windows
set VAGRANT_CONFIG_FILE=configs/2-controllers-0-compute.yaml
set PROPOSAL_YAML=/root/HA-cloud.yaml
set VAGRANT_SSH_CONFIG=/tmp/ssh-config.vagrant



REM ####################
REM use this on the devel system
vagrant up admin

REM ####################
REM use this for the demo
REM vagrant up --no-parallel

REM ####################
REM ssh configuration on the admin node
vagrant ssh-config
REM if %ERRORLEVEL% == 0 (
REM   echo SSH configuration failed, exiting...
REM   goto :eof
REM   ) else (
REM   echo SSH configured on admin node
REM )

vagrant up --no-parallel

REM ###################
REM basic functionality test
vagrant ssh admin  -c "sudo touch /root/root-test"
if %errorlevel% neq 0 (
  echo touch/root privileges test failed, exiting...
    ) else (
  echo touch/root privileges test executed on admin node
)


vagrant ssh admin -c "sudo setup-node-aliases.sh"
vagrant ssh admin -c "sudo crowbar batch build /root/HA-cloud.yaml"
