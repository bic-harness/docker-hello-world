#!groovy

podTemplate(cloud: "kubernetes", containers: [
    containerTemplate(name: 'jnlp', image: 'jenkinsci/jnlp-slave:alpine', ttyEnabled: true, alwaysPullImage: true),
    containerTemplate(name: 'kaniko', image: 'gcr.io/kaniko-project/executor:debug', ttyEnabled: true, command: '/busybox/cat', alwaysPullImage: true)
]) {
    node(POD_LABEL) {
        //Vault Configuration
        def configuration = [vaultUrl: 'http://10.110.141.74:8200',
                            vaultCredentialId: 'vault-token', engineVersion: 1]
        //Define Required Secrets and Env Variables
        def secrets = [
            [path: 'kv/docker', secretValues: [
                [envVar: 'DOCKER_CONFIG_FILE', vaultKey: 'config']]]
        ]
        //Use the Credentials with the Build
        withVault([configuration: configuration, vaultSecrets: secrets]) {
            //Checkout code from GitHub
            stage ('Checkout') {
                try {
                    git credentialsId: 'github-key', branch: "$BRANCH_NAME", url: "git@github.com:bic-harness/docker-hello-world.git"
                }
                catch (exc) {
                    println "Failed the Git Checkout - ${currentBuild.fullDisplayName}"
                }
            }
            //Package up and ship via Kaniko
            stage('Kaniko - Build & Ship') {
                container('kaniko') {
                    try {
                        //Kaniko Build and Ship to Docker Hub
                        //Use --verbosity=debug for more detailed logs if necessary
                        env.DOCKER_CONFIG = "/kaniko/.docker"
                        sh """
                        set +x
                        echo '$DOCKER_CONFIG_FILE' > config.json
                        cp config.json /kaniko/.docker/config.json
                        /kaniko/executor --dockerfile=$WORKSPACE/Dockerfile --context=$WORKSPACE  --destination=bicharness/helloworld:$BUILD_NUMBER --skip-tls-verify
                        """                  
                    }
                    catch (exc) {
                        println "Kaniko Steps Failed - ${currentBuild.fullDisplayName}"
                        throw(exc)
                    }
                }
            }
        }
    }
}