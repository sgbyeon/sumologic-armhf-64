# sumologic-armhf-64

### INFO
1. Only tested on Amazon linux 2 for Graviton2.
2. Never use any of these tools in production.

### Pre-installed
1. java-1.8.0-openjdk
```bash
yum install java-1.8.0-openjdk
```
2. system-lsb
```bash
yum install system-lsb
```
3. Alternative
```bash
./arm-sumologic-agent-preinstall.sh
```

### libsigar
1. It's already built. you can check it in the libsigar-aarch64-linux directory.
2. If you want to create it again, please proceed as follows.
```bash
cd libsigar-aarch64-linux
./autogen.sh
```

### Agent installation
1. modify agent.config
```bash
vim agent.config
accessid="suXXXXXXXXXXXX"
accesskey="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
name="arm-test"
```
2. agent installation
```bash
./arm-sumologic-agent-install.sh
```

### Agent remove
1. Agent remove (optional)
```bash
./arm-sumologic-agent-remove.sh
```
