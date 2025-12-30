pipeline {
    agent any

    tools {
        // Only if you configured TOOLBELT in Jenkins tools
        // name must match exactly
        // tool 'TOOLBELT'
    }

    environment {
        TOOLBELT = 'sf'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Init Environment') {
            steps {
                script {
                    env.HUB_ORG  = env.HUB_ORG_DH
                    env.SFDC_HOST = env.SFDC_HOST_DH
                    env.CONNECTED_APP_CONSUMER_KEY = env.CONNECTED_APP_CONSUMER_KEY_DH
                    env.JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
                }
            }
        }

        stage('Authenticate Salesforce (JWT)') {
            steps {
                withCredentials([
                    file(credentialsId: "${env.JWT_KEY_CRED_ID}", variable: 'JWT_KEY_FILE')
                ]) {
                    bat """
                    ${TOOLBELT} auth jwt grant ^
                      --client-id ${CONNECTED_APP_CONSUMER_KEY} ^
                      --jwt-key-file %JWT_KEY_FILE% ^
                      --username ${HUB_ORG} ^
                      --instance-url ${SFDC_HOST} ^
                      --set-default-dev-hub
                    """
                }
            }
        }

        stage('Deploy Metadata') {
            steps {
                bat """
                ${TOOLBELT} project deploy start ^
                  --manifest manifest/package.xml ^
                  --target-org ${HUB_ORG}
                """
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful'
        }
        failure {
            echo 'Deployment Failed'
        }
    }
}
