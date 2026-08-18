import 'package:flutter/material.dart';
import '../../core/settings/app_preferences_v10.dart';
import '../../core/storage/app_storage.dart';
import '../../models/child.dart';
import '../../widgets/app_feedback.dart';
import '../parents/parents_screen.dart';
import '../settings/settings_screen.dart';
import '../shop/shop_screen.dart';
import '../stages/stage_screen.dart';
import '../registration/child_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Child? child;
  final prefs = AppPreferencesV10.instance;

  @override
  void initState() {
    super.initState();
    _loadChild();
  }

  Future<void> _loadChild() async {
    final kids = await AppStorage.getChildren();
    final active = await AppStorage.activeId();
    Child? selected;

    if (active != null) {
      for (final k in kids) {
        if (k.id == active) {
          selected = k;
          break;
        }
      }
    }

    selected ??= kids.isEmpty ? null : kids.first;
    if (selected != null) await AppStorage.setActive(selected.id);
    if (mounted) setState(() => child = selected);
  }

  Future<void> _openRegistration() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChildRegistrationScreen()),
    );
    await _loadChild();
  }

  Future<void> _openParents() async {
    final ok = await _parentGate();
    if (!ok || !mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ParentsScreen()),
    );
    await _loadChild();
  }

  Future<bool> _parentGate() async {
    final a = 2 + DateTime.now().second % 5;
    final b = 1 + DateTime.now().millisecond % 4;
    final isAddition = DateTime.now().millisecond.isEven;
    final expected = isAddition ? a + b : (a > b ? a - b : b - a);
    final controller = TextEditingController();
    var error = false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialog) {
          void check() {
            if (int.tryParse(controller.text.trim()) == expected) {
              Navigator.pop(dialogContext, true);
            } else {
              setDialog(() {
                error = true;
                controller.clear();
              });
            }
          }

          return AlertDialog(
            title: const Text('منطقة الوالدين 🔒'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('أجب عن السؤال حتى لا يدخل الطفل إلى المتابعة بالخطأ.'),
                const SizedBox(height: 16),
                Text(
                  '$a ${isAddition ? '+' : '−'} $b = ؟',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'الإجابة',
                    errorText: error ? 'إجابة غير صحيحة، حاول مرة أخرى' : null,
                  ),
                  onSubmitted: (_) => check(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(onPressed: check, child: const Text('دخول')),
            ],
          );
        },
      ),
    );

    controller.dispose();
    return result == true;
  }

  void _openStage(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StageScreen(stageId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = prefs.themeMode == ThemeMode.dark;
    final scheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [scheme.primary, scheme.tertiary],
            ).createShader(bounds),
            child: const Text(
              'معلمي',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
            ),
          ),
          leading: IconButton(
            tooltip: 'الإعدادات',
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          actions: [
            IconButton(
              tooltip: isDark ? 'الوضع النهاري' : 'الوضع الليلي',
              icon: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
              onPressed: () {
                prefs.setDarkMode(!isDark);
                AppFeedback.show(isDark ? '☀️ أهلاً بالنهار الجميل!' : '🌙 وقت التعلم الهادئ!');
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _childCard(scheme),
            const SizedBox(height: 16),
            _parentCard(),
            const SizedBox(height: 22),
            Text(
              'مراحل التعلم',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: scheme.onSurface),
            ),
            const SizedBox(height: 5),
            Text(
              child == null ? 'اختر المرحلة المناسبة وابدأ رحلة ممتعة.' : 'اختر مرحلة ${child!.name} وابدأ التعلم.',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15),
            ),
            const SizedBox(height: 14),
            ..._stageCards(),
            const SizedBox(height: 6),
            _storeCard(),
          ],
        ),
      ),
    );
  }

  Widget _childCard(ColorScheme scheme) {
    return App3DCard(
      onTap: _openRegistration,
      encouragement: child == null ? '🌟 هيا يا بطل، سجل اسمك!' : '💫 يمكنك تعديل بياناتك متى شئت!',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [scheme.primaryContainer, scheme.tertiaryContainer]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: scheme.surface.withValues(alpha: .82), shape: BoxShape.circle),
              child: Icon(Icons.child_care_rounded, size: 38, color: scheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child == null ? 'اكتب اسمك يا بطل ⭐' : 'أهلاً يا ${child!.name} 🌟',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: scheme.onPrimaryContainer),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    child == null ? 'سجّل اسمك ومرحلتك لنحفظ تقدمك.' : 'المرحلة: ${child!.stage}  •  اضغط للتعديل',
                    style: TextStyle(color: scheme.onPrimaryContainer.withValues(alpha: .78)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_back_ios_new_rounded, color: scheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _parentCard() => App3DCard(
        onTap: _openParents,
        encouragement: '🔐 هذه مساحة خاصة بالأسرة',
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            child: Icon(Icons.family_restroom_rounded, color: Theme.of(context).colorScheme.secondary),
          ),
          title: const Text('متابعة الأسرة', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          subtitle: const Text('نتائج الطفل، المهارات المتقنة، ما يحتاج إلى مراجعة والإنجازات'),
          trailing: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      );

  List<Widget> _stageCards() {
    const stages = [
      ('kg1', 'الروضة الأولى', '٣–٤ سنوات', Icons.palette_rounded, 'ألوان وأشكال واستماع وأعداد أولى'),
      ('kg2', 'الروضة الثانية', '٤–٥ سنوات', Icons.auto_stories_rounded, 'حروف وأرقام وكتابة وكلمات قصيرة'),
      ('prep', 'التمهيدي', '٥–٦ سنوات', Icons.school_rounded, 'حركات وتهجي وقراءة وأعداد وتمهيد إنجليزي'),
      ('g1', 'الصف الأول', '٦–٧ سنوات', Icons.star_rounded, 'قراءة وكتابة وحساب وإنجليزي مبسط'),
      ('g2', 'الصف الثاني', '٧–٨ سنوات', Icons.rocket_launch_rounded, 'قواعد وقراءة وحساب ومفردات إنجليزية'),
      ('g3', 'الصف الثالث', '٨–٩ سنوات', Icons.emoji_events_rounded, 'قراءة متقدمة وقواعد وحساب وتحديات'),
    ];

    return stages.map((s) {
      final color = Theme.of(context).colorScheme;
      return Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: App3DCard(
          onTap: () => _openStage(s.$1),
          encouragement: '🚀 رائع! لنبدأ ${s.$2}',
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color.primaryContainer, color.secondaryContainer]),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(s.$4, color: color.primary, size: 30),
            ),
            title: Text(s.$2, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            subtitle: Text('${s.$3} • ${s.$5}'),
            trailing: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
      );
    }).toList();
  }

  Widget _storeCard() => App3DCard(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen())),
        encouragement: '⭐ اجمع النجوم وافتح جوائز جميلة!',
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            child: Icon(Icons.storefront_rounded, color: Theme.of(context).colorScheme.tertiary),
          ),
          title: const Text('المتجر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          subtitle: const Text('جوائز وملصقات وشخصيات تشجيعية بالنجوم'),
          trailing: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      );
}
