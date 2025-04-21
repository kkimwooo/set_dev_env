#!/bin/bash

set -e  # 오류 발생 시 스크립트 즉시 종료

echo "🔧 Mint Linux 개발 환경 세팅 시작..."

# 1. 패키지 업데이트
echo "📦 패키지 정보 갱신 중..."
sudo apt update && sudo apt upgrade -y

# 2. 필수 개발 도구 설치
echo "🛠️ 필수 도구 설치 중..."
sudo apt install -y \
  git \
  curl \
  wget \
  build-essential \
  unzip \
  zip \
  neovim \
  software-properties-common

# 3. OpenJDK 17 설치
echo "☕ Java 17 설치 중..."
sudo apt install -y openjdk-17-jdk

# JAVA_HOME 설정
echo "✅ JAVA_HOME 설정 중..."
JAVA_HOME_PATH=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
if ! grep -q "JAVA_HOME" ~/.profile; then
  echo "export JAVA_HOME=$JAVA_HOME_PATH" >> ~/.profile
  echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.profile
fi

# 4. Zsh + Oh My Zsh 설치
echo "💻 Zsh 및 Oh My Zsh 설치 중..."
sudo apt install -y zsh

# 기본 쉘 변경
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s $(which zsh)
fi

# Oh My Zsh 설치
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 5. Oh My Zsh 추천 플러그인 설치
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

echo "🔌 Zsh 플러그인 설치 중..."
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions || true
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting || true
git clone --depth=1 https://github.com/djui/alias-tips $ZSH_CUSTOM/plugins/alias-tips || true

# 6. Powerlevel10k 테마 설치
echo "🎨 Powerlevel10k 테마 설치 중..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k || true

# 7. .zshrc 구성
echo "🧩 .zshrc 구성 중..."
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting alias-tips)/' ~/.zshrc

# 중복 방지 후 설정 추가
grep -qxF '[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh' ~/.zshrc || echo '[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh' >> ~/.zshrc

echo "✅ 개발 환경 세팅 완료!"
echo "📌 새 터미널을 열거나 'source ~/.zshrc'를 실행하세요."

