import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/report_reason.dart';
import 'package:flutter_music_pro/src/core/enum/report_type.dart';
import 'package:flutter_music_pro/src/data/track/model/track_report_request.model.dart';
import 'package:flutter_music_pro/src/presentation/track/bloc/track_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text_field.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text_small.dart';
import 'package:flutter_music_pro/src/service_locator.dart';
import 'package:go_router/go_router.dart';

class ModalReport extends StatefulWidget {
  const ModalReport({super.key, required this.mediaItem});
  final MediaItem mediaItem;
  @override
  State<ModalReport> createState() => _ModalReportState();
}

class _ModalReportState extends State<ModalReport> {
  final _formReport = GlobalKey<FormState>();
  final TrackBloc trackBloc = locator.get<TrackBloc>();
  final descriptionController = TextEditingController();
  final signatureController = TextEditingController();
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  ReportReason? seletedReason = ReportReason.copyright;
  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        context.loc.reportTrack(widget.mediaItem.title),
        leadingWidget: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.close)),
      ),
      body: BlocProvider(
        create: (context) => trackBloc,
        child: BlocListener(
            bloc: trackBloc,
            listener: (context, state) {
              if (state is TrackLoading) {
                context.show();
              }
              if (state is TrackReportState) {
                context.dismiss();
                context.pop();
                context.showMaterialSnackBar(context.loc.report_added);
              }
              if (state is TrackReportFaildState) {
                context.dismiss();
                context.pop();
                context.showMaterialSnackBar(state.message);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formReport,
                child: ListView(
                  children: [
                    DropdownButton(
                      onCallBack: (ReportReason value) {
                        setState(() {
                          seletedReason = value;
                          checkboxValue1 = false;
                          checkboxValue2 = false;
                          checkboxValue3 = false;
                          signatureController.text = '';
                          descriptionController.text = '';
                        });
                      },
                    ),
                    const Divider(height: 16),
                    KhmertracksTextField(
                        labelText: context.loc.report_description,
                        hintText: context.loc.ttlDescription,
                        minLine: 6,
                        maxLine: 12,
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return context.loc.all_fields;
                          }
                          return null;
                        }),
                    Visibility(
                      visible: seletedReason == ReportReason.copyright
                          ? true
                          : false,
                      child: Column(
                        children: [
                          const Divider(height: 16),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: checkboxValue1,
                            onChanged: (bool? value) {
                              setState(() {
                                checkboxValue1 = value!;
                              });
                            },
                            title: KhmertracksTextSmall(
                              text: context.loc.report2,
                            ),
                          ),
                          const Divider(height: 0),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: checkboxValue2,
                            onChanged: (bool? value) {
                              setState(() {
                                checkboxValue2 = value!;
                              });
                            },
                            title: KhmertracksTextSmall(
                              text: context.loc.report2,
                            ),
                          ),
                          const Divider(height: 0),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: checkboxValue3,
                            onChanged: (bool? value) {
                              setState(() {
                                checkboxValue3 = value!;
                              });
                            },
                            title: KhmertracksTextSmall(
                              text: context.loc.report3,
                            ),
                          ),
                          const Divider(height: 16),
                          KhmertracksTextField(
                              controller: signatureController,
                              hintText: context.loc.signature,
                              labelText: context.loc.subSignature,
                              textInputAction: TextInputAction.newline,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return context.loc.all_fields;
                                }
                                return null;
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryContainer),
            onPressed: () => {
                  if (_formReport.currentState!.validate())
                    {
                      if (seletedReason == ReportReason.copyright)
                        {
                          if (checkboxValue1 == true &&
                              checkboxValue2 == true &&
                              checkboxValue3 == true)
                            {
                              trackBloc.add(TrackReportEvent(
                                  TrackReportRequestModel(
                                      description: descriptionController.text,
                                      reason: seletedReason!.toIndex,
                                      signature: signatureController.text,
                                      type: ReportType.track.toIndex),
                                  int.parse(widget.mediaItem.id)))
                            }
                          else
                            {
                              context
                                  .showMaterialSnackBar(context.loc.all_fields)
                            }
                        }
                      else
                        {
                          trackBloc.add(TrackReportEvent(
                              TrackReportRequestModel(
                                  description: descriptionController.text,
                                  reason: seletedReason!.toIndex,
                                  signature: '',
                                  type: ReportType.track.toIndex),
                              int.parse(widget.mediaItem.id)))
                        }
                    }
                },
            child: KhmertracksText(
              text: context.loc.send,
              isBold: true,
              isSmall: true,
            )),
      ),
    );
  }
}

class DropdownButton extends StatefulWidget {
  const DropdownButton({super.key, required this.onCallBack});
  final Function(ReportReason value) onCallBack;
  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ReportReason>(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.primary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.primary, width: 1),
        ),
        filled: true,
        fillColor: context.primaryContainer,
      ),
      isExpanded: true,
      value: ReportReason.values.first,
      icon: const Icon(Icons.keyboard_arrow_down),
      onChanged: (ReportReason? value) {
        setState(() {
          widget.onCallBack(value!);
        });
      },
      items: ReportReason.values
          .map<DropdownMenuItem<ReportReason>>((ReportReason value) {
        return DropdownMenuItem<ReportReason>(
          value: value,
          child: Text(
            value.name(context),
            style: context.titleSmall,
          ),
        );
      }).toList(),
    );
  }
}
