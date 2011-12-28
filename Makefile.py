from metamake import task, shell
import paramiko
import os

SERVICE_HOST = '107.20.208.98'
SERVER_USERNAME = 'ubuntu'
SERVER_PRIVATE_KEY = paramiko.RSAKey.from_private_key_file(os.path.expanduser('~/.ssh/commonplace.pem'))
GIT_BRANCH = 'master-2012'

SSH = paramiko.SSHClient()
SSH.set_missing_host_key_policy(paramiko.AutoAddPolicy())

def remote_pull():
    SSH.connect(SERVICE_HOST, username=SERVER_USERNAME, pkey=SERVER_PRIVATE_KEY)
    stdin, stdout, stderr = SSH.exec_command("cd commonplace; git checkout %s; git pull origin" % GIT_BRANCH)
    print stdout.readlines()
    SSH.close()

@task
def start_metrics():
    SSH.connect(SERVICE_HOST, username=SERVER_USERNAME, pkey=SERVER_PRIVATE_KEY)
    stdin, stdout, stderr = SSH.exec_command("cd commonplace; bundle exec ruby lib/stats_server.rb log DUMP_FILE=log.json &")
    SSH.close()

@task
def stop_metrics():
    SSH.connect(SERVICE_HOST, username=SERVER_USERNAME, pkey=SERVER_PRIVATE_KEY)
    stdin, stdout, stderr = SSH.exec_command('ps aux | grep "ruby stats_server.rb" | awk "{print $2}" | head -1 | xargs kill -9')
    SSH.close()
    
@task
def restart_metrics():
    stop_metrics()
    remote_pull()
    start_metrics()
    
