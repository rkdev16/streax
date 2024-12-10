import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ConnectionsScreenLoadingWidget extends StatelessWidget {
  const ConnectionsScreenLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        shrinkWrap: true,
        children: [
          storyPlaceholder(),
          connectionsSectionWidget(),
          connectionsSectionWidget(),
          connectionsSectionWidget()











        ],
      ),
    );
  }

  Widget storyPlaceholder(){
    return  SizedBox(
      height: 100,
      child: ListView.separated(
          padding: const  EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: const  BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                  ),
                ),
                Container(
                  margin: const  EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                  height: 12,width: 70,
                  color: Colors.white,)
              ],);

          },
          separatorBuilder: (context,index){
            return  const SizedBox(width: 16,);
          },
          itemCount: 8),
    );
  }


  Widget connectionsSectionWidget(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

      Container(
        width: 100,
        height: 20,
        margin: const  EdgeInsets.all(16),
        color: Colors.white,

      ),


        SizedBox(
          height: 250,
          child: GridView.builder(
              physics: const  NeverScrollableScrollPhysics(),
              padding: const  EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              gridDelegate: const  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 230,
                  crossAxisSpacing: 16
              ),
              itemCount:2,
              itemBuilder: (context,index){

                return Container(

                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                );
              }),
        )

    ],);
  }
}