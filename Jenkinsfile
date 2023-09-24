pipeline{
    agent{
        node{
            label 'workstation'
        }
    }
parameters{
    choice(name: 'CHOICE', choices: ['Dev', 'prod'], description: 'Chose the ENV')
}
stages{
    stage('Terraform INIT'){
        steps{
            sh 'terraform init -backend-config=env-${env}/state.tfvars'
        }
    }
    stage('Terraform Apply'){
        steps{
            sh 'terraform apply -auto-approve -var-file=env-${env}/main.tfvars'
        }
    }
}
post{
    always{
        cleanWs()
    }
}
}