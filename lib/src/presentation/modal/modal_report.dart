import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/report_reason.dart';
import 'package:zmare/src/core/enum/report_type.dart';
import 'package:zmare/src/data/track/model/track_report_request.model.dart';
import 'package:zmare/src/presentation/track/bloc/track_bloc.dart';

import 'package:zmare/src/presentation/widgets/zmare_text_field.dart';
import 'package:zmare/src/presentation/widgets/zmare_text_small.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:go_router/go_router.dart';

class ModalReport extends StatefulWidget {
  const ModalReport(
      {super.key, required this.mediaItem, required this.dominantColor});
  final MediaItem mediaItem;
  final Color dominantColor;
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
  ReportReason? selectedReason = ReportReason.copyright;

  @override
  void dispose() {
    descriptionController.dispose();
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.reportTrack(widget.mediaItem.title),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: widget.dominantColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
          ),
          onPressed: () => context.pop(),
        ),
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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formReport,
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    DropdownButton(
                      onCallBack: (ReportReason value) {
                        setState(() {
                          selectedReason = value;
                          checkboxValue1 = false;
                          checkboxValue2 = false;
                          checkboxValue3 = false;
                          signatureController.text = '';
                          descriptionController.text = '';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ZmareTextField(
                          labelText: context.loc.report_description,
                          hintText: context.loc.ttlDescription,
                          minLine: 6,
                          maxLine: 12,
                          outlineInputBorder: false,
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return context.loc.all_fields;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    if (selectedReason == ReportReason.copyright)
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: checkboxValue1,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkboxValue1 = value!;
                                    });
                                  },
                                  title: ZmareTextSmall(
                                    text: context.loc.report2,
                                  ),
                                ),
                                const Divider(height: 0),
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: checkboxValue2,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkboxValue2 = value!;
                                    });
                                  },
                                  title: ZmareTextSmall(
                                    text: context.loc.report2,
                                  ),
                                ),
                                const Divider(height: 0),
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: checkboxValue3,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkboxValue3 = value!;
                                    });
                                  },
                                  title: ZmareTextSmall(
                                    text: context.loc.report3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ZmareTextField(
                                controller: signatureController,
                                hintText: context.loc.signature,
                                labelText: context.loc.subSignature,
                                textInputAction: TextInputAction.newline,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return context.loc.all_fields;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              if (_formReport.currentState!.validate()) {
                if (selectedReason == ReportReason.copyright) {
                  if (checkboxValue1 && checkboxValue2 && checkboxValue3) {
                    trackBloc.add(TrackReportEvent(
                      TrackReportRequestModel(
                        description: descriptionController.text,
                        reason: selectedReason!.toIndex,
                        signature: signatureController.text,
                        type: ReportType.track.toIndex,
                      ),
                      int.parse(widget.mediaItem.id),
                    ));
                  } else {
                    context.showMaterialSnackBar(context.loc.all_fields);
                  }
                } else {
                  trackBloc.add(TrackReportEvent(
                    TrackReportRequestModel(
                      description: descriptionController.text,
                      reason: selectedReason!.toIndex,
                      signature: '',
                      type: ReportType.track.toIndex,
                    ),
                    int.parse(widget.mediaItem.id),
                  ));
                }
              }
            },
            child: Text(
              context.loc.send,
              style: TextStyle(
                  color: widget.dominantColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
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
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: context.primary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
