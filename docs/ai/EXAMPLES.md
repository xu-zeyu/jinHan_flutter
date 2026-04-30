# EXAMPLES.md

---

# Widget Example

```dart
/// 登录按钮组件
class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      child: const Text('登录'),
    );
  }
}