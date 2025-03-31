wget -O gradle-8.7.tar.gz https://services.gradle.org/distributions/gradle-8.7-all.zip
mkdir -p ~/env/gradle-8.7 && tar zxf gradle-8.7.tar.gz -C ~/env/gradle-8.7 --strip-components=1
echo -e 'GRADLE_HOME=~/env/gradle-8.7 \nPATH=$GRADLE_HOME/bin:$PATH' >> ~/.bashrc && source ~/.bashrc 
