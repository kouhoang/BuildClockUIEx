import 'package:build_clock/widgets/background_wrapper.dart';
import 'package:build_clock/widgets/canvas_clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/canvas_clock_view_model.dart';

class CanvasClockScreen extends StatefulWidget {
  const CanvasClockScreen({Key? key}) : super(key: key);

  @override
  _CanvasClockScreenState createState() => _CanvasClockScreenState();
}

class _CanvasClockScreenState extends State<CanvasClockScreen>
    with AutomaticKeepAliveClientMixin<CanvasClockScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (_) => CanvasClockViewModel()..initialize(),
      child: BackgroundWrapper(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Consumer<CanvasClockViewModel>(
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
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
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
                    child: CanvasClockWidget(
                      hours: viewModel.clockData.hours,
                      minutes: viewModel.clockData.minutes,
                      seconds: viewModel.clockData.seconds,
                      showColon: viewModel.showColon,
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
