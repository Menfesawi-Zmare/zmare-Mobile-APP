import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/profile_privacy.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';
import 'package:zmare/src/service_locator.dart';

import '../../widgets/khmertracks_text_field.dart';

class BioWidget extends StatelessWidget {
  const BioWidget({super.key});
  // final Profile? profile;
  @override
  Widget build(BuildContext context) {
    late final account = locator
        .get<Box<dynamic>>(instanceName: BoxType.account.name)
        .listenable(
      keys: [accountDetail],
    );
    return ValueListenableBuilder(
        valueListenable: account,
        builder: (BuildContext context, value, Widget? child) {
          final accountJson = value.get(accountDetail);
          Profile profile = Profile.fromJson(accountJson);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KhmertracksText(
                      text: context.loc.userTtlGeneral,
                      isBold: true,
                    ),
                    InkWell(
                      onTap: () =>
                          context.pushNamed(editBioPath, extra: profile),
                      child: Text(
                        context.loc.edit,
                        style: context.titleMedium?.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KhmertracksTextField(
                      hintText: profile.firstName,
                      labelText: context.loc.ttlFirstName,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksTextField(
                      hintText: profile.lastName,
                      labelText: context.loc.ttlLastName,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksTextField(
                      hintText: profile.email,
                      labelText: context.loc.ttlEmail,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksTextField(
                      hintText: profile.country,
                      labelText: context.loc.ttlCountry,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksTextField(
                      hintText: profile.city,
                      labelText: context.loc.ttlCity,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksTextField(
                      hintText: ProfilePrivacy.values
                          .where(
                              (element) => element.toIndex == profile.private!)
                          .first
                          .name(context),
                      labelText: context.loc.profilePrivacy,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksText(
                      text: context.loc.description,
                      isSmall: true,
                      isBold: true,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: KhmertracksText(
                    text: profile.description != null
                        ? profile.description!
                        : context.loc.descritionContent,
                    isSmall: true,
                  )),
            ],
          );
        });
  }
}
