import '../services/background_service.dart';
import 'base_view_model.dart';

class TabViewModel extends BaseViewModel {
  void initialize() async {
    setLoading(true);
    try {
      await BackgroundService.loadBackground();
    } catch (e) {
      setError('Failed to initialize: $e');
    } finally {
      setLoading(false);
    }
  }
}
