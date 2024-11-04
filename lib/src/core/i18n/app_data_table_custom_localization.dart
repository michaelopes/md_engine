import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';
import 'package:md_engine/src/core/i18n/app_translate.dart';

class AppDataTableCustomLocalization extends PagedDataTableLocalization {
  static const delegate = AppDataTableCustomLocalizationDelegate();
  @override
  String get applyFilterButtonText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("applyFilterButtonText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.applyFilterButtonText;
  }

  @override
  String get cancelFilteringButtonText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("cancelFilteringButtonText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.cancelFilteringButtonText;
  }

  @override
  String get editableColumnCancelButtonText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("editableColumnCancelButtonText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.editableColumnCancelButtonText;
  }

  @override
  String get editableColumnSaveChangesButtonText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("editableColumnSaveChangesButtonText")}",
      QR.context!,
    );
    return trText.isNotEmpty
        ? trText
        : super.editableColumnSaveChangesButtonText;
  }

  @override
  String get nextPageButtonText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("nextPageButtonText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.nextPageButtonText;
  }

  @override
  String get noItemsFoundText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("noItemsFoundText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.noItemsFoundText;
  }

  @override
  String pageIndicatorText(Object currentPage) {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("pageIndicatorText")}",
      QR.context!,
      params: {
        "p1": currentPage.toString(),
      },
    );
    return trText.isNotEmpty ? trText : super.pageIndicatorText(currentPage);
  }

  @override
  String get filterByTitle {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("filterByTitle")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.filterByTitle;
  }

  @override
  String get previousPageButtonText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("previousPageButtonText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.previousPageButtonText;
  }

  @override
  String get refreshText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("refreshText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.refreshText;
  }

  @override
  String refreshedAtText(Object time) {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("refreshedAtText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.refreshedAtText(time);
  }

  @override
  String get removeAllFiltersButtonText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("removeAllFiltersButtonText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.removeAllFiltersButtonText;
  }

  @override
  String get rowsPerPageText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("rowsPerPageText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.rowsPerPageText;
  }

  @override
  String get removeFilterButtonText {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("removeFilterButtonText")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.removeFilterButtonText;
  }

  @override
  String get showFilterMenuTooltip {
    final trText = AppTranslate.tr(
      "datatable.${MdToolkit.I.camelToUnderscore("showFilterMenuTooltip")}",
      QR.context!,
    );
    return trText.isNotEmpty ? trText : super.showFilterMenuTooltip;
  }

  @override
  String totalElementsText(Object totalElements) {
    final trText = AppTranslate.tr(
        "datatable.${MdToolkit.I.camelToUnderscore("totalElementsText")}",
        QR.context!,
        params: {
          "p1": totalElements.toString(),
        });
    return trText.isNotEmpty ? trText : super.totalElementsText(totalElements);
  }
}

class AppDataTableCustomLocalizationDelegate
    extends LocalizationsDelegate<PagedDataTableLocalization> {
  const AppDataTableCustomLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<PagedDataTableLocalization> load(Locale locale) async {
    return AppDataTableCustomLocalization();
  }

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<PagedDataTableLocalization> old) =>
      false;
}
