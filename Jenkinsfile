pipeline {
    agent any

    environment {
        TOOLBELT = 'sf'
        HUB_ORG = 'env.HUB_ORG_DH'
        SFDC_HOST = 'env.SFDC_HOST_DH'
        CONNECTED_APP_CONSUMER_KEY = 'env.CONNECTED_APP_CONSUMER_KEY_DH'
        JWT_KEY_CRED_ID = 'env.JWT_CRED_ID_DH'
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Authenticate to Salesforce (JWT)') {
            steps {
                withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'JWT_KEY_FILE')]) {

                    script {
                        def authCmd = """
                        ${TOOLBELT} auth jwt grant \
                          --client-id ${CONNECTED_APP_CONSUMER_KEY} \
                          --jwt-key-file "${JWT_KEY_FILE}" \
                          --username ${HUB_ORG} \
                          --instance-url ${SFDC_HOST} \
                          --set-default-dev-hub
                        """

                        if (isUnix()) {
                            sh authCmd
                        } else {
                            bat authCmd
                        }
                    }
                }
            }
        }

        stage('Deploy Metadata') {
            steps {
                script {
                    def deployCmd = """
                    ${TOOLBELT} project deploy start \
                      --manifest manifest/package.xml \
                      --target-org ${HUB_ORG} \
                      --wait 10
                    """

                    if (isUnix()) {
                        sh deployCmd
                    } else {
                        bat deployCmd
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
