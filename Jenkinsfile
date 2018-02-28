pipeline {
	agent { node { label 'lisk-docker' } }
	stages {
		stage('docker build') {
			steps {
				ansiColor('xterm') {
					dir('images/') {
						sh 'make'
					}
				}
			}
		}
		stage('smoke tests') {
			steps {
				ansiColor('xterm') {
					dir('examples/testnet/') {
						sh 'make'
						sh 'docker-compose logs db |grep --quiet "PostgreSQL init process complete; ready for start up."'
						retry(3) {
							sleep 30
							sh 'docker-compose logs lisk |grep --quiet "Genesis block loading"'
						}
					}
				}
			}
		}
	}
	post {
		always {
			ansiColor('xterm') {
				dir('examples/testnet/') {
					sh 'make mrproper'
				}
			}
		}
	}
}
