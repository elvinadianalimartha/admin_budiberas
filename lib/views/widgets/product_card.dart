import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class ProductCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: secondaryTextColor.withOpacity(0.8), width: 0.5),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              //Photo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('assets/indomie.png'),
                    )
                ),
              ),
              //Product data
              SizedBox(width: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minyak Bimoli Spesial 2 liter',
                    style: primaryTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    'Rp 45.000',
                    style: priceTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  SizedBox(height: 4,),
                  Row(
                    children: [
                      Text(
                        'Stok: 0',
                        style: secondaryTextStyle.copyWith(
                          fontWeight: medium,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 12,),
                      Container(
                        color: Color(0xffEBEBEB),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'Tidak aktif',
                          style: secondaryTextStyle.copyWith(
                            fontWeight: medium,
                            fontSize: 12,
                          ),
                        )
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: btnColor,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  padding: EdgeInsets.all(8),
                ),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: btnColor,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.edit, color: Colors.white, size: 14
                          ,)
                    ),
                    SizedBox(width: 11,),
                    Text(
                      'Ubah',
                      style: changeBtnTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 20,),
              OutlinedButton(
                onPressed: () {
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: alertColor,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  padding: EdgeInsets.all(8),
                ),
                child: Row(
                  children: [
                    //Icon(Icons.delete, color: alertColor, size: 22,),
                    Image.asset('assets/delete_icon.png', width: 16,),
                    SizedBox(width: 9,),
                    Text(
                      'Hapus',
                      style: alertTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

