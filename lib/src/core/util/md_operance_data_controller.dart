import 'package:operance_datatable/operance_datatable.dart';

class MdOperanceDataController<T> extends OperanceDataController<T> {
  void refresh() {
    setRowsPerPage(rowsPerPage);
  }
}
