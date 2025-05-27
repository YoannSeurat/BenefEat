import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;
import 'package:benefeat/constants/user_info.dart' as userinfo;

class HomePage extends StatefulWidget {
  final VoidCallback? onProductsTap;
  const HomePage({super.key, this.onProductsTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userAddress = "";
  Position? userPosition;

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    final address = await userinfo.getSpecificUserInfo("adress");
    setState(() => userAddress = address);
    
    if (userAddress == 'Utilisateur déconnecté') return;
    List<Location> locations = [];
    try {
      locations = await locationFromAddress(userAddress);
    } catch (e) {
      locations = [];
    }
    if (locations.isNotEmpty) {
      setState(() {
        userPosition = Position(
          latitude: locations.first.latitude,
          longitude: locations.first.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      });
    }
  }

  // Calculate distance between user and a store
  Future<double?> _calculateDistance(Position storePosition) async {
    if (userPosition == null) return null;
    return Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      storePosition.latitude,
      storePosition.longitude,
    );
  }

  Future<List<Map<String, dynamic>>> _getStores() async => constants.STORES;

  void _openMaps() async {
    if (userAddress == 'Utilisateur déconnecté') return;
    final url = Uri.parse("https://www.google.com/maps?q=${Uri.encodeComponent(userAddress)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 23,
        children: [
          SizedBox(height: constants.APPBAR_HEIGHT + 20,),

            GestureDetector(
              onTap: _openMaps,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.kindakindalightgrey,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.location_on_outlined, color: colors.darkred),
                  title: Text(
                    userAddress,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.open_in_new, color: colors.darkred),
                ),
              ),
            ),

          SizedBox(),

          Text("Magasins partenaires", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _getStores(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data!.map((store) => 
                    FutureBuilder<double?>(
                      future: _calculateDistance(store['position']),
                      builder: (context, distanceSnapshot) {
                        return storeCard(
                          store,
                          distance: distanceSnapshot.data,
                        );
                      },
                    )
                  ).toList(),
                ),
              );
            },
          ),

          SizedBox(),

          Text("Parcourir", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),

          productSection(context),

          //! debug
          FutureBuilder<String>(
            future: userinfo.getSpecificUserInfo("email"),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              if (snapshot.data == "benefeatefrei@gmail.com") {
                return ElevatedButton(
                  onPressed: () async {
                    final userInfo = await userinfo.getUserInfo();
                    if(!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                      title: Text("User Info"),
                      content: Text(userInfo.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("OK"),
                        ),
                      ],
                      ),
                    );
                  },
                  child: Text("show user info"),
                );
              }
              return SizedBox();
            },
          ),
          //! debug
          FutureBuilder<String>(
            future: userinfo.getSpecificUserInfo("email"),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              if (snapshot.data == "benefeatefrei@gmail.com") {
                return ElevatedButton(
                  onPressed: () async {
                    final beststores = constants.getBestStores(userPosition);
                    if(!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                      title: Text("Best stores"),
                      content: Text(beststores.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("OK"),
                        ),
                      ],
                      ),
                    );
                  },
                  child: Text("show best stores"),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget storeCard(store, {double? distance}) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse("https://www.google.com/maps?q=${Uri.encodeComponent(store['adress'])}");
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Image.asset("assets/logos/${store['name']}.png", height: 50),
            SizedBox(height: 5),
            Text(store['name'], style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "${store['score']}/5 ★",
              style: TextStyle(
                color: colors.darkred,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (distance != null)
              Text(
                "${(distance / 1000).toStringAsFixed(2)} km",
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget productSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onProductsTap != null) {
          widget.onProductsTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.only(right:20),
        decoration: BoxDecoration(
          color: colors.kindakindalightgrey,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 12,
            offset: Offset(0, 4),
            ),
          ],
        ),
        child : Row(
          children: [
            Image.asset('assets/logos/products_image.png', width: 110,),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Produits", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),),
                  Text(
                    "Faites vos courses,\nen full benef 🤩",
                    style: TextStyle(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: colors.darkred,)
          ],
        ),
      ),
    );
  }
}