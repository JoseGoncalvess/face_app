import 'package:flutter/material.dart';
import 'package:persona_app/core/utils/const.dart';
import 'package:persona_app/src/details/details_view_model.dart';

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
              if (datailsUser != null)
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
                datailsUser?.fullName ?? 'Detalhes',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: (datailsUser == null)
                  ? Container(color: primaryColor)
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          datailsUser?.picture.large ?? defaultUserImage,
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
                                    "ID: ${datailsUser?.id.value}",
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

    if (datailsUser == null) {
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
              _buildInfoRow('Email', datailsUser?.email),
              _buildInfoRow('Gênero', datailsUser?.gender),
              _buildInfoRow('Nacionalidade', datailsUser?.nat),
            ],
          ),

          _buildInfoGroup(
            title: 'Endereço',
            icon: Icons.location_on_outlined,
            children: [
              _buildInfoRow('País', datailsUser?.location.country),
              _buildInfoRow('Estado', datailsUser?.location.state),
              _buildInfoRow('Cidade', datailsUser?.location.city),
              _buildInfoRow(
                'Rua',
                '${datailsUser?.location.street.name}, ${datailsUser?.location.street.number}',
              ),
              _buildInfoRow('CEP', datailsUser?.location.postcode),
              _buildInfoRow(
                'Fuso',
                '${datailsUser?.location.timezone.offset} (${datailsUser?.location.timezone.description})',
              ),
              _buildInfoRow(
                'Coordenadas',
                '${datailsUser?.location.coordinates.latitude}, ${datailsUser?.location.coordinates.longitude}',
              ),
            ],
          ),

          _buildInfoGroup(
            title: 'Contato',
            icon: Icons.phone_outlined,
            children: [
              _buildInfoRow('Telefone', datailsUser?.phone),
              _buildInfoRow('Celular', datailsUser?.cell),
            ],
          ),

          _buildInfoGroup(
            title: 'Login',
            icon: Icons.lock_outline,
            children: [
              _buildInfoRow('Username', datailsUser?.login.username),
              _buildInfoRow(
                'UUID',
                datailsUser?.login.uuid,
                isSelectable: true,
              ),
              _buildInfoRow('Password', datailsUser?.login.password),
            ],
          ),

          _buildInfoGroup(
            title: 'Datas',
            icon: Icons.date_range_outlined,
            children: [
              _buildInfoRow('Nascimento', datailsUser?.dob.date),
              _buildInfoRow('Idade', '${datailsUser?.dob.age} anos'),
              _buildInfoRow('Registrado em', datailsUser?.registered.date),
              _buildInfoRow(
                'Idade Registro',
                '${datailsUser?.registered.age} anos',
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
