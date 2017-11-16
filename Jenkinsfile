pipeline {
	agent { node { label 'lisk-docker' } }
	stages {
		stage('checkout') {
			steps {
				checkout scm
			}
		}
		stage('docker build') {
			steps {
				ansiColor('xterm') {
					sh 'make clean images'
				}
			}
		}
		stage('smoke tests') {
			steps {
				ansiColor('xterm') {
					sh 'make testnet'
					dir('testnet') {
						sh 'docker-compose logs redis |grep --quiet "Ready to accept connections"'
						sh 'docker-compose logs db |grep --quiet "PostgreSQL init process complete; ready for start up."'
						retry(3) {
							sleep 30
							sh 'docker-compose logs lisk |grep --quiet "Database is ready."'
						}
					}
				}
			}
		}
	}
	post {
		always {
			ansiColor('xterm') {
				sh 'make -C testnet mrproper'
			}
		}
	}
}
