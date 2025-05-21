
import 'package:flutter/material.dart';
import 'package:uts_aplication/models/petani_models.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uts_aplication/services/apipetani.dart';
import 'package:uts_aplication/ui/detail_petani.dart';
import 'package:uts_aplication/ui/form_petani.dart';

class PagePetani extends StatefulWidget {
  const PagePetani({super.key});

  @override
  State<PagePetani> createState() => _PagePetaniState();
}

class _PagePetaniState extends State<PagePetani> {
  static const _pageSize = 10;
  final PagingController<int, Petani> _pagingController = PagingController(
    firstPageKey: 1,
  );

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await ApiStatic.getPetaniFilter(
        pageKey,
        _searchController.text.trim(),
        '', // status dikosongkan
        pageSize: _pageSize,
      );

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  final String baseUrl = 'https://dev.wefgis.com/';

  Future<void> _deletePetani(String idPenjual) async {
    final result = await ApiStatic.deletePetani(idPenjual);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result ? 'Data berhasil dihapus' : 'Gagal menghapus data',
        ),
        backgroundColor: result ? Colors.green : Colors.red,
      ),
    );

    if (result) _pagingController.refresh();
  }

  Widget _buildPetaniItem(Petani petani) {
    return Card(
      color: Colors.blue.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 3,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPetani(petani: petani),
            ),
          );
        },
        leading: ClipOval(
          child:
              petani.foto.isNotEmpty
                  ? Image.network(
                    '$baseUrl${petani.foto}',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 60,
                        ),
                  )
                  : const Icon(Icons.person, size: 60, color: Colors.blue),
        ),
        title: Text(
          petani.nama.isNotEmpty ? petani.nama : 'Nama tidak tersedia',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NIK: ${petani.nik.isNotEmpty ? petani.nik : "-"}'),
            Text('Alamat: ${petani.alamat.isNotEmpty ? petani.alamat : "-"}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.blue),
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetaniForm(petani: petani),
                ),
              ).then((_) => _pagingController.refresh());
            } else if (value == 'delete') {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: const Text("Yakin ingin menghapus data ini?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deletePetani(petani.idPenjual.toString());
                          },
                          child: const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            }
          },
          itemBuilder:
              (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Hapus')),
              ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari Nama',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
              ),
              onSubmitted: (_) => _pagingController.refresh(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _pagingController.refresh(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Filter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Petani'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(() => _pagingController.refresh()),
              color: Colors.blue,
              child: PagedListView<int, Petani>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Petani>(
                  itemBuilder:
                      (context, petani, index) => _buildPetaniItem(petani),
                  firstPageProgressIndicatorBuilder:
                      (_) => const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder:
                      (_) => const Center(child: CircularProgressIndicator()),
                  firstPageErrorIndicatorBuilder:
                      (_) => const Center(child: Text('Gagal memuat data')),
                  noItemsFoundIndicatorBuilder:
                      (_) => const Center(child: Text('Tidak ada data petani')),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PetaniForm()),
          ).then((_) => _pagingController.refresh());
        },
        tooltip: 'Tambah Petani',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
