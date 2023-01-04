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
              // return NikuButton.outlined(
              //   'Connect'.text.bold().fontSize(20),
              // ).onPressed(h.connect);
              else {
                shown = 'Your browser is not supported!';
              }

              return Text(shown);
            }),
            const SizedBox(height: 30),
            if (h.isConnected && h.isInOperatingChain)
            // [
              TextButton(onPressed: h.getCakeTokenBalance, child: const Text('fetch ur cake!')),
            // NikuButton('fetch ur cake!'.text.fontSize(20))
            //     .onPressed(h.getCakeTokenBalance),
            TextButton(onPressed: h.burnSomeCake, child: const Text('burn some cake?! (scary)')),
            // NikuButton('burn some cake?! (scary)'.text.fontSize(20))
            //     .onPressed(h.burnSomeCake),
            Text('Your cake balance is ${h.yourCakeBalance} wei'),
            //   'Your cake balance is ${h.yourCakeBalance} wei'
            //       .text
            //       .fontSize(18)
            // ].wrap.spacing(10).crossCenter(),
            if (h.isConnected && h.isInOperatingChain) ...[
              // [
              TextButton(onPressed: h.getMasterChefInformation, child: const Text('fetch masterchef information!')),
              // NikuButton('fetch masterchef information!'.text.fontSize(20))
              //     .onPressed(h.getMasterChefInformation),
              Text('Current cake per block is ${h.cakePerBlock} wei/block'),
              // 'Current cake per block is ${h.cakePerBlock} wei/block'
              //     .text
              //     .fontSize(18),
              Text('Current pool length is ${h.poolLength}'),
              // 'Current pool length is ${h.poolLength}'.text.fontSize(18),

              // ].wrap.spacing(10).crossCenter(),
              TextButton(onPressed: h.burnSomeCake, child: const Text('EMERGENCY WITHDRAW AT POOL 0!!!')),
              // NikuButton('EMERGENCY WITHDRAW AT POOL 0!!!'.text.fontSize(20))
              //     .onPressed(h.burnSomeCake),
            ]
          ].column,
        ),
      ),
    );
  }
}