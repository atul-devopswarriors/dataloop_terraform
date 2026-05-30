# Helm deployment wrapper for Ansible Vault protected certs

This wrapper deploys the existing `helm/web` chart while automating the
certificate/private-key workflow:

1. Find files under:
   - `helm/web/certs`
   - `helm/web/multi-tenancy`
2. Detect which files are currently encrypted with Ansible Vault.
3. Decrypt only those files.
4. Run `helm upgrade --install`.
5. Re-encrypt the originally encrypted files in an `always` section, even when
   Helm fails.

## Required command

Ansible playbooks do not accept the Helm values file as a bare positional
argument. Pass it as an extra variable:

```bash
ansible-playbook \
  -i inventories/dev/hosts \
  -l worker_node_group \
  playbooks/master-helm.yaml \
  -e env=dev \
  -e helm_values_file=helm/web/values.yaml \
  -e vault_password_file=/tmp/vault.txt \
  --vault-password-file=/tmp/vault.txt
```

For other environments:

```bash
ansible-playbook \
  -i inventories/qa/hosts \
  -l worker_node_group \
  playbooks/master-helm.yaml \
  -e env=qa \
  -e helm_values_file=helm/web/values-qa.yaml \
  -e vault_password_file=/tmp/vault.txt \
  --vault-password-file=/tmp/vault.txt
```

`--vault-password-file` lets Ansible read vaulted playbook variables if you use
them. `vault_password_file` is passed to the `ansible-vault encrypt/decrypt`
commands executed inside the playbook.

## Useful overrides

The playbook defaults to:

```yaml
helm_release_name: "web-{{ env }}"
helm_namespace: "web-{{ env }}"
helm_chart_dir: "{{ playbook_dir }}/../helm/web"
helm_wait: true
helm_atomic: true
helm_create_namespace: true
helm_timeout: 10m
helm_delegate_to: localhost
```

Override them as needed:

```bash
ansible-playbook \
  -i inventories/dev/hosts \
  -l worker_node_group \
  playbooks/master-helm.yaml \
  -e env=dev \
  -e helm_values_file=helm/web/values-dev.yaml \
  -e vault_password_file=/tmp/vault.txt \
  -e helm_release_name=web \
  -e helm_namespace=web-dev \
  --vault-password-file=/tmp/vault.txt
```

To pass additional Helm flags:

```bash
-e 'helm_extra_args=--set image.tag=1.2.3'
```

## Important notes

- Run this from the repository root so `helm/web` resolves correctly.
- The machine selected by `helm_delegate_to` must have `helm`,
  `ansible-vault`, kubeconfig access, and filesystem access to `helm/web`.
- The playbook only re-encrypts files that were Ansible Vault encrypted before
  the Helm deployment started.
- If you already decrypt manually and the files are plaintext before the
  playbook starts, the wrapper will not encrypt them because it cannot know they
  were meant to be restored.
