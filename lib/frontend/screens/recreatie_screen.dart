import 'package:flutter/material.dart';
import '../../../midend/models/perechiSunetTime_model.dart';

class recreatie_screen extends StatelessWidget {
  List<PerechiSunetTime> perechiSunet;
  recreatie_screen(this.perechiSunet);

  bool color = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: perechiSunet.length,
          itemBuilder: (context, index) {
            color = !color;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: color ? const Color(0xff212121) : const Color(0xff313131),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                children: [
                  Text('${index + 1}'),
                  const Spacer(),
                  Text(
                    '${perechiSunet[index].startingTime} - ${perechiSunet[index].endingTime}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: color ? const Color(0xff212121) : const Color(0xff313131),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
