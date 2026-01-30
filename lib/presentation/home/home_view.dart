

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_o/core/di/di_setup.dart';
import 'package:hear_o/core/router/route_names.dart';
import 'package:hear_o/core/router/router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouterService>();
    return FantasyHomeScreen();
  }
}


class FantasyHomeScreen extends StatelessWidget {
  const FantasyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0A0F17),
              Color(0xFF070A0F),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final h = c.maxHeight;

              // 화면 비율에 따라 패널 크기 조절
              final rightMenuW = w * 0.22; // 우측 세로 메뉴 폭
              final bottomBarH = h * 0.16; // 하단 바 높이

              return Stack(
                children: [

                  // 2) 상단 왼쪽 닉네임/레벨 패널
                  Positioned(
                    left: w * 0.03,
                    top: h * 0.015,
                    child: _PlayerPanel(width: w * 0.42),
                  ),

                  // 3) 상단 중앙 재화 바
                  Positioned(
                    top: h * 0.015,
                    right: 0,
                    child: _CurrencyBar(width: w * 0.34),
                  ),

                  // 5) 우측 세로 메뉴
                  Positioned(
                    top: h * 0.20,
                    right: w * 0.03,
                    child: _RightMenu(width: rightMenuW),
                  ),

                  // 6) 중앙 스테이지 카드 + 시작하기 버튼
                  Positioned(
                    left: w * 0.18,
                    bottom: 10,
                    child: _StageCard(width: w * 0.52),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// -------------------------
/// Player panel (top-left)
/// -------------------------
class _PlayerPanel extends StatelessWidget {
  final double width;
  const _PlayerPanel({required this.width});

  @override
  Widget build(BuildContext context) {
    return _OrnatePanel(
      width: width,
      height: 86,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            _CircleIcon(
              size: 44,
              child: const Icon(Icons.shield, color: Colors.white),
              // child: Image.asset('assets/ui/avatar.png', fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '프사 닉네임',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Text('레벨: 1', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        SizedBox(width: 14),
                        Text('경험치: 0/100', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: 0.15,
                        minHeight: 6,
                        backgroundColor: Color(0xFF2A3342),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -------------------------
/// Currency bar (top-center)
/// -------------------------
class _CurrencyBar extends StatelessWidget {
  final double width;
  const _CurrencyBar({required this.width});

  @override
  Widget build(BuildContext context) {
    return _OrnatePanel(
      width: width,
      height: 54,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: _CurrencyChip(
                icon: Icons.circle,
                label: '600',
                // iconAsset: 'assets/ui/coin.png',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _CurrencyChip(
                icon: Icons.diamond,
                label: '10',
                // iconAsset: 'assets/ui/gem.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CurrencyChip({
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF121A27).withOpacity(0.55),
        border: Border.all(color: const Color(0xFF9C8351).withOpacity(0.55)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          _PlusButton(onTap: () {}),
        ],
      ),
    );
  }
}

class _PlusButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PlusButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF2B2315),
          border: Border.all(color: const Color(0xFFB89B64)),
          boxShadow: const [
            BoxShadow(blurRadius: 6, color: Colors.black45, offset: Offset(0, 2)),
          ],
        ),
        child: const Icon(Icons.add, size: 16, color: Colors.white),
      ),
    );
  }
}


class _RightMenu extends StatelessWidget {
  final double width;
  const _RightMenu({required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BottomItem(
          label: '상점',
          icon: Icons.shopping_bag,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _BottomItem(
          label: '친구',
          icon: Icons.people_alt,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _BottomItem(
          label: '연속 출석',
          icon: Icons.calendar_month,
          badge: '7',
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _BottomItem(
          label: '클럽',
          icon: Icons.shield_moon,
          onTap: () {},
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFF2B2315),
        border: Border.all(color: const Color(0xFFB89B64)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

/// -------------------------
/// Center stage card + Start button
/// -------------------------
class _StageCard extends StatelessWidget {
  final double width;
  const _StageCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OrnatePanel(
          width: width,
          height: 160,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              children: const [
                SizedBox(height: 10),
                Text(
                  '1. 음정의 숲',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  '설명글',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _StartButton(
          width: width * 0.62,
          onTap: () {
            context.go(RouteNames.game);

          },
        ),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  final double width;
  final VoidCallback onTap;
  const _StartButton({required this.width, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: width,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFF2B2315),
          border: Border.all(color: const Color(0xFFD7B779), width: 1.2),
          boxShadow: const [
            BoxShadow(blurRadius: 14, color: Colors.black54, offset: Offset(0, 6)),
          ],
        ),
        child: const Text(
          '시작하기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? badge;
  final VoidCallback onTap;

  const _BottomItem({
    required this.label,
    required this.icon,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: _OrnatePanel(
        width: double.infinity,
        height: 78,
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null)
              Positioned(
                right: 10,
                top: 8,
                child: _Badge(text: badge!),
              ),
          ],
        ),
      ),
    );
  }
}

/// -------------------------
/// Ornate panel (프레임 느낌 공통 컴포넌트)
/// 실제 게임 느낌 내려면 여기서 panel.png / 9-slice / Shader 등을 붙이면 됨.
/// -------------------------
class _OrnatePanel extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const _OrnatePanel({
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.isFinite ? width : null,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE6D3A7).withOpacity(0.95),
            const Color(0xFFC7AE7B).withOpacity(0.95),
          ],
        ),
        border: Border.all(color: const Color(0xFF3A2B16).withOpacity(0.75), width: 1),
        boxShadow: const [
          BoxShadow(blurRadius: 16, color: Colors.black54, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: child,
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final double size;
  final Widget child;
  const _CircleIcon({required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1B202B).withOpacity(0.65),
        border: Border.all(color: const Color(0xFFB89B64).withOpacity(0.85)),
        boxShadow: const [
          BoxShadow(blurRadius: 10, color: Colors.black45, offset: Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(child: child),
    );
  }
}



