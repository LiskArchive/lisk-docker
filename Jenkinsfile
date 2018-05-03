pipeline {
	agent { node { label 'lisk-docker' } }
	stages {
		stage('docker build') {
			steps {
				ansiColor('xterm') {
					dir('images/lisk/') {
						sh '''
						LATEST=$( curl --silent --show-error https://downloads.lisk.io/lisk/development/latest.txt )
						make tag=$LATEST development
						docker tag lisk/development:$LATEST lisk/development:latest
						'''
					}
				}
			}
		}
		stage('smoke tests') {
			steps {
				ansiColor('xterm') {
					dir('examples/development/') {
						sh 'make'
						retry(3) {
							sleep 10
							sh 'docker-compose logs db |grep --quiet "PostgreSQL init process complete; ready for start up."'
						}
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
				dir('examples/development/') {
					sh 'make mrproper'
				}
			}
		}
	}
}
