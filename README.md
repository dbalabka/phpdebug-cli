# phpdebug-cli
XDebug PHP CLI debugging helper console command with PhpStorm, NetBeans support

# Installation steps
1. Donwload file into ~/.phpdebug. Run following command:
   ```bash
   curl https://raw.githubusercontent.com/torinaki/phpdebug-cli/master/phpdebug.sh > ~/.phpdebug
   ```
2. Put following lines into ~/.bashrc :
   ```bash
   # Get the aliases and functions
   if [ -f ~/.phpdebug ]; then
       . ~/.phpdebug
   fi
   ```
3. (optional) Script will try to autodetect your machine IP where runs IDE or use 127.0.0.1 otherwise.
   If automatic detection doesn't work for you, set ip directly via IDE_IP enviroment variable:
   ```bash
   export IDE_IP=1.2.3.4
   ```
4. (optional) Change ports if it not same as default (see local variables zend_debugger_config and xdebug_config);
```bash
   export IDE_ZEND_PORT=10137
   export IDE_ZDEBUG_PORT=9000
   ```
5. (optional) Change IDE specific configuration: serverName, idekey
```bash
   export IDE_SERVERNAME="Any_server_name"
   export IDE_KEY="PHPSTORM"
   ```
6. Run: source ~/.bashrc

# Usage
1. After installation use phpdebug/phpdebugoff commands to start/stop debugging:
```bash
  $ phpdebug
  $ php ./script1_to_debug.php
  $ php ./script2_to_debug.php
  $ phpdebugoff
  ```
2. Or simply use instead of php command to debug only one script
```bash
  $ phpdebug -dmemory_limit=1G ./script_to_debug.php
  ```
  
# Configuration options
You can use evniroment variables to change default configurations
```bash
export IDE_ZEND_PORT=10137
export IDE_XDEBUG_PORT=9000
export IDE_KEY="PHPSTORM"
export IDE_SERVERNAME="$(hostname)"
# SSH client IP will be autodetected by default
export IDE_IP="1.2.3.4" 
```
