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
	}
}
