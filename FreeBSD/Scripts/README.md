# ⚙️ **Automação e Setup**

## 🛠️ **Scripts Disponíveis**
 Scripts desenvolvidos em **sh** (Shell padrão do FreeBSD) para automatizar a preparação do ambiente de desenvolvimento.

 | Script | Funcionalidade |
 | :--- | :--- |
 | **[`install.sh`](./install.sh)** | **Download e Verificação.** Obtém a versão mais recente do FreeBSD, valida o checksum (SHA256) e extrai a ISO. |
 | **[`setup.sh`](./setup.sh)** | **Pós-Instalação.** Configura grupos (`wheel`, `video`), instala pacotes (`sudo`, `git`), ajusta fontes do terminal e configura o prompt (ZSH/Shell visual). |

## 🚀 **Como Utilizar**
 1. Dê permissão de execução:
 ```sh
 chmod +x *.sh
 ```

 2. Execute conforme a necessidade:
 ```sh
 ./install.sh  # Para baixar a ISO
 ./setup.sh    # Para configurar o sistema (Requer root/sudo)
 ```
