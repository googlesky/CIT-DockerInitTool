pipeline {
    agent none
    stages {

        stage('Build C Package') {
            agent {
                docker {
                    image 'rikorose/gcc-cmake:latest'
                }
            }
            steps {
                dir("examble/daemon"){
                    sh """
                        mkdir build || true
                        cd build
                        cmake -DCMAKE_INSTALL_PREFIX=/usr ../
                        make
                        find -name "daemon"
                        cd bin
                        mv daemon cdaemon
                    """
                    archiveArtifacts "build/bin/cdaemon"
                }
            }
        }

        stage('Build Java Package') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                dir("examble/shiro-spring-boot-sample"){
                    sh 'mvn -B -DskipTests clean package'
                    sh 'find -name "*.jar"'
                    archiveArtifacts "target/*.jar"
                }
            }
        }

        stage('Build Python Package') {
            agent {
                docker {
                    image 'ubuntu'
                }
            }
            steps {
                sh """
                    cp -R examble/devops-project-samples/python/flask/webapp/Application/ ./build_python
                    cd build_python
                    mv *.py run.py
                    tar -zcvf ../python_code.tar.gz ./
                """
                archiveArtifacts "python_code.tar.gz"
            }
        }

        stage('Build PHP Package') {
            agent {
                docker {
                    image 'ubuntu'
                }
            }
            steps {
                sh """
                    cp -R examble/simple-php-website ./build_PHP
                    cd build_PHP
                    tar -zcvf ../php_code.tar.gz ./
                """
                archiveArtifacts "php_code.tar.gz"
            }
        }

        stage('Copy Artifacts') {
            agent {
                docker {
                    image 'ubuntu'
                }
            }
            steps {
                unarchive mapping: ['build/bin/cdaemon': 'runc']
                unarchive mapping: ['target/*.jar': 'myapp.jar']
                unarchive mapping: ['python_code.tar.gz': 'python_code.tar.gz']
                unarchive mapping: ['php_code.tar.gz': 'php_code.tar.gz']
                // sh "tar -xzvf python_code.tar.gz"
                sh "ls -l"
            }
        }

        stage('Package') {
            agent {
                docker {
                    image 'ubuntu'
                }
            }
            steps {
                sh """
                    mkdir package || true
                    cp -R ./code ./package/code
                    cp -R ./installer ./package/installer
                    cp -R ./src ./package/src
                    cd ./package
                    tar -zcvf ../package.tar.gz ./
                """

                archiveArtifacts "package.tar.gz"
            }
        }

        stage('Auto Deploy') {
            agent {
                docker {
                    image 'ubuntu'
                    args '-v /root/.ssh:/root/.ssh'
                }
            }
            steps {
                sh """
                ssh root@192.168.101.199
                echo "Work!"
                exit
                """
            }
        }

        stage('Script Installer') {
            agent {
                docker {
                    image 'ubuntu'
                }
            }
            steps {
                archiveArtifacts "installer/installer.sh"
            }
            post {
                always {
                    sh "rm -rf *"
                }
            }
        }
    }
}
