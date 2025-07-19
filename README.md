# Gerenciamento de Dispositivos Bluetooth de Áudio

Este repositório contém dois scripts principais para facilitar o gerenciamento de dispositivos Bluetooth de áudio no Linux utilizando o `pactl`:

- [`bt.sh`](bt.sh)
- [`blue.sh`](blue.sh)

Os scripts sao o resultado da necessidade de alterar o perfil ativo do bluetooth para que o audio fique sincronizado com o video no Linux.

Voce pode criar um atalho no Linux (eu uso CTRL F12) para executar o script [`bt.sh`](bt.sh)

Outra copisa que precisa fazer é criar um link simbolico na pasta bin do diretorio HOME do usuario para os scripts [`bt.sh`](bt.sh) e [`blue.sh`](blue.sh)

\# ln -s /home/usuario/scripts/bt.sh /home/usuario/bin/bt.sh
\# ln -s /home/usuario/scripts/blue.sh /home/usuario/bin/blue.sh


## Descrição dos Scripts

### `blue.sh`

Script utilitário para listar dispositivos de áudio, perfis e identificar o perfil ativo de um dispositivo Bluetooth.

#### Uso

```sh
./blue.sh -list
./blue.sh -active <nome_dispositivo>
./blue.sh <nome_dispositivo>
```

#### Funcionalidades

- `-list`: Lista todos os dispositivos de áudio disponíveis (exibe o nome de cada placa).
- `-active <nome_dispositivo>`: Mostra o perfil ativo do dispositivo especificado.
- `<nome_dispositivo>`: Lista todos os perfis disponíveis para o dispositivo.

---

### `bt.sh`

Script principal para gerenciar dispositivos Bluetooth de áudio, alternando entre perfis disponíveis e registrando logs do processo.

#### Funcionalidades

- Lista todos os dispositivos Bluetooth de áudio disponíveis.
- Para cada dispositivo encontrado:
  - Exibe o perfil ativo.
  - Lista todos os perfis disponíveis.
  - Alterna entre os perfis para garantir que estão funcionando.
  - Retorna ao perfil padrão (por exemplo, `a2dp-sink`).
- Gera um log detalhado em `/tmp/btman.log`.

#### Exemplo de uso

```sh
./bt.sh
```

---

## Requisitos

- Linux com suporte ao `pactl` (PulseAudio).
- Permissão de execução para os scripts.

## Observações

- Certifique-se de que seus dispositivos Bluetooth estejam pareados e conectados antes de executar os scripts.
- O caminho para o script `blue.sh` pode precisar ser ajustado em `bt.sh` conforme o local onde ele está salvo.

## Licença

Uso pessoal
