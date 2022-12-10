pipeline {
    agent{ label 'slave'}
    stages {
        stage('Install Puppet-agent on slave') {
            steps {
                echo 'Install Puppet'
                sh "wget -N -O 'puppet.deb' https://apt.puppetlabs.com/puppet6-release-bionic.deb"
                sh "chmod 755 puppet.deb"
                sh "sudo dpkg -i puppet.deb"
                sh "sudo apt update"
                sh "sudo apt install -y puppet-agent"
            }
        }

        stage('configure and start puppet') {
            steps {
                echo 'configure puppet'
                sh "mkdir -p /etc/puppetlabs/puppet"
                sh "if [ -f /etc/puppetlabs/puppet/puppet.conf ]; then sudo rm -f /etc/puppetlabs/puppet.conf; fi"
                sh "echo '[main]\ncertname = node1.local\nserver = puppet' >> ~/puppet.conf"
                sh "sudo mv ~/puppet.conf /etc/puppetlabs/puppet/puppet.conf"
                echo 'start puppet'
                sh "sudo systemctl start puppet"
                sh "sudo systemctl enable puppet"
            }
        }

        stage('Install Docker on slave through puppet file') {
            steps {
                sh "sudo /opt/puppetlabs/bin/puppet module install garethr-docker"
                sh "sudo /opt/puppetlabs/bin/puppet apply /home/jenkins/jenkins_slave/workspace/puppet-docker.pp"
            }
        }

        stage('Git Checkout') {
            steps {
                sh "if [ ! -d '/home/jenkins/jenkins_slave/workspace' ]; then git clone https://github.com/Jegankumard/edureka.git /home/jenkins/jenkins_slave/workspace ; fi"
                sh "cd /home/jenkins/jenkins_slave/workspace && sudo git checkout master"
            }
        }
        
        stage('Docker Build and Run container') {
            steps {
                sh "sudo docker rm -f webapp || true"
                sh "cd /home/jenkins/jenkins_slave/workspace && sudo docker build -t test ."
                sh "sudo docker run -it -d --name webapp -p 8090:80 test"
            }
        }
            post {
                failure {
                    sh "echo Failure"
					sh "sudo docker rm -f webapp"
                }
			}
		}
	}
}
