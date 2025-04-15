import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 

class RiwayatPoin extends StatefulWidget { 
  final int totalPoints;
  final List<dynamic> transactions;
  
  const RiwayatPoin({
    super.key, 
    required this.totalPoints, 
    required this.transactions
  });

  @override
  State<RiwayatPoin> createState() => _RiwayatPoinState();
}

class _RiwayatPoinState extends State<RiwayatPoin> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.recycling, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Poin',
                    style: TextStyle(fontSize: 14, color: Colors.teal),
                  ),
                  Text(
                    '${widget.totalPoints}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        if (widget.transactions.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'Belum ada riwayat transaksi',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        else
          ...widget.transactions.map((transaction) {
          
            final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');
            final timeFormatter = DateFormat('HH:mm', 'id_ID');
            
            final date = dateFormatter.format(transaction.dateTime);
            final time = timeFormatter.format(transaction.dateTime) + ' WIB';
            
            // Check if this transaction has a redemption code
            final redemptionCode = transaction.redemptionCode;
            
            return _buildHistoryItem(
              transaction.type,
              transaction.points > 0 ? '+${transaction.points}' : '${transaction.points}',
              date,
              time,
              transaction.title,
              redemptionCode, 
            );
          }).toList(),
      ],
    );
  }
  
  Widget _buildHistoryItem(String type, String points, String date, String time, [String? description, String? redemptionCode]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/poin.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$points Poin',
                    style: TextStyle(
                      color: int.parse(points.replaceAll('+', '')) < 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: redemptionCode != null && type == 'Barang Ecofriendly',
            replacement: SizedBox.shrink(),
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFA3D1C6).withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF3D8D7A).withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.confirmation_number_outlined,
                    size: 16,
                    color: Color(0xFF3D8D7A),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Kode Redeem: $redemptionCode',
                    style: const TextStyle(
                      color: Color(0xFF3D8D7A),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: redemptionCode!)); 
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kode disalin ke clipboard'),
                          backgroundColor: Color(0xFF3D8D7A),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 16,
                      color: Color(0xFF3D8D7A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}