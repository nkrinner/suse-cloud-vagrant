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



REM ###################
REM basic functionality test
vagrant ssh admin  -c "sudo touch /root/root-test"
if %errorlevel% neq 0 (
  echo touch/root privileges test failed, exiting...
    ) else (
  echo touch/root privileges test executed on admin node
)

REM ##################
REM remove windows line breaks
vagrant ssh admin -c "sudo  for i in /tmp; do tr -d '\r' < $i > $i; done"


REM ##################
REM copy files
vagrant ssh admin -c "sudo  cp /tmp/setup-node-aliases /root/bin/setup-node-aliases; sudo chmod u+x /root/bin/setup-node-aliases"
vagrant ssh admin -c "sudo  cp /tmp/node-sh-vars root/bin/node-sh-vars"

REM ####################
REM configure the admin node


REM ####################
REM TODO:
REM implement these commands from the original build.sh script
REM pre vagrant-up
REM check_vagrant_config ## not implemented
REM check_hypervisor

REM post vagrant-up
REM vagrant_ssh_config ## not implemented - not needed?
REM setup_node_aliases # implemented
REM setup_node_sh_vars # implemented
REM switch_to_kvm_if_required ## not implementd - not needed?
REM batch_build_proposals "$PROPOSALS_YAML" # implemented - not tested

REM setup_node_aliases
vagrant ssh admin -c "sudo /root/bin/setup-node-aliases"
if %ERRORLEVEL% neq 0 (
  echo setup-node-aliases failed, exiting...
  goto :eof
  ) else (
  echo setup-node-aliases executed on admin node
)

REM setup_node_sh_vars
vagrant ssh admin -c "/root/bin/node-sh-vars > /tmp/.crowbar-nodes-roles.cache"
if %ERRORLEVEL% NEQ 0 (
  echo node-sh-vars failed, exiting...
  goto :eof
  ) else (
  echo node-sh-vars executed on admin node
)


REM batch_build_proposals "$PROPOSALS_YAML"
vagrant ssh admin -c "sudo stdbuf -oL crowbar batch --timeout 1200 build %PROPOSAL_YAML%"
if %ERRORLEVEL% NEQ 0 (
  echo crowbar batch failed, exiting...
  goto :eof
  ) else (
  echo crowbar batch executed on admin node
)



echo Success!
echo.
echo A highly-available OpenStack cloud has been built.  You can now test failover.


