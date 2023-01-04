import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3_web_app/extension/string_e.dart';
import 'package:web3_web_app/presentation/home/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (h) => Scaffold(
        body: Center(
          child: [
            Builder(builder: (_) {
              var shown = '';
              if (h.isConnected && h.isInOperatingChain) {
                shown = 'You\'re connected!';
              } else if (h.isConnected && !h.isInOperatingChain) {
                shown = 'Wrong chain! Please connect to BSC.';
              } else if (h.isEnabled){
                return TextButton(onPressed: h.connect, child: const Text('connect'));
              }
              else {
                shown = 'Your browser is not supported!';
              }

              return Text(shown);
            }),
            const SizedBox(height: 30),
            if (h.isConnected && h.isInOperatingChain)
              TextButton(onPressed: h.getCakeTokenBalance, child: const Text('fetch ur cake!')),
            TextButton(onPressed: h.burnSomeCake, child: const Text('burn some cake?! (scary)')),
            Text('Your cake balance is ${h.yourCakeBalance} wei'),
            if (h.isConnected && h.isInOperatingChain) ...[
              TextButton(onPressed: h.getMasterChefInformation, child: const Text('fetch masterchef information!')),
              Text('Current cake per block is ${h.cakePerBlock} wei/block'),
              Text('Current pool length is ${h.poolLength}'),
              TextButton(onPressed: h.burnSomeCake, child: const Text('EMERGENCY WITHDRAW AT POOL 0!!!')),
            ]
          ].column,
        ),
      ),
    );
  }
}