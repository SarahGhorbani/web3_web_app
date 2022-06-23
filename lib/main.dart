import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';
import 'package:niku/niku.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      GetMaterialApp(title: 'Cool ass dapp', home: Home());
}

extension StringE on String {
  NikuText get text => NikuText(this);
}

extension ListE on List<Widget> {
  NikuColumn get column => NikuColumn(this);
  NikuRow get row => NikuRow(this);
  NikuWrap get wrap => NikuWrap(this);
}

class HomeController extends GetxController {
  bool get isEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == OPERATING_CHAIN;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  String currentAddress = '';

  int currentChain = -1;

  static const OPERATING_CHAIN = 56;

  connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress = accs.first;

      currentChain = await ethereum!.getChainId();

      update();
    }
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    cakeToken = null;
    update();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accs) {
        clear();
      });

      ethereum!.onChainChanged((chain) {
        clear();
      });
    }
  }

  @override
  void onInit() {
    init();

    super.onInit();
  }

  static const CAKE_ADDRESS = '0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82';

  static const DEAD_ADDRESS = '0x000000000000000000000000000000000000dead';

  ContractERC20? cakeToken;

  BigInt yourCakeBalance = BigInt.zero;

  getCakeTokenBalance() async {
    if (cakeToken == null) {
      cakeToken = ContractERC20(CAKE_ADDRESS, provider!.getSigner());
    }
    yourCakeBalance = await cakeToken!.balanceOf(currentAddress);
    update();
  }

  burnSomeCake() async {
    await getCakeTokenBalance();

    // Burn all 1 gwei of your Cake! Super dangerous!
    if (yourCakeBalance > BigInt.from(1000000000) // 1 Gwei
    ) {
      final tx =
      await cakeToken!.transfer(DEAD_ADDRESS, BigInt.from(1000000000));
      await tx.wait();

      await getCakeTokenBalance();
    }
  }

  final abi = [
    'function cakePerBlock() view returns (uint)',
    'function poolLength() view returns (uint)',
    'function emergencyWithdraw(uint)',
  ];

  static const MASTERCHEF_ADDRESS =
      '0x73feaa1ee314f8c655e354234017be2193c9e24e';

  Contract? masterChef;

  BigInt cakePerBlock = BigInt.zero;

  int poolLength = 0;

  getMasterChefInformation() async {
    if (masterChef == null)
      masterChef = Contract(MASTERCHEF_ADDRESS, abi, provider!.getSigner());
    cakePerBlock = await masterChef!.call<BigInt>('cakePerBlock');
    poolLength = await masterChef!.call<int>('poolLength');
    update();
  }

  emergencyWithdraw() async {
    await getMasterChefInformation();

    // EMERGENCY WITHDRAW AT POOL 0; ALERT!
    final tx = await masterChef!.call('emergencyWithdraw', [0]);
    await tx.wait();
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (h) => Scaffold(
        body: Center(
          child: [
            Builder(builder: (_) {
              var shown = '';
              if (h.isConnected && h.isInOperatingChain)
                shown = 'You\'re connected!';
              else if (h.isConnected && !h.isInOperatingChain)
                shown = 'Wrong chain! Please connect to BSC.';
              else if (h.isEnabled){
                return TextButton(onPressed: h.connect, child: Text('connect'));
              }
                // return NikuButton.outlined(
                //   'Connect'.text.bold().fontSize(20),
                // ).onPressed(h.connect);
              else
                shown = 'Your browser is not supported!';

              return Text(shown);
            }),
            SizedBox(height: 30),
            if (h.isConnected && h.isInOperatingChain)
              // [
                TextButton(onPressed: h.getCakeTokenBalance, child: Text('fetch ur cake!')),
                // NikuButton('fetch ur cake!'.text.fontSize(20))
                //     .onPressed(h.getCakeTokenBalance),
                TextButton(onPressed: h.burnSomeCake, child: Text('burn some cake?! (scary)')),
                // NikuButton('burn some cake?! (scary)'.text.fontSize(20))
                //     .onPressed(h.burnSomeCake),
                Text('Your cake balance is ${h.yourCakeBalance} wei'),
              //   'Your cake balance is ${h.yourCakeBalance} wei'
              //       .text
              //       .fontSize(18)
              // ].wrap.spacing(10).crossCenter(),
            if (h.isConnected && h.isInOperatingChain) ...[
              // [
                TextButton(onPressed: h.getMasterChefInformation, child: Text('fetch masterchef information!')),
                // NikuButton('fetch masterchef information!'.text.fontSize(20))
                //     .onPressed(h.getMasterChefInformation),
                Text('Current cake per block is ${h.cakePerBlock} wei/block'),
                // 'Current cake per block is ${h.cakePerBlock} wei/block'
                //     .text
                //     .fontSize(18),
                Text('Current pool length is ${h.poolLength}'),
                // 'Current pool length is ${h.poolLength}'.text.fontSize(18),

              // ].wrap.spacing(10).crossCenter(),
              TextButton(onPressed: h.burnSomeCake, child: Text('EMERGENCY WITHDRAW AT POOL 0!!!')),
              // NikuButton('EMERGENCY WITHDRAW AT POOL 0!!!'.text.fontSize(20))
              //     .onPressed(h.burnSomeCake),
            ]
          ].column,
        ),
      ),
    );
  }
}