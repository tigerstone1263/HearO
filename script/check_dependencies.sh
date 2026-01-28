#!/bin/bash

# 의존성 분석 스크립트
# 사용법: ./scripts/check_dependencies.sh

echo "======================================"
echo "📦 의존성 분석 보고서"
echo "======================================"
echo ""

# 한 번만 실행하고 결과 저장
DEPS_OUTPUT=$(flutter pub deps --style=compact)

echo "1️⃣ 직접 의존성 (Direct Dependencies)"
echo "--------------------------------------"
echo "$DEPS_OUTPUT" | awk '/^dependencies:/,/^dev dependencies:/ {if (/^-/) print}'
echo ""

echo "2️⃣ 개발 의존성 (Dev Dependencies)"
echo "--------------------------------------"
echo "$DEPS_OUTPUT" | awk '/^dev dependencies:/,/^transitive dependencies:/ {if (/^-/) print}'
echo ""

echo "3️⃣ 전이 의존성 (Transitive Dependencies)"
echo "--------------------------------------"
echo "$DEPS_OUTPUT" | awk '/^transitive dependencies:/,0 {if (/^-/) print}'
echo ""

echo "======================================"
echo "📊 의존성 개수 통계"
echo "======================================"
DIRECT=$(echo "$DEPS_OUTPUT" | awk '/^dependencies:/,/^dev dependencies:/ {if (/^-/) print}' | wc -l | xargs)
DEV=$(echo "$DEPS_OUTPUT" | awk '/^dev dependencies:/,/^transitive dependencies:/ {if (/^-/) print}' | wc -l | xargs)
TRANSITIVE=$(echo "$DEPS_OUTPUT" | awk '/^transitive dependencies:/,0 {if (/^-/) print}' | wc -l | xargs)

echo "직접 의존성: $DIRECT개"
echo "개발 의존성: $DEV개"
echo "전이 의존성: $TRANSITIVE개"
echo "총 의존성: $((DIRECT + DEV + TRANSITIVE))개"
echo ""

echo "======================================"
echo "⚠️  불필요한 의존성 체크"
echo "======================================"
echo "pubspec.yaml에 선언되었지만 코드에서 사용되지 않을 수 있는 패키지를 확인하세요."
echo ""
echo "각 모듈별 import 확인:"
echo ""

for module in "packages/domain" "packages/data" "packages/presentation" "lib"; do
  if [ -d "$module" ]; then
    echo "📁 $module:"
    grep -rh "^import 'package:" "$module" --include="*.dart" 2>/dev/null | \
      sed "s/import 'package:\([^\/]*\).*/\1/" | \
      sort -u | \
      grep -v "^flutter" | \
      grep -v "^domain" | \
      grep -v "^data" | \
      grep -v "^presentation" | \
      sed 's/^/  - /'
    echo ""
  fi
done