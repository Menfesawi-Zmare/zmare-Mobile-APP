import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/profile_privacy.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';
import 'package:zmare/src/service_locator.dart';

import '../../widgets/zmare_text_field.dart';

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
                    ZmareText(
                      text: context.loc.userTtlGeneral,
                      isBold: true,
                    ),
                    InkWell(
                      onTap: () =>
                          context.pushNamed(editBioPath, extra: profile),
                      child: Text(
                        context.loc.edit,
                        style: context.titleMedium?.copyWith(
                          color: context.primary,
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
                    ZmareTextField(
                      hintText: profile.firstName,
                      labelText: profile.firstName != null
                          ? profile.firstName!
                          : context.loc.ttlFirstName,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ZmareTextField(
                      hintText: profile.lastName,
                      labelText: profile.lastName != null
                          ? profile.lastName!
                          : context.loc.ttlLastName,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ZmareTextField(
                      hintText: profile.email,
                      labelText: profile.email != null
                          ? profile.email!
                          : context.loc.ttlEmail,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ZmareTextField(
                      hintText: profile.country,
                      labelText: profile.country != null
                          ? profile.country!
                          : context.loc.ttlCountry,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ZmareTextField(
                      hintText: profile.city,
                      labelText: profile.city != null
                          ? profile.city!
                          : context.loc.ttlCity,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ZmareTextField(
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
                    // ZmareText(
                    //   text: context.loc.description,
                    //   isSmall: true,
                    //   isBold: true,
                    // ),
                  ],
                ),
              ),
              // Padding(
              //     padding:
              //         const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              //     child: ZmareText(
              //       text: profile.description != null
              //           ? profile.description!
              //           : context.loc.descritionContent,
              //       isSmall: true,
              //     )),
            ],
          );
        });
  }
}
