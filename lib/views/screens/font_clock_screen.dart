import 'package:build_clock/widgets/background_wrapper.dart';
import 'package:build_clock/widgets/font_clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/font_clock_view_model.dart';

class FontClockScreen extends StatefulWidget {
  const FontClockScreen({Key? key}) : super(key: key);

  @override
  _FontClockScreenState createState() => _FontClockScreenState();
}

class _FontClockScreenState extends State<FontClockScreen>
    with AutomaticKeepAliveClientMixin<FontClockScreen> {
  FontClockViewModel? _viewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (_) {
        _viewModel = FontClockViewModel()..initialize();
        return _viewModel!;
      },
      child: BackgroundWrapper(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Consumer<FontClockViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: FontClockWidget(
                      hours: viewModel.clockData.hours,
                      minutes: viewModel.clockData.minutes,
                      seconds: viewModel.clockData.seconds,
                    ),
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
