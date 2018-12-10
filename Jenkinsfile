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
                dir("examble/java"){
                    sh 'mvn package'
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
                    cp -R examble/python ./build_python
                    cd build_python
                    mv *.py run.py | true
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
                dir("code/gcc"){
                    unarchive mapping: ['build/bin/cdaemon': 'myapp']
                    sh "chmod +x myapp"
                    sh "cp myapp ../../src/gcc"
                }
                dir("code/java"){
                    unarchive mapping: ['target/*.jar': 'myapp.jar']
                }
                dir("src/python"){
                    unarchive mapping: ['python_code.tar.gz': 'python_code.tar.gz']
                    sh "tar -xzvf python_code.tar.gz"
                }
                dir("code/web"){
                    unarchive mapping: ['php_code.tar.gz': 'php_code.tar.gz']
                    sh "tar -xzvf php_code.tar.gz"
                }
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
                    cp -R ./code ./package/
                    cp -R ./installer ./package/
                    cp -R ./src ./package/
                    cd ./package
                    tar -zcvf ../package.tar.gz ./
                """

                archiveArtifacts "package.tar.gz"
            }
        }

        stage('Auto Deploy') {
            agent {
                docker {
                    image 'centos'
                    args '-v /root/.ssh:/root/.ssh -v /etc/yum.conf:/etc/yum.conf'
                }
            }
            steps {
                sh """
                ls -l
                yum install openssh-clients -y
                ssh root@192.168.101.199 << EOF
    cd /opt/initTool/ || mkdir /opt/initTool/ | cd /opt/initTool/
    rm -rf ./*.*
EOF
                scp -rp installer/installer.sh root@192.168.101.199:/opt/initTool/
                scp -rp package.tar.gz root@192.168.101.199:/opt/initTool/
                ssh root@192.168.101.199 << EOF
    cd /opt/initTool/
    ls -l
    sh installer.sh
EOF
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
                cleanWs()
            }
        }
    }
}
