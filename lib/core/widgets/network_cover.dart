import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';


class NetworkCover extends StatelessWidget{
  const NetworkCover({
   super.key,
   required this.url,
   this.width =56,
   this.height = 72,
   this.label = 'Cover',
});

  final String? url;
  final double width;
  final double height;
  final String label;

  Widget _placeholder(BuildContext context, {bool loading = false}){
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      color: colors.outline,
      alignment: Alignment.center,
      child:loading
        ? const SizedBox(
        width:20,
        height:20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          :Text(label, style: AppTextStyles.caption),
    );
  }
  @override
  Widget build(BuildContext context){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: (url == null || url!.isEmpty)
        ? _placeholder(context)
          :Image.network(
            url!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            loadingBuilder: (context,child,progress) =>
                progress == null? child: _placeholder(context, loading:true),
             errorBuilder: (context, error, stack) => _placeholder(context),
      ),
    );
  }
}