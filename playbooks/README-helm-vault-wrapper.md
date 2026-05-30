# Helm deployment wrapper for Ansible Vault protected certs

This wrapper deploys the existing `helm/web` chart through an Ansible role.
It automates this workflow:

1. Load Helm/chart settings from inventory vars.
2. Find key/certificate files under configured chart directories.
3. Detect which files are currently encrypted with Ansible Vault.
4. Decrypt only those files.
5. Ensure the target Kubernetes namespace exists.
6. Run `helm upgrade --install` with `--namespace` every time.
7. Re-encrypt the originally encrypted files in an `always` section, even when
   Helm fails.

## Files added

```text
ansible.cfg
playbooks/master-helm.yaml
roles/helm_vault_deploy/tasks/main.yaml
roles/helm_vault_deploy/tasks/validate.yaml
roles/helm_vault_deploy/tasks/namespace.yaml
roles/helm_vault_deploy/tasks/vault-files.yaml
roles/helm_vault_deploy/tasks/deploy.yaml
inventories/dev/hosts
inventories/dev/group_vars/all.yaml
inventories/dev/group_vars/dev1.yaml
```

## Ansible role path

`ansible.cfg` sets:

```ini
[defaults]
roles_path = roles
```

Run the playbook from the repository root so Ansible can find the role and the
relative chart paths.

## Minimal playbook

`playbooks/master-helm.yaml` only calls the role:

```yaml
---
- name: Deploy helm/web with Ansible Vault managed certificate files
  hosts: all
  gather_facts: false
  run_once: true
  any_errors_fatal: true

  roles:
    - helm_vault_deploy
```

## Where values come from

Common/default values are loaded from:

```text
inventories/dev/group_vars/all.yaml
```

Important defaults in that file:

```yaml
env: dev
helm_release_name: "web-{{ env }}"
helm_namespace: "web-{{ env }}"
helm_chart_dir: "{{ playbook_dir }}/../helm/web"
helm_values_file: "{{ helm_chart_dir }}/values.yaml"
vault_password_file: /tmp/vault.txt

helm_vault_cert_roots:
  - "{{ helm_chart_dir }}/certs"
  - "{{ helm_chart_dir }}/multi-tenancy"
helm_vault_file_patterns:
  - "*.key"
  - "*.pem"
```

The sample namespace-specific overrides for `dev1` are loaded from:

```text
inventories/dev/group_vars/dev1.yaml
```

That file sets:

```yaml
env: dev
helm_namespace: dev1
helm_release_name: web-dev1
helm_values_file: "{{ helm_chart_dir }}/values.yaml"
vault_password_file: /tmp/vault.txt
```

Because `inventories/dev/hosts` places `localhost` in the `dev1` group, Ansible
automatically loads `group_vars/dev1.yaml` when you target `dev1`.

## Deploy to namespace dev1

```bash
ansible-playbook   -i inventories/dev/hosts   -l dev1   playbooks/master-helm.yaml   --vault-password-file=/tmp/vault.txt
```

This uses:

- chart: `helm/web`
- values file: `helm/web/values.yaml`
- namespace: `dev1`
- release name: `web-dev1`
- vault password file: `/tmp/vault.txt`

Internally, the role runs the equivalent Helm command:

```bash
helm upgrade --install web-dev1 helm/web   --namespace dev1   --values helm/web/values.yaml   --timeout 10m   --create-namespace   --wait   --atomic
```

## Deploy with a different values file

Override just the values file at runtime:

```bash
ansible-playbook   -i inventories/dev/hosts   -l dev1   playbooks/master-helm.yaml   -e helm_values_file=helm/web/values-dev1.yaml   --vault-password-file=/tmp/vault.txt
```

## Deploy by passing all namespace settings at runtime

If you do not want a `group_vars/dev1.yaml` file, use `group_vars/all.yaml` plus
runtime overrides:

```bash
ansible-playbook   -i inventories/dev/hosts   -l worker_node_group   playbooks/master-helm.yaml   -e env=dev   -e helm_namespace=dev1   -e helm_release_name=web-dev1   -e helm_values_file=helm/web/values.yaml   -e vault_password_file=/tmp/vault.txt   --vault-password-file=/tmp/vault.txt
```

## Restrict encryption/decryption to only `helm/web/certs/*.key`

In `inventories/dev/group_vars/all.yaml`, use:

```yaml
helm_vault_cert_roots:
  - "{{ helm_chart_dir }}/certs"
helm_vault_file_patterns:
  - "*.key"
```

## Required tools on the Ansible controller

The machine selected by `helm_delegate_to` must have:

- `ansible`
- `ansible-vault`
- `helm`
- `kubectl`
- kubeconfig access to the target cluster
- filesystem access to `helm/web`

## Important behavior

- The role decrypts only files that already start with `$ANSIBLE_VAULT;`.
- The role re-encrypts only files that were encrypted before the deployment
  started.
- If files are already plaintext before the role starts, the role will not
  encrypt them because it cannot safely know they were meant to be restored.
- Do not run raw `helm upgrade --install` directly if the chart still contains
  vaulted key files. Run the Ansible playbook instead.
