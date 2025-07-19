#!/bin/bash

# Verifica se nenhum argumento foi passado
if [ -z "$1" ]; then
  echo "Uso:"
  echo "  $0 -list                  # Lista todas as placas de áudio de forma resumida"
  echo "  $0 -active <nome_dispositivo> # Retorna o perfil ativo de um dispositivo"
  echo "  $0 <nome_dispositivo>     # Lista todos os perfis de um dispositivo"
  echo ""
  echo "Exemplos:"
  echo "  $0 -list"
  echo "  $0 -active alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"
  echo "  $0 bluez_card.5C_FB_7C_9D_4B_D1"
  exit 1
fi
 
# Opção para listar todas as placas
if [ "$1" == "-list" ]; then
  #echo "Listando todas as placas de áudio:"
  #pactl list cards short | awk '/bluez/{print $2}'
  pactl list cards short | awk '{print $2}'

# Opção para retornar o perfil ativo
elif [ "$1" == "-active" ]; then
  if [ -z "$2" ]; then
    echo "Erro: O comando '-active' requer o nome do dispositivo."
    echo "Uso: $0 -active <nome_dispositivo>"
    exit 1
  fi
  DEVICE_NAME="$2"
  #echo "Buscando perfil ativo para: $DEVICE_NAME"
  #echo "---"

  pactl list cards | awk -v device_name="$DEVICE_NAME" '
    /Card #/ {
      in_target_card = 0
    }
    /Name: / {
      if ($2 == device_name) {
        in_target_card = 1
      }
    }
    in_target_card && /Active Profile: / {
      print $3
      exit # Encontrou e pode sair
    }
  '

  if [ $? -ne 0 ]; then
    echo "---"
    echo "Erro ao buscar perfil ativo ou dispositivo '$DEVICE_NAME' não encontrado."
    echo "Use '$0 -list' para ver os nomes dos dispositivos disponíveis."
  fi

# Opção para listar todos os perfis de um dispositivo
else
  DEVICE_NAME="$1"
  #echo "Listando perfis para o dispositivo: $DEVICE_NAME"
  #echo "---"

  pactl list cards | awk -v device_name="$DEVICE_NAME" '
    /Card #/ {
      in_target_card = 0
    }
    /Name: / {
      if ($2 == device_name) {
        in_target_card = 1
      }
    }
    in_target_card {
      if (/Profiles:/) {
        flag = 1
        next
      }
      if (/Active Profile:|Ports:/) {
        flag = 0
      }
      if (flag && /:/) {
        print $1
      }
    }
  ' | sed 's/://'

  if [ $? -ne 0 ]; then
    echo "---"
    echo "Erro ao listar perfis ou dispositivo '$DEVICE_NAME' não encontrado."
    echo "Use '$0 -list' para ver os nomes dos dispositivos disponíveis."
  fi
fi