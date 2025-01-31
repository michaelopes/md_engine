export 'package:dio/dio.dart';
export 'package:pretty_dio_logger/pretty_dio_logger.dart';
export 'package:qlevar_router/qlevar_router.dart';
export 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
export 'package:carousel_slider/carousel_slider.dart';
export 'package:visibility_detector/visibility_detector.dart';

export 'package:lottie/lottie.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:uuid/uuid.dart';
export 'package:intl/intl.dart';
export 'package:easy_mask/easy_mask.dart';
export 'package:auto_size_text/auto_size_text.dart';
export 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
export 'package:diacritic/diacritic.dart';
export 'package:get_it/get_it.dart';
export 'package:device_info_plus/device_info_plus.dart';
export 'package:package_info_plus/package_info_plus.dart';
export 'package:rx_notifier/rx_notifier.dart';
export 'package:universal_platform/universal_platform.dart';
export 'package:encrypt_env/encrypt_env.dart';
export 'package:operance_datatable/operance_datatable.dart';
export 'package:get_storage/get_storage.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:widgets_to_image/widgets_to_image.dart';

export './src/md_app.dart';

//OWN IMPORTS
export './src/core/base/md_service.dart';
export './src/core/base/md_state.dart';
export './src/core/base/md_widget_state.dart';
export './src/core/base/md_stateless.dart';

export './src/core/helpers/error_object.dart';
export './src/core/helpers/global_error_observer.dart';
export './src/core/helpers/load_object.dart';
export './src/core/helpers/md_state_observable.dart';

export 'src/core/util/md_typedefs.dart';
export 'src/core/util/md_extensions.dart';
export 'src/core/util/md_toolkit.dart';
export 'src/core/util/md_failures.dart';
export 'src/core/util/md_sub_route.dart';
export 'src/core/util/md_secure_storage.dart';
export 'src/core/util/md_masks.dart';
export 'src/core/util/md_view_error_event.dart';
export 'src/core/util/md_capitalize_words_text_formatter.dart';
export 'src/core/util/md_operance_data_controller.dart';
export 'src/core/util/md_memory_cache.dart';
export 'src/core/util/md_card_detector.dart';
export 'src/core/util/md_debouncer.dart';

export 'src/core/viewmodel/md_viewmodel.dart';
export 'src/core/viewmodel/md_viewmodel_state.dart';

export 'src/core/http_driver/md_dio_http_driver.dart';
export 'src/core/http_driver/md_http_driver_options.dart';
export 'src/core/http_driver/md_http_driver_middleware.dart';
export 'src/core/http_driver/md_http_driver_response_parser.dart';
export 'src/core/http_driver/md_http_driver_interface.dart';

export 'src/core/i18n/md_translate_options.dart';

export 'src/collections/md_list.dart';
export 'src/collections/md_map.dart';
export 'src/collections/md_set.dart';

export 'src/core/util/md_asset_icon.dart';
export 'src/core/util/md_asset_image.dart';

export 'src/core/validator/md_field_validator.dart';
export 'src/core/validator/md_validator.dart';
export 'src/core/validator/md_cnpj_validator.dart';

export 'src/widgets/md_appbar.dart';
export 'src/widgets/md_binary_check.dart';
export 'src/widgets/md_bottom_sheet.dart';
export 'src/widgets/md_button.dart';
export 'src/widgets/md_card_observer.dart';
export 'src/widgets/md_carousel.dart';
export 'src/widgets/md_collapse.dart';
export 'src/widgets/md_common_tag.dart';
export 'src/widgets/md_container.dart';
export 'src/widgets/md_dialog.dart';
export 'src/widgets/md_expansion.dart';
export 'src/widgets/md_failure_more_details.dart';
export 'src/widgets/md_flip_two_widgets.dart';
export 'src/widgets/md_form_h_spacer.dart';
export 'src/widgets/md_form_w_spacer.dart';
export 'src/widgets/md_height.dart';
export 'src/widgets/md_icon.dart';
export 'src/widgets/md_layout.dart';
export 'src/widgets/md_list_no_items_found.dart';
export 'src/widgets/md_on_off.dart';
export 'src/widgets/md_pincode.dart';
export 'src/widgets/md_responsive.dart';
export 'src/widgets/md_select_field.dart';
export 'src/widgets/md_select_field_dialog.dart';
export 'src/widgets/md_session_title.dart';
export 'src/widgets/md_shadow_text.dart';
export 'src/widgets/md_simple_circle_select.dart';
export 'src/widgets/md_subtitle.dart';
export 'src/widgets/md_text_form_field.dart';
export 'src/widgets/md_title.dart';
export 'src/widgets/md_width.dart';
export 'src/widgets/md_clock.dart';
export 'src/widgets/md_3d_drawer.dart';
export 'src/widgets/md_drawer.dart';
export 'src/widgets/md_dashboard_card.dart';
export 'src/widgets/md_counter_indicator.dart';
export 'src/widgets/md_sub_route_builder.dart';
export 'src/widgets/md_rotatable.dart';
export 'src/widgets/md_observer.dart';
export 'src/widgets/md_title_value.dart';
export 'src/widgets/md_divider.dart';
export 'src/widgets/md_search_dialog.dart';
export 'src/widgets/md_number_selection.dart';
export 'src/widgets/md_full_screen_loading.dart';

import 'package:flutter/material.dart';
import 'package:md_engine/src/core/i18n/app_translate.dart';
import 'package:operance_datatable/operance_datatable.dart';
import 'package:qlevar_router/qlevar_router.dart';

OperanceDataDecoration? _kDefaultDataTableDecoration;
double kDefaultMdButtonHeight = 46;
double kDefaultMdTextFormFieldHeight = 54;

OperanceDataDecoration get kDefaultDataTableDecoration {
  _kDefaultDataTableDecoration ??= OperanceDataDecoration(
    colors: OperanceDataColors(
      rowColor: Theme.of(QR.context!).scaffoldBackgroundColor,
      rowHoverColor: Theme.of(QR.context!).primaryColor.withOpacity(.2),
    ),
    icons: OperanceDataIcons(
      columnHeaderSortAscendingIcon: Icons.arrow_upward,
      columnHeaderSortDescendingIcon: Icons.arrow_downward,
    ),
    sizes: OperanceDataSizes(
      headerHeight: 60.0,
      rowHeight: 44.0,
    ),
    styles: OperanceDataStyles(
      footerDecoration: BoxDecoration(),
      searchDecoration: InputDecoration(
          hintText: AppTranslate.tr("shared.search", QR.context!),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(QR.context!).primaryColor,
          ),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
    ),
    ui: OperanceDataUI(
      animationDuration: 300,
      rowsPerPageOptions: [20, 40, 80, 120],
      searchPosition: SearchPosition.left,
      rowsPerPageText: AppTranslate.tr("shared.rows_per_page", QR.context!),
    ),
  );
  return _kDefaultDataTableDecoration!;
}
