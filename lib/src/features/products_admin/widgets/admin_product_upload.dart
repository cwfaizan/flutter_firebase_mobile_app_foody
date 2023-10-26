import 'package:cwf_fudy/src/utils/unique_pid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/async_value_widget.dart';
import '../../../common_widgets/custom_image.dart';
import '../../../common_widgets/error_message_widget.dart';
import '../../../utils/async_value_ui.dart';
import '../../../localization/string_hardcoded.dart';
import '../../../common_widgets/primary_button.dart';
import '../../../constants/app_sizes.dart';
import '../../products/models/product.dart';
import '../controllers/admin_product_upload_controller.dart';

class AdminProductUpload extends ConsumerWidget {
  const AdminProductUpload({super.key});
  // final ProductID productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      adminProductUploadControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // pid auto generated by uuid
    final ProductID productId = ref.watch(uuidProvider).v4();
    // State of the upload operation
    final state = ref.watch(adminProductUploadControllerProvider);
    final isLoading = state.isLoading;
    // Product to be uploaded
    final product = ref.watch(templateProductProvider(productId));
    return AsyncValueWidget<Product?>(
      value: product,
      data: (templateProduct) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (templateProduct != null) ...[
                CustomImage(imageUrl: templateProduct.imageUrl),
                gapH16,
                PrimaryButton(
                  text: 'Upload'.hardcoded,
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () => ref
                          .read(adminProductUploadControllerProvider.notifier)
                          .upload(templateProduct),
                ),
              ] else
                ErrorMessageWidget(
                  'Product template not found for ID: $productId',
                ),
            ],
          ),
        ),
      ),
    );
  }
}