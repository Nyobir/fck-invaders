# Керівництво користувача по встановленню
## Платформа: Linux 🐧 (Ubuntu/Debian)

### Необхідні інструменти для роботи програми:
#### Усі подальші команди необхідно виконати у терміналі в визначеному порядку
 
1. Консольна утиліта `dialog` для роботи меню в терміналі і `git` для контролю версій програми
```bash
sudo apt-get install dialog git -y
```
 
2. Консольна утиліта для керування віддаленими серверами на платформі [Digital Ocean](https://www.digitalocean.com)

Скачка архіву в домашню директорію
```bash
cd ~
wget https://github.com/digitalocean/doctl/releases/download/v1.72.0/doctl-1.72.0-linux-amd64.tar.gz
```

Розпаковування архіву
```bash
tar xf ~/doctl-1.72.0-linux-amd64.tar.gz
```

Копіювання виконуваного файлу в `path`
```bash
sudo mv ~/doctl /usr/local/bin
```

3. Встановлення програми для контролю атак:
```bash
git clone https://github.com/Nyobir/MHDDoS.git
```

4. Згенерувати пару ключів для доступу через SSH (Непотрібно якщо ключі уже присутні). У всіх підменю можна просто натиснути `Enter`
```bash
ssh-keygen
```

