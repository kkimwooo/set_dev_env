#!/bin/bash

# 스크립트 실행 중 에러 발생 시 중지
set -e

echo "====================================="
echo "🍎 macOS 개발 환경 세팅 스크립트 시작"
echo "====================================="

# 1. Homebrew 설치
if ! command -v brew &>/dev/null; then
    echo "🔧 Homebrew 설치 중..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew가 이미 설치되어 있습니다."
fi

# 2. Homebrew 경로 설정 (Apple Silicon과 Intel Mac 모두 지원)
echo "🔧 Homebrew PATH 설정 중..."
if [[ -d "/opt/homebrew/bin" ]]; then
    # Apple Silicon (M1/M2)
    BREW_PATH="/opt/homebrew/bin"
elif [[ -d "/usr/local/bin" ]]; then
    # Intel Mac
    BREW_PATH="/usr/local/bin"
else
    echo "❌ Homebrew 경로를 찾을 수 없습니다. 설치가 제대로 이루어지지 않았습니다."
    exit 1
fi

# PATH 설정 추가
if ! grep -q "$BREW_PATH" ~/.zshrc; then
    echo "export PATH=\"$BREW_PATH:\$PATH\"" >>~/.zshrc
    echo "✅ PATH 설정이 ~/.zshrc에 추가되었습니다."
else
    echo "✅ PATH 설정이 이미 존재합니다."
fi

# 환경 변수 적용
source ~/.zshrc

# brew 명령어 확인
if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew가 설치되었지만 'brew' 명령어를 인식하지 못합니다. PATH 설정을 확인하세요."
    exit 1
else
    echo "✅ Homebrew가 정상적으로 설치되었습니다: $(brew --version)"
fi


# 2. Git 설치
echo "🔧 Git 설치 중..."
brew install git

# 3. OpenJDK 23 설치
echo "🔧 OpenJDK 23 설치 중..."
brew install openjdk

# OpenJDK 23 심볼릭 링크 생성 (macOS 표준 경로에 등록)
echo "🔗 OpenJDK 23 심볼릭 링크 생성 중..."
sudo ln -sfn $(brew --prefix openjdk)/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-23.jdk

# 4. OpenJDK 17 설치
echo "🔧 OpenJDK 17 설치 중..."
brew install openjdk@17

# OpenJDK 17 심볼릭 링크 생성 (macOS 표준 경로에 등록)
echo "🔗 OpenJDK 17 심볼릭 링크 생성 중..."
sudo ln -sfn $(brew --prefix openjdk@17)/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

# 5. jEnv 설치
echo "🔧 jEnv 설치 중..."
brew install jenv

# jEnv 초기화 및 PATH 설정
if ! grep -q "jenv init" ~/.zshrc; then
    echo 'export PATH="$HOME/.jenv/bin:$PATH"' >>~/.zshrc
    echo 'eval "$(jenv init -)"' >>~/.zshrc
    source ~/.zshrc
fi
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# 6. jEnv에 OpenJDK 버전 등록
echo "🔧 jEnv에 OpenJDK 버전 등록 중..."
jenv add /Library/Java/JavaVirtualMachines/openjdk-23.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home

# 7. OpenJDK 17을 기본 버전으로 설정
echo "🔧 jEnv를 통해 기본 Java 버전을 OpenJDK 17로 설정 중..."
jenv global 17

# 8. Java 버전 확인
echo "🔍 jEnv에서 활성화된 Java 버전 확인:"
jenv versions

echo "🔍 Java 버전 확인:"
java -version

echo "====================================="
echo "🎉 macOS 개발 환경 세팅 완료!"
echo "====================================="