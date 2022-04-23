import 'package:budiberas_admin_9701/views/widgets/reusable/delete_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/edit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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

              const SizedBox(width: 16,),

              //Product data
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Minyak Bimoli Spesial 2 liter',
                            style: primaryTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Text(
                      'Rp 45.000',
                      style: priceTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        Text(
                          'Stok: 0',
                          style: secondaryTextStyle.copyWith(
                            fontWeight: medium,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Container(
                          color: const Color(0xffEBEBEB),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                ),
              )
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              editButton(
                onClick: () {
                }
              ),
              const SizedBox(width: 20,),
              deleteButton(
                onClick: () {

                }
              )
            ],
          )
        ],
      ),
    );
  }
}

