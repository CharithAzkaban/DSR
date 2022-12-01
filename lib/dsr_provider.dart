import 'package:dsr_app/common.dart';
import 'package:dsr_app/models/cheque.dart';
import 'package:dsr_app/widgets/balance_item.dart';
import 'package:dsr_app/widgets/banking_item.dart';
import 'package:dsr_app/widgets/direct_banking_item.dart';
import 'package:dsr_app/widgets/product_item.dart';
import 'package:dsr_app/widgets/return_item.dart';
import 'package:dsr_app/widgets/stock_item.dart';
import 'package:flutter/material.dart';

import 'widgets/credit_collection_item.dart';
import 'widgets/credit_item.dart';

class DSRProvider extends ChangeNotifier {
  List<ProductItem> _productList = [];
  List<Cheque> _chequeList = [];
  List<StocktItem> _stockList = [];
  List<BalanceItem> _balanceList = [];
  List<BankingItem> _bankingList = [];
  List<DirectBankingItem> _directBankingList = [];
  List<BankingItem> _selectedBankingList = [];
  List<DirectBankingItem> _selectedDirectBankingList = [];
  List<CreditItem> _creditList = [];
  List<CreditCollectionItem> _creditCollectionList = [];
  List<ReturnItem> _returnList = [];
  bool _selectableBanking = false;
  bool _connected = false;
  int _status = 0;

  double _totalSale = 0;

  double _totalCashInhand = 0;
  double _totalChequeInhand = 0;

  double _totalSampathBanking = 0;
  double _totalPeoplesBanking = 0;
  double _totalCargillsBanking = 0;

  double _totalSampathDirectBanking = 0;
  double _totalPeoplesDirectBanking = 0;
  double _totalCargillsDirectBanking = 0;

  double _totalCredit = 0;
  double _totalCreditCollection = 0;

  double get totalSale => _totalSale;

  double get totalCashInhand => _totalCashInhand;
  double get totalChequeInhand => _totalChequeInhand;

  double get totalSampathBanking => _totalSampathBanking;
  double get totalPeoplesBanking => _totalPeoplesBanking;
  double get totalCargillsBanking => _totalCargillsBanking;

  double get totalSampathDirectBanking => _totalSampathDirectBanking;
  double get totalPeoplesDirectBanking => _totalPeoplesDirectBanking;
  double get totalCargillsDirectBanking => _totalCargillsDirectBanking;

  double get totalCredit => _totalCredit;
  double get totalCreditCollection => _totalCreditCollection;

  bool get connected => _connected;

  int get status => _status;

  setTotalSale(double totalSale) {
    _totalSale = totalSale;
    notifyListeners();
  }

  setTotalCashInhand(double totalCashInhand) {
    _totalCashInhand = totalCashInhand;
    notifyListeners();
  }

  setTotalChequeInhand(double totalChequeInhand) {
    _totalChequeInhand = totalChequeInhand;
    notifyListeners();
  }

  setTotalSampathBanking(double totalSampathBanking) {
    _totalSampathBanking = totalSampathBanking;
    notifyListeners();
  }

  setTotalPeoplesBanking(double totalPeoplesBanking) {
    _totalPeoplesBanking = totalPeoplesBanking;
    notifyListeners();
  }

  setTotalCargillsBanking(double totalCargillsBanking) {
    _totalCargillsBanking = totalCargillsBanking;
    notifyListeners();
  }

  setTotalSampathDirectBanking(double totalSampathDirectBanking) {
    _totalSampathDirectBanking = totalSampathDirectBanking;
    notifyListeners();
  }

  setTotalPeoplesDirectBanking(double totalPeoplesDirectBanking) {
    _totalPeoplesDirectBanking = totalPeoplesDirectBanking;
    notifyListeners();
  }

  setTotalCargillsDirectBanking(double totalCargillsDirectBanking) {
    _totalCargillsDirectBanking = totalCargillsDirectBanking;
    notifyListeners();
  }

  setTotalCredit(double totalCredit) {
    _totalCredit = totalCredit;
    notifyListeners();
  }

  setTotalCreditCollection(double totalCreditCollection) {
    _totalCreditCollection = totalCreditCollection;
    notifyListeners();
  }

  setStatus(int status) {
    _status = status;
    notifyListeners();
  }

  List<ProductItem> get productList => _productList;
  List<Cheque> get chequeList => _chequeList;
  List<StocktItem> get stocktList => _stockList;
  List<BalanceItem> get balanceList => _balanceList;
  List<BankingItem> get bankingList => _bankingList;
  List<DirectBankingItem> get directBankingList => _directBankingList;
  List<CreditItem> get creditList => _creditList;
  List<CreditCollectionItem> get creditCollectionList => _creditCollectionList;
  List<ReturnItem> get returnList => _returnList;

  bool get selectableBanking => _selectableBanking;

  addProduct(ProductItem productItem) {
    bool exist = false;
    for (ProductItem product in _productList) {
      if (product.productId == productItem.productId) {
        toast(
            msg: '${productItem.productName} is already added!',
            toastStatus: TS.ERROR);
        exist = true;
        break;
      }
    }

    if (!exist) {
      _productList.add(productItem);
      toast(msg: 'A sale is added', toastStatus: TS.SUCCESS);
      notifyListeners();
    }
  }

  addCheque(Cheque cheque){
    _chequeList.add(cheque);
    notifyListeners();
  }

  getTotalChequeAmount(){
    var total = 0.0;
    for(var cheque in _chequeList){
      total += cheque.cheque_amount;
    }
    return total;
  }

  clearChequeList(){
    _chequeList.clear();
    notifyListeners();
  }

  removeCheque(Cheque cheque){
    _chequeList.removeWhere((che) => che.cheque_no == cheque.cheque_no);
    notifyListeners();
  }

  addBalance(BalanceItem balanceItem) {
    _balanceList.add(balanceItem);
    notifyListeners();
  }

  addStock(StocktItem stockItem) {
    _stockList.add(stockItem);
    notifyListeners();
  }

  addBanking(BankingItem bankingItem) {
    _bankingList.add(bankingItem);
    notifyListeners();
  }

  addDirectBanking(DirectBankingItem directBankingItem) {
    _directBankingList.add(directBankingItem);
    notifyListeners();
  }

  addSelectedBanking(BankingItem bankingItem) {
    _selectedBankingList.add(bankingItem);
    notifyListeners();
  }

  addSelectedDirectBanking(DirectBankingItem directBankingItem) {
    _selectedDirectBankingList.add(directBankingItem);
    notifyListeners();
  }

  addReturn(ReturnItem returnItem) {
    _returnList.add(returnItem);
    notifyListeners();
  }

  addCredit(CreditItem creditItem) {
    _creditList.add(creditItem);
    notifyListeners();
  }

  addCreditCollection(CreditCollectionItem creditCollectionItem) {
    _creditCollectionList.add(creditCollectionItem);
    notifyListeners();
  }

  deleteCreditCollection(CreditCollectionItem creditCollectionItem) {
    _creditCollectionList.remove(creditCollectionItem);
    notifyListeners();
  }

  deleteAllCreditCollection() {
    _creditCollectionList.clear();
    notifyListeners();
  }

  deleteProduct(ProductItem productItem) {
    _productList.remove(productItem);
    notifyListeners();
  }

  deleteStock(StocktItem stockItem) {
    _stockList.remove(stockItem);
    notifyListeners();
  }

  deleteAllProducts() {
    _productList.clear();
    notifyListeners();
  }

  deleteSelectedBanking() {
    _bankingList.remove(_selectedBankingList);
    notifyListeners();
  }

  deleteSelectedDirectBanking() {
    _selectedDirectBankingList.forEach((element) {
      _directBankingList.remove(element);
    });
    notifyListeners();
  }

  deleteCredit(CreditItem creditItem) {
    _creditList.remove(creditItem);
    notifyListeners();
  }

  deleteAllCredits() {
    _creditList.clear();
    notifyListeners();
  }

  deleteReturn(ReturnItem returnItem) {
    _returnList.remove(returnItem);
    notifyListeners();
  }

  deleteAllReturns() {
    _returnList.clear();
    notifyListeners();
  }

  setSelectableBanking(bool selectableBanking) {
    _selectableBanking = selectableBanking;
    notifyListeners();
  }

  selectBanking(BankingItem bankingItem) {
    _selectedBankingList.add(bankingItem);
  }

  selectDirectBanking(DirectBankingItem directBankingItem) {
    _selectedDirectBankingList.add(directBankingItem);
  }

  deselectBanking(BankingItem bankingItem) {
    _selectedBankingList.remove(bankingItem);
  }

  deselectDirectBanking(DirectBankingItem directBankingItem) {
    _selectedDirectBankingList.remove(directBankingItem);
  }

  deselectAllBanking() {
    _selectedBankingList.clear();
  }

  deselectAllDirectBanking() {
    _selectedDirectBankingList.clear();
  }

  deleteBanking(BankingItem bankItem) {
    _bankingList.remove(bankItem);
    notifyListeners();
  }

  deleteAllBankings() {
    _bankingList.clear();
    notifyListeners();
  }

  deleteDirectBanking(DirectBankingItem directBankingItem) {
    _directBankingList.remove(directBankingItem);
    notifyListeners();
  }

  deleteAllDirectBankings() {
    _directBankingList.clear();
    notifyListeners();
  }

  setConnection(bool connected) {
    _connected = connected;
    notifyListeners();
  }
}
