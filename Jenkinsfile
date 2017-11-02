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
				sh 'make images'
			}
		}
		stage('smoke tests') {
			steps {
				ansiColor('xterm') {
					sh 'make testnet'
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
