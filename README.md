# bootstrap

Add joe as a user to a VPS by running the following command:

```
curl -fsSL https://raw.githubusercontent.com/joekiller/bootstrap/main/bootstrap.sh | bash
```

Or using wget:

```
wget -qO- https://raw.githubusercontent.com/joekiller/bootstrap/main/bootstrap.sh | bash
```

This script expects to be run by a user with sudo access. It will create the `joe`
account if needed, install the SSH keys from https://github.com/joekiller.keys, and
configure passwordless sudo for the account.
