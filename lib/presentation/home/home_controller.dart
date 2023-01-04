import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool get isEnabled => ethereum != null;
  bool get isInOperatingChain => currentChain == operatingChain;
  bool get isConnected => isEnabled && currentAddress.isNotEmpty;
  String currentAddress = '';
  int currentChain = -1;
  static const operatingChain = 56;

  connect() async {
    if (isEnabled) {
      final account = await ethereum!.requestAccount();
      if (account.isNotEmpty) currentAddress = account.first;

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
      ethereum!.onAccountsChanged((account) {
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

  static const cakeAddress = '0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82';

  static const deadAddress = '0x000000000000000000000000000000000000dead';

  ContractERC20? cakeToken;

  BigInt yourCakeBalance = BigInt.zero;

  getCakeTokenBalance() async {
    cakeToken ??= ContractERC20(cakeAddress, provider!.getSigner());
    yourCakeBalance = await cakeToken!.balanceOf(currentAddress);
    update();
  }

  burnSomeCake() async {
    await getCakeTokenBalance();

    // Burn all 1 gwei of your Cake! Super dangerous!
    if (yourCakeBalance > BigInt.from(1000000000) // 1 Gwei
    ) {
      final tx =
      await cakeToken!.transfer(deadAddress, BigInt.from(1000000000));
      await tx.wait();

      await getCakeTokenBalance();
    }
  }

  final abi = [
    'function cakePerBlock() view returns (uint)',
    'function poolLength() view returns (uint)',
    'function emergencyWithdraw(uint)',
  ];

  static const masterChefAddress =
      '0x73feaa1ee314f8c655e354234017be2193c9e24e';

  Contract? masterChef;

  BigInt cakePerBlock = BigInt.zero;

  int poolLength = 0;

  getMasterChefInformation() async {
    masterChef ??= Contract(masterChefAddress, abi, provider!.getSigner());
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