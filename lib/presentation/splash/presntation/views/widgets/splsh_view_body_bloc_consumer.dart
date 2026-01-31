import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/splash/presntation/views/widgets/splash_view_body.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashViewBodyBlocConsumer extends StatefulWidget {
  const SplashViewBodyBlocConsumer({super.key});

  @override
  State<SplashViewBodyBlocConsumer> createState() =>
      _SplashViewBodyBlocConsumerState();
}

class _SplashViewBodyBlocConsumerState
    extends State<SplashViewBodyBlocConsumer> {
  String? _targetRoute; // المسار النهائي (Home أو Login).
  bool _animationFinished = false;
  bool _navigated = false;

  void _maybeNavigate() {
    if (!mounted) return;
    if (_navigated) return;

    // لا نتحرك أبداً قبل ما يكمل الأنيميشن بالكامل
    if (!_animationFinished) return;

    // لو لسه ما جانا قرار من Auth → نعتبرها Login (safe default)
    final route = _targetRoute ?? AppRouter.KloginView;

    _navigated = true;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // هنا فقط نحدد الوجهة المطلوبة، بدون تنقّل الآن
        if (state is AuthSuccess) {
          _targetRoute = AppRouter.KhomeView;
        } else if (state is AuthFailure ||
            state is AuthUnauthenticated ||
            state is AuthInitial) {
          _targetRoute = AppRouter.KloginView;
        }

        // ممكن الـ Auth يرد بعد الأنيميشن → جرّب التنقّل الآن
        _maybeNavigate();
      },
      child: SplashViewBody(
        // هذا الكولباك يتم استدعاؤه من داخل SplashViewBody
        // بعد انتهاء كل الفيزات (Convergence + Tagline + Icon Drop + Exit).
        onAnimationComplete: () {
          _animationFinished = true;
          // لو Auth رد قبل الأنيميشن → هذا سيطلق التنقل الآن.
          // لو Auth ما رد → نروح Login كـ default.
          _maybeNavigate();
        },
      ),
    );
  }
}
