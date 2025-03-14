#!/bin/bash

# 컬러 출력 함수
function print_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

function print_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# 1️⃣ Oh My Zsh 설치
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Oh My Zsh 설치 중..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_info "Oh My Zsh 설치 완료!"
else
    print_info "Oh My Zsh가 이미 설치되어 있음."
fi

# 2️⃣ Powerlevel10k 테마 설치
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_info "Powerlevel10k 테마 설치 중..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    print_info "Powerlevel10k 테마 설치 완료!"
else
    print_info "Powerlevel10k 테마가 이미 설치되어 있음."
fi

# 3️⃣ 주요 플러그인 설치 (zsh-autosuggestions, zsh-syntax-highlighting, fzf, alias-tips)
PLUGINS=(
    "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting"
    "fzf https://github.com/junegunn/fzf"
    "alias-tips https://github.com/djui/alias-tips"
)

for plugin in "${PLUGINS[@]}"; do
    name=$(echo $plugin | cut -d' ' -f1)
    repo=$(echo $plugin | cut -d' ' -f2)
    target="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"

    if [ ! -d "$target" ]; then
        print_info "$name 플러그인 설치 중..."
        git clone --depth=1 "$repo" "$target"
        print_info "$name 플러그인 설치 완료!"
    else
        print_info "$name 플러그인이 이미 설치되어 있음."
    fi
done

# 4️⃣ .zshrc 파일 수정
ZSHRC="$HOME/.zshrc"

print_info ".zshrc 설정을 업데이트 중..."

# 기존 플러그인 라인 수정
sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf alias-tips)' "$ZSHRC"

# Powerlevel10k 테마 적용
sed -i '/^ZSH_THEME=/c\ZSH_THEME="powerlevel10k/powerlevel10k"' "$ZSHRC"

# fzf 자동 완성 활성화
echo '[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh' >> "$ZSHRC"

# 5️⃣ Zsh 환경 적용
print_info "Zsh 환경을 새로 고침 중..."
source "$ZSHRC"

print_info "🎉 Oh My Zsh + Powerlevel10k + 주요 플러그인 설치 완료!"
print_info "🚀 터미널을 다시 시작하면 새로운 Zsh 환경이 적용됩니다."
