# Installation steps:
# 1. Put this file under ~/.phpdebug
#    $ curl https://gist.githubusercontent.com/torinaki/9059015/raw/.phpdebug > ~/.phpdebug
# 2. Put following lines into ~/.bashrc:
#    # Get the aliases and functions
#    if [ -f ~/.phpdebug ]; then
#        . ~/.phpdebug
#    fi
# 3. (optional) Script will try to autodetect your machine IP where runs IDE or use 127.0.0.1 otherwise.
#    If automatic detection doesn't work for you, set ip directly via IDE_IP enviroment variable:
#    $ export IDE_IP=1.2.3.4
# 4. (optional) Change ports if it not same as default (see local variables zend_debugger_config and xdebug_config);
#    $ export IDE_ZEND_PORT=10137
#    $ export IDE_ZDEBUG_PORT=9000
# 5. (optional) Change IDE specific configuration: serverName, idekey
#    $ export IDE_SERVERNAME="Any_server_name"
#    $ export IDE_KEY="PHPSTORM"
# 6. Run: source ~/.bashrc

# Usage:
# 1. After installation use phpdebug/phpdebugoff commands to start/stop debugging:
#   $ phpdebug
#   $ php ./script1_to_debug.php
#   $ php ./script2_to_debug.php
#   $ phpdebugoff
# 2. Or simply use instead of php command to debug only one script
#   $ phpdebug -dmemory_limit=1G ./script_to_debug.php

# Init default evniroment variables
export IDE_ZEND_PORT=10137
export IDE_XDEBUG_PORT=9000
export IDE_KEY="PHPSTORM"
export IDE_SERVERNAME="$(hostname)"

function _check_xdebug_installed()
{
    if ! php -i | egrep -q "(xdebug|zend_debugger)"; then
        echo "\e[0;31mWarning! XDebug or Zend Debugger extension not found\e[m"
    fi
}

function _print_settings_info()
{
    echo -e "\e[93mXDebug connection is $IDE_IP:$IDE_XDEBUG_PORT and server name '$IDE_SERVERNAME'. Zend Debugger connection is $IDE_IP:$IDE_ZEND_PORT with IDE key '$IDE_KEY'\e[m"
    echo -e "\e[93mAny of this settings can be configured with environment variables: IDE_IP, IDE_XDEBUG_PORT, IDE_SERVERNAME, IDE_ZEND_PORT, IDE_KEY\e[m"
}

function _phpdebug()
{
    # For Zend debugger
    # Set special EVN variables (don't forget to change "debug_host" and "debug_port")
    local zend_debugger_config="start_debug=1&debug_stop=0&debug_fastfile=1&debug_covere=1&use_remote=1&send_sess_end=1&debug_session_id=2000&debug_start_session=1&debug_port=${IDE_ZEND_PORT}"
    # For Xdebug
    # Set special EVN variables.
    # PHPSTORM is default idekey key. It must be same like in PhpStorm -> Settings -> PHP -> Debug -> DBGp Proxy
    local xdebug_config="idekey=${IDE_KEY} remote_port=${IDE_XDEBUG_PORT}"
    # For PhpStorm
    # Same for Xdebug and Zend Debugger
    # PhpStorm server config name is placed in Settings -> PHP -> Servers
    local php_ide_config="serverName=${IDE_SERVERNAME}"
    
    # try to autodetect IP if global variable IDE_IP not set
    if [ -z ${IDE_IP+x} ]; then
        if [ -z "$SSH_CLIENT" ]; then
           IDE_IP="127.0.0.1";
        else
           IDE_IP=$( echo $SSH_CLIENT | sed s/\ .*$// );
        fi
    fi
    
    zend_debugger_config="${zend_debugger_config}&debug_host=${IDE_IP}"
    xdebug_config="${xdebug_config} remote_host=${IDE_IP}"
    
    _check_xdebug_installed
    _print_settings_info
    
    if [ "$*" = "" ]; then
        export QUERY_STRING="$zend_debugger_config"
        export XDEBUG_CONFIG="$xdebug_config"
        export PHP_IDE_CONFIG="$php_ide_config"
    else
        PHP_IDE_CONFIG="$php_ide_config" XDEBUG_CONFIG="$xdebug_config" QUERY_STRING="$zend_debugger_config" php $*
    fi
}
alias phpdebug="_phpdebug"
alias phpdebugoff="unset QUERY_STRING && unset PHP_IDE_CONFIG && unset XDEBUG_CONFIG"
