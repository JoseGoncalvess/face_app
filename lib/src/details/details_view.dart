import 'package:flutter/material.dart';
import 'package:face_app/core/utils/const.dart';
import 'package:face_app/core/utils/date_formater.dart';
import 'package:face_app/src/details/details_view_model.dart';

class DetailsView extends DetailsViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            expandedHeight: 300.0,
            pinned: true,
            elevation: 0,
            actions: [
              if (detailsUser != null)
                IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          isPersisted
                              ? Icons.bookmark_added
                              : Icons.bookmark_add_outlined,
                          color: Colors.white,
                        ),
                  onPressed: isLoading ? null : handlePersistenceToggle,
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                detailsUser?.fullName ?? 'Detalhes',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: (detailsUser == null || !isConnected)
                  ? Container(color: primaryColor)
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          detailsUser?.picture.large ?? defaultUserImage,
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.4),
                          colorBlendMode: BlendMode.darken,
                        ),
                        Center(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    "ID: ${detailsUser?.id.value}",
                                    style: TextStyle(
                                      color: backgroudColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (detailsUser == null) {
      return SliverFillRemaining(
        child: const Center(
          child: Text(
            'Erro: Usuário não encontrado.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(12.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildInfoGroup(
            title: 'Informações Pessoais',
            icon: Icons.person_outline,
            children: [
              _buildInfoRow('Email', detailsUser?.email),
              _buildInfoRow('Gênero', detailsUser?.gender),
              _buildInfoRow('Nacionalidade', detailsUser?.nat),
            ],
          ),

          _buildInfoGroup(
            title: 'Endereço',
            icon: Icons.location_on_outlined,
            children: [
              _buildInfoRow('País', detailsUser?.location.country),
              _buildInfoRow('Estado', detailsUser?.location.state),
              _buildInfoRow('Cidade', detailsUser?.location.city),
              _buildInfoRow(
                'Rua',
                '${detailsUser?.location.street.name}, ${detailsUser?.location.street.number}',
              ),
              _buildInfoRow('CEP', detailsUser?.location.postcode),
              _buildInfoRow(
                'Fuso',
                '${detailsUser?.location.timezone.offset} (${detailsUser?.location.timezone.description})',
              ),
              _buildInfoRow(
                'Coordenadas',
                '${detailsUser?.location.coordinates.latitude}, ${detailsUser?.location.coordinates.longitude}',
              ),
            ],
          ),

          _buildInfoGroup(
            title: 'Contato',
            icon: Icons.phone_outlined,
            children: [
              _buildInfoRow('Telefone', detailsUser?.phone),
              _buildInfoRow('Celular', detailsUser?.cell),
            ],
          ),

          _buildInfoGroup(
            title: 'Login',
            icon: Icons.lock_outline,
            children: [
              _buildInfoRow('Username', detailsUser?.login.username),
              _buildInfoRow(
                'UUID',
                detailsUser?.login.uuid,
                isSelectable: true,
              ),
              _buildInfoRow('Password', detailsUser?.login.password),
            ],
          ),

          _buildInfoGroup(
            title: 'Datas',
            icon: Icons.date_range_outlined,
            children: [
              _buildInfoRow(
                'Nascimento',
                DateFormater.dateFormatedLocal(detailsUser!.dob.date),
              ),
              _buildInfoRow('Idade', '${detailsUser?.dob.age} anos'),
              _buildInfoRow(
                'Registrado em',
                DateFormater.dateFormatedLocal(detailsUser!.registered.date),
              ),
              _buildInfoRow(
                'Idade Registro',
                '${detailsUser?.registered.age} anos',
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _buildInfoGroup({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      color: backgroudColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 0.5, color: primaryColor),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String? value, {
    bool isSelectable = false,
  }) {
    if (value == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: MediaQuery.sizeOf(context).height * 0.017,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColorCiew,
                fontSize: MediaQuery.sizeOf(context).height * 0.016,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
