# Керівництво користувача по встановленню
## Платформа: Mac OS 🍏

### Необхідні інструменти для роботи програми:
#### Усі подальші команди необхідно виконати у терміналі в визначеному порядку

1. `Homebrew` утиліта для встановлення необхідних компонентів

Встановлення:     
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
 
2. Консольна утиліта `dialog` для роботи меню в терміналі
```bash
brew install dialog
```
 
3. Консольна утиліта для керування віддаленими серверами на платформі [Digital Ocean](https://www.digitalocean.com)
```bash
brew install doctl
```

4. Система контролю версій `git`
```bash
brew install git
```

5. Встановлення програми для контролю атак:
```bash
git clone https://github.com/Nyobir/MHDDoS.git
```

6. Згенерувати пару ключів для доступу через SSH (Непотрібно якщо ключі уже присутні). У всіх підменю можна просто натиснути `Enter`
```bash
ssh-keygen
```