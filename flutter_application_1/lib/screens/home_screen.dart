import 'package:flutter/material.dart';
import '../main.dart'; // AppTheme
 
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QUẢN LÝ KHÁCH SẠN"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://scontent.fhan14-5.fna.fbcdn.net/v/t39.30808-6/319888352_906647430511337_922734217827518560_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=1d70fc&_nc_ohc=8UnfVBwkI6gQ7kNvwHC4yuq&_nc_oc=AdqwgQXpdJxaHEI-rjZeHD3wHNrcAPkRJExMpwZdIqi1VfOFg_vzoFSWV0FlybZuFEo&_nc_zt=23&_nc_ht=scontent.fhan14-5.fna&_nc_gid=MUV8_wPAyRlwyLjO0pRkbQ&_nc_ss=7f289&oh=00_Af7-d2DGQemfAk-L8oX7psiUHOvDYQjP8bepZSPy981o1w&oe=69FDAD2E',
                width: 320,
                height: 220,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Chào mừng đến với KHÁCH SẠN ABC",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBlue,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Hệ thống quản lý khách hàng",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}