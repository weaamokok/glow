import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/consts.dart';
import '../../../helper/locale_manager.dart';
import '../../../l10n/translations.g.dart';

class LanguageSelectionBottomSheet extends HookConsumerWidget {
  const LanguageSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocale = context.t;
    final currentLocale = Localizations.localeOf(context);
    final localeFuture = ref.read(LocaleManager.appLocaleProvider.future);
    final locale = useFuture(localeFuture);
    print('locale is $locale');

    final selectedLocale = useState<Locale>(currentLocale);

// Update `selectedLocale` only once when `locale.data` is ready
    useEffect(() {
      if (locale.hasData && locale.data != null) {
        selectedLocale.value = locale.data!;
      }
      return null; // no dispose
    }, [locale.data]);

    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(spacing: 10, children: [
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  context.maybePop();
                },
                child: Text(
                  appLocale.core.cancel,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff282828).withValues(alpha: .5)),
              ),
              TextButton(
                onPressed: () {
                  context.maybePop();
                },
                child: Text(
                  appLocale.core.done,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              spacing: 5,
              children: [
                Text(
                  appLocale.profileScreen.languageBottomSheet.description,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  spacing: 10,
                  children: Consts.supportedLocale.map(
                    (e) {
                      final title = e.languageCode == 'ar'
                          ? appLocale.profileScreen.languageBottomSheet.arLang
                          : appLocale.profileScreen.languageBottomSheet.engLang;
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: selectedLocale.value == e
                                ? Color(0xff4C7B8B)
                                : Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        selected: selectedLocale.value == e,
                        selectedColor: Color(0xff4C7B8B),
                        selectedTileColor: Color(0xff4C7B8B).withAlpha(20),
                        leading: Text(
                          e.languageCode,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: selectedLocale.value == e
                            ? Icon(Icons.check_circle, color: Color(0xff4C7B8B))
                            : Icon(
                                Icons.circle_outlined,
                                color: Colors.grey.shade300,
                              ),
                        onTap: () {
                          selectedLocale.value = e;
                          ref.read(LocaleManager.changeAppLocale(e));
                        },
                      );
                      ;
                    },
                  ).toList(),
                )
              ],
            ),
          ),
        ]));
  }
}
